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
