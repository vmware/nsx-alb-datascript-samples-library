# Check for CVE-2022-42889 Text4Shell attacks in request header

Validate all parts of the request header against the attack and
also check for evasions of the detection.

To check for request body too, you have to enable `request_body_buffering`
in application profile.


```lua
-- detect CVE-2022-42889 Text4shell
local function check_for_attack (location, value)
    if type(value) == "string" then
        if string.contains(value, "${") then
            lower = string.lower(value)
            if string.contains(lower, "${script:") then
              avi.vs.log("CVE-2022-42889 Text4shell attack detected at " .. location)
              avi.http.response(400)
            end
            if string.contains(lower, "${dns:") then
              avi.vs.log("CVE-2022-42889 Text4shell attack detected at " .. location)
              avi.http.response(400)
            end
            if string.contains(lower, "${url:") then
              avi.vs.log("CVE-2022-42889 Text4shell attack detected at " .. location)
              avi.http.response(400)
            end
            -- detect evasion
            if string.match(lower, "${%a*${") then
                  avi.vs.log("CVE-2022-42889 Text4shell attack (evasion attempt) detected at " .. location)
                  avi.http.response(400)
            end
        end
    end
end

local function check_table(location, table)
    if table then
        for name, value in pairs(table) do
           check_for_attack(location, name)
           if type(value) == "table" then
               for index, value in pairs(value) do
                   check_for_attack(location .. "." .. name, value)
               end
           else
               check_for_attack(location .. "." .. name, value)
           end
        end
    end
end

local function check_request_body()
    -- by default, we only inspect the first 128 kb
    body = avi.http.get_req_body(128)
    if body then
        body = avi.utils.uri_decode(body)
        if body then
            check_for_attack("BODY", body)
        end
    end
end

check_table("REQUEST_HEADERS", avi.http.get_header())
check_table("QUERY_ARGS", avi.http.get_query(avi.QUERY_TABLE))
check_for_attack("PATH", avi.http.get_path())
check_for_attack("URI", avi.http.get_uri())
check_request_body()
```
