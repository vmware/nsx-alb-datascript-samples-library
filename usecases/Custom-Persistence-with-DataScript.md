# Custom Persistence with DataScript

Avi Load Balancer includes several standard methods of persisting clients to the same server for a prolonged time. For some applications, it may be valuable to have more customizations to the persistence behavior or to support a wider array of application types.

Persistence is the ability to identify a client and stick or persist connections from that client to the same destination server for a period.

| DataScript Function | Description |
| :--- | :--- |
| `avi.vs.table_insert( [table_name], key, value, [lifetime_exten])` | Store custom data in a time-based table |
| `avi.vs.table_lookup( [table_name], key, [lifetime_exten])` | Lookup data in a table |
| `avi.vs.table_remove( [table_name], key)` | Remove data from a table |
| `avi.vs.table_refresh( [table_name], key [lifetime_exten])` | Update the expire time for a table entry |

**Note:** The above table is a reiteration of the DataScript function that is useful for persistence.

## JSessionID Example

The following example persists based on an HTTP cookie sent from a server with a unique JSessionID. Subsequent client requests include that cookie, which is used to persist requests to the same server.

**HTTP Response event:** Add persist for 20 minutes, or update the timer if the entry already exists.

```lua
if avi.http.get_cookie("JSESSIONID") then
    avi.vs.table_insert(avi.http.get_cookie("JSESSIONID"), avi.pool.server_ip(), 1200)
end
```

**HTTP Request event:** Rename the pool before applying to a virtual service.

```lua
if avi.http.get_cookie("JSESSIONID") then
    avi.pool.select("poolname", avi.vs.table_lookup(avi.http.get_cookie("JSESSIONID")))
end
```

## SSL Session ID Persistence

SSL/TLS session resumption is a mechanism to reduce the full SSL handshake between the client and server when a new connection is established. The server puts a non-zero session ID in the Server Hello, when the SSL handshake is complete. The client persists and reuses the session ID throughout the session-timeout to reduce the full SSL handshake.

Persistence is the ability to identify a session with the session ID provided by the server and to stick or persist them to a destination server for some time. Avi Load Balancer provides a way to persist session ID mapped to the server and port information using `VS_DATASCRIPT_EVT_L4_REQUEST` and `VS_DATASCRIPT_EVT_L4_RESPONSE` events.

**Note:** SSL/TLS session resumption using session ID is not supported for the TLS1.3 version.

### Persistence Table

The group of `avi.vs.table` functions are a primary DataScript mechanic for creating custom persistence on a virtual service. These functions enable storing data locally on Avi Load Balancer SE for a configurable time.

### L4 SSL Persistence Example

DataScript uses the existing Default-TLS DataScript template to extract session ID from the SSL handshake. The following are the two DataScripts required for L4 persistence:

**1. VS_DATASCRIPT_EVT_L4_REQUEST DataScript:** The session ID is extracted from client Hello. If the session ID is found, then mapped server information is found using table commands. Otherwise, it is considered as a new session.

```lua
function string.tohex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end

local avi_tls
local buffered
local payload
require "Default-TLS"
avi.l4.collect(10)
avi.l4.read()
local len = avi_tls.get_req_buffer_size(payload)
if (buffered < len) then
    avi.l4.collect(100)
end

if (avi_tls.sanity_check(payload)) then
    local h = avi_tls.parse_record(payload)
    local ses = avi_tls.get_session_id(h)
    if ses ~= nil then
        persisted_info = avi.vs.table_lookup(string.tohex(ses))
        if persisted_info ~= nil then
            sip, sport = persisted_info:match("([^,]+),([^,]+)")
            if(avi.pool.get_server_status("tls-pp-pool", sip, sport) ~= 1) then
                avi.vs.table_remove(string.tohex(ses))
            else
                avi.pool.select("tls-pp-pool", sip, tonumber(sport))
            end
        end
    end
    avi.l4.ds_done()
end
avi_tls = nil
```

**2. VS_DATASCRIPT_EVT_L4_RESPONSE DataScript:** The session ID is extracted from Server Hello. If the session ID is found, then the session ID and server information are inserted into the persistent table using table commands.

```lua
function string.tohex (str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end

local avi_tls = require "Default-TLS"
local buffered2
local payload2
avi.l4.collect(10)
avi.l4.read()
local len = avi_tls.get_req_buffer_size(payload2)

if (buffered2 < len) then
    avi.l4.collect(100)
end

if (avi_tls.sanity_check(payload2)) then
    local h = avi_tls.parse_record(payload2)
    local ses_server = avi_tls.get_session_id(h)
    if ses_server ~= nil then
        sip, sport = avi.pool.get_server_info()
        avi.vs.table_insert(string.tohex(ses_server), sip..","..sport)
        avi.l4.ds_done()
    end
end
avi_tls = nil
```
