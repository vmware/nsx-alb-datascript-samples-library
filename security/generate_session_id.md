# Generate Custom Session ID based on time, ip address and GET request id hash value

```lua
-- HTTP_REQ
if avi.http.cookie_exists("session-id") then
   avi.vs.reqvar.session_id_exists = true
else
   avi.vs.reqvar.session_id_exists = false
end

-- HTTP_RESP
if avi.vs.reqvar.session_id_exists == false then
  ip = avi.vs.ip()
  req_id = avi.utils.sha1_hash(avi.http.get_request_id())
  now = os.time()
  id = ip .. ":" .. string.sub(req_id,1,8) .. ":"  .. tostring(now)
  cookie_table = { session_id=id, secure=true }
  avi.http.add_cookie(cookie_table)
end
```
