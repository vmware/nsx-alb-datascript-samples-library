# Datascript Examples

**Availability**
[HTTP Host Switching](availability/host_switching.md)  
[HTTP URI Switching - Simple](availability/uri_switching.md)  
[HTTP URI Switching - Advanced](availability/uri_switching2.md)  
[HTTP IP Switching](availability/ip_switching.md)  


### Port Redirects

When the port does not equal 443, then redirect the client to the HTTPS url. This could be used when you want to force all traffic to a specific port.

```
if avi.vs.port() ~= "443" then
  avi.http.redirect("https://" .. avi.vs.host() .. avi.http.get_uri())
end
```

### Bot corral
```
```

### Custom html response
```
body = "Hostname:" + avi.vs.host()
avi.http.response( 200, body )

```

### AB pool selection
```
poolA = "poolA"
poolB = "poolB"

if avi.http.get_path() == "/A/" then
   avi.pool.select(poolA)
elseif avi.http.get_path () == "/B/" then
   avi.pool.select(poolB)
end
```

### Content switch - hostname
```
```

### Content Switch - Path
```
if string.lower(avi.http.get_path()) == "/app1/" then
  avi.pool.select("app1-pool")
else
  avi.pool.select("other")
end
```

### Client Cert check
```
if avi.http.secure() then
  if avi.ssl.client_cert("avi.CLIENT_CERT_ISSUER") ~=
    "/C=US/O=foo/OU=www.foo.com/CN=www.foo.com/email=admin@foo.com" then
    avi.http.add_header("client_cert_issuer",
      avi.ssl.client_cert("avi.CLIENT_CERT_ISSUER"))
    avi.pool.select("Quarantine-Pool")
  end
end
```

### Location Port Rewrite
```
```

### SSL Version check
```
ssl_version = avi.ssl.protocol()
avi.vs.log(ssl_version)
```

### Content Switch - Geolocation
```
```

### Cookie jar
```
cookie_table = {jsessionid="123", lang="en"}
avi.http.add_cookie( cookie_table )
```

### Log Custom Data
```
my_string = "This is to be inserted into the log"
avi.vs.log(my_string)
```

### Cookie encryption gateway
```
```

### Header sanitization
```
```
