# SNI Based Content Switching L4 Passthrough

Starting with Avi Vantage 18.2.5, it is possible to load balance a layer 4 application based on a server name in the SNI extension on TLS client hello. The DataScript ensures that it is invoked after having sufficient bytes to inspect the TLS payload. Once load balancing is done, it stops invoking DataScript again for subsequent packets in the same connection.

## VS and data script configuration
- **VS Configuration -** 
    - TCP/UDP Profile: "System-TCP-Proxy"
    - Application Profile: "System-L4-Application"
    - Pool: keep it blank or a default pool
- **Pool Configuration -** 
    - Should be SSL enabled (`required`)
    - SSL to Backend Servers: check "Enable SSL" and "TLS SNI" (`required`)
- **Data script Configuration -** 
    - Pools: Add all your pools
    - Protocol Parser: "Default-TLS"
    - Events: L4 Request Event

## Data script code
```lua
local avi_tls = require "Default-TLS"
buffered = avi.l4.collect(20)
payload = avi.l4.read()
len = avi_tls.get_req_buffer_size(payload)
if ( buffered < len ) then
    avi.l4.collect(len)
end
if ( avi_tls.sanity_check(payload) ) then
    local h = avi_tls.parse_record(payload) -- <-- to parses the payload
    local sname = avi_tls.get_sni(h)        -- <-- to obtain the SNI name
    if sname == nil then
        avi.vs.log('SNI not present')
    else
        avi.vs.log("SNI=".. sname)
        -- select pool based on SNI
        if sname == "site1.company.com" then avi.pool.select("site1_Pool")
            elseif sname == "site2.company.com" then avi.pool.select("site2_Pool")
            elseif sname == "site3.company.com" then avi.pool.select("site3_Pool")
            elseif sname == "site4.company.com" then avi.pool.select("site4_Pool")
            else avi.pool.select("Default_Pool")
        end
    end
end
-- Stop invoking DataScript after the first payload.
avi.l4.ds_done()
avi_tls = nil
```
