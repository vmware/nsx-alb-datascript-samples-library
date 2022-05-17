# TLS Version and IP Group

Match the TLS version and if IP address is not present on IP address group, drop the request. Loggins is apart of native Avi functionality

## F5 TLS Version and IP Group Match

```
when HTTP_REQUEST {
#log local0. "[SSL::cipher version] and client [client_addr]"
 if { ([SSL::cipher version] equals "TLSv1") && (not([class match [IP::client_addr] equals IP_Group])) }{
   log local0. "dropped [SSL::cipher version] for [http_host] [http_uri] source-ip [client_addr] header [HTTP::header "User-Agent"]"
   drop
   }
 elseif { ([SSL::cipher version] equals "TLSv1.1") && (not([class match [IP::client_addr] equals IP_Group])) }{
   log local0. "dropped [SSL::cipher version] for [http_host] [http_uri] source-ip [client_addr] header [HTTP::header "User-Agent"]"
   drop
   }
}   
```  

## Avi TLS Version and IP Group Match

```lua
var=avi.vs.client_ip()
ua = avi.http.get_header("user-agent")
ip_group=avi.ipgroup.contains("IP_Group", var)

if avi.ssl.protocol() == "TLSv1.0" or "TLSv1.1" and avi.ipgroup.contains("IP_Group", var) == false then
avi.http.close_conn()
end
```

