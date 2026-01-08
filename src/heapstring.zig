const String = @import("root").String;
const std = @import("std");


/// HeapString is a special type of string which handles the data using allocator.
/// This is the actual growable string. it grows with the size of value.
pub const HeapString = struct {
    buffer: []u8,
    length: usize,
    max_size: usize,
    allocator: std.mem.Allocator,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, data: []const u8) HeapString {
        const buffer = try allocator.alloc(u8, data.len);
        std.mem.copyForwards(u8, buffer, data);
    }

    pub fn new(allocator: std.mem.Allocator) HeapString {
        return .{
            .buffer = undefined,
            .length = 0,
            .max_size = 0,
            .allocator = allocator
        };
    }


    pub fn push(self: *Self, buffer: []u8) void {
        if (self.max_size - self.length > 0) {
            // add to the buffer
        } else {
            // create extra space and then add to the buffer
        }
    }
    

    pub fn deinit(self: *Self) void {
        self.allocator.free(self.buffer);
    }
};
