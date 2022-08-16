# Random Letter generator
There	are	several	use	cases	where	you	may	want	a	random	letter	generator	utility	to	use	it
with	different	kind	of	content	changes	we	do	while	parsing.	This	example	will	demonstrate
how	to	generate	a	string	of	pseudo-random	letters.


```lua
local charset = {}  do
  -- [a-zA-Z]
  for i = 65,  90 do table.insert(charset, string.char(i)) end
  for i = 97, 122 do table.insert(charset, string.char(i)) end

end

local function randomString(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.clock()^5)
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end
avi.http.add_header("Random-String",randomString(32) )
```
