# Header Persistence using Akamai True-Client-IP header
Akamai's	True-Client-IP	header	is	way	to	recognize	actual Client	IP for	all	traffic	routed	through
Akamai	regional	servers.	Akamai	inserts	this	header	in	each	request	with	a	value	of the	original	user's	IP
address.	This	header	can	be	used	to	define	persistence	for	real	client	with	the	same	backend	server.

Persistence can be easily done through REST/UI/CLI: https://avinetworks.com/docs/17.2/custom-http-header-persistence/ or through Custom Datascript below:

Apply these scripts to the "HTTP REQUEST" & "HTTP RESPONSE" events appropriately ,pool has to be selected for datascript.

```
-- HTTP_REQUEST
default_pool = "primary_pool"
avi.vs.reqvar.true_client_ip =  avi.http.get_header("True-Client-IP")
-- if header provided
if avi.vs.reqvar.true_client_ip then
  -- lookup server using value of True-Client-IP for existing mapping in persistence table
  avi.vs.reqvar.pinned_server_ip = avi.vs.table_lookup(avi.vs.reqvar.true_client_ip)
  -- assumming VS port matches server port
  pinned_server_port = avi.vs.port()
  -- if server found in persistence table and it's up, use already pinned server, if not use default pool
  if avi.vs.reqvar.pinned_server_ip and avi.pool.get_server_status(default_pool, avi.vs.reqvar.pinned_server_ip, pinned_server_port) == 1 then
    avi.pool.select(default_pool, avi.vs.reqvar.pinned_server_ip)
  else
    avi.vs.table_remove(avi.vs.reqvar.true_client_ip)
    avi.pool.select(default_pool)
  end
end
```

```
-- HTTP_RESPONSE
if avi.vs.reqvar.true_client_ip then
  selected_server_ip = avi.pool.server_ip()
  if avi.vs.reqvar.pinned_server_ip then
    -- Update the expire time for a table entry for 20 minutes for active connection i.e. existing persistence entry
    avi.vs.table_refresh(avi.vs.reqvar.true_client_ip,1200)
  else
    -- Create persistence entry for 20 minutes based on True-Client-IP header
    avi.vs.table_insert(avi.vs.reqvar.true_client_ip, selected_server_ip,1200)
  end
end
```
