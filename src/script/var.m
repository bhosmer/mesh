
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

X fix the bug (drilling through type vars)
@ oops another bug, somebody's not unifying: (y!0) ? cases

ok the bug is, type list subsumption is doing 0-offset prefix checking (enough to guarantee tuple(list1) <= tuple(list2) correctness.
but that's more than we need for variants.
points to the bigger problem of different kinds of constraints on incoming types when things are built out of them.
and "how to work backwards"

...and there's another latent bug in the signature of cond below: there should be a V2.
question: do we want to simplify by doing away with this and going with exact types?
(where does the subsumption subtyping in tuples come from? just generated constraints?)

if no subtypes, what breaks? A: nothing much.
...I think it means we can push constraints on type params out to finished sigs, and eliminate the params if not otherwise used.
e.g. > f(x:Int) { if(x<0, { false!() }, { true!x }) }
     f(x:Int) { if(x<0, { false!() }, { true!x }) }
     > $t f
     $t f
     f : <A:(true ! Int, false ! ())> Int -> A

HEY how does using record syntax for variants affect inference?
might not work but should be ok - just do a ?(var1, var2, ...). Should be ok with multiple tags at type time, more complicated at runtime? UGH

what about inferring one arm of a variant and trying to feed it into a full signature, does ewxact typing fuck that up?
A: yes it does.
> x = #x!"HEY"
x = #x!"HEY"
> cases = (x: { "I'm a string: " + _ }, y: { "I'm an int" + tostr(_) });
cases = (x: { "I'm a string: " + _ }, y: { "I'm an int" + tostr(_) });
> x ? cases
x ? cases
ERROR /Users/bhosmer/mesh/src/script/lib/lang.m[124, 1]: type [String, t10] does not satisfy constraint [String]
ERROR <shell>[1, 1]: cannot unify actual base type <K:{#x}, V:[*]|[String], K2:K, R> (Var(Assoc(K, V)), Rec(Assoc(K2, Cone(V, R)))) -> R with target base type <A:(x ! String), B, C> (A, (x: String -> String, y: B -> String)) -> C
>

@@@
exact pros: simpler signatures, easier error messages, possibly tighter generated code
subsumption pros: fewer annoying annotation necessities, arguably more flexible code. More intuitive notion of soundness.
subsumption cons: need richer notion of constraint satisfaction - type apps can't get by just with constraints on params
@@@

ok but re record syntax for variants: NO, you can't do that because variants aren't just single-field records.
for instance, you can't project out the field value. So if you allowed that construction syntax, you'd have to
deduce the type from context.

That doesn't say what the syntax should be. Currently it's tag!value, but could be ?(tag: value) if you want. it seems clumsy though.
But so anyway, just forget it.
ok so rn records require exact unification, but variants don't. where is that decision being made?
...apparently no constraint satisfaction checks of any kind. TC tries to unify in in fun app and fails.
T is first unified with the one record then the other record. Needs Join basically. But again: how do variants get expended during unification
I'd have expected it to wind up in SubstMap.bindVar and then constraint, but no.
@@@ track from TC onward. Have no problem adding a rule that says any type with negative positions (i.e. that contracts
under union) is pinned, but need to know where that rule comes from.
Really, need to document the constrol flow in this thing. Keep having to rediscover it.
@@@

@@@
something to remember about the homegrown objects: each method takes a slot, rather than being stored in a vtable.
that's a big difference. need to either do the @@@ syntactic thing @@@ or have real objects - the bound lambdas will
be big
@@@

run cond
then decide about variants. If not:
we dshouldn't't need subtyping, but check sigs
is variant syntax worth it? probably not for constructing values, but ? op is probably still good.
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

1. code path for TC
    typechecker calls unify(), which calls Type.subst() on each and then
    Type.unify() (not sure yet why env is passed, since subst table is passed explicitly)
        lots of indirection, down to... TypeApp. base unifies w/base (basically =), args unify w/args.
          so, no difference between records and variants yet.
    it's because variants are done only through type vars, and bindvar merges constraints.
        (without heeding contravariance properly, I don't think)
    ...if you want tuples/records to do the same thing, need to bind them to type vars also.
    ...in which case will need to track whether exactness is preserved, and deparameterize them if so.
    still, should confirm: do we want record narrowing etc.? Depends also on the answer to what
    is returned by indexed application.

@@@ stopping mid-switchover from recordterm->recordtype to recordterm->tvar:recordtype
couple of bugs:
$load var does something I forget
f(x:Int) { if(x<0, {(false:())}, {(true:x)}) }
blows up trying to get the keyset from a typevar.
could just spider the typevar constraint, but looking to see how types are recovered from tvars.

Q: where are satisfy and subsume called?
TypeChecker.unify -> Type.unify -> Subst.bindVar -> Constraint.satisfy
when a var is bound to a concrete type, var's constraint must 'satisfy' (be satisfied by) type.
So: Constraint.satisfy(type) means 'verify that constraint is satisfied by type, possibly generating further substitutions'

Constraint.satisfy -> Type.subsume -> Constraint.satisfy
a.subsume(b) looks like a subtype check: if a <: b, new substmap is returned, otherwise null.
everything is equality except enum, record, tuple.

a. continue current strategy of doing recs/tups like variants (create type variable immed.)
b. go back to original tups/recs because literal terms should have simple types,
    and do joins instead of unification where necessary.
    make variants work the same way
    regardless, formatters should work off values not types *for literal terms*,
        and for nonliterals will need to read through type vars/params
        (may force keyed access, or dictionary passing?)

/////////////////////////////////// refs have lifetime types //////////////////////////////////////////
/////////////////////////////////// transitive unbox **x //////////////////////////////////////////

@@@
okay, the TC is limping along with tvar approach to records, but inference is wrong - bad polarity.
just doing the same thing with recs as it does with variants.
blows up at RT in the expected way
@@@

@@@ also this doesn't work <T | (x: Int)> f() -> T { (x:10, y:10) }
@@@ ...or <T | (x: Int)> f() -> T { (x:10) } @@@
@@@ ...or <T | ?(x: Int)> f() -> T { x!10 } @@@
@@@ <T|Int> f(x:T) -> T { x * 1 }
    ERROR <shell>[1, 1]: declared type <T:Int> T -> T does not agree with inferred type Int -> Int
@@@
seems like constraint checking is fucked up
also variant type and expr syntax ...

choices:
1. try to eliminate type vars at end by noticing that types are minimal or maximal (needs variance regardless)
2. always use type vars during inference, even for e.g. Int constants (would have the opposite problem w.r.t. annotations?)
. definitely need

> <T|(x:String, y:Int)> f(r:T) -> String  { r.x }
<T|(x:String, y:Int)> f(r:T) -> String  { r.x }
...another one - annotation overconstrains w.r.t. inference


T1. fix above
T2. rationalize constraints
T3. polarity
T4. indexed application, indexed composition

Rules:
unify on concrete types has no subtyping, but constraints do (and polarity)
once T has been bound to a concrete type, it's pinned.



next:
fix above probs,
    clarify diff btw e.g. RecordConstraint and SubsumptionConstraint which specifies a Record type
        - <T | C> builds SubsumptionConstraint C, subs constraints give rise to others, type var subsume adds one
        - RecordConstraint is attached to tvar for literals (I just added this) and apply terms w/dot a
    merge (for records anyway) looks like union in both cases
    Constraint.merge
    maybe add polarity
"type merge not implemented" on loading var.m
whatever you wind up with for records, do it for tuples
once subsumption subtyping is settled, see if there isn't any easy way to go to real rec layouts
then indexed application/composition


2. make records/tuples do the same thing as variants coming out of ifs
    why not already?
    recs error when typemap w/false key fails to unify with typemap w/true key.
    but why don't vars do the same thing?

3. DONT FORGET THAT ITS A PROCESS


>> tuple-to-rec coercion at callsites. funs w/named params take records not tuples.
then extend autocoerce idea to () -> lambdas?



**/


intrinsic <K, K2 | K, V:[*], R> cond(
  sel : Var(Assoc(K, V)),
  cases : Rec(Assoc(K2, Cone(V, R)))
) -> R;

cases = (x: { "I'm a string: " + _ }, y: { "I'm an int" + tostr(_) });

sel = x ! "hey";
//sel2 = (x: "hey");

sel ? cases