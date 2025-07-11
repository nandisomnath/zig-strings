const String = @import("root").String;
const std = @import("std");

pub const HeapString = struct {
    buffer: []u8,
    allocator: std.mem.Allocator,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, data: []const u8) HeapString {
        var buffer = try allocator.alloc(u8, data.len);
        std.mem.copyForwards(u8, buffer, data);
    }

    pub fn deinit(self: *Self) void {
        self.allocator.free(self.buffer);
    }
};
