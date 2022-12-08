#True-Client on HTTP Header
This datascript is for case that an Avi Virtual service (VS) is behind a proxy which will send traffic from clients to the VS with "True-Client-IP" header to preserve client IP. Virtual Service will see client IP Address as Proxy IP Address. 
By default, VS will discard that "True-Client-IP" header from the proxy server. Thus, we need to add the "True-Client-IP" header back before sending the traffic to backend servers so that application servers are aware of the origin of the traffic.

Encode the header value before passing it to avi.http.add_header function to avoid being used for malicious HTTP attack if the proxy was compromised.

```lua
-- HTTP_REQUEST
-- get http headers
headers = avi.http.get_header()

function uri_encode(str)
    return (str:gsub("([^%w-_.~])", function (c)
        return string.format('%%%02X', string.byte(c))
    end))
end
-- iterate across set of headers
for header,value in pairs(headers) do
  if string.beginswith(string.lower(header),"true-client-ip") then
    -- add True-Client-IP header with True Client IP address
    avi.http.add_header("True-Client-IP", uri_encode(value))
  end
end
```
