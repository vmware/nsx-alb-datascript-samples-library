# Remove X-* and Server Headers from Response
  Remove multiple X-* headers inserted by proxies on request path, as well as hide Server header. Apply this to the "HTTP RESPONSE" Event.

```lua
-- HTTP_RESP
-- get http headers
headers = avi.http.get_header()
-- iterate across set of headers
for header,value in pairs(headers) do
  if string.beginswith(string.lower(header),"x-") or string.contains(string.lower(header),"server")  then
      avi.http.remove_header(header)
      -- generate log message
      avi.vs.log("Header Removed: " .. header .. " : " .. value)
  end
end
```
