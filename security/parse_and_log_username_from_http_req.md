#Parse	and	Log	Username	from	HTTP	requests

HTTP	logging	is	essential	from	most	of	the	Web/App	deployments	where	you	want	to	capture	the	traffic	details	passing	through.	Authorization	header	in	HTTP	request	carries	the	username	which	is	important	 data	to	log	for	accountability	of	changes.	This	example	shows	how	to	parse	and	log	the	username	from	the	Authorization	header	of	HTTP	Requests.

```lua
--HTTP_REQUEST
authorization_header = avi.http.get_header("Authorization")
basic_authorization = authorization_header:find("Basic")
if basic_authorization == 1 then
  credentials = {}
  -- user_id = credentials[1]
  -- password = credentials[2]
  authorization_decoded = avi.utils.base64_decode(authorization_header:sub(7))
  for match in authorization_decoded:gmatch("([^:]+),?") do
          table.insert(credentials,match)
  end
  user_id = credentials[1]
  avi.http.set_userid(user_id)
  -- avi.vs.log optional, as user_id logged through avi.http.set_userid method
  avi.vs.log("Authorization Username:"..user_id)
end
```
