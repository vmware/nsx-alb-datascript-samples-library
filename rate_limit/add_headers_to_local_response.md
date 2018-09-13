# Add Custom Headers to Local Response in Rate Limiting
You can use the DataScript Rate Limit function to add your own custom headers to the
Local Response that is sent by a rate limiter.
For the script to work you need to set the "custom" rate limiter in the Application
Profile.

1. On the controller, go to **Templates**
2. Under the **Application** tab, select and edit your Application Profile 
   (or create a new one)
3. Select the **DDoS** tab
4. Under **Add Rate Limit**, select **Rate Limit all HTTP requests that map to any 
   custom string to all URLs of the Virtual Service.**
5. Enter the values for **Threshold** and **Time Period**. 
   For this particular use-case select **Action** as _Send HTTP Local Response_ and 
   **Status Code** as _429_. You do not need to upload a file.
6. Click **Save**

The script below is written to emulate the VS Performance Rate Limiter. So all
requests to a specific VS are rate limited.

```lua
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
