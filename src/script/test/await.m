
import unittest;

// test multiple threads waiting on a single box

test(n)
{
    b = box(-1);
    ntasks = box(0);

    for(count(n), { i ->
        spawn {
            await(b, {
                when(*b == -1, { ntasks <- inc });
                _ == i });
            ntasks <- dec;
        }
    });

    await(ntasks, { _ == n });

    for(count(n), { b := _ });

    timeout = box(false);
    spawn { sleep(10000); timeout := true };

    awaits((timeout, ntasks), (id, { _ == 0 }));

    when(*ntasks != 0, {
        print("*** DROPPED TASKS: ", *ntasks, "***")
    });

    (*ntasks == 0, *ntasks)
};

runs = count(100) | { print("test", _); test(100) };

(oks, drops) = unzip(runs);
print("total bad runs, total dropped tasks:", (size(filter(oks, not)), sum(drops)));
assert_equals({ 0 }, { sum(drops) });
