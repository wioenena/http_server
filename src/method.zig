const std = @import("std");

pub const HTTPMethodError = error{InvalidMethod};

pub const HTTPMethod = enum {
    GET,
    HEAD,
    POST,
    PUT,
    DELETE,
    CONNECT,
    OPTIONS,
    TRACE,
    PATCH,

    pub fn isBodyAllowedForRequestMethod(self: HTTPMethod) bool {
        return switch (self) {
            HTTPMethod.GET => true,
            HTTPMethod.HEAD => true,
            HTTPMethod.POST => true,
            HTTPMethod.PUT => true,
            HTTPMethod.DELETE => true,
            HTTPMethod.CONNECT => true,
            HTTPMethod.OPTIONS => true,
            HTTPMethod.TRACE => false,
            HTTPMethod.PATCH => true,
        };
    }

    pub fn isBodyAllowedForResponseMethod(self: HTTPMethod) bool {
        return switch (self) {
            HTTPMethod.GET => true,
            HTTPMethod.HEAD => false,
            HTTPMethod.POST => true,
            HTTPMethod.PUT => true,
            HTTPMethod.DELETE => true,
            HTTPMethod.CONNECT => true,
            HTTPMethod.OPTIONS => true,
            HTTPMethod.TRACE => true,
            HTTPMethod.PATCH => true,
        };
    }

    pub fn format(
        self: HTTPMethod,
        comptime fmt: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        if (fmt.len == 0) {
            std.fmt.invalidFmtError(fmt, self);
        }

        return writer.print("{s}", .{self.toString()});
    }

    pub fn toString(self: HTTPMethod) []const u8 {
        return switch (self) {
            HTTPMethod.GET => "GET",
            HTTPMethod.HEAD => "HEAD",
            HTTPMethod.POST => "POST",
            HTTPMethod.PUT => "PUT",
            HTTPMethod.DELETE => "DELETE",
            HTTPMethod.CONNECT => "CONNECT",
            HTTPMethod.OPTIONS => "OPTIONS",
            HTTPMethod.TRACE => "TRACE",
            HTTPMethod.PATCH => "PATCH",
        };
    }

    pub fn fromString(method: []const u8) HTTPMethodError!HTTPMethod {
        if (std.mem.eql(u8, method, "GET")) {
            return HTTPMethod.GET;
        } else if (std.mem.eql(u8, method, "GET")) {
            return HTTPMethod.GET;
        } else if (std.mem.eql(u8, method, "GET")) {
            return HTTPMethod.GET;
        } else if (std.mem.eql(u8, method, "GET")) {
            return HTTPMethod.GET;
        } else if (std.mem.eql(u8, method, "GET")) {
            return HTTPMethod.GET;
        } else if (std.mem.eql(u8, method, "GET")) {
            return HTTPMethod.GET;
        } else if (std.mem.eql(u8, method, "GET")) {
            return HTTPMethod.GET;
        } else if (std.mem.eql(u8, method, "GET")) {
            return HTTPMethod.GET;
        } else if (std.mem.eql(u8, method, "GET")) {
            return HTTPMethod.GET;
        } else {
            return error.InvalidMethod;
        }
    }
};

test "isBodyAllowedForRequestMethod" {
    try std.testing.expect(HTTPMethod.GET.isBodyAllowedForRequestMethod() == true);
    try std.testing.expect(HTTPMethod.TRACE.isBodyAllowedForRequestMethod() == false);
}

test "isBodyAllowedForResponseMethod" {
    try std.testing.expect(HTTPMethod.GET.isBodyAllowedForResponseMethod() == true);
    try std.testing.expect(HTTPMethod.HEAD.isBodyAllowedForResponseMethod() == false);
}

test "fromString" {
    try std.testing.expect(try HTTPMethod.fromString("GET") == HTTPMethod.GET);
    try std.testing.expect(HTTPMethod.fromString("UNEXPECTED") == HTTPMethodError.InvalidMethod);
}
