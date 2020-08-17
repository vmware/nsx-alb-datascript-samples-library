# Send Token Response to Let's Encrypt Servers Challange

Will Send Token Response to Let's Encrypt Servers Challange, here we will get token from HTTP URI and send response back by appending response value
Here we need to define static value for response

```lua
-- HTTP_REQUEST
local uri = avi.http.get_uri()
token = ' '
for key in uri:gmatch("([^/]+)") do  
    token = key
  end
resptoken = (token .. ".<Define Response Value>")
avi.vs.log(resptoken)
if avi.http.get_uri() == ("/well-known/acme-challenge/"..token) then
    avi.http.response(200, { }, resptoken)
end 
```
