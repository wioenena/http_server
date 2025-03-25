const std = @import("std");
const Server = @import("server.zig").Server;
const Request = @import("request.zig").Request;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var server = try Server.init(std.net.Address.initIp4([_]u8{ 127, 0, 0, 1 }, 3000), allocator, &handlerFn);

    try server.listen();
}

fn handlerFn(request: Request, stream: std.net.Stream) anyerror!void {
    const writer = stream.writer();
    std.debug.print("Request in handler fn\n", .{});
    request.print();

    // const version = request.version.toString();
    try std.fmt.format(writer, "{s} {} {s}\r\n", .{ request.version.toString(), 404, "Cannot access!!!!" });
    _ = try writer.write("\r\n");
    stream.close();
}
