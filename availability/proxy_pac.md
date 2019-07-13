# Managing Proxy Auto-Configuration (PAC) file
The example outlines how to integrate existing proxy.pac file to DataScript Lua code and serve it to the end users.

1. Proxy Auto-Configuration (PAC) file.
    ```
    function FindProxyForURL(url, host) {
      if (isPlainHostName(host) ||
          dnsDomainIs(host, ".avinetworks.com") ||
          isInNet(host, "192.168.0.0", "255.255.0.0")) {
        return "DIRECT";
      } else {
        return "PROXY proxy.avinetworks.net:8080";
      }
    }
    ```
2. The above file has to be prepared/formatted for DataScript, leveraging sed function. The output of sed function will be used in DataScript.
    ```
    root@avitools:/tmp# sed ':a;N;$!ba;s/\n/\\n/g' proxy.pac
    function FindProxyForURL(url, host) {\n  if (isPlainHostName(host) ||\n      dnsDomainIs(host, ".avinetworks.com") ||\n      isInNet(host, "192.168.0.0", "255.255.0.0")) {\n    return "DIRECT";\n  } else {\n    return "PROXY proxy.avinetworks.net:8080";\n  }\n}
    ```

3. Create HTTP_REQ DataScript and associate it to the corresponding virtual service.
    ```lua
    -- HTTP_REQ
    proxy_pac_body = 'function FindProxyForURL(url, host) {\n  if (isPlainHostName(host) ||\n      dnsDomainIs(host, ".avinetworks.com") ||\n      isInNet(host, "192.168.0.0", "255.255.0.0")) {\n    return "DIRECT";\n  } else {\n    return "PROXY proxy.avinetworks.net:8080";\n  }\n}'

    if string.contains(avi.http.get_path(), 'proxy.pac') then
    avi.http.response(200,{content_type="application/x-ns-proxy-autoconfig", pragma="no-cache"}, proxy_pac_body)
    end
    ```
4. Verify the applied DataScript.
    ```
    root@avitools:/tmp# curl -i http://10.57.0.52/proxy.pac
    HTTP/1.1 200 OK
    Content-Type: application/x-ns-proxy-autoconfig
    Content-Length: 252
    Connection: keep-alive
    pragma: no-cache

    function FindProxyForURL(url, host) {
      if (isPlainHostName(host) ||
          dnsDomainIs(host, ".avinetworks.com) ||
          isInNet(host, "192.168.0.0", "255.255.0.0")) {
        return "DIRECT";
      } else {
        return "PROXY proxy.avinetworks.net:8080";
      }
    root@avitools:/tmp# apt-get install libpacparser1
    root@avitools:/tmp# curl -O http://10.57.0.52/proxy.pac
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   253  100   253    0     0   1144      0 --:--:-- --:--:-- --:--:--  1150
    root@avitools:/tmp# pactester -p proxy.pac -u http://www.avinetworks.com
    DIRECT
    root@avitools:/tmp# pactester -p proxy.pac -u http://vmware.com
    PROXY proxy.avinetworks.net:8080
    ```
