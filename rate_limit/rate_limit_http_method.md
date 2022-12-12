# Rate limit using HTTP headers

Datascript will rate limit based off http header attributes.
The action is set to log when if limit is reached

```lua
-- rate_limiter specifies the name of the DataScript rate limiter. Define a rate limiter
-- in the DataScript configuration with this name and define the rate limit parameters
-- as required.
local rate_limiter = 'http_headers_rl'

-- rate_limit_string defines what constitutes a "bucket" for rate limiting. This could
-- in this case, we will rate limit based on http headers from each client
-- you can also rate limit for the entire VS by defining rate_limit_string = avi.vs.name() 
local rate_limit_string = avi.vs.client_ip()

query = avi.http.get_query()
method = avi.http.method()
path = avi.http.get_path()
--only trigger if no query and using method GET
if not query and method == 'GET'  and path == '/' then
	limit_exceeded= avi.vs.ratelimit.exceed(rate_limiter, rate_limit_string)
--limit_exceed is based off the rate_limiter configured in the DS 
	if count_exceeded then
--log message to show when rate limit is trigged, alternatively can drop/redirect/etc...
		avi.vs.log(rate_limit_string .. "Reached Limit")
	end
end
```
