# Persistence using URI with options for timeout

This example talks about server persistence based on URI within customer request.
Client has two options to select connection persistence timeout for 30 minutes or 9 hours based on the query. If "s" parameter specified, connection persistence is set for 30 minutes, if "l" for 9 hours. Query example, http:///192.168.0.245/?l=12345, where "l" option flag and "12345" is unique client identifier.

Persistence can be easily done through REST/UI/CLI: https://avinetworks.com/docs/17.2/custom-http-header-persistence/ or through Custom Datascript below:

Apply these scripts to the "HTTP REQUEST" & "HTTP RESPONSE" events appropriately ,pool has to be selected for datascript.

```lua
-- HTTP_REQUEST
default_pool = "default_pool"
if avi.http.get_query("s", "true") then
  avi.vs.reqvar.uri_value = "s:" .. avi.http.get_query("s", "true")
elseif avi.http.get_query("l", "true") then
  avi.vs.reqvar.uri_value =  "l:" .. avi.http.get_query("l", "true")
end
-- if header provided
if avi.vs.reqvar.uri_value then
  -- lookup server using uri value for existing mapping in persistence table
  avi.vs.reqvar.pinned_server_ip = avi.vs.table_lookup(avi.vs.reqvar.uri_value )
  if pinned_server_ip  then
     avi.vs.log("LOOKUP:" .. avi.vs.reqvar.pinned_server_ip)
  end
  -- assumming VS port matches server port
  pinned_server_port = avi.vs.port()
  -- if server found in persistence table and it's up, use already pinned server, if not use default pool
  if avi.vs.reqvar.pinned_server_ip and avi.pool.get_server_status(default_pool, avi.vs.reqvar.pinned_server_ip, pinned_server_port) == 1 then
    avi.pool.select(default_pool, avi.vs.reqvar.pinned_server_ip)
  else
    avi.vs.log("REMOVE:" .. avi.vs.reqvar.uri_value )
    avi.vs.table_remove(avi.vs.reqvar.uri_value )
    avi.pool.select(default_pool)
  end
end
```

```lua
-- HTTP_RESPONSE
if avi.vs.reqvar.uri_value then
  selected_server_ip = avi.pool.server_ip()
  if avi.vs.reqvar.pinned_server_ip then
    -- Update the expire time for a table entry for active connection i.e. existing persistence entry
    avi.vs.log("REFRESH:" .. avi.vs.reqvar.uri_value )
    if string.beginswith(avi.vs.reqvar.uri_value ,"s") then
      avi.vs.table_refresh(avi.vs.reqvar.uri_value , 1800)
    elseif string.beginswith(avi.vs.reqvar.uri_value ,"l") then
      avi.vs.table_refresh(avi.vs.reqvar.uri_value , 32767)
    end
  else
    -- Create persistence entry
    avi.vs.log("INSERT:" .. selected_server_ip)
    if string.beginswith(avi.vs.reqvar.uri_value ,"s") then
      avi.vs.table_insert(avi.vs.reqvar.uri_value , selected_server_ip, 1800)
    elseif string.beginswith(avi.vs.reqvar.uri_value ,"l") then
      avi.vs.table_insert(avi.vs.reqvar.uri_value , selected_server_ip, 32767)
    end
  end
end
```
