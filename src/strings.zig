const std = @import("std");

pub const String = struct {
    data: []const u8,
    alloc: std.mem.Allocator,

    const Self = @This();

    pub fn new(alloc: std.mem.Allocator, data: []const u8) Self {
        const value = alloc.alloc(u8, data.len) catch @panic("unable to create string");
        @memmove(value, data);
        return .{
            .data = value,
            .alloc = alloc,
        };
    }

    pub fn deinit(self: *Self) void {
        self.alloc.free(self.data);
    }

    /// Trim all the values from the string.
    /// Trim the value from left and also right.
    pub fn trim(self: *Self, values_to_strip: []const u8) void {
        const data = std.mem.trim(u8, self.data, values_to_strip);
        self.data = data;
    }

    /// Trim all the whitespace chars like ' ', '\n', '\t', etc.
    pub fn trimAllWhiteSpace(self: *Self) void {
        const data = std.mem.trim(u8, self.data, &std.ascii.whitespace);
        self.data = data;
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
    /// You have to give a buffer for the storage and that have to a stack buffer.
    /// This function is in testing.
    pub fn concat(self: *Self, other: String) void {
        const value = std.mem.concat(self.alloc, u8, &[_][]const u8{ self.data, other.data }) catch "";
        self.data = value;
    }

    pub fn append(self: *Self, str: []const u8) void {
        self.concat(String.new(self.alloc, str));
    }

    /// returns true if string len is 0 otherwise it is false
    pub fn isEmpty(self: *Self) bool {
        if (self.len() == 0) {
            return true;
        }
        return false;
    }

    /// Returns the index within this string of the first occurrence of the specified character.
    /// the index of the first occurrence of the character
    /// in the character sequence represented by this object,
    /// or -1 if the character does not occur.
    pub fn index(self: *Self, ch: u8) usize {
        for (self.data, 0..) |value, i| {
            if (value == ch) {
                return i;
            }
        }
        return -1;
    }

    /// Returns a string that is a substring of this string. 
    /// The substring begins at the specified beginIndex and extends
    /// to the character at index endIndex - 1. Thus the length of the
    /// substring is endIndex-beginIndex.
    /// beginIndex - the beginning index, inclusive.
    /// endIndex - the ending index, exclusive.
    pub fn substr(self: *Self, begin: usize, end: usize) Self {
        const n = end - begin;
        const value = self.alloc.alloc(u8, n) catch @panic("substr");
        @memmove(value[0..], self.data[begin..end]);
        return Self.new(self.alloc, value);
    }

    /// returns the string data.
    /// The zig native string.
    pub fn toString(self: *Self) []const u8 {
        return self.data;
    }
};

const testing = std.testing;
const test_alloc = std.heap.page_allocator;

test "strings creation" {
    // const v = ;
    var s = String.new(test_alloc, "hello");
    try testing.expectEqual(5, s.len());
}

test "strings length function" {
    var s1 = String.new(test_alloc, "");
    var s2 = String.new(test_alloc, &[_]u8{});
    var s3 = String.new(test_alloc, "Hello");

    try testing.expectEqual(0, s1.len());
    try testing.expectEqual(0, s2.len());
    try testing.expectEqual(5, s3.len());
}

test "strings trim functions" {
    var s1 = String.new(test_alloc, "");
    var s2 = String.new(test_alloc, "Hello ");
    var s3 = String.new(test_alloc, "\they\t\n");
    s1.trim(" ");
    s2.trim(" ");
    s3.trimAllWhiteSpace();
    // std.debug.print("{s}\n", .{s3.trimAllWhiteSpace().data});

    try testing.expect(s1.equal(String.new(test_alloc, "")));
    try testing.expect(s2.equal(String.new(test_alloc, "Hello")));
    try testing.expect(s3.equal(String.new(test_alloc, "hey")));

    try testing.expect(s1.equalBuffer(""));
    try testing.expect(s2.equalBuffer("Hello"));
    try testing.expect(s3.equalBuffer("hey"));
}



test "string_concat_functions" {
    var s1 = String.new(test_alloc, "Hello");
    var s2 = String.new(test_alloc, "Hi");
    var s3 = String.new(test_alloc, "");
    defer s1.deinit();
    defer s2.deinit();
    defer s3.deinit();

    s1.concat(s2);
    s2.concat(s3);
    s3.concat(s3);
    try testing.expect(s1.equalBuffer("HelloHi"));
    try testing.expect(s2.equalBuffer("Hi"));
    try testing.expect(s3.equalBuffer(""));
}
