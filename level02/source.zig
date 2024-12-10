const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("string.h");
    @cInclude("stdlib.h");
});

const std = @import("std");

pub fn main() void {
    @setRuntimeSafety(false);

    const password_file = c.fopen("/home/users/level03/.pass", "r");
    if (password_file == null) {
        _ = c.puts("ERROR: failed to open password file");
        c.exit(1);
    }

    var password: [48]u8 = undefined;
    var password_len = c.fread(&password, 1, 41, password_file);
    const og_password_len = password_len;
    password_len = @intFromPtr(c.memchr(&password, '\n', og_password_len)) - @intFromPtr(&password);
    password[password_len] = 0;

    if (og_password_len != 41) {
        _ = c.puts("ERROR: failed to read password file");
        _ = c.puts("ERROR: failed to read password file");
        c.exit(1);
    }
    _ = c.fclose(password_file);

    _ = c.puts(
        \\===== [ Secure Access System v1.0 ] =====
        \\/***************************************\
        \\| You must login to access this system. |
        \\\***************************************/
    );

    _ = c.puts("--[ Username: ");
    var username: [100]u8 = undefined;
    _ = c.fgets(&username, 100, c.stdin());
    const username_len = @intFromPtr(c.memchr(&username, '\n', username.len)) - @intFromPtr(&username);
    username[username_len] = 0;

    _ = c.puts("--[ Password: ");
    var user_password: [100]u8 = undefined;
    _ = c.fgets(&user_password, 100, c.stdin());
    const user_password_len = @intFromPtr(c.memchr(&user_password, '\n', user_password.len)) - @intFromPtr(&user_password);
    user_password[user_password_len] = 0;

    _ = c.puts("*****************************************");

    if (c.strncmp(&user_password, &password, 41) == 0) {
        _ = c.printf("Greetings, %s!\n", &username);
        _ = c.system("/bin/sh");
        return;
    }

    _ = c.printf(@ptrCast(&username));
    _ = c.puts(" does not have access!");

    c.exit(1);
}
