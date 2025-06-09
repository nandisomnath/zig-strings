const std = @import("std");


pub const String = struct {

    data: []u8,
    const Self = @This();


    pub fn new(data: []const u8) Self {
        return .{
            .data = data
        };
    }


    /// Trim all the values from the string.
    /// Trim the value from left and also right.
    pub fn trim(self: *Self, values_to_strip: []const u8) void {
        self.data = std.mem.trim(u8, self.data, values_to_strip);
    }

    /// Trim all the whitespace chars like ' ', '\n', '\t', etc.
    pub fn trimAllWhiteSpace(self: *Self) void {
       self.data = std.mem.trim(u8, self.data, std.ascii.whitespace);
    }


    /// Split and gives a SplitIterator for now it is use the split function from std library.
    /// TODO: write own spilt and gives the strings array representation of that
    pub fn split(self: *Self, delimiter: []const u8) std.mem.SplitIterator(u8, .sequence) {
        return std.mem.splitSequence(u8, self.data, delimiter);
    }


    /// checks if it is equal or not
    pub fn equal(self: *Self, other: String) bool {
        return std.mem.eql(u8, self.data, other.data);
    }

    

};