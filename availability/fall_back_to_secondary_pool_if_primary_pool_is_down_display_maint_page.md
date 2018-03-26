# Fall back to secondary pool if all primary pool servers are down, display custom maintenance page if both pools are down.
How to perform efficient load balancing during event when primary pool is under maintenance and transparently switch to secondary pool. Apply this to the "HTTP REQUEST" Event, pools has to be selected for datascript.

```
primary_pool = "primary_pool"
backup_pool = "secondary_pool"
force_maint = 0

if primary_pool~=nil then
  primary_pool_servers_up_count, primary_pool_servers_total_count = avi.pool.get_servers(primary_pool)
  if primary_pool_servers_up_count < 1 then
    avi.vs.log("Primary Pool: All Servers Down. Switching to Backup Pool.")
    if backup_pool~=nil then
      backup_pool_servers_up_count, primary_pool_servers_total_count = avi.pool.get_servers(backup_pool)
      if backup_pool_servers_up_count < 1 then
        avi.vs.log("Backup Pool: All Servers Down. Forcing Maint Mode.")
        force_maint = 1
      else
        avi.pool.select(backup_pool)
        avi.vs.log("Pool used:" .. backup_pool)
      end
    end
  else
    avi.pool.select(primary_pool)
    avi.vs.log("Pool used:" .. primary_pool)
  end
else
  if backup_pool~=nil then
    backup_pool_servers_up_count, primary_pool_servers_total_count = avi.pool.get_servers(backup_pool)
    if backup_pool_servers_up_count < 1 then
      avi.vs.log("Backup Pool: All Servers Down. Forcing Maint Mode.")
      force_maint = 1
    else
      avi.pool.select(backup_pool)
      avi.vs.log("Pool used:" .. backup_pool)
    end
  end
end
if force_maint == 1 then
  avi.http.response(503,{content_type="text/html"},"<\!doctype html><title>Site Maintenance</title><style> body { text-align: center; padding: 150px; } h1 { font-size: 50px; } body { font: 20px Helvetica, sans-serif; color: #333; } article { display: block; text-align: left; width: 650px; margin: 0 auto; } a { color: #dc8100; text-decoration: none; } a:hover { color: #333; text-decoration: none; }</style><article> <h1>We&rsquo;ll be back soon!</h1> <div> <p>Sorry for the inconvenience but we&rsquo;re performing some maintenance at the moment. If you need to you can always <a href=\"mailto:#\">contact us</a>, otherwise we&rsquo;ll be back online shortly!</p> <p>&mdash; The Team</p> </div></article>")
end
```
