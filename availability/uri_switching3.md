# HTTP URI Switching using String Groups - Advanced

Leverage StringGroup defined dict to redirect the requests from existing url to new url. StrinGroup type is KEYVAL, where the key is current url and value is new url (to be redirected to). StringGroup "urls_stringgroup" has to be attached to datascript.

```lua
-- HTTP_REQUEST
url = avi.http.scheme() .. avi.http.hostname() .. avi.http.get_uri()
new_url, match = avi.stringgroup.equals("urls_stringgroup", url)
if match then
  avi.http.redirect(new_url)
end
```

StringGroup "urls_stringgroup":

```json
{
"kv": [
{
"value": "https://test.ca/test123?test=true",
"key": "http://test.com/3458?private=true"
},
{
"value": "https://newtest.com",
"key": "http://test.com/"
}
],
"type": "SG_TYPE_KEYVAL",
"name": "urls_stringgroup"
}
```