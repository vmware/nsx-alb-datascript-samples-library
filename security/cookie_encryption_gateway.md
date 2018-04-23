# Cookie Encryption Gateway

Encrypt any cookies leaving this virtual server and decrypt them on the way in.  This can also be done within the HTTP Profile, but with this all cookies are encrypted, rather than manually specifying each cookie to encrypt.

# F5 Cookie Encryption Gateway
```
when RULE_INIT {
  # Exposed passphrase, but this key can be synchronized to the peer LTM
    set ::passphrase "secret"

  # Private passphrase, but it isn't synchronized.  On LTM failover to
  # its peer, applications relying on the encrypted cookies will break.
    # set ::passphrase [AES::key]
}

when HTTP_REQUEST {
  foreach { cookieName } [HTTP::cookie names] {
    HTTP::cookie decrypt $cookieName ::passphrase
  }
}

when HTTP_RESPONSE {
  foreach { cookieName } [HTTP::cookie names] {
    HTTP::cookie encrypt $cookieName ::passphrase
  }
}
```

# Avi Cookie Encryption Gateway

Apply this to the "HTTP Request" Event

```lua
key = "234LJKH43J3H4K6KJH77H234"
cookies, count = avi.http.get_cookie_names()

if count > 0 then
  for cookie_num = 1, #cookies do
    cookie_name = cookies[cookie_num]
    cookie_data = avi.http.get_cookie(cookie_name)
    decrypt = avi.crypto.decrypt(cookie_data, key)
    avi.http.replace_cookie(cookie_name, decrypt)
  end
end
```

Apply this to the "HTTP Response" Event

```lua
key = "234LJKH43J3H4K6KJH77H234"
cookies, count = avi.http.get_cookie_names()

if count > 0 then
  for cookie_num = 1, #cookies do
    cookie_name = cookies[cookie_num]
    cookie_data = avi.http.get_cookie(cookie_name)
    encrypt = avi.crypto.encrypt(cookie_data, key)
    avi.http.replace_cookie(cookie_name, encrypt)
  end
end
```
