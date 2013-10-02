
// parallelizing fetches over a tree-shaped structure

// page definition is a top-level array of string-returning
// functions, and an array of sub-pages
//
type Page = (top: [() -> String], subs: [Page]);

// page data is a top-level array of strings,
// and an array of sub-Datas
//
type Data = (top: [String], subs: [Data]);

// dispatch simulator. runs function after delay,
// bracketed with start/end messages
//
dispatch(f) {
    print(taskid(), ">", f);
    sleep(rand(1000));
    v = f();
    print(taskid(), "<", f);
    v
};

// synchronous fetch: dispatch the fetchers one after the
// other in a single thread
//
sfetch(p : Page) -> Data {
    (top: p.top | dispatch, subs: p.subs | sfetch)
};

// asynchronous fetch: in a single top-level thread,
// initiate an asynchronous callback for each fetcher.
// on completion, build page from fetched data
//
afetch(p : Page) -> Data {

    tasks = box(0);
    fetched = box([:]);

    fsub(p : Page) {
        tasks <- { $0 + size(p.top) };
        p.top | { f =>
            async({ dispatch(f) }, { d =>
                fetched <- { mapset($0, f, d) };
                tasks <- dec
            })
        };
        p.subs | fsub;
        ()
    };

    fsub(p);
    await(tasks, { $0 == 0 });

    build(p : Page) -> Data {
        (top: maplm(p.top, *fetched), subs: p.subs | build)
    };

    build(p)
};

// multitask fetch: dispatch fetches in explicitly
// parallel tasks.
//
mfetch(p : Page) -> Data {
    top = future { p.top |: dispatch };
    subs = future { p.subs |: mfetch };
    (top: top(), subs: subs())
};

// test page
testpage : Page = (
    top: [
        { "top1" },
        { "top2" },
        { "top3" } ],
    subs: [
        (top: [{ "sub1.1" }, { "sub1.2" }], subs: []),
        (top: [{ "sub2.1" }, { "sub2.2" }], subs: []),
        (top: [{ "sub3.1" }, { "sub3.2" }], subs: [
            (top: [{ "sub3.1.1" }, { "sub3.1.2" }], subs: []),
            (top: [{ "sub3.2.1" }, { "sub3.2.2" }], subs: [])])]
);

// test
printstr("SYNC");
print(sfetch(testpage));

print("ASYNC");
print(afetch(testpage));

print("MULTI");
print(mfetch(testpage));