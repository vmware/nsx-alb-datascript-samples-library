# Redirect	Location	header	validator

Location	 header	 in	 HTTP	 responses	 are	 used	 to	 redirect	 client	 to	 different	 source.	 Most	 of	 the	 HTTP Redirection	happens	based	on	Location	header	processing.	In	this	use	case	Location	header is	intercepted
for any	redirects	which	are	to	a	domain	that	is	not	in	a	whitelist	string	data	group.	If	it	is	not	in	whitelist,	Location	header	will	change	to default	blocked	HTML	page.

1. In the UI, go to Template > Groups > String Groups
2. Create a new String Group, named "whitelisted_locations_for_redirect" with the following domains.
  - example.com
  - example.ca
  - example.org
3. Attach Stringroup to datascript below. Apply this to the "HTTP RESPONSE" Event.

```
-- HTTP_RESPONSE
location = avi.http.get_header("Location")
-- if redirect and location header set
if location and string.beginswith(avi.http.status(),"3") then
  location_stringgroup, match = avi.stringgroup.contains("whitelisted_locations_for_redirect", location )
  -- if location header does not contain whitelisted location, then block redirect to unknown location and redirect to default page
  if match == nil then
    avi.http.replace_header("Location", "http://www.example.com/redirect_blocked.html")
  end
end
```
