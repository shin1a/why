(* This file was originally generated by why.
   It can be modified; only the generated parts will be overwritten. *)

Require Import Why.
Require Import Omega.
Require Import Zdiv.
Require Import ZArithRing.

Proof.
intuition.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
subst; apply Z_div_ge0; omega.
assert (h: p + a * b = x * y). assumption.
rewrite (Z_div_mod_eq a 2) in h.
rewrite <- h.
subst.
replace (a mod 2) with 1. 
ring.
omega.
unfold Zwf.
 repeat split; try omega.
subst; apply Z_div_lt; try omega.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
subst; apply Z_div_ge0; try omega.
assert (h: p + a * b = x * y). assumption.
rewrite (Z_div_mod_eq a 2) in h.
rewrite <- h.
subst.
replace (a mod 2)%Z with 0%Z.
ring.
cut (2 > 0)%Z; [ intro h' | omega ].
generalize (Z_mod_lt a 2 h').
cut ((a mod 2)%Z <> 1%Z); intros; try omega.
omega.
unfold Zwf.
repeat split; try omega.
subst; apply Z_div_lt; try omega.
Save.

Proof.
intuition; subst.
transitivity (p + 0*b); auto.
ring.
Save.


