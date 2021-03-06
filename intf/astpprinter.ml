(**************************************************************************)
(*                                                                        *)
(*  The Why platform for program certification                            *)
(*                                                                        *)
(*  Copyright (C) 2002-2011                                               *)
(*                                                                        *)
(*    Jean-Christophe FILLIATRE, CNRS & Univ. Paris-sud 11                *)
(*    Claude MARCHE, INRIA & Univ. Paris-sud 11                           *)
(*    Yannick MOY, Univ. Paris-sud 11                                     *)
(*    Romain BARDOU, Univ. Paris-sud 11                                   *)
(*                                                                        *)
(*  Secondary contributors:                                               *)
(*                                                                        *)
(*    Thierry HUBERT, Univ. Paris-sud 11  (former Caduceus front-end)     *)
(*    Nicolas ROUSSET, Univ. Paris-sud 11 (on Jessie & Krakatoa)          *)
(*    Ali AYAD, CNRS & CEA Saclay         (floating-point support)        *)
(*    Sylvie BOLDO, INRIA                 (floating-point support)        *)
(*    Jean-Francois COUCHOT, INRIA        (sort encodings, hyps pruning)  *)
(*    Mehdi DOGGUY, Univ. Paris-sud 11    (Why GUI)                       *)
(*                                                                        *)
(*  This software is free software; you can redistribute it and/or        *)
(*  modify it under the terms of the GNU Lesser General Public            *)
(*  License version 2.1, with the special exception on linking            *)
(*  described in file LICENSE.                                            *)
(*                                                                        *)
(*  This software is distributed in the hope that it will be useful,      *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  *)
(*                                                                        *)
(**************************************************************************)

open Logic
open Cc
open Ident
open Format
open Misc
open Pp
open Tags
open Astprinter

let print_term fmt t = 
  let rec print0 fmt t =
    print1 fmt t
  and print1 fmt = function
    | Tapp (id, [a;b], _) when id == t_add_int || id == t_add_real ->
	fprintf fmt "%a +@ %a" print1 a print2 b
    | Tapp (id, [a;b], _) when id == t_sub_int || id == t_sub_real ->
	fprintf fmt "%a -@ %a" print1 a print2 b
    | t ->
	print2 fmt t
  and print2 fmt = function
    | Tapp (id, [a;b], _) when id == t_mul_int || id == t_mul_real ->
	fprintf fmt "%a *@ %a" print2 a print3 b
    | Tapp (id, [a;b], _) when (* id == t_div_int || *) id == t_div_real ->
	fprintf fmt "@[%a /@ %a@]" print2 a print3 b
(*
    | Tapp (id, [a;b], _) when id == t_mod_int ->
	fprintf fmt "@[%a@ %%@ %a@]" print2 a print3 b
*)
    | t ->
	print3 fmt t
  and print3 fmt = function
    | Tconst (ConstInt n) -> 
	fprintf fmt "%s" n
    | Tconst (ConstBool b) -> 
	fprintf fmt "%b" b
    | Tconst ConstUnit -> 
	fprintf fmt "tt" 
    | Tconst (ConstFloat c) -> 
	Print_real.print fmt c
    | Tvar id when id == implicit ->
	fprintf fmt "<?>"
    | Tvar id when id == t_zwf_zero ->
	fprintf fmt "<Zwf(0)>"
    | Tvar id | Tapp (id, [], _) -> 
	Ident.print fmt id
    | Tderef _ ->
	assert false
    | Tapp (id, _, _) as t when Ident.string id = "acc" ->
	print_fct_acc fmt t
    | Tapp (id, _, _) as t when Ident.string id = "shift" ->
	print_fct_shift fmt t
    | Tapp (id, [t], _) when id == t_neg_int || id == t_neg_real ->
	fprintf fmt "(- %a)" print3 t
    | Tapp (id, [_;_], _) as t when is_int_arith_binop id ->
	fprintf fmt "@[(%a)@]" print0 t
    | Tapp (id, [a; b; c], _) when id == if_then_else -> 
	fprintf fmt "(@[if %a then@ %a else@ %a@])" print0 a print0 b print0 c
    | Tapp (id, tl, _) -> 
	fprintf fmt "@[%s(%a)@]" (Ident.string id) print_terms tl
    | Tnamed (User n, t) ->
	(match (Tools.grab_infos n) with
	   | None -> fprintf fmt "@[%a@]" print3 t
	   | Some l ->
	       let n = new_tag l in
	       pp_open_tag fmt n;
	       fprintf fmt "@[%a@]" print3 t;
	       pp_close_tag fmt ()
	)
    | Tnamed (Internal _n, t) ->
	fprintf fmt "@[%a@]" print3 t
  and print_terms fmt tl =
    print_list comma print3 fmt tl
  and is_shift = function 
    | Tapp (id, _, _) when (Ident.string id = "shift") -> true
    | _ -> false
  and print_fct_acc fmt = function
	| Tapp (_id, [m; term], _) -> 
	    if (is_shift term) 
	    then fprintf fmt "%a{%a}" print_fct_acc_shift term print3 m
	    else fprintf fmt "%a{%a}" print3 term print3 m
	| t -> print3 fmt t
  and print_fct_acc_shift fmt = function 
    | Tapp (_id, [p; offset], _) -> fprintf fmt "%a[%a]" print3 p print3 offset;
    | t -> print3 fmt t
  and print_fct_shift fmt = function
	 | Tapp (_id, [p; offset], _) -> 
	     fprintf fmt "%a + %a" print3 p print3 offset
	 | t -> print3 fmt t
  in
  print1 fmt t

let pprefix_id id =
  if id == t_lt || id == t_lt_int || id == t_lt_real then "<" 
  else if id == t_le || id == t_le_int || id == t_le_real then "<="
  else if id == t_gt || id == t_gt_int || id == t_gt_real then ">"
  else if id == t_ge || id == t_ge_int || id == t_ge_real then ">="
  else if is_eq id then "=="
  else if is_neq id then "!="
  else assert false

let print_predicate fmt p =
  let rec print0 fmt = function
    | Pif (a, b, c) -> 
	fprintf fmt "(@[if %a@ then %a@ else %a@])"
	  print_term a print0 b print0 c
    | Pimplies (_, a, b) -> 
	fprintf fmt "@[%a =>@ %a@]" print1 a print0 b
    | Piff (a, b) -> 
	fprintf fmt "@[%a <=>@ %a@]" print1 a print0 b
    | p -> print1 fmt p
  and print1 fmt = function
    | Por (a, b) -> fprintf fmt "@[%a ||@ %a@]" print2 a print1 b
    | p -> print2 fmt p
  and print2 fmt = function
    | Pand (_, _, a, b) -> 
	fprintf fmt "@[%a &&@ %a@]" print3 a print2 b
    | Forallb (_, a, b) -> 
        fprintf fmt "@[%a &&@ %a@]" print3 a print2 b
    | p -> print3 fmt p
  and print3 fmt = function
    | Ptrue -> 
	fprintf fmt "\\true"
    | Pvar id when id == Ident.default_post ->
	fprintf fmt "\\true"
    | Pfalse -> 
	fprintf fmt "\\false"
    | Pvar id -> 
	Ident.print fmt id
    | Papp (id, [t], _) when id == well_founded ->
	fprintf fmt "@[well_founded(%a)@]" print_term t
    | Papp (id, [a;b], _) when id == t_zwf_zero -> 
	fprintf fmt "(@[0 <= %a && %a < %a@])" 
	  print_term b print_term a print_term b
    | Papp (id, [a;b], _) when is_relation id ->
	fprintf fmt "@[%a %s@ %a@]" 
	  print_term a (pprefix_id id) print_term b
    | Papp (id, l, _) ->
	fprintf fmt "@[%a(%a)@]" Ident.print id
	  (print_list comma print_term) l
    | Pnot p -> 
	fprintf fmt "! %a" print3 p
    | Forall (_,id,n,t,_,p) -> 
	let id' = next_away id (predicate_vars p) in
	let p' = subst_in_predicate (subst_onev n id') p in
	fprintf fmt "(@[\\forall %a %s;@ %a@])" 
	  print_pure_type t (Ident.string id') print0 p'
    | Exists (id,n,t,p) -> 
	let id' = next_away id (predicate_vars p) in
	let p' = subst_in_predicate (subst_onev n id') p in
	fprintf fmt "(@[\\exists %a %s;@ %a@])"
	  print_pure_type t (Ident.string id') print0 p'
    | Plet (id,n,_, t,p) -> 
	let id' = next_away id (predicate_vars p) in
	let p' = subst_in_predicate (subst_onev n id') p in
	fprintf fmt "(@[let %s = %a in@ %a@])"
	  (Ident.string id') print_term t print0 p'
    | Pnamed (User n, p) ->
	(match (Tools.grab_infos n) with
	   | None -> fprintf fmt "@[%a@]" print3 p
	   | Some l ->
	       let n = new_tag l in
	       pp_open_tag fmt n;
	       fprintf fmt "@[%a@]" print3 p;
	       pp_close_tag fmt ()
	)
    | Pnamed (Internal _n, p) ->
	fprintf fmt "@[%a@]" print3 p
    | (Por _ | Piff _ | Pand _ | Pif _ | Pimplies _ | Forallb _) as p -> 
	fprintf fmt "@[(%a)@]" print0 p
  in
  print0 fmt p
