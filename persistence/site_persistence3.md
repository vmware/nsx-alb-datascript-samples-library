# Custom Site Persistence Leveraging Server Persistence Cookie for Two Sites Scenario

Site Persistence can be achieved leveraging built-in Avi GSLB functionality, however there are use cases when external GSLB is used and site persistence required with Avi solution.

1. Solution is designated to achieve site persistence across two sites scenario.
2. Sites are identified by server persistence cookie name assigned using persistence profile.
3. There are two pools has to be defined per site local_pool and remote_pool:
   a. local_pool will be used to serve new requests/sessions or existing. Existing sessions will be identified by server persistence cookie. Local_pool consists of actual application servers.  local_pool will have persistence profile assigned - based on cookie.
   b. remote_pool will be used to redirect sessions/requests to remote site based on server persistence cookie. Remote_pool will include only ip of remote site virtual service.  remote_pool will not have persistence profile enabled.
4. local_pool_status_uri defines uri to query virtual service status based on local_pool state by external GSLB system

```lua
-- HTTP_REQ
-- local_pool will have persistence set using persistence profile under pool configuration
local_site_server_persistence_cookie_name = "KVAAVROI"
-- remote_pool will not have persistence profile, remote_pool is to represent remote virtualservice, remote_pool will be used to proxy requests back to originally pinned servers based on local_pool persistence
-- cookie specified below is to identify remote site, the actual remote_site_server_persistence_cookie_name represents a cookie name that set by persistence profile under local_pool configuration at remote site
remote_site_server_persistence_cookie_name = "DDVHSLLQ"
-- local_pool will be default pool for virtualservice and will be set under virtualservice configuration
local_pool = "local_pool"
-- remote_pool to include ip address of virtualservice of remotesite
remote_pool = "remote_pool"
-- specify uri which will be used to access local pool health status
local_pool_status_uri = "/local_pool_status"

local_pool_servers_up_count, local_pool_servers_total_count = avi.pool.get_servers(local_pool)
remote_pool_servers_up_count, remote_pool_servers_total_count = avi.pool.get_servers(remote_pool)

-- Providing local pool state to allow external gslb service properly perform health monitor of virtualservice based on local pool state
if avi.http.get_uri() == local_pool_status_uri then
  if local_pool_servers_up_count >= 1 then
    avi.http.response(200, {content_type="text/html"},
      "LOCAL POOL STATE: UP")
  else
    avi.http.response(503, {content_type="text/html"},
      "LOCAL POOL STATE: DOWN")
  end
end

-- If received request has request with cookie assigned by remote site, proxy request back using remote_pool.
-- request only will be proxied if remote_pool is up, meaning remote dc is up
if (avi.http.cookie_exists(remote_site_server_persistence_cookie_name) and remote_pool_servers_up_count >= 1) or local_pool_servers_up_count < 1  then
  avi.pool.select(remote_pool)
end
```
