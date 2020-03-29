# Load Balance/Persist using Custom Consistent Hash

The example below will leverage a custom string such as a parameter "sessionid" or a header "X-Session-Id" in a combination with Load Balance Algorithm "Consistent Hash using Custom String" to perform a load balancing decision.

```lua
-- HTTP_REQUEST
query = avi.http.get_query("sessionid")
header = avi.http.get_header("X-Session-Id")
if query and query ~= "true" then
    avi.vs.log('CUSTOM CONSISTENT HASH STRING USING QUERY: '.. query)
    avi.pool.chash(query)
elseif header then
    avi.vs.log('CUSTOM CONSISTENT HASH STRING USING HEADER: '.. header)
    avi.pool.chash(header)
else
    avi.vs.log('NIL CONSISTENT HASH STRING')
end
```