const std = @import("std");
const libc = @cImport({
    @cInclude("stdlib.h");
    @cInclude("unistd.h");
});

fn readLine(reader: std.fs.File, buf: []u8) ![]const u8 {
    const len = try reader.read(buf);
    if (len == buf.len) {
        return error.InputTooLarge;
    }
    return std.mem.trim(u8, buf[0..len], "\r\n ");
}

fn readNumber(file: std.fs.File) !u32 {
    var buf: [64]u8 = undefined;
    const line = try readLine(file, &buf);
    if (std.mem.startsWith(u8, line, "0x")) {
        return std.fmt.parseUnsigned(u32, line[2..], 16);
    } else {
        return std.fmt.parseUnsigned(u32, line, 10);
    }
}

fn crack_code(input: []const u8) error{InvalidInput}!u32 {
    if (input.len < 6 or input.len > 32) {
        return error.InvalidInput;
    }

    var acc = (@as(u32, input[3]) ^ 0x1337) +% 0x5eeded;

    for (input) |c| {
        if (c < ' ') {
            return error.InvalidInput;
        }
        acc +%= (@as(u32, c) ^ acc) % 0x539;
    }
    return acc;
}

pub fn main() !void {
    _ = libc.alarm(60); // lol

    const stdout = std.io.getStdOut();
    const stdin = std.io.getStdIn();

    try stdout.writeAll("Enter account name: ");
    var buf: [32]u8 = undefined;
    const input = try readLine(stdin, &buf);

    try stdout.writeAll("Enter serial: ");
    const serial = try readNumber(stdin);

    const result = try crack_code(input);

    if (serial == result) {
        _ = libc.system("/bin/sh");
    }
}
