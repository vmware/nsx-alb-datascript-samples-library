# Overwrite single HTTP query option from the existing set of query options - Advanced

The original url https://demo.avinetworks.com/path1/index.html?fruits=oranges&type=organic&origin=us to be transformed for pool member consumption to https://demo.avinetworks.com/path1/index.html?fruits=apples&type=organic&origin=us

```lua
if avi.http.get_query("fruits", "oranges") then
  query_table = avi.http.get_query(avi.QUERY_TABLE)
  query_table['fruits'] = 'apples'
  avi.http.set_query(query_table)
end
```
