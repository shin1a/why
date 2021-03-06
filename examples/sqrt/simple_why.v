(* This file was originally generated by why.
   It can be modified; only the generated parts will be overwritten. *)

Require Export Why.
Require Export ZArithRing.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma sqrt_po_1 : 
  forall (n: Z),
  forall (HW_1: n >= 0),
  0 >= 0.
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma sqrt_po_2 : 
  forall (n: Z),
  forall (HW_1: n >= 0),
  n >= (0 * 0).
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma sqrt_po_3 : 
  forall (n: Z),
  forall (HW_1: n >= 0),
  1 = ((0 + 1) * (0 + 1)).
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma sqrt_po_4 : 
  forall (n: Z),
  forall (HW_1: n >= 0),
  forall (HW_2: 0 >= 0 /\ n >= (0 * 0) /\ 1 = ((0 + 1) * (0 + 1))),
  forall (count: Z),
  forall (sum: Z),
  forall (HW_3: count >= 0 /\ n >= (count * count) /\ sum =
                ((count + 1) * (count + 1))),
  forall (HW_4: sum <= n),
  forall (count0: Z),
  forall (HW_5: count0 = (count + 1)),
  forall (sum0: Z),
  forall (HW_6: sum0 = (sum + 2 * count0 + 1)),
  count0 >= 0.
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma sqrt_po_5 : 
  forall (n: Z),
  forall (HW_1: n >= 0),
  forall (HW_2: 0 >= 0 /\ n >= (0 * 0) /\ 1 = ((0 + 1) * (0 + 1))),
  forall (count: Z),
  forall (sum: Z),
  forall (HW_3: count >= 0 /\ n >= (count * count) /\ sum =
                ((count + 1) * (count + 1))),
  forall (HW_4: sum <= n),
  forall (count0: Z),
  forall (HW_5: count0 = (count + 1)),
  forall (sum0: Z),
  forall (HW_6: sum0 = (sum + 2 * count0 + 1)),
  n >= (count0 * count0).
Proof.
intuition.
apply Zge_trans with sum; intuition.
subst count0; intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma sqrt_po_6 : 
  forall (n: Z),
  forall (HW_1: n >= 0),
  forall (HW_2: 0 >= 0 /\ n >= (0 * 0) /\ 1 = ((0 + 1) * (0 + 1))),
  forall (count: Z),
  forall (sum: Z),
  forall (HW_3: count >= 0 /\ n >= (count * count) /\ sum =
                ((count + 1) * (count + 1))),
  forall (HW_4: sum <= n),
  forall (count0: Z),
  forall (HW_5: count0 = (count + 1)),
  forall (sum0: Z),
  forall (HW_6: sum0 = (sum + 2 * count0 + 1)),
  sum0 = ((count0 + 1) * (count0 + 1)).
Proof.
intuition.
subst sum0 count0 sum; ring.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma sqrt_po_7 : 
  forall (n: Z),
  forall (HW_1: n >= 0),
  forall (HW_2: 0 >= 0 /\ n >= (0 * 0) /\ 1 = ((0 + 1) * (0 + 1))),
  forall (count: Z),
  forall (sum: Z),
  forall (HW_3: count >= 0 /\ n >= (count * count) /\ sum =
                ((count + 1) * (count + 1))),
  forall (HW_4: sum <= n),
  forall (count0: Z),
  forall (HW_5: count0 = (count + 1)),
  forall (sum0: Z),
  forall (HW_6: sum0 = (sum + 2 * count0 + 1)),
  0 <= (n - sum).
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma sqrt_po_8 : 
  forall (n: Z),
  forall (HW_1: n >= 0),
  forall (HW_2: 0 >= 0 /\ n >= (0 * 0) /\ 1 = ((0 + 1) * (0 + 1))),
  forall (count: Z),
  forall (sum: Z),
  forall (HW_3: count >= 0 /\ n >= (count * count) /\ sum =
                ((count + 1) * (count + 1))),
  forall (HW_4: sum <= n),
  forall (count0: Z),
  forall (HW_5: count0 = (count + 1)),
  forall (sum0: Z),
  forall (HW_6: sum0 = (sum + 2 * count0 + 1)),
  (n - sum0) < (n - sum).
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma sqrt_po_9 : 
  forall (n: Z),
  forall (HW_1: n >= 0),
  forall (HW_2: 0 >= 0 /\ n >= (0 * 0) /\ 1 = ((0 + 1) * (0 + 1))),
  forall (count: Z),
  forall (sum: Z),
  forall (HW_3: count >= 0 /\ n >= (count * count) /\ sum =
                ((count + 1) * (count + 1))),
  forall (HW_7: sum > n),
  (count * count) <= n.
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma sqrt_po_10 : 
  forall (n: Z),
  forall (HW_1: n >= 0),
  forall (HW_2: 0 >= 0 /\ n >= (0 * 0) /\ 1 = ((0 + 1) * (0 + 1))),
  forall (count: Z),
  forall (sum: Z),
  forall (HW_3: count >= 0 /\ n >= (count * count) /\ sum =
                ((count + 1) * (count + 1))),
  forall (HW_7: sum > n),
  n < ((count + 1) * (count + 1)).
Proof.
intuition.
Save.

