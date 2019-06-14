# Custom function for URI Encoding

By default URIs are designed to accept only certain characters in the ASCII character set.  URI encoding serves the purpose of replacing these non-conforming characters with a % symbol followed by two hexadecimal digits.  RFC3986 has more details regarding URL Encoding

Example provided will retrieve the uri modify it to encode non-confirming characters

```lua
-- HTTP_REQUEST
uri=avi.http.get_uri()

function uri_encode(str)
    return (str:gsub("([^%w-_.~])", function (c)
        return string.format('%%%02X', string.byte(c))
    end))
end

avi.http.set_uri(uri_encode(uri))
```