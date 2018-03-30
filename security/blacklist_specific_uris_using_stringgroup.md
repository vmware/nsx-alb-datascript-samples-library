# Blacklist Specific URIs using String Group
 Usually not every URI has to be exposed to the external world as it is posses potential security risk to the system. List of specific URIs listed in String Group "uri_blacklist" and after evaluated in datascript for potential match. Create String Group (string list, Templates > Groups > String Group).  Apply script to the "HTTP REQUEST" Event.

```
uri = avi.http.get_uri()
blocked_uri, match = avi.stringgroup.beginswith("uri_blacklist", uri)
if match then
   avi.http.response(404, {content_type="text/html"},"Access Denied!")
   avi.http.close_conn()
end
```
