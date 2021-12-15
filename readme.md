# DataScript Examples

## Content Switching
[HTTP Host Switching](availability/host_switching.md)  
[HTTP Host Switching using Host Header](availability/host_switching2.md)  
[HTTP Host Switching using Host Header and String Groups](availability/host_switching3.md)  
[HTTP URI Switching - Simple](availability/uri_switching.md)  
[HTTP URI Switching - Advanced](availability/uri_switching2.md)  
[HTTP IP Switching](availability/ip_switching.md)  
[HTTP Content Switch based on HTTP POST / REQUEST DATA](availability/content_switch_based_on_http_request_data.md)  
[HTTP URI Switching using String Groups - Advanced](availability/uri_switching3.md)  

## L4 Traffic Management


## Availability

[HTTP Retry 500 Errors](availability/http_retry_500_error.md)  
[Fall back to secondary pool or custom maintenance page](availability/fall_back_to_secondary_pool_if_primary_pool_is_down_display_maint_page.md)  
[Load Balancing during Maintenance Window](availability/load_balancing_during_maintenance.md)  
[HTTP redirect based on Client location taken from source IP address](availability/http_redirect_based_on_client_country.md)  
[GEO Location database lookup based on source IP](availability/client_geo_headers.md)  
[Rewrite	HTTP	redirect	response	from	301	to	302](availability/rewrite_http_redirect_response_from_301_302.md)  
[Ratio	based	Load	Balancing](availability/ratio_based_load_balancing.md)  
[Location header rewrite with non-standard port](availability/location_header_rewrite_with_nonstandard_port.md)  
[Prepend request path](availability/path_prepend.md)  
[Append string(www) and redirect to http(s) host](availability/append_www_to_http_https_host.md)  
[Custom connection timeout for specific URI path or pool](availability/timeouts.md)    
[Rewrite single HTTP query option from the existing set of query options - Advanced](availability/overwrite_http_query1.md)  
[URI Encoding Function](availability/uri_encode.md)  
[Managing Proxy Auto-Configuration (PAC) file](availability/proxy_pac.md)   

## Persistence

[Header Persistence](availability/custom_header_persistence.md)  
[JSessionID Persistence](availability/jsessionid_persistence.md)  
[Site Persistence using Cookie - Solution A](availability/site_persistence.md)  
[Site Persistence using Cookie - Solution B](availability/site_persistence2.md)  
[Site Persistence using Cookie - Solution C](availability/site_persistence5.md)  
[Site Persistence Leveraging Server Persistence Cookie for Two Sites Scenario](availability/site_persistence3.md)  
[Persistence using URI with options for timeout](availability/uri_persistence.md)  
[Load Balance/Persist using Custom Consistent Hash](availability/custom_persistence_using_custom_consistent_hash.md)  

## Security
[HTTP to HTTPS Port Redirect](security/http_to_https_redirect.md)  
[Client Cert check](security/client_cert_check.md)  
[Block SSLv3.0, TLSv1.0 or cipher suites that don't provide encryption](security/log_ssl_version.md)  
[Blacklist Specific URIs using String Group](security/blacklist_specific_uris_using_stringgroup.md)  
[Disable HTTP	Processing	For	Selective HTTP	Methods](security/disable_http_processing_for_selective_http_methods.md)  
[Mitigate	Microsoft	vulnerability	MS15-034 and CVE-2015-1635](security/mitigate_microsoft_vulnerability_ms15-034.md)  
[Computing HMAC](security/computing_hmac.md)  
[Controlling Bots](security/controlling_bots.md)  
[Cross	Origin	Resource	Sharing	Implementation](security/cors.md)  
[Parse and Log Username from HTTP requests](security/parse_and_log_username_from_http_req.md)  
[Retrieve SAML Attribute from session cookie and expose it as Header and as Avi Logging attribute](security/saml_attrs.md)  
[Client SSL Certificate Validation with Header Insertion](security/irule_Client_Auth.md)  
[Generate Custom Session ID based on time, ip address and GET request id hash value](security/generate_session_id.md)  
[Add SameSite attribute to Cookies that do not have it](security/add_samesite_cookie.md)  
[Check For log4j Attacks (CVE-2021-44228)](security/check_for_log4j_attacks.md)  

### Security - Cookie
[Validate String Characters in Cookie / Cookie Sanitizer](security/validate_string_characters_in_cookie.md)  
[Cookie Encryption Gateway](security/cookie_encryption_gateway.md)  
[Cookie Rewrite / Cookie Sanitizer](security/cookie_rewrite.md)

### Security - Header
[X-Forwarded-For Header Insert](security/x_forwarded_for_header_insert.md)  
[X-Client-IP allow requests from range of IPs](security/x_client_allow_request_from_range_of_ips.md)  
[Header Insertion for Content Security](security/header_insertion_for_content_security.md)  
[Remove X-* and Server Headers from Response](security/remove_x_headers_from_http_resp.md)  
[Close Connections without Host header](security/close_connection_without_host.md)  
[Redirect	Location	header	validator](security/redirect_location_header_validator.md)  
[Let's Encrypt Server chanllange response](security/let's_Encrypt_Response.md)  
[True Client IP on Header](security/true_client_ip.md)  

## Acceleration
[Client Cache Control Behavior](availability/client_cache_control_behavior.md)  

## Rate Limiting
[Setting up Rate Limiter to use in DataScript](rate_limit/set_up_DS_rate_limiter.md)  
[Add Custom Headers to Local Response](rate_limit/add_headers_to_local_response.md)  
[Enforce a Penalty Timeout for Blacklisted Clients](rate_limit/rate_limit_penalty_box.md)  
[HTTP Header Rate Limiter](rate_limit/rate_limit_http_method.md)  

## Troubleshooting
[Log SSL Version](security/log_ssl_version.md)  
[Log HTTP Headers](security/log_http_headers.md)  

## Misc
[Pseudo-random hex	character	generator](security/pseudo_random_hex_generator.md)  
[Random Letter generator](security/random_letter_generator.md)  
