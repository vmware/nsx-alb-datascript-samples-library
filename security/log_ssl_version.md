# Log SSL Version/Cipher and block SSLv3.0, TLSv1.0 or cipher suites that don't provide encryption.
Logging of SSL/TLS version for enhanced log collection and troubleshooting use cases. SSLv3 is known to be weak and vulnerable thus ability to track the SSLv3 transaction is important for the administrators. Avi Vantage provides a number of features to help understand the utilization of SSL traffic and troubleshoot SSL-related issues. More details: https://avinetworks.com/docs/latest/ssl-visibility-and-troubleshooting/

OpenSSL cipher suites: https://www.openssl.org/docs/manmaster/man1/ciphers.html


```
-- HTTP_REQUEST
-- logging version
avi.vs.log(avi.ssl.protocol() .. ":" .. avi.ssl.cipher())
-- closing connection for SSLv3.0 or TLSv1.0
if avi.ssl.protocol() == "TLSv1" or avi.ssl.protocol() == "SSLv3.0" then
  avi.http.close_conn()
  -- Overlaps with https://avinetworks.com/docs/latest/ssl-tls-profile/
  -- blocking cipher suites that don't provide encryption or DES/3DES cipher suites
elseif string.contains(string.lower(avi.ssl.cipher()),"des") or string.contains(string.lower(avi.ssl.cipher()),"null")  then
  avi.http.close_conn()
end
```

List of cipher suites that don't provide encryption:

```
openssl ciphers -v 'ALL:eNULL'

ECDHE-RSA-NULL-SHA      SSLv3 Kx=ECDH     Au=RSA  Enc=None      Mac=SHA1
ECDHE-ECDSA-NULL-SHA    SSLv3 Kx=ECDH     Au=ECDSA Enc=None      Mac=SHA1
GOST2012256-NULL-STREEBOG256 SSLv3 Kx=GOST     Au=GOST01 Enc=None      Mac=STREEBOG256
GOST2001-NULL-GOST94    SSLv3 Kx=GOST     Au=GOST01 Enc=None      Mac=GOST94
AECDH-NULL-SHA          SSLv3 Kx=ECDH     Au=None Enc=None      Mac=SHA1
ECDH-RSA-NULL-SHA       SSLv3 Kx=ECDH/RSA Au=ECDH Enc=None      Mac=SHA1
ECDH-ECDSA-NULL-SHA     SSLv3 Kx=ECDH/ECDSA Au=ECDH Enc=None      Mac=SHA1
NULL-SHA256             TLSv1.2 Kx=RSA      Au=RSA  Enc=None      Mac=SHA256
NULL-SHA                SSLv3 Kx=RSA      Au=RSA  Enc=None      Mac=SHA1
NULL-MD5                SSLv3 Kx=RSA      Au=RSA  Enc=None      Mac=MD5
```
