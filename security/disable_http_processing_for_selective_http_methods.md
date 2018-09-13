# Disable HTTP	Processing	For	Selective HTTP	Methods
  HTTP	is	the	most	common	layer	7	based	communication	protocol	in	industry	today.	Most	of
us	use	it	for	our	everyday	jobs	to	get	done. HTTP	RFC	has	defined	common	set	of	methods
and	operations	to	be	used.	While	there	are	some	special	methods	and	operations	which	are
not	expected	to	be	used	in	normal	use	cases.	This	example	shows	how	you	can	disable	HTTP
processing	and	specific	functions	for	these	methods. Apply this to the "HTTP REQUEST" Event.
This is only datascript example, the functionality below can be done through HTTP Policies framework or WAF as well.


```lua
--HTTP_REQUEST
restricted_methods = "MOVE,COPY,LOCK,UNLOCK,PROPFIND,PROPPATCH,MKCOL"
non_http_methods = "CONNECT"
event_method = avi.http.method()
if string.contains(restricted_methods, event_method) then
    avi.http.response("403")
elseif string.contains(non_http_methods, event_method) then
    avi.http.set_reqvar("disable_http_processing", true)
end
```

```lua
--HTTP_RESP
if avi.http.get_reqvar("disable_http_processing") == true then
   avi.http.disable()
end
```
