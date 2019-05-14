# Datascript APIs for Client SSL Certificate Validation with Header Insertion with X509 certification

The script check if the request is HTTPS or not, if it is HTTPS it continiues and check the SSL Certifications.
Datascript API (avi.ssl.check_client_cert_validity()) is to expose the different scenarios of client certificate validation namely:
avi.http.add_header("PP_CLIENT_CERT",cert_data) - will insert the SSL certtificate in the PP_CLIENT_CERT header

For a refernce to the response codes: https://linux.die.net/man/1/verify

1. Certificate was presented by client and successfully validated
2. Certificate was presented but not valid (Implementation of this condition is independent of bit map right now)
3. Certificate was not presented by the Client

```lua
-- Check if the request is HTTPS, if not, skip
if avi.http.secure() == "on" then
    cert_verify = avi.ssl.check_client_cert_validity()
    if cert_verify == 1 then
        avi.http.add_header("Client-Auth", "Valid cert")
    else
        avi.http.add_header("Client-Auth", avi.ssl.check_err_in_client_cert(cert_verify))
        cert_data = avi.ssl.client_cert(avi.CLIENT_CERT)
        avi.http.add_header("PP_CLIENT_CERT",cert_data)
    end
else
        avi.http.add_header("Client-Auth", "No cert")
end
```