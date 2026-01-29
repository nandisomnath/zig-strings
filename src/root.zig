//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.

const strings = @import("strings.zig");

// exposed types and functions
pub const String = strings.String;

// TODO: adding a sorting function to string library which sort strings
// See:  https://github.com/lifthrasiir/rust-natord

test {
    _ = strings;
}
