# HTTP Host Switching using Host Header

Load balance requests to different pools based on Host header. Assuming host header name is used to generate pool name. Example, if host header equals to 'www.example.com',' pool 'www.example.com_pool' will be selected. If 'www.example.com_pool' has servers up in the pool, pool will be selected. Pools has to be attached to datascript. Apply this to the "HTTP REQUEST" Event.

```
-- HTTP_REQUEST
default_pool = "default_pool"
host = avi.http.get_header("Host")
-- if host header exists
if host then
  -- assuming host header name is used to generate pool name
  -- example, if host header is www.example.com, pool name is www.example.com_pool
  -- Pools has to be attached to datascript
  pool = host .. "_pool"
  -- verify if pool exists
  pool_exists = pcall(avi.pool.get_servers,pool)
  -- if yes and pool has active servers, select it
  if pool_exists then
    servers_up, servers_total = avi.pool.get_servers(pool)
    -- verify that pool functional and has servers up
    if servers_up >= 1 then
      avi.pool.select(pool)
      avi.vs.log("SELECTED_POOL:" .. pool)
    -- if no, use default pool
    else
      avi.pool.select(default_pool)
      avi.vs.log("SELECTED_POOL:" .. default_pool)
    end
  -- if no, use default pool
  else
    avi.pool.select(default_pool)
    avi.vs.log("SELECTED_POOL:" .. default_pool)
  end
end
```
