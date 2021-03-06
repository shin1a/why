(* Load Programs. *)(**************************************************************************)
(*                                                                        *)
(* Proof of the Bresenham line drawing algorithm.                         *)
(*                                                                        *)
(* Jean-Christophe Filliâtre (LRI, Université Paris Sud)                  *)
(* May 2001                                                               *)
(*                                                                        *)
(**************************************************************************)

(*s Some lemmas about absolute value (over type [Z]). *)

Require Import ZArith.
Require Import Omega.
Require Import ZArithRing.

(*s First a tactic [Case_Zabs] to do case split over [(Zabs x)]: 
    introduces two subgoals, one where [x] is assumed to be non negative
    and thus where [Zabs x] is replaced by [x]; and another where
    [x] is assumed to be non positive and thus where [Zabs x] is
    replaced by [-x]. *)

Lemma Z_gt_le : forall x y:Z, (x > y)%Z -> (y <= x)%Z.
Proof.
intros; omega.
Qed.

Ltac Case_Zabs a Ha :=
  elim (Z_le_gt_dec 0 a); intro Ha;
   [ rewrite (Zabs_eq a Ha)
   | rewrite (Zabs_non_eq a (Z_gt_le 0 a Ha)) ].

(*s A useful lemma to establish $|a| \le |b|$. *)

Lemma Zabs_le_Zabs :
 forall a b:Z,
   (b <= a <= 0)%Z \/ (0 <= a <= b)%Z -> (Zabs a <= Zabs b)%Z.
Proof.
intro a; Case_Zabs a Ha; intro b; Case_Zabs b Hb; omega.
Qed.

(*s A useful lemma to establish $|a| \le $. *)

Lemma Zabs_le :
 forall a b:Z, (0 <= b)%Z -> ((Zopp b <= a <= b)%Z <-> (Zabs a <= b)%Z).
Proof.
intros a b Hb.
 Case_Zabs a Ha; split; omega.
Qed.

(*s Two tactics. [ZCompare x y H] discriminates between [x<y], [x=y] and 
    [x>y] ([H] is the hypothesis name). [RingSimpl x y] rewrites [x] by [y]
    using the [Ring] tactic. *)

Ltac ZCompare x y H :=
  elim (Z_gt_le_dec x y); intro H;
   [ idtac | elim (Z_le_lt_eq_dec x y H); clear H; intro H ].

Ltac RingSimpl x y := replace x with y; [ idtac | ring ].

(*s Key lemma for Bresenham's proof: if [b] is at distance less or equal 
    than [1/2] from the rational [c/a], then it is the closest such integer.
    We express this property in [Z], thus multiplying everything by [2a]. *)

Lemma closest :
 forall a b c:Z,
   (0 <= a)%Z ->
   (Zabs (2 * a * b - 2 * c) <= a)%Z ->
   forall b':Z, (Zabs (a * b - c) <= Zabs (a * b' - c))%Z.
Proof.
intros a b c Ha Hmin.
generalize (proj2 (Zabs_le (2 * a * b - 2 * c) a Ha) Hmin).
intros Hmin' b'.
elim (Z_le_gt_dec (2 * a * b) (2 * c)); intro Habc.
(* 2ab <= 2c *)
rewrite (Zabs_non_eq (a * b - c)).
ZCompare b b' Hbb'.
  (* b > b' *)
  rewrite (Zabs_non_eq (a * b' - c)).
  apply Zle_left_rev.
  RingSimpl (Zopp (a * b' - c) + Zopp (Zopp (a * b - c)))%Z
   (a * (b - b'))%Z.
  apply Zmult_le_0_compat; omega.
  apply Zge_le.
  apply Zge_trans with (m := (a * b - c)%Z).
  apply Zmult_ge_reg_r with (p := 2%Z).
 omega.
  RingSimpl (0 * 2)%Z 0%Z.
   RingSimpl ((a * b - c) * 2)%Z (2 * a * b - 2 * c)%Z.
 omega.
  RingSimpl (a * b' - c)%Z (a * b' + Zopp c)%Z.
  RingSimpl (a * b - c)%Z (a * b + Zopp c)%Z.
  apply Zle_ge.
    apply Zplus_le_compat_r.
  apply Zmult_le_compat_l; omega.
  (* b < b' *)
  rewrite (Zabs_eq (a * b' - c)).
  apply Zmult_le_reg_r with (p := 2%Z).
 omega.
  RingSimpl ((a * b' - c) * 2)%Z
   (2 * (a * b' - a * b) + 2 * (a * b - c))%Z.
  apply Zle_trans with a.
   RingSimpl (Zopp (a * b - c) * 2)%Z (Zopp (2 * a * b - 2 * c)).
 omega.
  apply Zle_trans with (2 * a + Zopp a)%Z.
 omega.
  apply Zplus_le_compat.
  RingSimpl (2 * a)%Z (2 * a * 1)%Z.
  RingSimpl (2 * (a * b' - a * b))%Z (2 * a * (b' - b))%Z.
  apply Zmult_le_compat_l; omega.
  RingSimpl (2 * (a * b - c))%Z (2 * a * b - 2 * c)%Z.
 omega.
    (* 0 <= ab'-c *)
    RingSimpl (a * b' - c)%Z (a * b' - a * b + (a * b - c))%Z.
    RingSimpl 0%Z (a + Zopp a)%Z.
    apply Zplus_le_compat.
    RingSimpl a (a * 1)%Z.
    RingSimpl (a * 1 * b' - a * 1 * b)%Z (a * (b' - b))%Z.
    apply Zmult_le_compat_l; omega.
    apply Zmult_le_reg_r with (p := 2%Z).
 omega.
    apply Zle_trans with (Zopp a).
 omega.
      RingSimpl ((a * b - c) * 2)%Z (2 * a * b - 2 * c)%Z.
 omega.
  (* b = b' *)
  rewrite <- Hbb'.
  rewrite (Zabs_non_eq (a * b - c)).
 omega.
  apply Zge_le.
  apply Zmult_ge_reg_r with (p := 2%Z).
 omega.
  RingSimpl (0 * 2)%Z 0%Z.
   RingSimpl ((a * b - c) * 2)%Z (2 * a * b - 2 * c)%Z.
 omega.
   apply Zge_le.
  apply Zmult_ge_reg_r with (p := 2%Z).
 omega.
  RingSimpl (0 * 2)%Z 0%Z.
   RingSimpl ((a * b - c) * 2)%Z (2 * a * b - 2 * c)%Z.
 omega.
 
(* 2ab > 2c *)
rewrite (Zabs_eq (a * b - c)).
ZCompare b b' Hbb'.
  (* b > b' *)
  rewrite (Zabs_non_eq (a * b' - c)).
  apply Zmult_le_reg_r with (p := 2%Z).
 omega.
  RingSimpl (Zopp (a * b' - c) * 2)%Z
   (2 * (c - a * b) + 2 * (a * b - a * b'))%Z.
  apply Zle_trans with a.
   RingSimpl ((a * b - c) * 2)%Z (2 * a * b - 2 * c)%Z.
 omega.
  apply Zle_trans with (Zopp a + 2 * a)%Z.
 omega.
  apply Zplus_le_compat.
  RingSimpl (2 * (c - a * b))%Z (2 * c - 2 * a * b)%Z.
 omega.
  RingSimpl (2 * a)%Z (2 * a * 1)%Z.
  RingSimpl (2 * (a * b - a * b'))%Z (2 * a * (b - b'))%Z.
  apply Zmult_le_compat_l; omega.
    (* 0 >= ab'-c *)
    RingSimpl (a * b' - c)%Z (a * b' - a * b + (a * b - c))%Z.
    RingSimpl 0%Z (Zopp a + a)%Z.
    apply Zplus_le_compat.
    RingSimpl (Zopp a) (a * (-1))%Z.
    RingSimpl (a * b' - a * b)%Z (a * (b' - b))%Z.
    apply Zmult_le_compat_l; omega.
    apply Zmult_le_reg_r with (p := 2%Z).
 omega.
    apply Zle_trans with a.
    RingSimpl ((a * b - c) * 2)%Z (2 * a * b - 2 * c)%Z.
    omega.
 omega.
  (* b < b' *)
  rewrite (Zabs_eq (a * b' - c)).
  apply Zle_left_rev.
  RingSimpl (a * b' - c + Zopp (a * b - c))%Z (a * (b' - b))%Z.
  apply Zmult_le_0_compat; omega.
  apply Zle_trans with (m := (a * b - c)%Z).
  apply Zmult_le_reg_r with (p := 2%Z).
 omega.
  RingSimpl (0 * 2)%Z 0%Z.
   RingSimpl ((a * b - c) * 2)%Z (2 * a * b - 2 * c)%Z.
 omega.
  RingSimpl (a * b' - c)%Z (a * b' + Zopp c)%Z.
  RingSimpl (a * b - c)%Z (a * b + Zopp c)%Z.
  apply Zplus_le_compat_r.
  apply Zmult_le_compat_l; omega.
  (* b = b' *)
  rewrite <- Hbb'.
    rewrite (Zabs_eq (a * b - c)).
 omega.
  apply Zmult_le_reg_r with (p := 2%Z).
 omega.
  RingSimpl (0 * 2)%Z 0%Z.
   RingSimpl ((a * b - c) * 2)%Z (2 * a * b - 2 * c)%Z.
 omega.
   apply Zmult_le_reg_r with (p := 2%Z).
 omega.
  RingSimpl (0 * 2)%Z 0%Z.
   RingSimpl ((a * b - c) * 2)%Z (2 * a * b - 2 * c)%Z.
 omega.
 Qed.
