const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("string.h");
});

var username: [256]u8 = undefined;

fn verify_user_name() i32 {
    _ = c.puts("verifying username...");
    return c.strncmp(@ptrCast(&username), "dat_wil", 7);
}

fn verify_user_pass(pass: [*c]u8) i32 {
    return c.strncmp(pass, "admin", 5);
}

pub fn main() void {
    @setRuntimeSafety(false);

    _ = c.puts("********* ADMIN LOGIN PROMPT *********");
    _ = c.puts("Enter Username: ");
    _ = c.scanf("%s", &username);

    if (verify_user_name() != 0) {
        _ = c.puts("nope, incorrect username...");
        return;
    }

    _ = c.puts("Enter Password: ");

    var password: [64]u8 = undefined;
    _ = c.scanf("%s", &password);

    _ = verify_user_pass(@ptrCast(&password));
    _ = c.puts("nope, incorrect password...");
    return;
}
