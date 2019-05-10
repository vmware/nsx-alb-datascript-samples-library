# Datascript APIs for Client SSL Certificate Validation with Header Insertion

The script check if the request is HTTPS or not, if it is HTTPS it continiues and check the SSL Certifications.
Datascript API (avi.ssl.check_client_cert_validity()) is to expose the different scenarios of client certificate validation namely:

1. Certificate was presented by client and successfully validated
2. Certificate was presented but not valid (Implementation of this condition is independent of bit map right now)
3. Certificate was not presented by the Client

```lua
-- Check if the request is HTTPS, if not, skip
if avi.http.secure() == "on" then
    cert_verify = avi.ssl.check_client_cert_validity()
    if cert_verify == 1 then
        avi.http.add_header("Client-Auth", "Valid cert")
    elseif cert_verify == 2 then
        avi.http.add_header("Client-Auth", "UNABLE_TO_GET_ISSUER_CERT_LOCALLY")
    else
        avi.http.add_header("Client-Auth", "No cert")
    end
end
```
