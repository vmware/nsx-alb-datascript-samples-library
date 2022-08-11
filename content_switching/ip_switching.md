# HTTP IP Switching

Identify and direct internal versus external clients based on their source IP address.  This can also be used to create white or black lists of clients addresses.  This rule uses a class list to maintain the list of IP addresses.

## F5 HTTP IP Switching
```
class private_net {
  network 10.0.0.0/8
  network 172.16.0.0/12
  network 192.168.0.0/16
}

when HTTP_REQUEST {
  if { [matchclass [IP::client_addr] equals ::private_net] } {
    pool internal_pool
  } else {
    pool default_pool
  }
}
```

## Avi IP Switching

Because Avi doesn't have a class matching function, we can instead make use of the IP Group feature in Avi's Configuration.

1. In the UI, go to Templates > Groups > IP Group
2. Create a new IP Group, named "Internal" with the following subnets.
  - 10.0.0.0/8
  - 172.16.0.0/12
  - 192.168.0.0/16
3. Use the following Datascript in your request event.
```lua
clientIP = avi.vs.client()
if avi.ipgroup.contains("Internal", clientIP) then
  avi.pool.select("internal_pool")
else
  avi.pool.select("external_pool")
end
```
