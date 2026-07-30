# Custom Error Webpage for Avi Load Balancer-Generated Responses

This section describes the procedure to generate a custom error page with application-specific content.

Currently, Avi Load Balancer can generate custom responses from policy, DataScript, or a `POOL_DOWN` action. Other than this, there are cases where we cannot communicate with a back-end server (for instance, in case of a 502 error), where we respond to the client with a hard-coded page (non-custom). Customers occasionally prefer to generate their custom error page so that it does not have Avi Load Balancer on the page but rather some application-specific message.

## How it Works

Avi Load Balancer supports a new DataScript event named `RESP_FAILED` that triggers when any error/timeout happens till a valid response header is received from the server and forwarded to the client.

For instance,
*   TCP/SSL connect/handshake to server fails.
*   Request proxy/send to server times out.
*   No response or partial response headers or bad response headers from the server.
*   The server resets connection while the Avi Load Balancer SE is waiting for the server to respond.

A DataScript attached to the `RESP_FAILED` event is executed. Example functions exposed to the script are `avi.http.response()`, `avi.http.redirect()`, and (the newly created) `avi.http.internal_status()`. The user can use these to customize responses for the different types of failures, log the reason in Avi Load Balancer logs, etc. For more information, see:
*   `avi.http.response(status, [headers, [body]])`
*   `avi.http.redirect(uri [,status])`
*   `avi.http.close_conn()`

See also,
*   DataScript Functions lists `avi.http.internal_status()`, which returns the reason why the request to the server failed.
*   `RESP_FAILED` status in Object Model.
*   `RESP_FAILED` status in DataScript Events.
