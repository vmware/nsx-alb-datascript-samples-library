# HTTP Retry 500 Errors

Don't send 500 errors (server busy) to the client.  Instead try the next server.  After 4 consecutive failed attempts, send the 500 error.  LTM version 9.2 and later can do this without the redirect, instead using the LB::reselect command.

## F5 HTTP Retry 500 Errors

```
when HTTP_REQUEST {
set my_url [HTTP::host][HTTP::uri]
  if { [HTTP::cookie BIGIP] contains "Redirect" } {
    set count [findstr [HTTP::cookie BIGIP] "Redirect_" 9 1]
  } else {
    set count 0
  }
}

when HTTP_RESPONSE {
  if { [HTTP::status] == 500 && $count < 4 } {
    incr count
    HTTP::respond 302 Location "http://$my_url" Set-Cookie "BIGIP=Redirect_$count" Connection "Close"
      } elseif { [HTTP::status] == 500 && $count == 4 } {
    set count 0
    HTTP::respond 404 Set-Cookie "BIGIP=Not_Found" Connection "Close"
    }
  }
}
```

## Avi HTTP Retry 500 Errors

Please refer to https://kb.avinetworks.com/docs/latest/http-server-reselect/
