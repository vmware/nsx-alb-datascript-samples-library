# SNI Based Content Switching L4 SSL Offload

Starting with Avi Vantage 18.2.5, it is possible to load balance a layer 4 application based on a server name in the SNI extension on TLS client hello. The DataScript ensures that it is invoked after having sufficient bytes to inspect the TLS payload. Once load balancing is done, it stops invoking DataScript again for subsequent packets in the same connection.

## VS and data script configuration
- **VS Configuration -** 
    - TCP/UDP Profile: "System-TCP-Proxy"
    - Application Profile: "System-SSL-Application"
    - Pool: a default pool
    - SSL Certificate: a wildcard certificate to cover all sites the VS is serving. 
- **Pool Configuration -** 
    - `no special requirement`
- **Data script Configuration -** 
    - Pools: Add all your pools
    - Events: L4 Request Event

## Data script code
```lua
-- to obtain the SNI name
local sname = avi.ssl.server_name()
avi.vs.log("sni name: "..sname)
-- select pool based on SNI
if sname == "site1.company.com" then avi.pool.select("site1_Pool")
    elseif sname == "site2.company.com" then avi.pool.select("site2_Pool")
    elseif sname == "site3.company.com" then avi.pool.select("site3_Pool")
    elseif sname == "site4.company.com" then avi.pool.select("site4_Pool")
    else avi.pool.select("Default_Pool")
end
-- Stop invoking DataScript after the first payload.
avi.vs.ds_done()

```
