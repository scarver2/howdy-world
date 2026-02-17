// odin-http/main.odin
package main

import "core:fmt"
import "core:log"
import "core:net"
import "core:os"

import http "deps:odin-http"

PORT :: 6969

main :: proc() {
	context.logger = log.create_console_logger(.Info)

	s: http.Server
	http.server_shutdown_on_interrupt(&s)

	router: http.Router
	http.router_init(&router)
	defer http.router_destroy(&router)

	http.route_get(&router, "/", http.handler(index))

	routed := http.router_handler(&router)

	log.infof("Listening on http://0.0.0.0:%d", PORT)

	// err := http.listen_and_serve(&s, routed, net.Endpoint{address = net.IP4_Any, port = PORT})
	// fmt.assertf(err == nil, "server stopped with error: %v", err)

	err := http.listen_and_serve(&s, routed, net.Endpoint{
      address = net.IP4_Any,
      port = PORT,
    })

    if err != nil {
        fmt.println("Server error:", err)
        os.exit(1)
	}
}

index :: proc(req: ^http.Request, res: ^http.Response) {
	http.respond_file(res, "templates/index.html")
}
