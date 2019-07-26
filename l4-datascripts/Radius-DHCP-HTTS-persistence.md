```
local parse_radius=require 'Default-Radius'
local parse_dhcp=require 'Default-DHCP'
local dictionary= {}
payload=avi.l4.read() 

local prime={3,5,7,11,13,17}
local vip_port=avi.vs.port()
local vs_name=avi.vs.name()


---------------- hash function ---------
----- create hash for the key ----
local function hashfunction(key, prefix)
  local key_len = string.len(key)
  local nkey = 0
  local tmp = 0
  local hash = 0
  
  while (key_len > 0) do
    tmp = (key_len%6) + 1
    nkey = nkey + (prime[tmp] * string.byte(key,key_len))
    key_len = key_len -1
    nnkey   = nkey % 101
    hash    = tostring(nnkey)
    return prefix.."_"..hash;
  end
end
------------------------------------------

----------------- healthcheck -------------
--- check health of server, return 0 if server down, 1 if server up ---
local function fetch_healthy_server(hash)
    local _value = avi.vs.table_lookup(hash)
    local _server = ""
    local _ret_code = 0
    
        if(_value ~= NIL) then
           local s = parse_radius.split(_value, "-")
          _server1 = s[1]
           if(avi.pool.get_server_status("l4-radius-pool", _server1, 1812) ~= 1) then
             avi.vs.log("server".._server1.."is down, removing entry")
             avi.vs.table_remove(hash)
             _ret_code = 0          
           else 
            _ret_code = 1         
         end 
        end   
    return _ret_code, _server1;
end
--------------------------------------------



---------- key and timeout select--------------

---- keyselect for radius 1812 and 1813 ---- 
local function keysel()  
  if (vip_port ~= "1813" and vip_port ~= "1812") then
    return 
  end

  avi.vs.log("vip_port ="..vip_port)
  local dictionary = parse_radius.parsepacket(payload)
  local nas_port_type=dictionary["61"]
  local calling_station_id=dictionary["31"]
  local framed_ip=dictionary["8"]
  local nas_ip=dictionary["4"]
  local key = ""
  local timeout = 28800
  
  if (calling_station_id == NIL) then
    key = nas_ip
    prefix = "nas_ip"
  else
    key = calling_station_id
    prefix = "m"
  end
  
  if (nas_port_type == 19) then
    timeout  = 3600
    avi.vs.debuglog("timeout"..timeout)
  end
  
  return key, timeout, prefix, framed_ip  
end


-----snmp parsing------------------------
if(vip_port=="161" or vip_port=="162") then 
  --- if snmp packet, load balance it to servers. No persistence required ----
  avi.l4.ds_done()
  return

  -----dhcp parsing----------------------------
elseif (vip_port == "67") then
  dhcp_params, dictionary = parse_dhcp.getDHCPParamsAndOptions(payload)
  interface, mac = parse_dhcp.getOption61(dictionary) 
  key = string.lower(mac)
  local health = 0
  local server = ""

 if (key ~= NIL) then
     hash = hashfunction(key, "m")
     health, server = fetch_healthy_server(hash)
    if(health == 1) then
        avi.pool.select("l4-radius-pool", server, 1812)
        avi.vs.log("Using client id"..key)
        avi.l4.ds_done()
        return
    end
  end

------ https parsing ----- 
elseif (vip_port == "443") then
     key = avi.vs.client_ip()
     hash = hashfunction(key,"ip")
     health, server = fetch_healthy_server(hash)
       if (health == 1) then 
         avi.pool.select("l4-radius-pool", server, 1812) 
         avi.l4.ds_done()
         return     
       end

----- radius 1813 parsing ---
elseif (vip_port == "1813") then
    key, timeout, prefix, framed_ip  = keysel()
    hash = hashfunction(key,prefix)
    health, server = fetch_healthy_server(hash)
    if (health == 0) then
      avi.vs.persist(hash, timeout)
      avi.l4.ds_done()
      return   
    end
    

    if(framed_ip ~= NIL) then 
      avi.vs.log("persist using framed ip")
      key = framed_ip
      hash = hashfunction(key, "ip")
      if(avi.vs.table_lookup(hash)==NIL) then
        server2 = server.."-"..tostring(1812)    
        avi.vs.table_insert(hash,server2,timeout)
      else
        health,server=fetch_healthy_server(hash)
        if(health==0) then
         avi.vs.persist(hash,timeout)
        end
      end
    end   
    avi.pool.select("l4-radius-pool", server, 1812)
    avi.l4.ds_done()
    return 

-----radius authentication(1812) parsing-------
elseif (vip_port=="1812") then
 avi.vs.debuglog("!!! I'm at 1812")
 key, timeout, prefix, framed_ip = keysel()
 hash = hashfunction(key,prefix)

---- health check & create persistence-----
 value = avi.vs.table_lookup(hash)
   if(value == NIL) then
     avi.vs.persist(hash, timeout)
     avi.vs.log("new entry")
     avi.l4.ds_done()
     return 
   end 
   health,server = fetch_healthy_server(hash)
   if (health~=1) then
      avi.vs.persist(hash, timeout)
      avi.vs.log("server down")
      avi.l4.ds_done()
      return 
    else
      avi.vs.log("updating timers for existing entry")
      avi.vs.table_refresh(key,timeout)
      avi.pool.select("l4-radius-pool", server, 1812)
      avi.l4.ds_done()
      return 
   end
end
avi.l4.ds_done()
```
