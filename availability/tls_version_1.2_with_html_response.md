# TLS Version Check and HTTP response with HTML Page

Check the TLS version and respond with HTTP 200 and HTML file. 

## F5 TLS version

```
when HTTP_REQUEST {
  if { [SSL::cipher version] ne "TLSv1.2" }  {
    switch [string tolower [HTTP::uri]] {"/"} {HTTP::respond 200 content [ifile get browser.html] "Content-Type" "text/html"}
  }
}
  
```

## Avi TLS Version

```lua
-- Create HTML Page and call the "page" in the DataScript.

page = "<html><body><p><center><b>Your request cannot be completed since you are not using TLSv1.2. Please contact your administrator.</b></p>"

if avi.ssl.protocol() ~= "TLSv1.2" and string.lower(avi.http.get_path()) == "/" then
avi.http.response(200, {content_type="text/html"}, page)
end  
```