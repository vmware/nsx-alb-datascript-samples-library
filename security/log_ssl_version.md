# Log SSL Version and block SSLv3.0 or TLSv1.0
Logging of SSL/TLS version for enhanced log collection and troubleshooting use cases. SSLv3 is known to be weak and vulnerable thus ability to track the SSLv3 transaction is important for the administrators.

```
-- HTTP_REQUEST
-- logging version
avi.vs.log(avi.ssl.protocol())

-- closing connection for SSLv3.0 or TLSv1.0
if avi.ssl.protocol() == "TLSv1" or avi.ssl.protocol() == "SSLv3.0" then
   avi.http.close_conn()
end
```
