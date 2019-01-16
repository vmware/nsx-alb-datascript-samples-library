# Prepend request path

This DataScript will prepend requests with an additional path, unless the path is already present.

Please add this DataScript in the DataScript section on a Virtual Service.

```lua
path = avi.http.get_path()
new_path = "/foo"

if not string.beginswith(path, new_path) then
   avi.http.set_path(new_path..path)
end
```
