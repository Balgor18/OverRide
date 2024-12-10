const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
});

pub fn main() void {
    @setRuntimeSafety(false);

    _ = c.puts(
        \\***********************************
        \\*            -Level00 -           *
        \\***********************************
    );
    c.puts("Password: ");

    var password: u32 = undefined;
    _ = c.scanf("%u", &password);

    if (password != 5276) {
        _ = c.puts("Invalid Password!");
    } else {
        _ = c.puts("Authenticated!");
        _ = c.system("/bin/sh");
    }
}
