(* This file was originally generated by why.
   It can be modified; only the generated parts will be overwritten. *)

Require Export Caduceus.

(*Why logic*) Definition clr_list :
  alloc_table -> ((memory) Z) -> ((memory) pointer) -> ((memory) pointer)
  -> pointer -> plist -> Prop.
Admitted.

(*Why logic*) Definition cons : pointer -> plist -> plist.
Admitted.

(*Why logic*) Definition in_list : pointer -> plist -> Prop.
Admitted.

(*Why logic*) Definition pair_in_list : pointer -> pointer -> plist -> Prop.
Admitted.

(*Why logic*) Definition reachable :
  alloc_table -> ((memory) pointer) -> ((memory) pointer) -> pointer
  -> pointer -> Prop.
Admitted.

(*Why logic*) Definition reachable_elements :
  alloc_table -> ((memory) pointer) -> ((memory) pointer) -> pointer
  -> pointer -> plist -> Prop.
Admitted.

(*Why axiom*) Lemma reachable_refl :
  (forall (alloc:alloc_table),
   (forall (l:((memory) pointer)),
    (forall (r:((memory) pointer)),
     (* File \"schorr_waite.c\", line 31, characters 28-59 *)
     (forall (p:pointer), (reachable alloc l r p p))))).
Admitted.

(*Why logic*) Definition unmarked_reachable :
  alloc_table -> ((memory) Z) -> ((memory) pointer) -> ((memory) pointer)
  -> pointer -> pointer -> Prop.
Admitted.

(*Why logic*) Definition weight :
  alloc_table -> ((memory) Z) -> ((memory) Z) -> ((memory) pointer)
  -> ((memory) pointer) -> pointer -> pointer -> weight_type.
Admitted.

