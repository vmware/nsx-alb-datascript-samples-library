# Send Token Response to Let's Encrypt Servers Challange

Will Send Token Response to Let's Encrypt Servers Challange, here we will get token from HTTP URI and send response back by appending response value
Here we need to define static value for response

```lua
-- HTTP_REQUEST
-- Use get_path to ignore query strings
local path = avi.http.get_path()

-- Use match to extract the token. 
-- Escape both '.' and '-' in the path
-- Inside Brackets, %w represents all alphanumeric characters (%d%l%u), and - just represents the hyphen.
local token = path:match("^/%.well%-known/acme%-challenge/([%w-]+)$")

-- If a valid token is found, intercept and respond
if token then
    local resptoken = token .. ".<Define Response Value>"
    
    -- Respond with 200 OK and text/plain instead of text/html
    avi.http.response(200, { content_type="text/plain" }, resptoken)
end
```
