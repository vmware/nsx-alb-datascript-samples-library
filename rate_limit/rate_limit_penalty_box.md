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

```lua
-- Event: HTTP_REQUEST
-- Key
custom_string = avi.vs.client_ip()

-- Note that the key could be any user-generated string that can be used to identify
-- requests like URLs, Client IP addresses, Request headers, etc.

--[[ For debugging purposes
   avi.vs.log(custom_string)
--]]

-- Timeout value
timeout = 900 -- The penalty time

-- Lookup table
given_action, remaining = avi.vs.table_lookup(custom_string, 0)
-- Last argument must be zero to tell table_lookup not to extend the timeout value

if given_action then
    avi.http.close_conn()
-- if not found in table
else
    count_exceeded, given_action = avi.vs.rate_limit(avi.RL_CUSTOM_STRING, custom_string, true)
    if count_exceeded then
        -- If number of requests from this client exceeds the maximum allowed amount
        -- Then, create an entry in the table for this client with a lifetime of 900s
        avi.vs.table_insert(custom_string, given_action, timeout)
        avi.http.close_conn()
    end
end
```
