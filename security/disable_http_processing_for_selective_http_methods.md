# Disable HTTP	Processing	For	Selective HTTP	Methods
  HTTP	is	the	most	common	layer	7	based	communication	protocol	in	industry	today.	Most	of
us	use	it	for	our	everyday	jobs	to	get	done. HTTP	RFC	has	defined	common	set	of	methods	
and	operations	to	be	used.	While	there	are	some	special	methods	and	operations	which	are
not	expected	to	be	used	in	normal	use	cases.	This	example	shows	how	you	can	disable	HTTP
processing	and	specific	functions	for	these	methods.

```
--HTTP_REQUEST
restricted_methods = "MOVE,COPY,LOCK,UNLOCK,PROPFIND,PROPPATCH,MKCOL"
event_method = avi.http.method()
if string.contains(restricted_methods, event_method) then
    avi.http.response("403")
end
```
