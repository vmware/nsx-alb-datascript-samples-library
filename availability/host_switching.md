# HTTP Host Switching

Load balance to different pools based on the host name the client is trying to access.  This allows a single IP address (and virtual server) to host numerous web sites.

## F5 HTTP Host Switching

```
when HTTP_REQUEST {
  switch [HTTP::host] {
    "site1.company.com" { pool Site1_Pool }
    "site2.company.com" { pool Site2_Pool }
    "site3.company.com" { pool Site3_Pool }
    "site4.company.com" { pool Site4_Pool }
    "default" { pool Default_Pool }
   }
}
```

## Avi HTTP Host Switching

```
host = avi.http.hostname()

if host == "site1.company.com" then avi.pool.select("Site1_Pool")
elseif host == "site2.company.com" then avi.pool.select("Site2_Pool")
elseif host == "site3.company.com" then avi.pool.select("Site3_Pool")
elseif host == "site4.company.com" then avi.pool.select("Site4_Pool")
else avi.pool.select("Default_Pool")
end
```
