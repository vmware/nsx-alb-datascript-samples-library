# HTTP URI Switching - Simple

Load balance URIs to different pools.

Desired URI to pool mapping:

http://www.foo.com/development/ --> Pool 1
http://www.foo.com/marketing/   --> Pool 2
http://www.foo.com/support/     --> Pool 3

## F5 HTTP URI Switching

```
when HTTP_REQUEST {
  if {[HTTP::uri] starts_with "/development" } {
    pool pool_development
  } elseif {[HTTP::uri] starts_with "/marketing" } {
    pool pool_marketing
  } elseif {[HTTP::uri] starts_with "/support" } {
    pool pool_support
  }
    else {
    discard
  }
}
```

## Avi HTTP URI Switching

```
if avi.http.get_path() = "/development" then
  avi.pool.select("pool_development")
elseif avi.http.get_path() = "/marketing" then
  avi.pool.select("pool_marketing")
elseif avi.http.get_path() = "/support" then
  avi.pool.select("pool_support")
else
  avi.http.close_conn()
end
```
