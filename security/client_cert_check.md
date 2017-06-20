# Client Cert check

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
