-- Check if the request is HTTPS, if not skip
if avi.http.secure() == "on" then
    cert_verify = avi.ssl.check_client_cert_validity()
    if cert_verify == 1 then
        avi.http.add_header("Client-Auth", "Valid cert")
    elseif cert_verify == 2 then
        avi.http.add_header("Client-Auth", "UNABLE_TO_GET_ISSUER_CERT_LOCALLY")
    else
        avi.http.add_header("Client-Auth", "No cert")
    end
end
