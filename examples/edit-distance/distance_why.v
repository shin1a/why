(* This file was originally generated by why.
   It can be modified; only the generated parts will be overwritten. *)

Require Import Why.
Require Export words.
Require Import Omega.
Require Import Sumbool.

Axiom n1_non_negative : (0 <= n1)%Z.

Axiom n2_non_negative : (0 <= n2)%Z.

Ltac omega' :=
  generalize n1_non_negative; generalize n2_non_negative;
   abstract omega.

Definition min_suffix (w1 w2:array A) (i j n:Z) :=
  min_dist (suffix n1 w1 i) (suffix n2 w2 j) n.

Definition test_char (a b:A) := bool_of_sumbool (A_eq_dec a b).

(*Why type*) Definition farray: Set ->Set.
Admitted.

(*Why logic*) Definition access : forall (A1:Set), (array A1) -> Z -> A1.
Admitted.
Implicit Arguments access.

(*Why logic*) Definition update :
  forall (A1:Set), (array A1) -> Z -> A1 -> (array A1).
Admitted.
Implicit Arguments update.

(*Why axiom*) Lemma access_update :
  forall (A1:Set),
  (forall (a:(array A1)),
   (forall (i:Z), (forall (v:A1), (access (update a i v) i) = v))).
Admitted.

(*Why axiom*) Lemma access_update_neq :
  forall (A1:Set),
  (forall (a:(array A1)),
   (forall (i:Z),
    (forall (j:Z),
     (forall (v:A1), (i <> j -> (access (update a i v) j) = (access a j)))))).
Admitted.

(*Why logic*) Definition array_length : forall (A1:Set), (array A1) -> Z.
Admitted.
Implicit Arguments array_length.

(*Why predicate*) Definition sorted_array  (t:(array Z)) (i:Z) (j:Z)
  := (forall (k1:Z),
      (forall (k2:Z),
       ((i <= k1 /\ k1 <= k2) /\ k2 <= j -> (access t k1) <= (access t k2)))).

(*Why predicate*) Definition exchange (A113:Set) (a1:(array A113)) (a2:(array A113)) (i:Z) (j:Z)
  := (array_length a1) = (array_length a2) /\
     (access a1 i) = (access a2 j) /\ (access a2 i) = (access a1 j) /\
     (forall (k:Z), (k <> i /\ k <> j -> (access a1 k) = (access a2 k))).
Implicit Arguments exchange.

(*Why logic*) Definition permut :
  forall (A1:Set), (array A1) -> (array A1) -> Z -> Z -> Prop.
Admitted.
Implicit Arguments permut.

(*Why axiom*) Lemma permut_refl :
  forall (A1:Set),
  (forall (t:(array A1)), (forall (l:Z), (forall (u:Z), (permut t t l u)))).
Admitted.

(*Why axiom*) Lemma permut_sym :
  forall (A1:Set),
  (forall (t1:(array A1)),
   (forall (t2:(array A1)),
    (forall (l:Z), (forall (u:Z), ((permut t1 t2 l u) -> (permut t2 t1 l u)))))).
Admitted.

(*Why axiom*) Lemma permut_trans :
  forall (A1:Set),
  (forall (t1:(array A1)),
   (forall (t2:(array A1)),
    (forall (t3:(array A1)),
     (forall (l:Z),
      (forall (u:Z),
       ((permut t1 t2 l u) -> ((permut t2 t3 l u) -> (permut t1 t3 l u)))))))).
Admitted.

(*Why axiom*) Lemma permut_exchange :
  forall (A1:Set),
  (forall (a1:(array A1)),
   (forall (a2:(array A1)),
    (forall (l:Z),
     (forall (u:Z),
      (forall (i:Z),
       (forall (j:Z),
        (l <= i /\ i <= u ->
         (l <= j /\ j <= u -> ((exchange a1 a2 i j) -> (permut a1 a2 l u)))))))))).
Admitted.

(*Why axiom*) Lemma exchange_upd :
  forall (A1:Set),
  (forall (a:(array A1)),
   (forall (i:Z),
    (forall (j:Z),
     (exchange a (update (update a i (access a j)) j (access a i)) i j)))).
Admitted.

(*Why axiom*) Lemma permut_weakening :
  forall (A1:Set),
  (forall (a1:(array A1)),
   (forall (a2:(array A1)),
    (forall (l1:Z),
     (forall (r1:Z),
      (forall (l2:Z),
       (forall (r2:Z),
        ((l1 <= l2 /\ l2 <= r2) /\ r2 <= r1 ->
         ((permut a1 a2 l2 r2) -> (permut a1 a2 l1 r1))))))))).
Admitted.

(*Why axiom*) Lemma permut_eq :
  forall (A1:Set),
  (forall (a1:(array A1)),
   (forall (a2:(array A1)),
    (forall (l:Z),
     (forall (u:Z),
      (l <= u ->
       ((permut a1 a2 l u) ->
        (forall (i:Z), (i < l \/ u < i -> (access a2 i) = (access a1 i))))))))).
Admitted.

(*Why predicate*) Definition permutation (A122:Set) (a1:(array A122)) (a2:(array A122))
  := (permut a1 a2 0 ((array_length a1) - 1)).
Implicit Arguments permutation.

(*Why axiom*) Lemma array_length_update :
  forall (A1:Set),
  (forall (a:(array A1)),
   (forall (i:Z),
    (forall (v:A1), (array_length (update a i v)) = (array_length a)))).
Admitted.

(*Why axiom*) Lemma permut_array_length :
  forall (A1:Set),
  (forall (a1:(array A1)),
   (forall (a2:(array A1)),
    (forall (l:Z),
     (forall (u:Z),
      ((permut a1 a2 l u) -> (array_length a1) = (array_length a2)))))).
Admitted.

(*Why logic*) Definition n1 : Z.
Admitted.

(*Why logic*) Definition n2 : Z.
Admitted.

Proof.
intuition.
omega'.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
ArraySubst t1.
subst t1.
assert (j < i0 \/ j=i0). omega. intuition.
AccessOther; intuition.
subst; AccessSame; intuition.
Save.

Proof.
intuition.
omega'.
replace (i1 + 1)%Z with n1; [ idtac | omega' ].
unfold min_suffix.
rewrite suffix_n_is_eps.
replace (access t0 j) with (Zlength (suffix n2 w2 j)).
exact (min_dist_eps_length (suffix n2 w2 j)).
replace (access t0 j) with (n2-j).
apply suffix_length; omega'.
symmetry; auto with *.
Save.

Proof.
intuition.
omega'.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
ArraySubst t2.
subst t2.
subst result0.
replace k with n2; [ idtac | omega' ].
unfold min_suffix.
rewrite (suffix_is_cons n1 w1 i2).
rewrite suffix_n_is_eps.
AccessSame.
apply min_dist_eps.
rewrite <- suffix_n_is_eps with (n := n2) (t := w2).
apply H20; omega'.
omega'.
subst t2.
AccessOther.
apply H20; omega'.
subst old result.
replace n2 with (j + 1)%Z; [ idtac | omega' ].
apply H20; omega'.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
ArraySubst t4.
subst t4.
unfold min_suffix.
assert (j0=k \/ j0 < k). omega. intuition.
  (* j0=k *)
  subst j0.
  rewrite (suffix_is_cons n1 w1 i2); [ idtac | omega' ].
  rewrite (suffix_is_cons n2 w2 k); [ idtac | omega' ].
  subst.
  replace (access w1 i2) with (access w2 k).
  apply min_dist_equal.
  AccessSame.
  assumption.
  (* j0<k *)
  subst.
  AccessOther.
  assert (min_suffix w1 w2 i2 k (access t3 k)); auto with *.
unfold min_suffix.
subst t4.
AccessOther.
assert (min_suffix w1 w2 (i2 + 1) k (access t3 k)); auto with *.
subst; unfold min_suffix. 
assert (min_suffix w1 w2 (i2 + 1) j0 (access t3 j0)); auto with *.
ring (j0-1+1); auto.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
ArraySubst t4.
unfold min_suffix.
subst t4.
assert (k=j0 \/ j0<k). omega. intuition.
  (* j0=k *)
  subst j0.
  rewrite (suffix_is_cons n1 w1 i2); [ idtac | omega' ].
  rewrite (suffix_is_cons n2 w2 k); [ idtac | omega' ].
  AccessSame.
  apply min_dist_diff.
  subst; auto.
  rewrite <- (suffix_is_cons n1 w1 i2); [ idtac | omega' ].
  subst.
  assert (min_suffix w1 w2 i2 (k+1) (access t3 (k+1))); auto with *.
  rewrite <- (suffix_is_cons n2 w2 k); [ idtac | omega' ].
  subst.
  assert (min_suffix w1 w2 (i2 + 1) k (access t3 k)); auto with *.
  (* j0<k *)
  subst.
  AccessOther.
  assert (min_suffix w1 w2 i2 k (access t3 k)); auto with *.
subst; unfold min_suffix.
AccessOther.
assert (min_suffix w1 w2 (i2 + 1) k (access t3 k)); auto with *.
replace (j1 + 1)%Z with j0; [ idtac | omega' ].
subst; intuition.
Save.

Proof.
intuition.
replace (i3+1) with i2; [ idtac | omega' ].
intuition.
Save.

Proof.
intuition.
omega'.
Save.

Proof.
intuition.
assert (hi2: i2+1=0). omega'.
unfold word_of_array.
subst.
assert (h: min_suffix w1 w2 (i2+1) 0 (access t1 0)); auto with *.
rewrite hi2 in h; auto.
Save.

(*Why type*) Definition A: Set.
Admitted.

(*Why type*) Definition word: Set.
Admitted.

(*Why logic*) Definition min_suffix :
  (array A) -> (array A) -> Z -> Z -> Z -> Prop.
Admitted.

(*Why logic*) Definition word_of_array : Z -> (array A) -> word.
Admitted.

(*Why logic*) Definition min_dist : word -> word -> Z -> Prop.
Admitted.
