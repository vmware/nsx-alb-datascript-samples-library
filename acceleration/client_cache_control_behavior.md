# Client Cache Control Behavior

Caching	 is	 one	 of	 the	 best ways to	 optimization	 Application	 response	 time	 and	 reduce	 the	 load	 on
web/app	servers.	Doing	Caching	at	ADC	layer	is	much	more	effective	as	it	can	be	done	along	with	other
ADC	operations.	Though	when	you	Cache	content,	you	can	control	what	to	Cache	on	ADC	and	what	Client
should	 be	 caching.	 This	 use	 case	 focuses	 on	 controlling	 end	 client	 caching	 behavior	 with	 respect	 to	different	kind	of	content.

More details on controlling cache on Avi Vantage: https://avinetworks.com/docs/latest/overview-of-http-cache/

Apply this to the "HTTP RESPONSE" Event.

```lua
-- HTTP_RESPONSE
content_path = avi.http.get_path()
content_header = avi.http.get_header("content-type")
-- StringGroups can be used as alternative to lua tables
expires_file_types = {["gif"]="Wed, 2 May 2018 00:00:00 GMT", ["png"]="Wed, 2 May 2018 00:00:00 GMT", ["ico"]="Wed, 2 May 2018 00:00:00 GMT"}
cache_control_file_types = {["xml"]="max-age=600", ["js"]="max-age=500", ["flv"]="max-age=400"}

for key, value in pairs(expires_file_types) do
  if string.endswith(content_path, key) and string.endswith(content_header, key) then
    avi.http.replace_header("Expires", value)
  end
end

for key, value in pairs(cache_control_file_types) do
  if string.endswith(content_path, key) and string.endswith(content_header, key) then
    avi.http.replace_header("Cache-Control", value)
  end
end
```
