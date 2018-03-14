
intrinsic <K, K2 | K, V:[*], R> cond(
  sel : Var(Assoc(K, V)),
  cases : Rec(Assoc(K2, Cone(V, R)))
) -> R;

cases = (x: { "I'm a string: " + _ }, y: { "I'm an int" + tostr(_) });

sel = x ! "hey";
//sel2 = (x: "hey");

sel ? cases