(* This file was originally generated by why.
   It can be modified; only the generated parts will be overwritten. *)

Require Import Why.

Parameter F : Z -> Z.
Axiom F_0 : F 0 = 1%Z.
Axiom F_1 : F 1 = 1%Z.
Axiom F_n : forall n:Z, (n >= 2)%Z -> F n = (F (n - 1) + F (n - 2))%Z.
Hint Resolve F_0 F_1 F_n .

Proof.
intuition.
assert (n=0 \/ n=1). omega. intuition; subst; auto.
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
subst; symmetry; auto with *.
Save.


Proof.
intuition.
subst; auto.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
subst; symmetry.
cut (1 <= x).
 replace x with (x + 1 - 1)%Z.
 generalize (x + 1)%Z.
intros; ring (z - 1 + 1)%Z; replace (z - 1 - 1)%Z with (z - 2)%Z.
 auto with *.
omega.
omega.
assumption.
subst; ring (x + 1 - 1)%Z; trivial.
Save.


Proof.
intuition.
assert (n=0 \/ n=1). omega. intuition; subst; auto.
Save.

Proof.
intuition.
Save.


Proof.
intuition.
Save.

Proof.
intuition.
subst; symmetry.
cut (1 <= k).
 replace k with (k + 1 - 1)%Z.
 generalize (k + 1)%Z.
intros; ring (z - 1 + 1)%Z; replace (z - 1 - 1)%Z with (z - 2)%Z.
 auto with *.
omega.
omega.
assumption.
subst; ring (k + 1 - 1)%Z; trivial.
Save.

Proof.
intuition.
subst.
assert (k=n). omega. subst; auto.
Save.

Proof.
intuition.
assert (n=0 \/ n=1). omega. intuition; subst; auto.
Save.


Proof.
intuition.
assert (n=0 \/ n=1). omega. intuition; subst; auto.
Save.

Proof.
intuition.
Save.

Proof.
intuition; ArraySubst t0.
Save.

Proof.
intuition.
subst; repeat rewrite array_length_update; trivial.
subst. assert (i=0 \/ i=1). omega. intuition; subst.
AccessOther; auto with *.
AccessSame; auto with *.
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
intuition; subst.
repeat rewrite array_length_update; assumption.
assert (i<k \/ i=k). omega. intuition; subst.
AccessOther; auto.
AccessSame.
replace (access t2 (k-1)) with (F (k-1)); symmetry; auto with *.
replace (access t2 (k-2)) with (F (k-2)); symmetry; auto with *.
symmetry; auto with *.
Save.

Proof.
intuition.
Save.

Proof.
intuition; subst; intuition.
Save.


(*Why logic*) Definition F : Z -> Z.
Admitted.

(*Why axiom*) Lemma F_0 : (F 0) = 1.
Admitted.

(*Why axiom*) Lemma F_1 : (F 1) = 1.
Admitted.

(*Why axiom*) Lemma F_n :
  (forall (n:Z), (n >= 2 -> (F n) = ((F (n - 1)) + (F (n - 2))))).
Admitted.

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

(*Why predicate*) Definition exchange (A94:Set) (a1:(array A94)) (a2:(array A94)) (i:Z) (j:Z)
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

(*Why predicate*) Definition permutation (A103:Set) (a1:(array A103)) (a2:(array A103))
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

