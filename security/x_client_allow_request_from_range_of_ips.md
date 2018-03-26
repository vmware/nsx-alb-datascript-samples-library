# X-Client-IP allow requests from range of IPs
 Usually the client requests comes through a proxy and the original client IP is not in the IP headers, but in the HTTP Headers and there is requirement to take specific actions based on the client ip which is present in the header. Apply this to the "HTTP REQUEST" Event.

1. In the UI, go to Templates > Groups > IP Group
2. Create a new IP Group, named "allowed_clients_list" with networks/ips to whitelist.
3. Use the following Datascript in your HTTP REQUEST event, IP Group  "allowed_clients_list" has to be selected for datascript.

```
-- get http headers
headers = avi.http.get_header()
-- iterate across set of headers
for key,val in pairs(headers) do
  -- select X-Client-IP header
  if string.contains(string.lower(key),"x-client-ip") then
    if avi.ipgroup.contains("allowed_clients_list", val) == false then
      -- generate log message
      avi.vs.log("Access Forbidden from Unknown Client Address: " .. val)
      -- return 403 Forbidden on the request
      avi.http.response(403, {content_type="text/html"}, "Access Denied from Unknown Client Address:" .. val)
      avi.http.close_conn()
    end
   end
end
```
