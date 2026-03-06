// swift-vapor/Sources/App/main.swift

import Vapor
import Elementary

let app = Application(.production)

app.get("/") { req async -> Response in

    let page = html {
        head {
            title { "Howdy from Swift Vapor" }
            meta(.charset(.utf8))
        }
        body {
            h1 { "Howdy, World!" }
        }
    }

    return Response(
        status: .ok,
        headers: ["Content-Type": "text/html"],
        body: .init(string: page.render())
    )
}

try app.run()
