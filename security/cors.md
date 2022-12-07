# Cross	Origin	Resource	Sharing	Implementation

Cross	origin	resource	sharing	is	required	when	you	are	dealing	with	multiple	domains	and	all	of	them
need	to	be	able	to	make	calls	to	specific	sub-domain	or	the	API	layer.	Many	times	we	even	need	to
allow	 the	 Partner	 networks	 to	 have	 access	 to	 such	 API	 sub-domains. One	 can	 do	 this	 on	 backend
servers	but	it	gets	complicated	quickly	and	every	change	needs	to	be	replicated	on	multiple	backend
servers	in	the	setup.	Doing	the	same	through	the	load	balancing	setup	is	a	much	simpler	way	to	get
there.


1. In the UI, go to Template > Groups > String Groups
2. Create a new String Group, named "allowed_origins" with the following domains.
  - http://example.com
  - http://example.ca
  - http://example.org
3. Use the following Datascript in your HTTP REQUEST and RESPONSE events, StringGroup  "allowed_origins" has to be associated with datascript.

```lua
-- HTTP_REQUEST
origin_header= avi.http.get_header("Origin")
-- Encode string to avoid being used for http smuggling attack
function uri_encode(str)
    return (str:gsub("([^%w-_.~])", function (c)
        return string.format('%%%02X', string.byte(c))
    end))
end
-- if Origin header exists and part of allowed_origins stringroup
if origin_header then
  allowed_origin, allowed_origin_match= avi.stringgroup.beginswith("allowed_origins", origin_header)
  if allowed_origin_match then
    allowed_methods= "POST,GET,OPTIONS"
    access_control_request_method_header= avi.http.get_header("Access-Control-Request-Method")
    -- present OPTIONS to the client
    if avi.http.method() == "OPTIONS" and access_control_request_method_header then
      avi.http.response(200, { Access_Control_Allow_Origin= origin_header,Access_Control_Allow_Methods= allowed_methods,Access_Control_Allow_Headers= access_control_request_method_header,Access_Control_Max_Age= "86400",Vary= "Origin"})
    else
    -- save origin header value to use in HTTP_RESPONSE event
    -- encode it before passing it to any other APIs
      avi.vs.reqvar.origin_header= uri_encode(origin_header)
    end
  end
end
```

```lua
-- HTTP_RESPONSE
-- if Origin Header was provided by client in HTTP REQUEST
if avi.vs.reqvar.origin_header then
  avi.http.replace_header("Access-Control-Allow-Origin",avi.vs.reqvar.origin_header)
  avi.http.replace_header("Access-Control-Allow-Credentials","true")
  avi.http.replace_header("Vary","Origin")
end
```
