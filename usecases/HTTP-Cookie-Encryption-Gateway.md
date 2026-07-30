# HTTP Cookie Encryption Gateway

The following DataScript encrypts the contents of a cookie going to a client and decrypts the content before returning the cookie to the server. This DataScript can be altered to encrypt all cookies, set the HTTPonly and Secure flags, and use a more complex key and encryption algorithm.

**HTTP Response**

```lua
local cookie = "my_cookie"
if avi.http.cookie_exists(cookie) then
    -- The default encryption algorithm used is AES-256 in CBC mode
    -- which requires key lengths of 256 bits.
    local key = "01234567890123456789012345678901"
    local value = avi.http.get_cookie(cookie)
    local encrypted_value = avi.crypto.encrypt(value, key)
    avi.http.replace_cookie(cookie, encrypted_value)
end
```

**HTTP Request**

```lua
local cookie = "my_cookie"
if avi.http.cookie_exists(cookie) then
    local key = "01234567890123456789012345678901"
    local value = avi.http.get_cookie(cookie)
    local decrypted_value = avi.crypto.decrypt(value, key)
    avi.http.replace_cookie(cookie, decrypted_value)
end
```
