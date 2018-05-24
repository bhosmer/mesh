
/**

codemod | to @
codemod # to `

type annos in regular language

No assoc. Variant is just Struct over 1 k/v pair

zip infix op (other APIs)

collection API, no throws

spontaneous type/key collapse

named arguments?

template strings


type cond = { K, V, R | Fun(+Struct([`sel: +Struct(K $ V), cases: -Struct(K $ (Fun @ V $ R))]), +Struct(K $ R)) };


CustRec = (first: String, last: String, age: Int);
Option<T> = (true: T, false: ())


CustRec = (rec: [first: String, last: String, age: Int]);

Option = { T | (rec: [true: T, false: ()]) }




intrinsic cond(sels: Struct(KSel $ VSel)), cases: Rec(Assoc(KCase, Fun @ zip(VCase, RCase)))) -> Rec(Assoc(;

----

    $ for zip
    | -> @
    # -> ``
    func sep. either -> or |
dependent application

fix the bug (drilling through type vars)
run cond
then decide about variants. If not:
will need subtyping, +/- e.g. in cond sig.
no variant syntax
(x: y) will be represented as a record type, cond will have to be rewritten
...and then we'll need to decide about convergent R types and tag stripping
...hope would be you could strip unconditionally if Rs are the same, and then
use an isomorphism rule to send a scalar into any -struct. But no, only if
types were unique. Maybe the best thing to do is do it without stripping
and see how cumbersome that is.

intrinsic <K, K2 | K, V:[*], R:[*]> cond(
  sel : Rec(Assoc(K, V)),
  cases : Rec(Assoc(K2, Fun @ (V $ R)))
) -> Rec(Assoc(K, R));

cases = (x: { "I'm a string: " + _ }, y: { "I'm an int" + tostr(_) });

sel = x ! "hey";
//sel2 = (x: "hey");

sel ? cases

**/


intrinsic <K, K2 | K, V:[*], R> cond(
  sel : Var(Assoc(K, V)),
  cases : Rec(Assoc(K2, Cone(V, R)))
) -> R;

cases = (x: { "I'm a string: " + _ }, y: { "I'm an int" + tostr(_) });

sel = x ! "hey";
//sel2 = (x: "hey");

sel ? cases