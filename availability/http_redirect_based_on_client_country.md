# HTTP redirect based on Client location taken from source IP address.

HTTP redirect based on Client location taken from source IP address. IP groups has be created and mapped to datascript. https://avinetworks.com/docs/latest/templates-groups-ip-group/, country can be selected vs explicit IP ranges to identify clients. More details: https://avinetworks.com/docs/latest/geo-location-database/. Apply this to the "HTTP REQUEST" Event and map respected ip groups to datascript.

```
-- HTTP_REQUEST
client_ip = avi.vs.client_ip()
if avi.ipgroup.contains("canada_nets",client_ip) and string.contains(avi.http.get_uri(),"/ca/") == false then
  avi.http.redirect("http://" .. avi.http.hostname() .. "/ca" .. avi.http.get_uri())
elseif avi.ipgroup.contains("ukraine_nets",client_ip) and string.contains(avi.http.get_uri(),"/ua/") == false then
  avi.http.redirect("http://" .. avi.http.hostname() .. "/ua" .. avi.http.get_uri())
elseif avi.ipgroup.contains("uk_nets",client_ip) and string.contains(avi.http.get_uri(),"/uk/") == false then
  avi.http.redirect("http://" .. avi.http.hostname() .. "/uk" .. avi.http.get_uri())
elseif avi.ipgroup.contains("us_nets",client_ip) and string.contains(avi.http.get_uri(),"/us/") == false then
  avi.http.redirect("http://" .. avi.http.hostname() .. "/us" .. avi.http.get_uri())
elseif avi.ipgroup.contains("india_nets",client_ip) and string.contains(avi.http.get_uri(),"/in/") == false then
  avi.http.redirect("http://" .. avi.http.hostname() .. "/in" .. avi.http.get_uri())
end
```
