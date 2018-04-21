# Location header rewrite with non-standard port 

Location	header	provides	 the	information	 to	client	as	where	 to	go	next.	While	 the	location	header
mostly	gets	generated	by	backend	Apps,	there	is	a	need	to	change	them	on	load	balancing	device.
Enterprises	runs	legacy	Apps	which	were	written	to	generate	the	Location	header	with	“http”	while
most	of	the	front-end	communication	is	now	switched	to	“https”.	Hence	there	is	a	need	to	do	protocol
changes	as	well	as	at	times	you	are	required	to	change	to	a	non-standard	port	based	on	where	actual
service	is	running.


```
-- HTTP_RESPONSE
--
-- Rewrites the HTTP Location header in a HTTP Reponse from HTTP to HTTPS and a none standard port to the end of the hostname
-- e.g. Location Header 'http://www.test.com/path1/path2/index.html' will be changed to 'https://www.test.com:80/path1/path2/index.html'
--
-- The Location response header indicates the URL to redirect a page to. It only provides a meaning when served with a 3xx (redirection) or 201 (created) status response
if string.beginswith(avi.http.status(),"3") or avi.http.status() == "201" then
  location = avi.http.get_header("Location")
  -- location = "http://www.avinetworks.com:8080/path1/path2/index.html?a=b&c=d"
  http_uri = ""
  http_hostname = ""
  if location and string.beginswith(location,"http://") then
    -- remove http:// from location
    location = string.sub(location,8)
    -- extract uri from location
    for match in string.gmatch(location, "/.*") do
      http_uri = match
    end
    -- use extracted uri to extract hostname
    len= string.len (location) - string.len(http_uri)
    http_hostname = string.sub(location,0,len)
    -- if extacted hostname contains custom port, for example test.com:8443, remove port from string
    if string.contains(http_hostname,":") then
      for match in string.gmatch(http_hostname, ".*:") do
        http_hostname = string.sub(match,0,-2)
      end
    end
    location_header = "https://" .. http_hostname .. ":80" .. http_uri
    avi.http.replace_header("Location", location_header)
  end
end
```
