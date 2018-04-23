# Validate String Characters in Cookie

HTTP	 Cookie	 are	 key	 to	 Application	 access	 and	 persistence	 and	 post	 authentication,	 Cookie	becomes	the	way	to	let	access	go	through	as	a	trusted	channel.	Certain	Apps	define	what	they	do	not	expect	in	the	Cookie	value	and	ADC	can	help	enforce	the	check	before	the	request	makes	it	 to	backend.	In	 this	example	when	HTTP	 request	contains	cookie	header,	we	check whether
value	of	the	cookie	contains	any	characters	not	defined	in	the	configured	legal	list	of	characters	and	log	that	entry.


```lua
-- HTTP_REQUEST
-- get cookies
cookies, count = avi.http.get_cookie_names()
-- if cookie(s) exists, validate cookie(s) value
if count >= 1 then
  for cookie_id= 1, #cookies do
    -- allow only [a-zA-Z0-9] pattern for cookie value
    if string.match(avi.http.get_cookie(cookies[cookie_id]),"^%w+$") == nil then
      avi.vs.log("INVALID COOKIE VALUE:" .. cookies[cookie_id])
      avi.http.remove_cookie(cookies[cookie_id])
    end
  end
end
```
