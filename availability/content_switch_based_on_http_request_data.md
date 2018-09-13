# HTTP Content Switch based on HTTP POST / REQUEST DATA

Load balance requests across different pools based on HTTP REQUEST DATA payload. Request Data can incorporate complex constructs, regex function offered for advanced parsing. Enable `request_body_buffering` (via the Application Profile under the DDOS tab or in the Avi CLI). Apply this to the "HTTP REQUEST DATA" Event.


```lua
-- HTTP_REQ_DATA
-- local_pool includes servers
local_pool = "local_pool"
remote_pool = "remote_pool"
if avi.http.method() == "POST" then
    body = avi.http.get_req_body(100)
    -- curl -X POST -d '[{ "server": "192.168.0.41", "port": 80}]'] 192.168.3.11
    -- body = '[{ "server": "10.0.0.10", "port": 80}]'
    patterns_table = {}
    for match in body:gmatch("([^\":]+),?") do
        if match:match("(%d+)%.(%d+)%.(%d+)%.(%d+)") then
            server_ip = match
        elseif match:match("(%d+)") then
            server_port = match:match("(%d+)")
        end
    end
    local_pool_contains_pool_server_address = pcall(avi.pool.select,local_pool,server_ip,server_port)
    remote_pool_contains_pool_server_address = pcall(avi.pool.select,remote_pool,server_ip,server_port)
    if local_pool_contains_pool_server_address then
        avi.pool.select(local_pool,server_ip,server_port)
    elseif remote_pool_contains_pool_server_address then
        avi.pool.select(remote_pool,server_ip,server_port)
    end
end
```