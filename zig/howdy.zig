const std = @import("std");

pub fn main() !void {
    const address = try std.net.Address.parseIp("127.0.0.1", 3000);

    var server = try address.listen(.{ .reuse_address = true });
    defer server.deinit();

    while (true) {
        var conn = try server.accept();
        defer conn.stream.close();

        try conn.stream.writeAll(
            "HTTP/1.1 200 OK\r\n" ++
            "Content-Type: text/plain\r\n" ++
            "Content-Length: 13\r\n" ++
            "\r\n" ++
            "Howdy, World!",
        );
    }
}

