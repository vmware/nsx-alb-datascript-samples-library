#Rate limit using HTTP headers

Datascript will rate limit based off http header attributes.
The action is set to log when if limit is reached

```lua
query = avi.http.get_query()
method = avi.http.method()
path = avi.http.get_path()
--only trigger if no query and using method GET
if not query and method == 'GET'  and path == '/' then
	custom_string = "trigger"
	count_exceeded, given_action = avi.vs.rate_limit(avi.RL_CUSTOM_STRING, custom_string, true)
--count_exceed is based off application profile value configured
	if count_exceeded then
--log message to show when profile is trigged, alternatively can drop/redirect/etc...
		avi.vs.log("Limit Reached")
	end
end
```
