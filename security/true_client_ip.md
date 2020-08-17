#True-Client on HTTP Header

Modify HTTP Header be adding True-Client IP Address while sending HTTP Request to Application server, here actual client is behind Porxy. Hence we Virtual Service will see client IP Address as Proxy IP Address

```lua
-- HTTP_REQUEST
-- get http headers
headers = avi.http.get_header()
-- iterate across set of headers
for header,value in pairs(headers) do
  if string.beginswith(string.lower(header),"True-Client-IP") then
    -- add True-Client-IP header with True Client IP address
    avi.http.add_header("True-Client-IP", value)
  end
end
```
