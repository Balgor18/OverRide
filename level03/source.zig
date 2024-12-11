const c = @cImport(@cInclude("stdlib.h"));
const std = @import("std");

fn readLine(file: std.fs.File) !u32 {
    while (true) {
        var buf: [32]u8 = undefined;
        const len = try file.read(&buf);
        if (len == buf.len) {
            continue;
        }
        const line = std.mem.trim(u8, buf[0..len], "\r\n ");
        const val = std.fmt.parseUnsigned(u32, line, 10) catch continue;
        return val;
    }
}

fn decrypt(key: u8, cyphertext: []u8) void {
    for (cyphertext) |*byte| {
        byte.* = byte.* ^ key;
    }
}

fn testKey(key: u8) bool {
    var cyphertext = [_]u8{ 0x51, 0x7d, 0x7c, 0x75, 0x60, 0x73, 0x66, 0x67, 0x7e, 0x73, 0x66, 0x7b, 0x7d, 0x7c, 0x61, 0x33 };

    if (key <= 0x9 or (key >= 0x10 and key <= 0x15)) {
        decrypt(key, &cyphertext);
    } else {
        const newKey = std.crypto.random.int(u8);
        decrypt(newKey, &cyphertext);
    }

    return std.mem.eql(u8, &cyphertext, "Congratulations!");
}

pub fn main() anyerror!void {
    const stdout = std.io.getStdOut();
    const stdin = std.io.getStdIn();

    try stdout.writeAll(
        \\***********************************
        \\*            level03             **
        \\***********************************
        \\
    );
    try stdout.writeAll("Password: ");
    const password = try readLine(stdin);

    const key = 0x1337d00d -% password;
    if (testKey(@truncate(key))) {
        _ = c.system("/bin/sh");
    } else {
        try stdout.writeAll("Invalid Password\n");
    }
}
