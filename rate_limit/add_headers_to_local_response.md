# Add Custom Headers to Local Response in Rate Limiting
You can use the DataScript Rate Limit function to add your own custom headers to the
Local Response that is sent by a rate limiter.
For the script to work you need to set the "custom" rate limiter in the Application
Profile.

The script below is written to emulate the VS Performance Rate Limiter. So all
requests to a specific VS are rate limited.

```lua
-- Event: HTTP_REQUEST
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

count_exceeded, action = avi.vs.rate_limit(avi.RL_CUSTOM_STRING, avi.vs.name(), true) -- or avi.vs.ip()
if count_exceeded and action == avi.RL_ACTION_LOCAL_RSP then
            avi.http.response(429, resp_headers , resp_body)
            end
```
