# HTTP Host Switching using Host Header and String Groups

Load balance requests across different pools based on Host header. Assuming host header value is key and pool name is value in String Group. Example, pools_stringgroup entries will look like www.example.com:www.example.com_pool, where host header value is key (www.example.com) and pool name (www.example.com_pool) is value. If 'www.example.com_pool' has servers up in the pool, pool will be selected. Pools and stringroup has to be attached to datascript. Create String Group using Template > Groups > String Groups. Key Value Pair option must be selected.  Apply this to the "HTTP REQUEST" Event.

```lua
-- HTTP_REQUEST
default_pool = "default_pool"
host = avi.http.get_header("Host")
-- if host header exists
if host then
  -- lookup pool name using host header value from pools_stringgroup
  -- assuming host header name is used as key in stringgroup pools_stringgroup
  -- pools_stringgroup entries will look like www.example.com:www.example.com_pool, where host header value is key and pool name is value
  -- pools and stringgroup has to be attached to datascript
  pool, match = avi.stringgroup.contains("pools_stringgroup", host)
  -- if pool found i.e. match == true
  avi.vs.log(match)
  if match then
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
