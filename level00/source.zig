const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
});

pub fn main() void {
    @setRuntimeSafety(false);

    c.puts(
        \\***********************************
        \\*            -Level00 -           *
        \\***********************************
    );
    c.puts("Password: ");

    var password: u32 = undefined;
    c.scanf("%u", &password);

    if (password != 5276) {
        c.puts("Invalid Password!");
    } else {
        c.puts("Authenticated!");
        c.system("/bin/sh");
    }
}
