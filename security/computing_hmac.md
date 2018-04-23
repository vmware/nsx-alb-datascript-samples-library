# Computing HMAC

HMAC	is	a	keyed-hash	message	authentication	code	computed involving	a	cryptographic	hash
function	in	combination	with	a	 secret	cryptographic	key.	It	can be	used	 to	 simultaneously
verify	both	the	data	integrity	and	the	authentication	of	a	message.

```lua
---HTTP_REQ or HTTP_RESP
host = avi.http.get_header("Host")
-- if host header exists
if host then
 avi.http.add_header("Murmur-hash", avi.utils.murmur_hash(host))
 avi.http.add_header("SHA1-hash", avi.utils.sha1_hash(host))
 avi.http.add_header("MD5-hash", avi.utils.md5_hash(host))
end
```
