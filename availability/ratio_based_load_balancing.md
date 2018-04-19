# Ratio	based	Load	Balancing
Using	pseudo	random	number	generation,	in	run	time	take	decisions	like	sending	part	of	the	traffic	to
one	pool	versus	another.	Below	example	sends	2%	of	connections	to	a	separate	pool	and	remaining
98%	of	connections are	sent	to	the	virtual	server's	default	pool.	The	second	example	selects	a	separate
pool	for	2%	of	requests	to	a	specific	set	of	URIs. This is only datascript example, the functionality below can be done through Pool Groups: https://avinetworks.com/docs/latest/pool-groups/
Pools has to be attached to datascript. Apply this to the "HTTP REQUEST" Event.

```
math.randomseed(os.clock()^5)
-- Send 2% of connections to secondary_pool, the rest to default_pool
if math.random() < 0.02 then avi.pool.select("secondary_pool")
else avi.pool.select("Default_Pool")
end
```
