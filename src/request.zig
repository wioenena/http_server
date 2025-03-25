const HTTPMethod = @import("method.zig").HTTPMethod;
const HTTPVersion = @import("version.zig").HTTPVersion;

pub const Request = struct { method: HTTPMethod, version: HTTPVersion };
