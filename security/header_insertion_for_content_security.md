# Header Insertion for Content Security
  Defining and inserting required headers in response for content security. Apply this to the "HTTP RESPONSE" Event.

'''
-- HTTP_RESP
-- https://securityheaders.io/
-- Templates > Profiles > HTTP application profile’s security settings page affects how a virtual service should handle HTTPS

max_age = 15552000
primary_pin_sha256="cUPcTAZWKaASuYWhhneDttWpY3oBAkE3h2+soZS7sWs="
backup_pin_sha256="M8HztCzM3elUxkcjR2S5P4hhyBNf6lHkmjAHKhpGPWE="

-- HSTS
-- https://https.cio.gov/hsts/
avi.http.add_header("Strict-Transport-Security", "max-age=" .. max_age .. "; includeSubDomains")
-- HPKP
-- https://developer.mozilla.org/en-US/docs/Web/HTTP/Public_Key_Pinning
avi.http.add_header("Public-Key-Pins",  "pin-sha256=" .. primary_pin_sha256 .. "; pin-sha256=".. backup_pin_sha256 .. "; includeSubDomains; max-age=" .. max_age)
-- X-XSS-Protection
avi.http.add_header("X-XSS-Protection", "1; mode=block")
-- X-Frame-Options
avi.http.add_header("X-Frame-Options", "DENY")
-- X-Content-Type-Options
avi.http.add_header("X-Content-Type-Options", "nosniff")
-- Content-Security-Policy
avi.http.add_header("Content-Security-Policy", "default-src https://avicontroller.avinetworks.com:443")
-- Content-Security-Policy for IE
avi.http.add_header("X-Content-Security-Policy", "default-src https://avicontroller.avinetworks.com:443")
'''
