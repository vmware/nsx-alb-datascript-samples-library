# Cookie Rewrite / Cookie Sanitizer

Modify cookie value of cookie "domain" from example.com to example.int on HTTP_REQUEST and overwrite it back to original on HTTP_RESPONSE. This example can be used to sanitize cookie payload for server processing.

```lua
-- HTTP_REQUEST
if avi.http.cookie_exists("domain") then
  cookie_value = avi.http.get_cookie("domain")
  if cookie_value:contains("example.com") then
    cookie_value_sanitized = cookie_value:gsub("example.com", "example.int")
    cookie_table = {domain=cookie_value_sanitized, sanitized=true}
    avi.http.replace_cookie(cookie_table)
  end
end

-- HTTP_RESPONSE
if avi.http.cookie_exists("domain") then
  cookie_value = avi.http.get_cookie("domain")
  if cookie_value:contains("example.int") then
    cookie_value_sanitized = cookie_value:gsub("example.int", "example.com")
    cookie_table = {appcookie=cookie_value_sanitized, sanitized=true}
    avi.http.replace_cookie(cookie_table)
  end
end
```
