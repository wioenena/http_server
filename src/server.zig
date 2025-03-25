const std = @import("std");
const Request = @import("request.zig").Request;
const HTTPMethod = @import("method.zig").HTTPMethod;
const HTTPVersion = @import("version.zig").HTTPVersion;

const ParsingState = enum {
    RequestLine,
    Headers,
    Body,
};

const HandlerFn = *const fn (Request, std.net.Stream) anyerror!void;

pub const Server = struct {
    addr: std.net.Address,
    listener: ?std.net.Server,
    allocator: std.mem.Allocator,
    parsingState: ParsingState = .RequestLine,
    handlerFn: HandlerFn,

    pub fn init(addr: std.net.Address, allocator: std.mem.Allocator, handlerFn: HandlerFn) !Server {
        return .{
            .addr = addr,
            .listener = null,
            .allocator = allocator,
            .handlerFn = handlerFn,
        };
    }

    pub fn listen(self: *Server) !void {
        self.listener = try self.addr.listen(.{});
        std.debug.print("Server running on: {any}\n", .{self.addr});
        while (true) {
            var conn = try self.listener.?.accept();
            try self.handleConnection(&conn);
        }
    }

    fn handleConnection(self: *Server, conn: *std.net.Server.Connection) !void {
        const reader = conn.stream.reader();
        var request: ?Request = null;
        while (true) {
            if (self.parsingState == .Body) {
                const content_length = request.?.headers.get("Content-Length");
                if (content_length == null) {
                    break;
                }
                const length = try std.fmt.parseInt(usize, content_length.?, 10);
                const buf = try self.allocator.alloc(u8, length);
                _ = try reader.read(buf);

                request.?.body = buf;
                break;
            }
            const line = try reader.readUntilDelimiterAlloc(self.allocator, '\n', std.math.maxInt(usize));

            // request
            if (self.parsingState == .RequestLine) {
                var first_line_iterator = std.mem.splitSequence(u8, line, " ");
                const method = first_line_iterator.next().?;
                const uri = first_line_iterator.next().?;
                const version = std.mem.trim(u8, first_line_iterator.next().?, "\r");
                request = Request.init(try HTTPMethod.fromString(method), try HTTPVersion.fromString(version), uri, std.StringHashMap([]const u8).init(self.allocator), null);
                self.parsingState = .Headers;
            } else if (self.parsingState == .Headers) {
                if (line[0] == '\r') {
                    self.parsingState = .Body;
                    continue;
                }
                var header_iterator = std.mem.splitSequence(u8, line, ":");
                const key = std.mem.trim(u8, header_iterator.next().?, " ");
                const value = std.mem.trim(u8, std.mem.trim(u8, header_iterator.next().?, " "), "\r");
                try request.?.headers.put(key, value);
            }
        }

        try self.handlerFn(request.?, conn.stream);
    }
};
