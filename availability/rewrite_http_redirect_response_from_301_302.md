# Rewrite	HTTP	redirect	response	from	301	to	302

Rewrite	HTTP	responses	with	HTTP	status	code	301	which	is	for	Permanent	Redirect	to	302	which	is used	for	Temporary	Redirect. Apply this to the "HTTP RESPONSE" Event.

```lua
-- HTTP_RESPONSE
-- if server response is a redirect 301, rewrite to 302, same location

if avi.http.status() == "301" then
  redirect_to = avi.http.protocol() .. "://" .. avi.http.hostname() .. avi.http.get_uri()
  avi.http.response(302, {content_type="text/html"},"<\!DOCTYPE HTML><html lang=\"en-US\"> <head> <meta charset=\"UTF-8\"> <meta http-equiv=\"refresh\" content=\"0; url=\"" .. redirect_to .. "\"> <script type=\"text/javascript\"> window.location.href = \"" .. redirect_to .. "\"</script> <title>Page Redirection</title> </head> <body> If you are not redirected automatically, follow this <a href=\""  .. redirect_to .. "\">link to example</a>. </body></html>")
  avi.http.replace_header("Location", redirect_to)
end
```
