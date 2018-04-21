#  Controlling Bots

 While its important for web crawlers to index your site, they have the ability to devour more than their share of your bandwidth.  Use this Datascript to send them to a quarantined server pool on your site. This is only datascript example, HTTP policy framework also can be used to achieve the same functionality, as option rate limiters and throttling can be applied: https://avinetworks.com/docs/latest/rate-shaping-and-throttling-options/

```
-- HTTP_REQUEST
bot_user_agent_mask = {"bot", "fast-", "crawler"}

for i=1, #bot_user_agent_mask do
 if string.contains(string.lower(avi.http.get_header("User-Agent")),bot_user_agent_mask[i]) then
   avi.pool.select("slow_pool")
   return
 else
   avi.pool.select("default_pool")
 end
end
```
