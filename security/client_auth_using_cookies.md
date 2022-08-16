# HTTP Client Auth Using Cookies

This is an example using HTTP cookie for authentication. If authentication is successful, a cookie will be sent to client. If next time, the AUTH cookie is present and valid, client will be passed immediately without being checked with AAA server. The cookie name, password, domain should be properly modified by user. This rule is for RADIUS AUTH, though it can be altered to accommodate TACACS or LDAP. http://devcentral.f5.com/Wiki/default.aspx/iRules/ClientAuthUsingHttpCookie.html

## F5 HTTP Client Auth Using Cookies

```
when CLIENT_ACCEPTED {
  set authinsck 0
  set forceauth 1
  set ckname BIGXAUTH
  set ckpass 1xxx5678
  set ckvalue [IP::client_addr]
  set ckdomain .y.z
  set asid [AUTH::start pam default_radius]
}

when HTTP_REQUEST {
  if {[HTTP::cookie exists $ckname]} {
    HTTP::cookie decrypt $ckname $ckpass 128
    if {[HTTP::cookie value $ckname] eq $ckvalue} {
      set forceauth 0
    }
    HTTP::cookie remove $ckname
  }
  if {$forceauth eq 1} {
    AUTH::username_credential $asid [HTTP::username]
    AUTH::password_credential $asid [HTTP::password]
    AUTH::authenticate $asid
    HTTP::collect
  }
}

when HTTP_RESPONSE {
  if {$authinsck eq 1} {
    HTTP::cookie insert name $ckname value $ckvalue path / domain $ckdomain
    HTTP::cookie secure $ckname enable
    HTTP::cookie encrypt $ckname $ckpass 128
  }
}

when AUTH_SUCCESS {
  if {$asid eq [AUTH::last_event_session_id]} {
    set authinsck 1
    HTTP::release
  }
}

when AUTH_FAILURE {
   if {$asid eq [AUTH::last_event_session_id]} {
     HTTP::respond 401 "WWW-Authenticate" "Basic realm=\"\""
   }
}

when AUTH_WANTCREDENTIAL {
   if {$asid eq [AUTH::last_event_session_id]} {
     HTTP::respond 401 "WWW-Authenticate" "Basic realm=\"\""
   }
}

when AUTH_ERROR {
   if {$asid eq [AUTH::last_event_session_id]} {
    HTTP::respond 401
   }
}
```

# Avi HTTP Client Auth Using Cookies

```

```
