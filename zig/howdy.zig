// zig/howdy.zig

const std = @import("std");

const html =
    \\<!doctype html>
    \\<html lang="en">
    \\  <head>
    \\    <meta charset="utf-8" />
    \\    <meta name="viewport" content="width=device-width, initial-scale=1" />
    \\    <title>Howdy from Zig</title>
    \\  </head>
    \\  <body>
    \\    <h1>Howdy, World!</h1>
    \\  </body>
    \\</html>
;

pub fn main() !void {
    const address = try std.net.Address.parseIp("0.0.0.0", 3000);

    var server = try address.listen(.{ .reuse_address = true });
    defer server.deinit();

    while (true) {
        var conn = try server.accept();
        defer conn.stream.close();

        const response = std.fmt.comptimePrint(
            "HTTP/1.1 200 OK\r\n" ++
            "Content-Type: text/html; charset=utf-8\r\n" ++
            "Content-Length: {d}\r\n" ++
            "Connection: close\r\n" ++
            "\r\n" ++
            "{s}",
            .{ html.len, html },
        );

        try conn.stream.writeAll(response);
    }
}
