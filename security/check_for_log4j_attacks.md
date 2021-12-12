# Check for CVE-2021-44228 Log4j attacks in request header

Validate all parts of the request header against the attack and
also check for evasions of the detection.

```lua
-- detect CVE-2021-44228 Log4j
local function check_for_attack (location, value)
    lower = string.lower(value)
    if string.contains(lower, "${jndi:") then
      avi.vs.log("CVE-2021-44228 Log4j attack detected at " .. location)
      avi.http.response(404)
    end
    -- detect evasion
    if string.contains(lower, "${j${") or string.contains(lower, "${jn${") or string.contains(lower, "${jnd${") or string.contains(lower, "${jndi${") then
          avi.vs.log("CVE-2021-44228 Log4j attack (evasion attempt) detected at " .. location)
          avi.http.response(404)
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

check_table("REQUEST_HEADERS", avi.http.get_header())
check_table("QUERY_ARGS", avi.http.get_query(avi.QUERY_TABLE))
check_table("REQUEST_COOKIE", avi.http.get_query(avi.http.get_cookie()))
check_for_attack("PATH", avi.http.get_path())
check_for_attack("URI", avi.http.get_uri())
```
