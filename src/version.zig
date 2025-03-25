const std = @import("std");

pub const HTTPVersionError = error{
    InvalidVersion,
};

pub const HTTPVersion = enum {
    HTTP_1_0,
    HTTP_2_0,

    pub fn toString(self: HTTPVersion) []const u8 {
        return switch (self) {
            HTTPVersion.HTTP_1_0 => "HTTP/1.0",
            HTTPVersion.HTTP_2_0 => "HTTP/2.0",
        };
    }

    pub fn fromString(version: []const u8) HTTPVersionError!HTTPVersion {
        if (std.mem.eql(u8, version, "HTTP/1.0")) {
            return HTTPVersion.HTTP_1_0;
        } else if (std.mem.eql(u8, version, "HTTP/2.0")) {
            return HTTPVersion.HTTP_2_0;
        } else {
            return error.InvalidVersion;
        }
    }
};

test "HTTPVersion toString" {
    try std.testing.expect(std.mem.eql(u8, HTTPVersion.HTTP_1_0.toString(), "HTTP/1.0"));
    try std.testing.expect(std.mem.eql(u8, HTTPVersion.HTTP_2_0.toString(), "HTTP/2.0"));
}

test "HTTPVersion fromString" {
    try std.testing.expect(try HTTPVersion.fromString("HTTP/1.0") == HTTPVersion.HTTP_1_0);
    try std.testing.expect(try HTTPVersion.fromString("HTTP/2.0") == HTTPVersion.HTTP_2_0);
    try std.testing.expect(HTTPVersion.fromString("UNEXPECTED") == HTTPVersionError.InvalidVersion);
}
