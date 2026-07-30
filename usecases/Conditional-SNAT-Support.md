# Conditional SNAT Support using L4 DataScript

A L4 DataScript can be used to programmatically override the default SNAT behaviour for pool traffic.

A typical use case is to allow the back-end traffic associated with different sets of clients to be differentiated in the network and on the application servers by mapping them to different SNAT IPs.

## Example DataScript

The following script should be attached to the TCP CLIENT ACCEPT event:

```lua
local client_ip = avi.vs.client_ip()
local match_ip1 = "10.10.10.1"
local match_ip2 = "10.10.10.2"

if client_ip == match_ip1 then
    avi.l4.source_ip("192.168.10.1")
elseif client_ip == match_ip2 then
    avi.l4.source_ip("192.168.10.2")
elseif avi.ipgroup.contains("vip-clients", client_ip) then
    avi.l4.source_ip("192.168.10.3")
end
```

In this example, the back-end traffic will use:
*   `192.168.10.1` as SNAT IP when the client IP is `10.10.10.1`.
*   `192.168.10.2` as SNAT IP when the client IP is `10.10.10.2`.
*   `192.168.10.3` as SNAT IP when the client IP matches an address in the IP Group `vip-clients`.
*   Default SNAT behaviour in all other cases.

## SNAT IP Advertisement

Starting with Avi Load Balancer version 31.1.1, the Service Engines do not respond to ARP requests for, nor advertise through BGP, SNAT IPs specified through the `avi.l4.source_ip()` function. You must configure the servers or network to support returning reply traffic to the appropriate Service Engine, for instance, by configuring static routes on the servers or in the network using a Service Engine Group floating IP as next hop.

**Note:** For IPv6 addresses, you must use the `snat_ip6s` parameter rather than `snat_ips`.

## Caveats and Restrictions

The following caveats and restrictions currently exist for this feature:
*   The virtual service must be configured with:
    *   Application profile of type L4, for instance, System-L4-Application.
    *   The Preserve Client IP option must not be enabled.
    *   Network profile of type TCP Proxy, for instance, System-TCP-Proxy.
    *   Service Engine Group configured for Legacy Active/Standby H/A mode.
*   **Note:** The SE Group may be configured with the Distribute Load option enabled provided the same SNAT IPs are not used across different virtual services.
*   SNAT IPs cannot be the same as:
    *   Any Service Engine interface IP.
    *   Any Service Engine floating IP.
    *   Any virtual service VIP.
