# Datascript Examples

## Availability

[HTTP Host Switching](availability/host_switching.md)  
[HTTP URI Switching - Simple](availability/uri_switching.md)  
[HTTP URI Switching - Advanced](availability/uri_switching2.md)  
[HTTP IP Switching](availability/ip_switching.md)  
[JSessionID Persistence](availability/jsessionid_persistence.md)  
[HTTP Retry 500 Errors](availability/http_retry_500_error.md)  
[Fall back to secondary pool or custom maintenance page](availability/fall_back_to_secondary_pool_if_primary_pool_is_down_display_maint_page.md)  
[Load Balancing during Maintenance Window](availability/load_balancing_during_maintenance.md)  
[Rewrite HTTP Redirect Port](availability/rewrite_http_redirect_port.md)  
[Header Persistence using Akamai True-Client-IP header](availability/header_persistence_akamai_true_client_ip.md)  
[HTTP redirect based on Client location taken from source IP address](availability/http_redirect_based_on_client_country.md)  

## Security

[HTTP to HTTPS Port Redirect](security/http_to_https_redirect.md)  
[Client Cert check](security/client_cert_check.md)  
[Log SSL Version and block SSLv3.0 or TLSv1.0](security/log_ssl_version.md)  
[Log HTTP Headers](security/log_http_headers.md)  
[Close Connections without Host](security/close_connection_without_host.md)  
[Cookie Encryption Gateway](security/cookie_encryption_gateway.md)  
[Header Insertion for Content Security](security/header_insertion_for_content_security.md)  
[Remove X-* and Server Headers from Response](security/remove_x_headers_from_http_resp.md)  
[X-Client-IP allow requests from range of IPs](security/x_client_allow_request_from_range_of_ips.md)  
[Blacklist Specific URIs using String Group](security/blacklist_specific_uris_using_stringgroup.md)    
[X-Forwarded-For Header Insert](security/x_forwarded_for_header_insert.md)  
## Misc

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
