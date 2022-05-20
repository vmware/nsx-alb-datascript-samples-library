# True Client IP Replacement

Check for the HTTP header True-Client-IP, if it exists then replace the HTTP Header.

## F5 True Client IP Replacement

```
when HTTP_REQUEST {
      if { [HTTP::header exists "True-Client-IP"] } {
         HTTP::header replace "X-Forwarded-For" "[HTTP::header "True-Client-IP"]"
      elseif { [HTTP::header exists "X-Forwarded-For"] } {
               HTTP::header replace "X-Forwarded-For" "[IP::client_addr]"
      else {
         HTTP::header insert "X-Forwarded-For" "[IP::client_addr]"
      }
   }
 }
}
```

## Avi True Client IP Replacement

```lua
if avi.http.get_header("True-Client-IP") then
      avi.http.replace_header("X-Forwarded-For", "True-Client-IP")
else avi.http.replace_header("X-Forwarded-For", avi.vs.client_ip())
end
```
