# Check URI, server count and respond 503

Match the HTTP URI and if the active pool members in the pool is less than 1, respond with HTTP 503 message.

## F5 Check URI, server count and respond 503

```
when HTTP_REQUEST {
 set $the_uri [HTTP::uri]
 if {($the_uri starts_with "/test/")} {
     if { [active_members Web_pool_http_pool_limit] < 1 } {
        HTTP::respond 503
        return
        } 
 pool App-Pool       
    }
}
```

## Avi Check URI, server count and respond 503

```lua
path = avi.http.get_path()

servers_up= avi.pool.get_servers("Web_pool_http_pool_limit")
if (string.beginswith(path, "/test/") and  servers_up == 0) then
avi.http.response(503)
else avi.pool.select("App-Pool")
end
```
