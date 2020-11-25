
* first goal: get variants/? working

* find other todo list(s)

* lambda sep to ->

* point-free tuple extraction syntax?

* finish move to underscore
  * "Inline param ref in lambda with declared methods" if old style is encountered
  * finish desugaring of declared params to _.n : { x, y -> ... } is { (x, y) = _; ... }
  * records should work the same way
  * __ = $$, or NOT
  * remove $n from parser
  * fix precedence: { _.0 _.1 }
  * (all should be subsumption-subtyped)

* , is a weird thing. could have pairing operator, tuple-append, tuple-concat, tuple-interp
* but then (x, y, z) and ((x, y), z) are mutually incompatible.
* with , for pair and ++ for concat you have x, y ++ z   and   x, y, z
* with , for concat and say % for pair you have x % y, z (or x, y, z with overload) and x % y % z

not so sure

* hope so because then curry = { f, x -> { f (x, _) } };
* infix for curry. @?
* with infix , and curry @, then {x,_} is (,) @ x  ... but it's better the other way
* what about other partial application? { f, y -> { f (_, y) } }
  * tuple interpolation is first step:
  * if (,)<Xs:[*], Y>: (Tup(Xs), Y) -> Tup(Xs ++ Y)  e.g. (a, b), c => (a, b, c) oops

not so sure, see above

* remember row types. the trouble comes with manipulation like append and the need to account for shadowing labels.
* don't forget that this small-scale stuff probably won't form the bulk of the experience. modules etc. ugh

tuple extraction: (x, y, z)..[0, 2]  => (x, z)

record extraction: (a: x, b: y, c: z)..[a, c]   => (a: x, c: z)

...these are just llmap etc but on structures. definitely want them. Overload call syntax for these too?





* some sort of with syntax
* punning

* try >> instead of | for each. or maybe back to @ with FLIPPED ORDER. easier to read
* consider flipping order for $ too

inc.0
inc.inc.0
inc.inc

plus.(inc, inc)

plus.twist.(inc, dec)

so the rule is: (X -> Y) . X  =>  Y

but (X -> Y) . (W -> X)  =>  (W -> Y)

and ((X, Y) -> Z) . ((A -> X, B -> Y))  =>  (A, B) -> Z

* fix assoc so this parses: box draw(5, size paras)

* finish fix for whatever the blocker was for declared variants/constraints/...

---

* tighten container typing 
  * finite sets
  * total/partial application overloads

* finish unified application syntax
  * `[X] <: Int -> X` (mod fin sets)
  * `[K:V] <: K -> V`
  * `<X, Y, F:X->Y> apply: (F,X) -> Y`
  * `<F:App, G:App, X, Y, Z)> compose: (F(X,Y), F(Y,Z)) -> F(X,Z)`
    * `(->)`, `[]`, `[:]` are `App`
    * (don't forget structural ones too) 

* predicate propagation

