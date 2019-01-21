# Append string(www) and redirect to http(s) host 

```lua
-- HTTP_REQUEST
-- if server is 
if string.beginswith(avi.http.hostname(),"www") == false then
    avi.http.redirect(avi.http.protocol() .. "://www." .. avi.http.hostname() .. avi.http.get_uri())
end
```
