# Custom Site Persistence using Cookie - Solution C

Site Persistence can be achieved leveraging built-in Avi GSLB functionality, however there are use cases when external GSLB is used and site persistence required with Avi solution.

Solution C:

1. Cookie "site-persistence-cookie" is leveraged to define site persistence by allocating the cookie on new request that identify site specific information, site_cookie is defined as avi.pool.server_ip().. ":" .. avi.vs.port()
2. There are two pools has to be defined per site local_pool and remote_pool:
   * local_pool will serve new requests or existing requests based on site_cookie lookup
   * remote_pool will serve exists requests based on site_cookie lookup or serve new requests if local_pool does not have any active members
3. There are list of health checks built-in:
   a. to avoid redirecting request to site with no active servers
   b. to avoid attaching cookie for local processing if there are no local_pool members up

```lua
-- HTTP_REQ
avi.vs.reqvar.cookie_private_key= "7762135A21351139927D442559CE06CC"
avi.vs.reqvar.site_persistence_cookie_name = "site-persistence-cookie"
local_pool = "local_pool"
remote_pool = "remote_pool"

local_pool_servers_up_count, local_pool_servers_total_count = avi.pool.get_servers(local_pool)
remote_pool_servers_up_count, remote_pool_servers_total_count = avi.pool.get_servers(remote_pool)
cookie_exists = nil
decrypted_site_cookie = nil

if avi.http.cookie_exists(avi.vs.reqvar.site_persistence_cookie_name) then
  cookie_exists = 1
  site_cookie = avi.http.get_cookie(avi.vs.reqvar.site_persistence_cookie_name)
  decoded_site_cookie = avi.utils.base64_decode(site_cookie)
  valid_block_length = pcall(avi.crypto.decrypt,decoded_site_cookie,avi.vs.reqvar.cookie_private_key)
  if valid_block_length then
    decrypted_site_cookie = avi.crypto.decrypt(decoded_site_cookie,avi.vs.reqvar.cookie_private_key)
  else
    avi.http.remove_cookie(avi.vs.reqvar.site_persistence_cookie_name)
    decrypted_site_cookie = nil
  end
end

if cookie_exists and decrypted_site_cookie then
  site_cookie = {}
  for match in decrypted_site_cookie:gmatch("([^:]+),?") do
   table.insert(site_cookie,match)
  end
  -- decrypted_site_cookie = "192.168.0.246:80"
  -- site_cookie[1] = 192.168.0.246
  -- site_cookie[2] = 80
  cookie_pool_server_address = site_cookie[1]
  cookie_pool_server_port = site_cookie[2]

  local_pool_contains_cookie_pool_server_address = pcall(avi.pool.select,local_pool,cookie_pool_server_address)
  remote_pool_contains_cookie_pool_server_address = pcall(avi.pool.select,remote_pool,cookie_pool_server_address)

  if local_pool_contains_cookie_pool_server_address then
    avi.pool.select(local_pool, cookie_pool_server_address)
  elseif remote_pool_contains_cookie_pool_server_address then
    avi.pool.select(remote_pool, cookie_pool_server_address)
  else
    avi.http.remove_cookie(avi.vs.reqvar.site_persistence_cookie_name)
    avi.vs.reqvar.set_cookie = 1
    if local_pool_servers_up_count >= 1 then
      avi.pool.select(local_pool)
    elseif remote_pool_servers_up_count >= 1 then
      avi.pool.select(remote_pool)
    end
  end
else
  avi.http.remove_cookie(avi.vs.reqvar.site_persistence_cookie_name)
  avi.vs.reqvar.set_cookie = 1
  if local_pool_servers_up_count >= 1 then
    avi.pool.select(local_pool)
  elseif remote_pool_servers_up_count >= 1 then
    avi.pool.select(remote_pool)
  end
end
```

```lua
-- HTTP_RESP
if avi.vs.reqvar.set_cookie == 1 then
  site_cookie = avi.pool.server_ip().. ":" .. avi.vs.port()
  encrypted_site_cookie = avi.crypto.encrypt(site_cookie, avi.vs.reqvar.cookie_private_key)
  encoded_site_cookie = avi.utils.base64_encode(encrypted_site_cookie)
  avi.http.add_cookie (avi.vs.reqvar.site_persistence_cookie_name, encoded_site_cookie)
end
```
