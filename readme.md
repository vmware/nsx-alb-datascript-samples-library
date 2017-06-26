# Datascript Examples

## Availability

[HTTP Host Switching](availability/host_switching.md)  
[HTTP URI Switching - Simple](availability/uri_switching.md)  
[HTTP URI Switching - Advanced](availability/uri_switching2.md)  
[HTTP IP Switching](availability/ip_switching.md)  
[JSessionID Persistence](availability/jsessionid_persistence.md)  
[HTTP Retry 500 Errors](availability/http_retry_500_error.md)

## Security
[HTTP to HTTPS Port Redirect](security/http_to_https_redirect.md)  
[Client Cert check](security/client_cert_check.md)  
[Log SSL Version](security/log_ssl_version.md)  
[Close Connections without Host](security/close_connection_without_host.md)  
[Cookie Encryption Gateway](security/cookie_encryption_gateway.md)


### Bot corral
```
```

### Custom html response
```
body = "Hostname:" + avi.vs.host()
avi.http.response( 200, body )

```

### Location Port Rewrite
```
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
