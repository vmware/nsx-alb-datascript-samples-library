# Enforce a Penalty Timeout for Blacklisted Clients

The DataScript below makes use of the DS rate limit function and the DS Table API
to enforce a 'penalty box'for certain type of requests. Here, if a client were to 
send more than x requests within a time period of t1 seconds, then all future 
requests from the client will be dropped for t2 seconds.
For example, if a client sent more than 20 requests in a 10 second period, then drop
all incoming requests from that client for the next 900 seconds.

**Idea:** Use the DS Table to enforce "Penalty box" for bad/malicious clients.
If a request from the client is to be rate-limited (i.e. the number of requests 
exceeded the allowed amount) then create an entry in the table for that client with 
a lifetime equal to the penalty time. So, for each entry(client) in the table, drop 
the request from that client. After, the penalty time has passed, the entry in the 
table will be removed from the table.

> To use the DS rate limiter you must create a rate limiter (that maps to custom strings) in the Application Profile.  
> All DS were tested under Avi version **21.1.3** and **22.1.1**

**Scenario 1: Block all requests from a client IP for certain time if its request hits pre-defined ratelimit.**
```lua
-- Event: HTTP_REQUEST
 
local rate_limiter = 'penalty_rl'
 
-- rate_limiter specifies the name of the DataScript rate limiter. Define a rate limiter
-- in the DataScript configuration with this name and define the rate limit parameters
-- as required.
 
local rate_limit_string = avi.vs.client_ip()
-- local rate_limit_string = avi.vs.client_ip() .. ':' .. avi.http.get_path()
 
-- rate_limit_string defines what constitutes a "bucket" for rate limiting. This could
-- be just the client IP address, a combination of client IP and URI (as in the second example)
-- or some other custom criterion.
 
local apply_penalty_box_to = avi.vs.client_ip()
 
-- apply_penalty_box_to defines how the penalty box should be applied. Usually the penalty box
-- will be applied to the same criterion as the rate limit, but in some cases a different criterion
-- may be desired. For example, the rate limit could be applied per client and per URL (as per the
-- second example of rate_limit_string above), but the penalty box could be applied to just the client IP,
-- with the effect that all subsequent requests from the client to ANY URL are subject to the penalty box
-- rather than just those to the specific URL which exceeded the rate limit.
 
 
--[[ For debugging purposes
   avi.vs.log(rate_limit_string)
   avi.vs.log(apply_penalty_box_to)
--]]
 
-- Timeout value
timeout = 900
-- timeout defines the penalty box time (minimum value = 300s)
 
-- Look up in the penalty box table
local in_penalty_box, remaining = avi.vs.table_lookup(apply_penalty_box_to, 0)
-- avi.vs.table_lookup( [table_name,] key [, lifetime_exten] )
-- When the optional lifetime_exten flag is not specified, the default value of 300 seconds is used. 
-- This means that by default, looking up the value of a key will extend the lifetime of a key by an additional 300 seconds. 
-- To lookup the key without impacting the expiration
-- the lifetime_exten flag must be zero to tell table_lookup not to extend the timeout value

-- if key apply_penalty_box_to is found in the default table, close the connect
if in_penalty_box then
    avi.vs.log('wait for penalty timeout:'..remaining)
    avi.http.close_conn()
else
    local exceeded = avi.vs.ratelimit.exceed(rate_limiter, rate_limit_string)
    avi.vs.log('access to exceeded: '..tostring(exceeded))
    if exceeded then
        -- If number of requests from this client exceeds the maximum allowed amount
        -- Then, create an entry in the table for this client with a lifetime of configured timeout value
        avi.vs.table_insert(apply_penalty_box_to, rate_limit_string, timeout)
        avi.vs.log('Rate limit exceeded: ' .. apply_penalty_box_to .. ' ' .. rate_limit_string)
        avi.http.close_conn()
    end
end
```

 
**Scenario 2: Block request to a specific URL from a client IP for a certain time if its request to the specific URL hits pre-defined ratelimit.**
```lua
-- Event: HTTP_REQUEST
 
local rate_limiter = 'penalty_rl'
local path = '/assets/avi.webm' 
local req_path = avi.http.get_path()
-- specify which path you need to restrict access
-- retrieve client http request path
 
local rate_limit_string = avi.vs.client_ip()
local apply_penalty_box_to = avi.vs.client_ip()
 
--[[ For debugging purposes
   avi.vs.log(rate_limit_string)
   avi.vs.log(apply_penalty_box_to)
--]]
 
-- Timeout value
timeout = 900
 
-- Look up in the penalty box table
local in_penalty_box, remaining = avi.vs.table_lookup(apply_penalty_box_to, 0)
-- avi.vs.table_lookup( [table_name,] key [, lifetime_exten] )
-- When the optional lifetime_exten flag is not specified, the default value of 300 seconds is used. 
-- This means that by default, looking up the value of a key will extend the lifetime of a key by an additional 300 seconds. 
-- To lookup the key without impacting the expiration
-- the lifetime_exten flag must be zero to tell table_lookup not to extend the timeout value
 
-- If the customer string/penalty timeout pair exits, close the connect
if ( in_penalty_box and req_path == path )then
    avi.vs.log('wait for penalty timeout:'..remaining..'(s) to path:'..path)
    avi.http.close_conn()
else
    if (req_path == path) then
        local exceeded = avi.vs.ratelimit.exceed(rate_limiter, rate_limit_string)
        avi.vs.log('access to '..path.. 'exceeded:'..tostring(exceeded))

        if exceeded  then
            -- If number of requests from this client exceeds the maximum allowed amount
            -- Then, create an entry in the table for this client with a lifetime of configured timeout value
            avi.vs.table_insert(apply_penalty_box_to, path, timeout)
            avi.vs.log('Rate limit exceeded: ' .. apply_penalty_box_to .. ' ' .. path)
            avi.http.close_conn()
        end
    end

end
```
