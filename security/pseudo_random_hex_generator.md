# Pseudo-random	hex	character	generator
Pseudo-random	hex	characters can	be	used	in	the	authentication	and	validation	flow	across
the	ADC	and	Client/Server.	The	hex	characters	can	be	used	for	different	purposes	as	well.
Starting 18.2.4 **avi.utils.rand_bytes(num_bytes)** function was introduced. This API allows users to generate cryptographically secure random bytes of data.

```lua
local charset = {}  do
    --[0-9]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    --[a-f]
    for c = 97, 102  do table.insert(charset, string.char(c)) end
end

local function randomString(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.clock()^5)
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end
avi.http.add_header("Random-Hex-32",randomString(32) )
```
