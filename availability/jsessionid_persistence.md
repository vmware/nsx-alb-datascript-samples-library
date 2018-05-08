# JSessionID Persistence

 A common requirement is to persist on an application servers JSessionID.  This identifier can be embedded within a cookie or in the header for devices such as cell phones that may not support cookies.  This rule can be used with the Universal Persistence feature to create a new JSessionID persistence. The exact parameters, such as the cookie name or length may need to be altered depending on the application server used.

## F5 JSessionID Persistence

```
when HTTP_REQUEST {
  if { [HTTP::cookie exists "JSessionID"] } {
    persist uie [HTTP::cookie "JSessionID"]
  } else {
    set jsess [findstr [HTTP::uri] "JSessionID" 11 ";"]
    if { $jsess != "" } {
      persist uie $jsess
    }
  }
}

when HTTP_RESPONSE {
  if { [HTTP::cookie exists "JSessionID"] } {
    persist add uie [HTTP::cookie "JSessionID"]
  }
}
```

## Avi JSessionID Persistence

In the following example we will add a persist for 20 minutes, or update the timer if the entry pre-exists.

```lua
if avi.http.get_cookie("JSESSIONID") then
  avi.vs.table_insert(avi.http.get_cookie("JSESSIONID"), avi.pool.server_ip(), 1200)
end
```

In the following we will rename the pool before applying it to a virtual service.

```lua
default_pool = "pool1"
if avi.http.get_cookie("JSESSIONID") then
  avi.pool.select(default_pool, avi.vs.table_lookup(avi.http.get_cookie("JSESSIONID")))
end
```

## Similar pages
[Header Persistence using True-Client-IP header](availability/header_persistence_akamai_true_client_ip.md)  
