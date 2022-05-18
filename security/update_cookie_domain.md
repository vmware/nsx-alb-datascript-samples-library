# Update Cookie Domain 

Check if the HTTP Cookie exists and update the domain attribute to the HTTP Cookie during HTTP Response.

## F5 Update Cookie Domain

```
when HTTP_RESPONSE {
 # Check if the persistence cookie exists in the response
 if {[HTTP::cookie exists "persist_cookie"]} {
 # set the domain attribute on the persistence cookie
 HTTP::cookie domain "persist_cookie" "test.com"
   }
}
```

## Avi Update Cookie Domain


[avi.http.update_cookie](https://avinetworks.com/docs/latest/datascript-avi-http-update-cookie/)  


```lua
-- HTTP_RESPONSE
cookie_name = "persist_cookie"

if avi.http.cookie_exists(cookie_name) then
avi.http.update_cookie(cookie_name, "domain", "test.com")
end
```