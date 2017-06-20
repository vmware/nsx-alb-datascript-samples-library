# HTTP Host Switching

Load balance URIs to different pools.  This functionality can also
be performed using an HTTP Class instead of an iRule.
Desired URI to pool mapping:
http://www.foo.com/development/ --> Pool 1
http://www.foo.com/marketing/   --> Pool 2
http://www.foo.com/support/     --> Pool 3

## F5 Host IP Switching
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

## Avi Host IP Switching
