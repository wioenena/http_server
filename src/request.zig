const std = @import("std");
const HTTPMethod = @import("method.zig").HTTPMethod;
const HTTPVersion = @import("version.zig").HTTPVersion;

pub const Request = struct {
    method: HTTPMethod,
    version: HTTPVersion,
    uri: []const u8,
    headers: std.StringHashMap([]const u8),
    body: ?[]const u8,

    pub fn init(method: HTTPMethod, version: HTTPVersion, uri: []const u8, headers: std.StringHashMap([]const u8), body: ?[]const u8) Request {
        return .{
            .method = method,
            .version = version,
            .uri = uri,
            .headers = headers,
            .body = body,
        };
    }

    pub fn print(self: *const Request) void {
        std.debug.print("Request: {s} {s} {s}\n", .{ self.method.toString(), self.version.toString(), self.uri });

        var header_iterator = self.headers.iterator();
        while (header_iterator.next()) |header_key_val| {
            std.debug.print("Header: {s}: {s}\n", .{ header_key_val.key_ptr.*, header_key_val.value_ptr.* });
        }

        if (self.body != null) {
            std.debug.print("Body: {s}\n", .{self.body.?});
        }
    }
};
