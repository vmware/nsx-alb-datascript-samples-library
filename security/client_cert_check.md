# Client Cert check
Client certificate based authentication is quite common use case in current secure infrastructure. Best aspect
is that Client cert based authentication can be done transparently and end user does not need to worry about
it every time. In this scenario, when Client certificate is received, the configuration checks for multiple fields
and ensures that Issuer for this certificate is known. More details: https://avinetworks.com/docs/latest/client-ssl-certificate-validation/

Apply this datascript to the "HTTP Request" Event.

```
-- HTTP_REQUEST
if avi.http.secure() then
  if avi.ssl.client_cert("avi.CLIENT_CERT_ISSUER") ~=
    "/C=US/O=foo/OU=www.foo.com/CN=www.foo.com/email=admin@foo.com" then
    avi.http.add_header("client_cert_issuer",
      avi.ssl.client_cert("avi.CLIENT_CERT_ISSUER"))
    avi.pool.select("Quarantine-Pool")
  end
end
```
