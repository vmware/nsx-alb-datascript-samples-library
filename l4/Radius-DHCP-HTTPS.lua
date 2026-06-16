local parse_radius = require 'Default-Radius'
local parse_dhcp = require 'Default-DHCP'

local payload = avi.l4.read() 
local prime = {3, 5, 7, 11, 13, 17}
local vip_port = avi.vs.port()
local vs_name = avi.vs.name()

---------------- hash function ---------
local function hashfunction(key, prefix)
  local key_len = string.len(key)
  local nkey = 0
  local tmp = 0
  local hash = 0
  local nnkey = 0
  
  while (key_len > 0) do
    tmp = (key_len % 6) + 1
    nkey = nkey + (prime[tmp] * string.byte(key, key_len))
    key_len = key_len - 1
    nnkey   = nkey % 101
    hash    = tostring(nnkey)
  end
  
  return prefix .. "_" .. hash
end
------------------------------------------

----------------- healthcheck -------------
local function fetch_healthy_server(hash)
    local _value = avi.vs.table_lookup(hash)
    local _server1 = nil 
    local _ret_code = 0
    
    if (_value ~= nil) then
        local server_part, port_part = _value:match("^(.*)-(%d+)$")
        if server_part then
            _server1 = server_part
        else
            _server1 = _value -- Fallback if no hyphen-port pattern found
        end
        
        -- Health check verifies the physical server on auth port 1812
        if (avi.pool.get_server_status("l4-radius-pool", _server1, 1812) ~= 1) then
            avi.vs.log("server " .. _server1 .. " is down, removing entry")
            avi.vs.table_remove(hash)
            _server1 = nil
            _ret_code = 0          
        else 
            _ret_code = 1         
        end 
    end   
    return _ret_code, _server1
end
--------------------------------------------

---------- key and timeout select--------------
local function keysel() 
  if (vip_port ~= "1813" and vip_port ~= "1812" and vip_port ~= "1645" and vip_port ~= "1646") then 
    return nil, nil, nil, nil 
  end

  local dictionary = parse_radius.parsepacket(payload) 
  
  if (dictionary == nil) then
      avi.vs.log("Malformed RADIUS payload. Using Client IP failsafe.")
      return avi.vs.client_ip(), 28800, "ip", nil
  end

  local nas_port_type = dictionary["61"] 
  local calling_station_id = dictionary["31"] 
  local framed_ip = dictionary["8"] 
  local nas_ip = dictionary["4"] 
  local user_name = dictionary["1"] 
  
  local key = "" 
  local prefix = ""
  local timeout = 28800  
  
  if (calling_station_id ~= nil) then
    key = calling_station_id 
    prefix = "m" 
  elseif (nas_ip ~= nil) then
    key = nas_ip 
    prefix = "nas_ip" 
  elseif (user_name ~= nil) then
    key = user_name
    prefix = "user"
  else 
    -- Fallback for packets missing all standard identification attributes
    key = avi.vs.client_ip()
    prefix = "ip"
  end  
  
  if (nas_port_type == 19) then
    timeout = 3600 
  end  
  
  return key, timeout, prefix, framed_ip 
end


-----snmp parsing------------------------
if (vip_port == "161" or vip_port == "162") then
  --- if snmp packet, load balance it to servers. No persistence required ----
  avi.l4.ds_done()
  return

-----dhcp parsing----------------------------
elseif (vip_port == "67") then
  local dhcp_params, dictionary = parse_dhcp.getDHCPParamsAndOptions(payload)
  
  if (dictionary ~= nil) then
      local interface, mac = parse_dhcp.getOption61(dictionary) 
      
      if (mac ~= nil) then
         local key = string.lower(mac)
         local hash = hashfunction(key, "m")
         local health, server = fetch_healthy_server(hash)
         
         if (health == 1) then
             avi.pool.select("l4-radius-pool", server, 1812)
             avi.vs.log("Using client id:" .. key)
             avi.l4.ds_done()
             return
         end
      end
  end

------ https parsing ----- 
elseif (vip_port == "443") then
     local key = avi.vs.client_ip()
     local hash = hashfunction(key, "ip")
     local health, server = fetch_healthy_server(hash)
     
     if (health == 1) then 
         avi.pool.select("l4-radius-pool", server, 1812) 
         avi.l4.ds_done()
         return     
     end

----- radius 1813 (Accounting) parsing ---
elseif (vip_port == "1813" or vip_port == "1646") then
    local key, timeout, prefix, framed_ip = keysel()
    local hash = hashfunction(key, prefix)
    local health, server = fetch_healthy_server(hash)
    
    if (health == 0) then
      avi.vs.persist(hash, timeout)
      avi.l4.ds_done()
      return   
    end
    
    -- Secondary IP-based persistence for Framed-IP updates
    if (framed_ip ~= nil) then 
      local f_hash = hashfunction(framed_ip, "ip")
      if (avi.vs.table_lookup(f_hash) == nil) then
        local server_entry = server .. "-1812"    
        avi.vs.table_insert(f_hash, server_entry, timeout)
      else
        local f_health, f_server = fetch_healthy_server(f_hash)
        if (f_health == 0) then
         avi.vs.persist(f_hash, timeout)
        end
      end
    end   
    
    if (server ~= nil and server ~= "") then
        avi.pool.select("l4-radius-pool", server, 1812)
    end
    avi.l4.ds_done()
    return 

----- radius 1812 (Authentication) parsing -------
elseif (vip_port == "1812" or vip_port == "1645") then
   local key, timeout, prefix, framed_ip = keysel()
   local hash = hashfunction(key, prefix)

   local value = avi.vs.table_lookup(hash)
   if (value == nil) then
     avi.vs.persist(hash, timeout)
     avi.l4.ds_done()
     return 
   end 
   
   local health, server = fetch_healthy_server(hash)
   if (health ~= 1) then
      avi.vs.persist(hash, timeout)
      avi.l4.ds_done()
      return 
   else
      -- Reset persistence timer for active session
      avi.vs.table_refresh(hash, timeout) 
      
      if (server ~= nil and server ~= "") then
          avi.pool.select("l4-radius-pool", server, 1812)
      end
      avi.l4.ds_done()
      return 
   end
end

avi.l4.ds_done()