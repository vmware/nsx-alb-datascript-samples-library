# DataScript Samples

This section explains various Datascript functions and their configuration.

## MCP Session Persistence through DataScripts

Starting with Avi Load Balancer version 32.1, the Avi Load Balancer platform is enhanced to efficiently handle stateful MCP connections for AI/ML workloads.
MCP requires session-based persistence.
When an application profile configured with the Service Type MCP is created, a DataScript template is generated and attached to the following events:
*   `VS_DATASCRIPT_EVT_HTTP_REQ`
*   `VS_DATASCRIPT_EVT_HTTP_RESP`

### Request Event
Checks the `mcp-session-id` header against a local lookup table to select the correct pool member.

```lua
-- Lookup pool name and server IP from separate tables
if avi.http.get_header("mcp-session-id") then
    local session_id = avi.http.get_header("mcp-session-id")
    
    -- Lookup pool name from pool table with lifetime extension
    local pool_name = avi.vs.table_lookup("pool_table", session_id, 600)
    
    -- Lookup server IP from server_table with lifetime extension
    local server_ip = avi.vs.table_lookup("server_table", session_id, 600)
    
    if pool_name and server_ip then
        avi.pool.select(pool_name, server_ip)
    end
end
```

### Response Event
Records the mapping for new sessions and purges entries for deleted sessions to optimize memory.

```lua
-- Get session id from response and request headers separately
local response_session_id = avi.http.get_header("mcp-session-id")
local request_session_id = avi.http.get_header("mcp-session-id", avi.HTTP_REQUEST)
local request_method = avi.http.method()

-- Delete Requests
-- Removes the entry if the request was a DELETE and was successful (2xx).
if request_method == "DELETE" then
    local session_id = response_session_id or request_session_id
    if session_id then
        local status_code = avi.http.status()
        if status_code then
            local status_num = tonumber(status_code)
            if status_num and status_num >= 200 and status_num < 300 then
                avi.vs.table_remove("pool_table", session_id)
                avi.vs.table_remove("server_table", session_id)
            end
        end
    end
    return
end

-- In case of requests other than delete, the session id from the response header is inserted and a 600-second timeout is configured:
if response_session_id then
    local pool_name = avi.pool.name()
    local server_ip = avi.pool.server_ip()
    avi.vs.table_insert("pool_table", response_session_id, pool_name, 600)
    avi.vs.table_insert("server_table", response_session_id, server_ip, 600)
end
```

## Log Custom Data

Create a local log with custom data. This log is visible in the application logs and can be sent to remote logging servers if the user-defined filter is configured in the virtual service's analytics profile. This logged data will be appended to standard log data generated for the request.

```lua
avi.vs.log("This is a custom log. The clients IP address is " .. avi.vs.client_ip())
```

## Persist on JsessionID

The following example looks at a server-generated cookie, using the value to persist the client to the server for an hour. This use case can also be performed through the native app-cookie persistence method.

**Add the following to the HTTP request:**
```lua
if avi.http.get_cookie("OAM_JSESSIONID") then
    if avi.vs.table_lookup(avi.http.get_cookie("OAM_JSESSIONID")) then
        avi.pool.select(avi.vs.table_lookup(avi.http.get_cookie("JSESSIONID")))
    end
end
```

**Add the following to the HTTP response:**
```lua
if avi.http.get_cookie("JSESSIONID") then
    avi.vs.table_insert(avi.http.get_cookie("JSESSIONID"), avi.pool.server_ip(), 3600)
end
```

## Redirect HTTP to HTTPS

If the client is accessing a secure section of a website and is not using SSL, then redirect them to HTTPS using a 302 Redirect.

```lua
if string.beginswith(avi.http.get_path(), "/secure") and avi.vs.port() ~= "443" then
    avi.http.redirect("https://" .. avi.http.hostname() .. avi.http.get_uri(), 302)
end
```

## Blocklist Enforcement of IP Addresses

Block clients coming from a designated blocklist group based on their client IP address. To implement this rule, create an IP group matching the name used in the following rule:

```lua
var = avi.vs.client_ip()
if avi.ipgroup.contains("IP-Group", var) then
    avi.vs.log("Blocklisted IP " .. var .. " attempting to log in")
    avi.http.close_conn()
end
```

## Content Switching - Basic

This rule directs clients to a pool based on an exact match of the HTTP path.

```lua
if avi.http.get_path() == "/sales/" then
    avi.pool.select("sales-pool")
elseif avi.http.get_path() == "/dev/" then
    avi.pool.select("dev-pool")
elseif avi.http.get_path() == "/marketing/" then
    avi.pool.select("marketing")
end
```

## Content Switching - Advanced

This rule directs clients to different pools or servers within a pool based on a match against their path:

```lua
if string.beginswith(avi.http.get_path(), "/sales/") then
    avi.pool.select("sales-pool")
elseif avi.http.get_path() == "/engineering/" then
    avi.pool.select("engineering-pool", "apache1")
elseif avi.http.get_path() == "/marketing/" then
    avi.pool.select("marketing", "10.10.31.201")
end
```

## Content Switching - Large List

For longer lists, it is preferable to separate the DataScript code from the data it uses. This makes adding or modifying the list of mappings easy without giving users (or automation API calls) access to the underlying rule. This approach takes advantage of a string group, which contains the list and is referenced by the DataScript.

The string group must be set to key/value pair, with sample entries such as:
*   `/marketing` : `marketing-pool`
*   `/dev` : `dev-pool`
*   `/checkout` : `default-pool`
*   `/nonprod` : `nonprod-pool`
*   `/test` : `nonprod-pool`
*   `/sales` : `sales`

```lua
val, match = avi.stringgroup.beginswith("StringGroup", avi.http.get_path())
if match then
    avi.pool.select(val)
else
    avi.pool.select("default-pool")
end
```

## Rewrite Client Request

Add a query to the request based on the country code of the HTTP hostname.
For instance, if the site is `www.avi.es/path/index.html?query=true`, the new request would be `www.avi.es/path/index.html?es=0123&query=true`.

```lua
host = avi.http.host()

-- Create an array of mappings
TLD_map = {es="123", fi="456", cn="789"}

if not host then
    -- The host header does not exist, so close the connection
    avi.http.close_conn()
elseif string.sub(host, 1, #"www.avi.") == "www.avi." then
    i,j = string.find(host, "avi")
    TLD = string.sub(host, j+2, -1)
    new_query = "?mandate=" .. TLD_map[TLD]
    old_query = avi.http.get_query()
    
    if #old_query > 0 then
        new_query = new_query .. "&" .. old_query
    end
    
    avi.http.redirect("www.avi.com" .. avi.http.get_path() .. new_query, 302)
end
```

## Generate a Different Redirect URL, Based on Different Host Names

Check if the hostname begins with `www.avi.` then get the ccTLD from the host. Form the beginning part of the new query using the `ccTLD_map` table to get the value of the query argument mandate. Append the old query, if it exists, to the new query. Generate the HTTP redirect to the new URL using the domain `www.avi.com` and the new query.

```lua
local ccTLD_map = {es="01345F", fi="5146FF", cn="45DFX", io="123456", ly="ABC123"}
host = avi.http.host()

if not host then
    avi.http.close_conn()
elseif string.sub(host, 1, #"www.avi.") == "www.avi." then
    i,j = string.find(host, "avi.")
    ccTLD = string.sub(host, j+1, -1)
    new_query = "?mandate=" .. ccTLD_map[ccTLD]
    old_query = avi.http.get_query()
    
    if #old_query > 0 then
        new_query = new_query .. "&" .. old_query
    end
    
    avi.http.redirect("www.avi.com" .. avi.http.get_path() .. new_query, 302)
end
```

## Rewrite Publicly Available Hosts & URLs to Private Hosts and URLs

This can be a common requirement for OpenShift environments, since routes are not typically open and accessible directly from the internet.

```lua
host = avi.http.get_header("Host")
path = avi.http.get_path()

if string.contains(host, "rhmap.global.acme.com") and string.beginswith(path, "/router/test") then
    avi.vs.log("router/test match")
    avi.http.replace_header("Host", "rhmap.apps.test-a.0341.02.wel.csl.cd2.acme.com")
    avi.vs.log("router/test new header")
    if avi.http.get_path_tokens(4) then
        avi.http.set_path("/" .. avi.http.get_path_tokens(4))
    else
        avi.http.set_path("/")
    end
elseif string.contains(host, "rhmap.global.acme.com") and string.beginswith(path, "/router/dev") then
    avi.vs.log("router/dev match")
    avi.http.replace_header("Host", "rhmap.apps.dev-a.0341.02.wel.csl.cd2.acme.com")
    avi.vs.log("router/dev new header")
    if avi.http.get_path_tokens(4) then
        avi.http.set_path("/" .. avi.http.get_path_tokens(4))
    else
        avi.http.set_path("/")
    end
elseif string.contains(host, "rhmap.global.acme.com") and string.beginswith(path, "/core") then
    avi.vs.log("core match")
    avi.http.replace_header("Host", "rhmap.apps.test-a.0341.02.wel.csl.cd2.acme.com")
    avi.vs.log("core new header")
    avi.http.set_path("/" .. avi.http.get_path_tokens(2))
else
    avi.vs.log("nothing matches")
end
```

## Block Client IPs that Exceed the Limit of Failure Responses

Note the following configurable settings in the script:
*   The failure responses are set to 400, 401, 402, 403, 404, and 405.
*   `MAX_FAILCOUNT` - The number of failure responses allowed within a period of time (`FAILCOUNT_DURATION`) before the IP is blocked.
*   `FAILCOUNT_DURATION` - The time period in seconds during which an IP is allowed to have the maximum number of failure responses without being blocked. The minimum value for this setting is 300 seconds (5 minutes).
*   `BLOCKLIST_DURATION` - The time period in seconds that an IP will be blocked after too many failure responses. The maximum value for this setting is 32400 seconds (9 hours).

**HTTP Request Event:**

```lua
failcount_table="FAILCOUNT"
blocklist_suffix="BLK"
client_ip = avi.vs.client_ip()
headers = avi.http.get_header()

-- iterate across set of headers
for header, value in pairs(headers) do
    if header=="true-client-ip" then
        hdr_value=value
        avi.vs.log(hdr_value)
    end
end

avi.vs.log(hdr_value)
client_ip_blk_key = hdr_value .. blocklist_suffix
blk_status, blk_remaining_time = avi.vs.table_lookup(failcount_table, client_ip_blk_key, 0)

if blk_status == 'BLOCKLIST' then
    msg = "Client IP: " .. hdr_value .. " in penalty box for another " .. blk_remaining_time .. " seconds"
    avi.vs.log(msg .. " respond")
    avi.http.response(429, {content_type="text/plain"}, msg .. "\n")
    --avi.http.close_conn()
end
```

**HTTP Response Event:**

```lua
MAX_FAILCOUNT = 100
FAILCOUNT_DURATION = 300
BLOCKLIST_DURATION = 600
-- Minimum value of AVI table entry lifetime/expiry-time is 300 secs (5 mins) and Maximum value is 32400 (9 hrs)

failcount_table="FAILCOUNT"
blocklist_suffix="BLK"
client_ip = avi.vs.client_ip()
headers = avi.http.get_header()

-- iterate across set of headers
for header, value in pairs(headers) do
    if header=="true-client-ip" then
        hdr_value=value
        avi.vs.log(hdr_value)
    end
end

client_ip_blk_key = hdr_value .. blocklist_suffix

function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

local items = Set { "400", "401", "402", "403", "404", "405" }
response = avi.http.status()

if items[tostring(response)] then
    fail_count, fc_remaining_time = avi.vs.table_lookup(failcount_table, hdr_value, 0)
    blk_status, status_remaining_time = avi.vs.table_lookup(failcount_table, client_ip_blk_key, 0)

    -- Increment the counter and check if the counter exceeded MAX_FAILCOUNT.
    if (fail_count == nil) and (blk_status == nil) then
        avi.vs.log("New Client IP " .. hdr_value .. " to the failcount table")
        avi.vs.table_insert(failcount_table, hdr_value, 1, FAILCOUNT_DURATION)
        avi.vs.table_insert(failcount_table, client_ip_blk_key, 'MONITOR', FAILCOUNT_DURATION)
    elseif (tonumber(fail_count) >= MAX_FAILCOUNT) and (blk_status == 'MONITOR') then
        avi.vs.log("Client IP " .. hdr_value .. " exceeded the failcount adding to blocklist")
        avi.vs.table_remove(failcount_table, client_ip_blk_key)
        avi.vs.table_insert(failcount_table, client_ip_blk_key, 'BLOCKLIST', BLOCKLIST_DURATION)
    elseif (blk_status == nil) then
        avi.vs.log("Client IP " .. hdr_value .. " refresh timer")
        avi.vs.table_insert(failcount_table, hdr_value, 1, FAILCOUNT_DURATION)
        avi.vs.table_insert(failcount_table, client_ip_blk_key, 'MONITOR', FAILCOUNT_DURATION)
    elseif (tonumber(fail_count) < MAX_FAILCOUNT) and (blk_status == 'MONITOR') then
        avi.vs.log("Client IP: " .. hdr_value .. " incremented fail count: " .. tonumber(fail_count) + 1 .. " remaining time: " .. status_remaining_time)
        avi.vs.table_remove(failcount_table, hdr_value)
        count = tonumber(fail_count) + 1
        avi.vs.table_insert(failcount_table, hdr_value, tostring(count), FAILCOUNT_DURATION)
    end
end
```
