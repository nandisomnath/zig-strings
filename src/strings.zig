const std = @import("std");

pub const String = struct {
    data: []const u8,
    const Self = @This();

    pub fn new(data: []const u8) Self {
        return .{ .data = data };
    }

    /// Trim all the values from the string.
    /// Trim the value from left and also right.
    pub fn trim(self: *Self, values_to_strip: []const u8) String {
        const data = std.mem.trim(u8, self.data, values_to_strip);
        return String.new(data);
    }

    /// Trim all the whitespace chars like ' ', '\n', '\t', etc.
    pub fn trimAllWhiteSpace(self: *Self) String {
        const data = std.mem.trim(u8, self.data, &std.ascii.whitespace);
        return String.new(data);
    }

    /// Split and gives a SplitIterator for now it is use the split function from std library.
    /// TODO: write own spilt and gives the strings array representation of that
    pub fn split(self: *Self, delimiter: []const u8) std.mem.SplitIterator(u8, .sequence) {
        return std.mem.splitSequence(u8, self.data, delimiter);
    }

    /// checks if it is equal or not
    pub fn equal(self: *const Self, other: String) bool {
        return std.mem.eql(u8, self.data, other.data);
    }


    pub fn equalBuffer(self: *const Self, buffer: []const u8) bool {
        return std.mem.eql(u8, self.data, buffer);
    }

    /// returns the length of the string
    pub fn len(self: *Self) usize {
        return self.data.len;
    }

    /// Returns a u8 from string at that index.
    /// if i >= len() then returns null
    pub fn at(self: *Self, i: usize) ?u8 {
        if (self.data.len > i) {
            return self.data[i];
        }
        return null;
    }

    /// Concat two strings together and gives and new string.
    /// This function is not well optimized and uses the stack.
    pub fn concat(self: *Self, other: *Self) String {
        const length = self.data.len + other.data.len;
        var buffer: [length]u8 = undefined;

        var i: usize = 0;

        for (self.data) |v| {
            buffer[i] = v;
            i += 1;
        }

        for (other.data) |v| {
            buffer[i] = v;
            i += 1;
        }
    }

    /// returns true if string len is 0 otherwise it is false
    pub fn isEmpty(self: *Self) bool {
        if (self.data.len == 0) {
            return true;
        }
        return false;
    }
};

const testing = std.testing;

test "strings creation" {
    // const v = ;
    var s = String.new("hello");
    try testing.expectEqual(5, s.len());
}


test "strings length function" {
    var s1 = String.new("");
    var s2 = String.new(&[_]u8{});
    var s3 = String.new("Hello");

    try testing.expectEqual(0, s1.len());
    try testing.expectEqual(0, s2.len());
    try testing.expectEqual(5, s3.len());
}



test "strings trim functions" {
    var s1 = String.new("");
    var s2 = String.new("Hello ");
    var s3 = String.new("\they\t\n");

    // std.debug.print("{s}\n", .{s3.trimAllWhiteSpace().data});
    
    try testing.expect(s1.trim(" ").equal(String.new("")));
    try testing.expect(s2.trim(" ").equal(String.new("Hello")));
    try testing.expect(s3.trimAllWhiteSpace().equal(String.new("hey")));

    try testing.expect(s1.trim(" ").equalBuffer(""));
    try testing.expect(s2.trim(" ").equalBuffer("Hello"));
    try testing.expect(s3.trimAllWhiteSpace().equalBuffer("hey"));

}
