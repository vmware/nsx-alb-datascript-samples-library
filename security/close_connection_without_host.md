# Close Connection without Host

In some cases we may want to stop communication if a client is requesting traffic without a host defined. To do these we would use the following.

```
host = avi.http.hostname()
if not host then
   avi.http.close_conn()
end
```
