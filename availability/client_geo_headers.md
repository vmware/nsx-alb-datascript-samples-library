# GeoLocation Header

In versions 18.1.5+ and 18.2.x new function avi.utils.get_geo_from_ip() is introduced and will leverage GEO database

```lua
client_ip = avi.vs.client_ip()
client_geo = avi.utils.get_geo_from_ip(client_ip)
if avi.http.get_header(COUNTRY) then
  avi.http.replace_header("COUNTRY", client_geo)
else
  avi.http.add_header("COUNTRY", client_geo)
end
```

More info on GEO database:
https://avinetworks.com/docs/18.1/geo-location-database/#overriding-the-database
