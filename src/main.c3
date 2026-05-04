import std::io;

fn int main() {
    int? n_opt = io::treadline().to_int();

    if (catch err = n_opt) {
        io::eprintn("Invalid number");
        return 1;
    }

    int n = n_opt; // auto-unwrapped after catch

    while (n != 1) {
        n = (n % 2 == 0) ? n / 2 : n * 3 + 1;
        io::printf("%d ", n);
    }

    io::printn();
    return 0;
}