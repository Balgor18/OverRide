const c = @cImport({
    @cInclude("stdio.h");
});

extern "c" fn puts(c: [*c]const u8) void;
extern "c" fn strncmp(a: [*c]const u8, b: [*c]const u8, n: usize) i32;
extern "c" fn scanf(c: [*c]const u8, ...) void;

var username: [256]u8 = undefined;

fn verify_user_name() i32 {
    puts("verifying username...");
    return strncmp(@ptrCast(&username), "dat_wil", 7);
}

fn verify_user_pass(pass: [*c]u8) i32 {
    return strncmp(pass, "admin", 5);
}

pub fn main() void {
    @setRuntimeSafety(false);

    puts("********* ADMIN LOGIN PROMPT *********");
    puts("Enter Username: ");
    scanf("%s", &username);

    if (verify_user_name() != 0) {
        puts("nope, incorrect username...");
        return;
    }

    puts("Enter Password: ");

    var password: [64]u8 = undefined;
    scanf("%s", &password);

    _ = verify_user_pass(@ptrCast(&password));
    puts("nope, incorrect password...");
    return;
}
