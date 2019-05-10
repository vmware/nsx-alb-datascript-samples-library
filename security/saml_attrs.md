# Retrieve SAML Attribute from session cookie and expose it as Header and as Avi Logging attribute
The script extracts a SAML attribute of interest (as an alphanumerical value) and provides it as Header as well as Avi Logging attribute. Starting 18.2.4 string.split() function can be used for ease of string parsing.  

```lua
saml_attr_name='SAML_USERID'
header_saml_name='X-SAML-User'

saml_attrs = avi.http.saml_session_decrypt()
if saml_attrs then
  for w in string.gmatch(saml_attrs, saml_attr_name .. "=%w+") do
      header_saml_attr_value = string.gsub(w, saml_attr_name .. '=', '')
  end
  if header_saml_attr_value then
    avi.http.add_header(header_saml_name, header_saml_attr_value)
    avi.http.set_userid(header_saml_attr_value)
  end
end
```
