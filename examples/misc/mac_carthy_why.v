(* This file was originally generated by why.
   It can be modified; only the generated parts will be overwritten. *)

Require Import Why.

Definition max (x y:Z) : Z :=
  match Z_le_gt_dec x y with
  | left _ => y
  | right _ => x
  end.

Admitted.

Admitted.

Proof.
unfold Zwf, max; intuition.
case (Z_le_gt_dec 0 (101 - n)); intuition.
case (Z_le_gt_dec 0 (101 - n)); intuition.
case (Z_le_gt_dec 0 (101 - (n+11))); intuition.
Qed.

Proof.
intros n.
unfold Zwf, max. 
case (Z_le_gt_dec 0 (101 - n)); intuition.
subst result.
ring (101-91).
case (Z_le_gt_dec 0 10); intuition.
subst result.
case (Z_le_gt_dec 0 (101 - (n + 11 - 10))); intuition; omega.
Save.

Proof.
intuition.
Save.

Proof.
intuition.
Save.


