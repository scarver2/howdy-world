// odin/main.odin

package main

import "core:fmt"
import "core:net"

PORT :: 6969

main :: proc() {
    fmt.println("Starting Odin server...")

    endpoint := net.Endpoint{
        address = net.IP4_Address{0, 0, 0, 0},
        port = PORT,
    }

    listener, listen_err := net.listen_tcp(endpoint)
    if listen_err != nil {
        fmt.println("Failed to listen:", listen_err)
        return
    }

    fmt.println("Listening on port", PORT)

    for {
        conn, _, accept_err := net.accept_tcp(listener)
        if accept_err != nil {
            continue
        }

body := `<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Howdy from Odin</title>
</head>
<body>
    <h1>Howdy, World!</h1>
</body>
</html>
`

response := fmt.tprintf(
    "HTTP/1.1 200 OK\r\nContent-Length: %d\r\nConnection: close\r\nContent-Type: text/html; charset=utf-8\r\n\r\n%s",
    len(body),
    body,
)

bytes := transmute([]u8)response
_, _ = net.send_tcp(conn, bytes)


        net.close(conn)
    }
}
