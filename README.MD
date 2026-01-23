## Zig-Strings : A library for zig to work with strings more better way.

This is a library to make string handle easier in zig programming language.
it uses std library for making most of it's api.
Some api is experimental.
  


## Features

- It gives api for handling strings in easier way in zig
- Strings are handled using external allocator.
- Use most of well known std library functions for the string api.

## Installation

1. Use below command to add this library in your project.
This is the latest available version you can use any of the working version you want.

```zsh
zig fetch --save https://github.com/nandisomnath/zig-strings/archive/refs/tags/v0.1.0.tar.gz 
```

1. Use below command to build.zig
   

```zig

const exe = b.addExecutable(.{
    .name = "my_app",
    .root_source_file = .{ .path = "src/main.zig" },
    .target = target,
    .optimize = optimize,
});

// 👇 Add the dependency
const strings_dep = b.dependency("strings", .{});
exe.root_module.addImport("strings", strings_dep.module("strings"));
```

## Contrib

- Create a issue.
- Create a pull request.

Everyone is welcome to contribute.



