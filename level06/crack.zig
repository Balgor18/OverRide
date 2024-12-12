const std = @import("std");

fn readLine(reader: std.fs.File, buf: []u8) ![]const u8 {
    const len = try reader.read(buf);
    if (len == buf.len) {
        return error.InputTooLarge;
    }
    return std.mem.trim(u8, buf[0..len], "\r\n ");
}

fn crack_code(input: []const u8) u32 {
    std.debug.assert(input.len >= 6 and input.len <= 32);

    var acc = (@as(u32, input[3]) ^ 0x1337) +% 0x5eeded;

    for (input) |c| {
        if (c < ' ') {
            return std.math.maxInt(u32);
        }
        acc +%= (@as(u32, c) ^ acc) % 0x539;
    }
    return acc;
}

pub fn main() !void {
    const stdout = std.io.getStdOut();
    const stdin = std.io.getStdIn();

    try stdout.writeAll("Enter account name: ");
    var buf: [32]u8 = undefined;
    const input = try readLine(stdin, &buf);

    const result = crack_code(input);
    try stdout.writer().print("Result: {}\n", .{result});
}
