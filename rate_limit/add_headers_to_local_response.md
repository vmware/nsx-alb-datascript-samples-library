# Add Custom Headers to Local Response in Rate Limiting
You can use the DataScript Rate Limit function to add your own custom headers to the
HTTP Response.
For the script to work you need to add a rate limiter in the DataScript.

The script below is written to emulate the VS Performance Rate Limiter. So all
requests to a specific VS are rate limited.

> The DS was tested under Avi version **21.1.3** and **22.1.1**

```lua
-- Event: HTTP_REQUEST
local rate_limiter = 'vs_rl'

resp_headers = {["My-header"]="Header_Data", ["Content-type"]="text/html"}
resp_body = [[
<html>
<head><title>429 Too Many Requests</title></head>
<body>
<center><h1>429 Too Many Requests</h1></center>
<hr><center>Avi Vantage/</center>
</body>
</html>
]]

exceeded = avi.vs.ratelimit.exceed(rate_limiter, avi.vs.name()) -- or avi.vs.ip()
if exceeded then
    avi.http.response(429, resp_headers , resp_body)
end

```
