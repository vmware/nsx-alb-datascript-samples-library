# Load Balancing during Maintenance Window
How to perform efficient load balancing during maintenance window. Apply this to the "HTTP REQUEST" Event, pool "maintenance_pool" has to be selected for datascript.

```
maintenance_pool = "maintenance_pool"

start_date = os.date("03/22/2018 07:20 PM")
end_date = os.date("03/22/2018 09:00 PM")
now = os.date("%m/%d/%Y %I:%M %p")

if start_date < now and end_date > now then
    avi.vs.log("Maintenance Mode Enabled. Started at " .. start_date .. " to end at " .. end_date .. ".Pool Selected: " .. maintenance_pool)
    avi.pool.select(maintenance_pool)
end
```
