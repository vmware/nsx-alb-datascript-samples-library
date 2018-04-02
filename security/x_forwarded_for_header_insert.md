# X-Forwarded-For Header Insert
  Checking for the header and inserting one if not found with respective value.
```
-- HTTP_REQUEST
-- get http headers
headers = avi.http.get_header()
-- iterate across set of headers
for header,value in pairs(headers) do
  if string.beginswith(string.lower(header),"x-forwarded-for") then
    -- Replace X-Forwarded-For value with Client IP address
    avi.http.replace_header("X-Forwarded-For", avi.vs.client_ip())
  else
    -- add X-Forwarded-For header with Client IP address
    avi.http.add_header("X-Forwarded-For", avi.vs.client_ip())
  end
end
```
