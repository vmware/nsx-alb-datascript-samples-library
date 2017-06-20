# HTTP URI Switching - Advanced

Load balance requests to different pools based on the type of content.

## F5 HTTP URI Switching

class Static_Content {
  ".gif"
  ".jpg"
  ".png"
  ".ico"
  ".css"
}

when HTTP_REQUEST {
  if { [matchclass [string tolower [HTTP::path]] ends_with ::Static_Content] } {
    pool Cache_Servers
  }
  pool App_Servers
}


## Avi HTTP URI Switching
