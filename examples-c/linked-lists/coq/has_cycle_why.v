(* This file was originally generated by why.
   It can be modified; only the generated parts will be overwritten. *)

Require Export Caduceus.
Require Export has_cycle_spec_why.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma cyclic_impl_po_1 : 
  forall (l: ((pointer) global)),
  forall (alloc: alloc_table),
  forall (tl_global: ((memory) ((pointer) global) global)),
  forall (HW_1: (* File "has_cycle.c", line 10, characters 5-14 *)
                (finite tl_global alloc l)),
  forall (HW_3: ~(l = null)),
  (valid alloc l).
Proof.
intros; destruct result0; intuition idtac.
subst; subst.
inversion_clear H.
inversion H2.
intuition.
elim (null_not_valid alloc); assumption.
discriminate Post9.
discriminate Post9.
Save.

(**
subst; exists (@nil pointer); auto.
subst; exists (cons l nil); apply Path_cons; auto.
apply finite_is_valid with tl; auto.
subst; exists (cons l nil); apply Path_cons; auto.
apply finite_is_valid with tl; auto.
subst.
**)

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma cyclic_impl_po_2 : 
  forall (l: ((pointer) global)),
  forall (alloc: alloc_table),
  forall (tl_global: ((memory) ((pointer) global) global)),
  forall (HW_1: (* File "has_cycle.c", line 10, characters 5-14 *)
                (finite tl_global alloc l)),
  forall (HW_3: ~(l = null)),
  forall (HW_4: (valid alloc l)),
  forall (result: ((pointer) global)),
  forall (HW_5: result = (acc tl_global l)),
  forall (l2: ((pointer) global)),
  forall (HW_6: l2 = result),
  (well_founded has_cycle_order).
Proof.
intuition.
subst l1.
unfold finite in Pre17; intuition.
elim Pre17; clear Pre17; intros pl H.
elim (H l (@nil pointer)); auto.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma cyclic_impl_po_3 : 
  forall (l: ((pointer) global)),
  forall (alloc: alloc_table),
  forall (tl_global: ((memory) ((pointer) global) global)),
  forall (HW_1: (* File "has_cycle.c", line 10, characters 5-14 *)
                (finite tl_global alloc l)),
  forall (HW_3: ~(l = null)),
  forall (HW_4: (valid alloc l)),
  forall (result: ((pointer) global)),
  forall (HW_5: result = (acc tl_global l)),
  forall (l2: ((pointer) global)),
  forall (HW_6: l2 = result),
  (* File "has_cycle.c", line 19, characters 17-117 *)
  ((exists pl1:plist, (lpath tl_global alloc l pl1 l)) /\
  (exists pl12:plist, (lpath tl_global alloc l pl12 l2) /\ ~(pl12 = nil))).
Proof.
Admitted.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma cyclic_impl_po_4 : 
  forall (l: ((pointer) global)),
  forall (alloc: alloc_table),
  forall (tl_global: ((memory) ((pointer) global) global)),
  forall (HW_1: (* File "has_cycle.c", line 10, characters 5-14 *)
                (finite tl_global alloc l)),
  forall (HW_3: ~(l = null)),
  forall (HW_4: (valid alloc l)),
  forall (result: ((pointer) global)),
  forall (HW_5: result = (acc tl_global l)),
  forall (l2: ((pointer) global)),
  forall (HW_6: l2 = result),
  forall (HW_7: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l)) /\
                (exists pl12:plist, (lpath tl_global alloc l pl12 l2) /\
                 ~(pl12 = nil)))),
  forall (l1: ((pointer) global)),
  forall (l2_0: ((pointer) global)),
  forall (HW_8: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l1)) /\
                (exists pl12:plist, (lpath tl_global alloc l1 pl12 l2_0) /\
                 ~(pl12 = nil)))),
  forall (HW_9: ~(l1 = l2_0)),
  forall (HW_10: ~(l1 = null)),
  forall (HW_11: ~(l2_0 = null)),
  (valid alloc l2_0).
Proof.
intuition.
inversion Pre17.
inversion_clear H0.
inversion_clear H1.
intuition.
elim (H l2_2 (x0 ++ x1)); intuition.
apply lpath_append with l1_1; auto.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma cyclic_impl_po_5 : 
  forall (l: ((pointer) global)),
  forall (alloc: alloc_table),
  forall (tl_global: ((memory) ((pointer) global) global)),
  forall (HW_1: (* File "has_cycle.c", line 10, characters 5-14 *)
                (finite tl_global alloc l)),
  forall (HW_3: ~(l = null)),
  forall (HW_4: (valid alloc l)),
  forall (result: ((pointer) global)),
  forall (HW_5: result = (acc tl_global l)),
  forall (l2: ((pointer) global)),
  forall (HW_6: l2 = result),
  forall (HW_7: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l)) /\
                (exists pl12:plist, (lpath tl_global alloc l pl12 l2) /\
                 ~(pl12 = nil)))),
  forall (l1: ((pointer) global)),
  forall (l2_0: ((pointer) global)),
  forall (HW_8: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l1)) /\
                (exists pl12:plist, (lpath tl_global alloc l1 pl12 l2_0) /\
                 ~(pl12 = nil)))),
  forall (HW_9: ~(l1 = l2_0)),
  forall (HW_10: ~(l1 = null)),
  forall (HW_11: ~(l2_0 = null)),
  forall (HW_12: (valid alloc l2_0)),
  forall (result0: ((pointer) global)),
  forall (HW_13: result0 = (acc tl_global l2_0)),
  forall (HW_14: ~(result0 = null)),
  (valid alloc l1).
Proof.
intuition subst.
elim H4; auto.
inversion_clear H0; intuition.
inversion H0; subst; auto.
elim (null_not_valid alloc); assumption. 
elim H5; auto.
apply not_cyclic_and_is_list with alloc tl l; auto.
inversion_clear H.
inversion_clear H0; intuition.
apply llist_is_list with (x ++ x0); auto.
unfold llist.
apply lpath_append with l1_1; auto.
elim H6; auto.
apply not_cyclic_and_is_list with alloc tl l; auto.
inversion_clear H.
inversion_clear H0; intuition.
apply llist_is_list with ((x ++ x0) ++ l2_2 :: nil); auto.
unfold llist.
apply lpath_append with l2_2; auto.
apply lpath_append with l1_1; auto.
constructor; auto.
rewrite H3; auto.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma cyclic_impl_po_6 : 
  forall (l: ((pointer) global)),
  forall (alloc: alloc_table),
  forall (tl_global: ((memory) ((pointer) global) global)),
  forall (HW_1: (* File "has_cycle.c", line 10, characters 5-14 *)
                (finite tl_global alloc l)),
  forall (HW_3: ~(l = null)),
  forall (HW_4: (valid alloc l)),
  forall (result: ((pointer) global)),
  forall (HW_5: result = (acc tl_global l)),
  forall (l2: ((pointer) global)),
  forall (HW_6: l2 = result),
  forall (HW_7: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l)) /\
                (exists pl12:plist, (lpath tl_global alloc l pl12 l2) /\
                 ~(pl12 = nil)))),
  forall (l1: ((pointer) global)),
  forall (l2_0: ((pointer) global)),
  forall (HW_8: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l1)) /\
                (exists pl12:plist, (lpath tl_global alloc l1 pl12 l2_0) /\
                 ~(pl12 = nil)))),
  forall (HW_9: ~(l1 = l2_0)),
  forall (HW_10: ~(l1 = null)),
  forall (HW_11: ~(l2_0 = null)),
  forall (HW_12: (valid alloc l2_0)),
  forall (result0: ((pointer) global)),
  forall (HW_13: result0 = (acc tl_global l2_0)),
  forall (HW_14: ~(result0 = null)),
  forall (HW_15: (valid alloc l1)),
  forall (result1: ((pointer) global)),
  forall (HW_16: result1 = (acc tl_global l1)),
  forall (l1_0: ((pointer) global)),
  forall (HW_17: l1_0 = result1),
  forall (HW_18: (valid alloc l2_0)),
  forall (result2: ((pointer) global)),
  forall (HW_19: result2 = (acc tl_global l2_0)),
  (valid alloc result2).
Proof.
intuition.
inversion Pre17.
inversion_clear H.
intuition.
elim (H5 l1_1 x0); intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma cyclic_impl_po_7 : 
  forall (l: ((pointer) global)),
  forall (alloc: alloc_table),
  forall (tl_global: ((memory) ((pointer) global) global)),
  forall (HW_1: (* File "has_cycle.c", line 10, characters 5-14 *)
                (finite tl_global alloc l)),
  forall (HW_3: ~(l = null)),
  forall (HW_4: (valid alloc l)),
  forall (result: ((pointer) global)),
  forall (HW_5: result = (acc tl_global l)),
  forall (l2: ((pointer) global)),
  forall (HW_6: l2 = result),
  forall (HW_7: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l)) /\
                (exists pl12:plist, (lpath tl_global alloc l pl12 l2) /\
                 ~(pl12 = nil)))),
  forall (l1: ((pointer) global)),
  forall (l2_0: ((pointer) global)),
  forall (HW_8: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l1)) /\
                (exists pl12:plist, (lpath tl_global alloc l1 pl12 l2_0) /\
                 ~(pl12 = nil)))),
  forall (HW_9: ~(l1 = l2_0)),
  forall (HW_10: ~(l1 = null)),
  forall (HW_11: ~(l2_0 = null)),
  forall (HW_12: (valid alloc l2_0)),
  forall (result0: ((pointer) global)),
  forall (HW_13: result0 = (acc tl_global l2_0)),
  forall (HW_14: ~(result0 = null)),
  forall (HW_15: (valid alloc l1)),
  forall (result1: ((pointer) global)),
  forall (HW_16: result1 = (acc tl_global l1)),
  forall (l1_0: ((pointer) global)),
  forall (HW_17: l1_0 = result1),
  forall (HW_18: (valid alloc l2_0)),
  forall (result2: ((pointer) global)),
  forall (HW_19: result2 = (acc tl_global l2_0)),
  forall (HW_20: (valid alloc result2)),
  forall (result3: ((pointer) global)),
  forall (HW_21: result3 = (acc tl_global result2)),
  forall (l2_1: ((pointer) global)),
  forall (HW_22: l2_1 = result3),
  (* File "has_cycle.c", line 19, characters 17-117 *)
  ((exists pl1:plist, (lpath tl_global alloc l pl1 l1_0)) /\
  (exists pl12:plist, (lpath tl_global alloc l1_0 pl12 l2_1) /\ ~(pl12 = nil))) /\
  (has_cycle_order (has_cycle_variant tl_global alloc l l1_0 l2_1)
   (has_cycle_variant tl_global alloc l l1 l2_0)).
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma cyclic_impl_po_8 : 
  forall (l: ((pointer) global)),
  forall (alloc: alloc_table),
  forall (tl_global: ((memory) ((pointer) global) global)),
  forall (HW_1: (* File "has_cycle.c", line 10, characters 5-14 *)
                (finite tl_global alloc l)),
  forall (HW_3: ~(l = null)),
  forall (HW_4: (valid alloc l)),
  forall (result: ((pointer) global)),
  forall (HW_5: result = (acc tl_global l)),
  forall (l2: ((pointer) global)),
  forall (HW_6: l2 = result),
  forall (HW_7: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l)) /\
                (exists pl12:plist, (lpath tl_global alloc l pl12 l2) /\
                 ~(pl12 = nil)))),
  forall (l1: ((pointer) global)),
  forall (l2_0: ((pointer) global)),
  forall (HW_8: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l1)) /\
                (exists pl12:plist, (lpath tl_global alloc l1 pl12 l2_0) /\
                 ~(pl12 = nil)))),
  forall (HW_9: ~(l1 = l2_0)),
  forall (HW_10: ~(l1 = null)),
  forall (HW_11: ~(l2_0 = null)),
  forall (HW_12: (valid alloc l2_0)),
  forall (result0: ((pointer) global)),
  forall (HW_13: result0 = (acc tl_global l2_0)),
  forall (HW_23: result0 = null),
  (0 <> 0 <-> (cyclic tl_global alloc l)).
Proof.
intuition.
inversion Pre17.
inversion_clear H.
inversion_clear H0.
intuition.
elim (H5 aux_1 ((x0 ++ x1) ++ l2_2 :: nil)); intuition.
apply lpath_append with l2_2; auto.
apply lpath_append with l1_1; auto.
subst aux_1; constructor; auto.
subst aux_1; intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma cyclic_impl_po_9 : 
  forall (l: ((pointer) global)),
  forall (alloc: alloc_table),
  forall (tl_global: ((memory) ((pointer) global) global)),
  forall (HW_1: (* File "has_cycle.c", line 10, characters 5-14 *)
                (finite tl_global alloc l)),
  forall (HW_3: ~(l = null)),
  forall (HW_4: (valid alloc l)),
  forall (result: ((pointer) global)),
  forall (HW_5: result = (acc tl_global l)),
  forall (l2: ((pointer) global)),
  forall (HW_6: l2 = result),
  forall (HW_7: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l)) /\
                (exists pl12:plist, (lpath tl_global alloc l pl12 l2) /\
                 ~(pl12 = nil)))),
  forall (l1: ((pointer) global)),
  forall (l2_0: ((pointer) global)),
  forall (HW_8: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l1)) /\
                (exists pl12:plist, (lpath tl_global alloc l1 pl12 l2_0) /\
                 ~(pl12 = nil)))),
  forall (HW_9: ~(l1 = l2_0)),
  forall (HW_10: ~(l1 = null)),
  forall (HW_24: l2_0 = null),
  (0 <> 0 <-> (cyclic tl_global alloc l)).
Proof.
intuition.
subst; auto.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma cyclic_impl_po_10 : 
  forall (l: ((pointer) global)),
  forall (alloc: alloc_table),
  forall (tl_global: ((memory) ((pointer) global) global)),
  forall (HW_1: (* File "has_cycle.c", line 10, characters 5-14 *)
                (finite tl_global alloc l)),
  forall (HW_3: ~(l = null)),
  forall (HW_4: (valid alloc l)),
  forall (result: ((pointer) global)),
  forall (HW_5: result = (acc tl_global l)),
  forall (l2: ((pointer) global)),
  forall (HW_6: l2 = result),
  forall (HW_7: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l)) /\
                (exists pl12:plist, (lpath tl_global alloc l pl12 l2) /\
                 ~(pl12 = nil)))),
  forall (l1: ((pointer) global)),
  forall (l2_0: ((pointer) global)),
  forall (HW_8: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l1)) /\
                (exists pl12:plist, (lpath tl_global alloc l1 pl12 l2_0) /\
                 ~(pl12 = nil)))),
  forall (HW_9: ~(l1 = l2_0)),
  forall (HW_25: l1 = null),
  (0 <> 0 <-> (cyclic tl_global alloc l)).
Proof.
intuition.
inversion_clear H.
subst l1_2.
exists (x ++ l1_1 :: nil).
apply lpath_add1; auto.
inversion_clear Pre17.
elim (H l1_1 x H5); intuition.
inversion_clear H0; intuition.
inversion H0; subst; intuition.
exists ((l0 ++ l2_2 :: nil) ++ (l2_2#tl) :: nil); intuition.
apply lpath_add1; auto.
apply lpath_add1; auto.
inversion_clear Pre17.
inversion_clear H.
elim (H8 (l2_2#tl) ((x0 ++ l1_1 :: l0) ++ l2_2 :: nil)); auto.
apply lpath_add1; auto.
apply lpath_append with l1_1; auto.
destruct l0; simpl in H8; discriminate H8.
Admitted.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma cyclic_impl_po_11 : 
  forall (l: ((pointer) global)),
  forall (alloc: alloc_table),
  forall (tl_global: ((memory) ((pointer) global) global)),
  forall (HW_1: (* File "has_cycle.c", line 10, characters 5-14 *)
                (finite tl_global alloc l)),
  forall (HW_3: ~(l = null)),
  forall (HW_4: (valid alloc l)),
  forall (result: ((pointer) global)),
  forall (HW_5: result = (acc tl_global l)),
  forall (l2: ((pointer) global)),
  forall (HW_6: l2 = result),
  forall (HW_7: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l)) /\
                (exists pl12:plist, (lpath tl_global alloc l pl12 l2) /\
                 ~(pl12 = nil)))),
  forall (l1: ((pointer) global)),
  forall (l2_0: ((pointer) global)),
  forall (HW_8: (* File "has_cycle.c", line 19, characters 17-117 *)
                ((exists pl1:plist, (lpath tl_global alloc l pl1 l1)) /\
                (exists pl12:plist, (lpath tl_global alloc l1 pl12 l2_0) /\
                 ~(pl12 = nil)))),
  forall (HW_26: l1 = l2_0),
  (1 <> 0 <-> (cyclic tl_global alloc l)).
Proof.
intuition.
Save.

(* Why obligation from file "", line 0, characters 0-0: *)
(*Why goal*) Lemma cyclic_impl_po_12 : 
  forall (l: ((pointer) global)),
  forall (alloc: alloc_table),
  forall (tl_global: ((memory) ((pointer) global) global)),
  forall (HW_1: (* File "has_cycle.c", line 10, characters 5-14 *)
                (finite tl_global alloc l)),
  forall (HW_27: l = null),
  (0 <> 0 <-> (cyclic tl_global alloc l)).
Proof.
intuition.
inversion_clear H.
inversion_clear H0; intuition idtac.
apply Cyclic with x x0 l1_1; auto.
inversion H0; intuition.
rewrite H9 in H; elim (null_not_valid alloc); assumption.
subst; auto.
Save.

Proof.
intuition.
subst; exists (@nil pointer); auto.
exists (l1 :: nil); intuition.
subst; constructor; auto.
inversion Pre17.
elim (H l (@nil pointer)); intuition.
discriminate H.
Save.

