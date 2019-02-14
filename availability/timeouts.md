# Custom connection timeout for URI path / pool

Connection timeout is defined within network profile (TCP Proxy profile > Idle Timeout) as part of virtual service configuration, however can be customized further leveraging datascript. DDoS > HTTP Keep-Alive Timeout under Application Profile can be used to ensure Keep-Alives are sent to the client and the client does not prematurely close out the connection to Avi. 

```lua
-- HTTP_REQUEST
if string.beginswith(avi.http.get_path(), "/special/") then
   avi.http.set_server_timeout(3600000)
   avi.pool.select("special_pool")
else
   -- Set the timeout in ms, this is currently set to 10 min
   avi.http.set_server_timeout(600000)
   avi.pool.select("default_pool")
end
```

