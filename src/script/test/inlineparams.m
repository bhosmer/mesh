
import unittest;

// inline param syntax
//
// Every function's param is named _
// Members of tuple params are addressable with e.g. _.0, _.1
// Members of record params are addressable with e.g. _.f, _.g

// simple cases

a = { _ };
assert_equals({ 0 }, { a(0) });

b = { [_.0, _.1] };
assert_equals({ [0, 1] }, { b(0, 1) });

// twisted
c = { [_.1, _.0] };
assert_equals({ [0, 1] }, { c(1, 0) });

// gap
d = { [_.0, _.2] };
assert_equals({ [0, 1] }, { d(0, "hey", 1) });

