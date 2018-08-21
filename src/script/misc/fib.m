// fibonacci

// recurse
fib0(n) {
    guard(n < 2, n, { fib0(n - 1) + fib0(n - 2) })
};

// iterate
fib1(n) {
    cyclen((0, 1), n, { (_.1, _.0 + _.1) }).0
};

n = 25;

print(fib0(n), fib1(n));
