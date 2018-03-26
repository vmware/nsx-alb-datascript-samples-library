# Rewrite HTTP Redirect Port
Manipulating the Location header to remove specific port assignment. Apply this to the "HTTP RESPONSE" Event.

```
-- HTTP RESP
-- if server response is a redirect (3XX)
if string.beginswith(avi.http.status(),"3") then
  -- Remove any custom TCP ports in URL, example replacing :8080/ with :/
  avi.http.redirect(avi.http.protocol() .. "://" .. avi.vs.host() .. avi.http.get_uri())
end
```
