ADDING True Client IP Address as header to HTTP request while sending HTTP Request to Application server.
Will be use full when the client traffic is coming behind Proxy server where VS will see client IP Address as Proxy Server IP Address.

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
