# TCP Proprietary Persistence

This iRule will search for an embedded server identifier to use for persistence (much like an HTTP cookie) and send the user to that node. If no server ID is found it will load balance the request as a new connection.  The rule looks for ...Server=3&... within the first 50 bytes of data received by the client.


## F5 TCP Proprietary Persistence

```
when CLIENT_ACCEPTED {
  TCP::collect 50
}

when CLIENT_DATA {
  if { [TCP::payload 50] contains "Server=" } {
    switch [findstr [TCP::payload] "Server=" 7 "&"] {
      "1"  { pool Default_Pool member 10.0.0.1 }
      "2"  { pool Default_Pool member 10.0.0.2 }
      "3"  { pool Default_Pool member 10.0.0.3 }
      "10" { pool Default_Pool member 10.0.0.10 }
      "default" { pool Default_Pool }
    }
  } else {
    pool Default_Pool
  }
  TCP::release
}
```

## Avi TCP Proprietary Persistence

```
Coming Soon!
```
