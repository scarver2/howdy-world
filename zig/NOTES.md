# Zig Notes

## StreamServer variant

```zig
// zig-hyperdrive/main.zig

const std = @import("std");

pub fn main() !void {
    var server = std.net.StreamServer.init(.{});
    defer server.deinit();

    try server.listen(.{ .port = 8080 });

    std.debug.print("🤠 Zig Hyperdrive listening on 8080\n", .{});

    while (true) {
        var conn = try server.accept();
        defer conn.stream.close();

        const response =
            "HTTP/1.1 200 OK\r\n" ++
            "Content-Type: text/html\r\n" ++
            "Connection: close\r\n\r\n" ++
            "<!DOCTYPE html>" ++
            "<html>" ++
            "<head><title>Zig Hyperdrive</title></head>" ++
            "<body>" ++
            "<h1>🤠 Howdy World!</h1>" ++
            "<p>Served at warp speed by Zig</p>" ++
            "</body>" ++
            "</html>";

        _ = try conn.stream.write(response);
    }
}
```
