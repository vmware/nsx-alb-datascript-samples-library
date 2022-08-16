# Log HTTP Headers
Logging of HTTP headers for enhanced log collection and troubleshooting use cases.

```lua
-- HTTP_REQUEST
-- get http headers
headers = avi.http.get_header()
-- iterate across set of headers
for header,value in pairs(headers) do
    avi.vs.log(header .. ":" .. value)
end
```
