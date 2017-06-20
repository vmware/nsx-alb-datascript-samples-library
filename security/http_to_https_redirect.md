# HTTP to HTTPS Port Redirect

When the port does not equal 443, then redirect the client to the HTTPS url. This could be used when you want to force all traffic to a specific port.

```
if avi.vs.port() ~= "443" then
  avi.http.redirect("https://" .. avi.vs.host() .. avi.http.get_uri())
end
```
