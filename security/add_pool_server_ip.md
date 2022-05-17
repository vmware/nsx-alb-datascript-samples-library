# Add Pool Member IP during HTTP Response.

Add the Pool server IP in the HTTP Response that was selected as a part of Load Balancing Algorithm.

## F5 Add pool member IP in a header named Pool-Info 

```
when HTTP_RESPONSE {  
   # Insert pool member IP in a header named Pool-Info 
   HTTP::header insert Pool-Info [LB::server addr] 
 }
```

## Avi Add pool member IP in a header named Pool-Info 

```lua
-- HTTP_RESPONSE
avi.http.add_header("Pool-Info", avi.pool.server_ip())
```