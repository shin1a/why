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



(*s Simplify's output *)

open Ident
open Options
open Misc
open Error
open Logic
open Logic_decl
open Cc
open Format
open Pp

type elem = 
  | Oblig of Loc.floc * bool * Logic_decl.vc_expl * string * sequent Env.scheme
  | Axiom of string * predicate Env.scheme
  | Predicate of string * predicate_def Env.scheme
(*
  | FunctionDef of string * function_def Env.scheme
*)

let queue = Queue.create ()

let reset () = 
  Queue.clear queue; 
  Encoding.reset ()

let rec decl_to_elem = function
  | Dgoal (loc, is_lemma, expl, id, s) -> 
      Queue.add (Oblig (loc, is_lemma, expl,id, s)) queue
  | Daxiom (_, id, p) -> 
      Queue.add (Axiom (id, p)) queue
  | Dpredicate_def (_, id, p) -> 
      Queue.add (Predicate (Ident.string id, p)) queue
  | Dfunction_def (_, _id, _p) -> 
      assert false
(*
      Queue.add (FunctionDef (Ident.string id, p)) queue
*)
  | Dinductive_def (loc, id, d) ->
      List.iter decl_to_elem (PredDefExpansor.inductive_def loc id d)
  | Dlogic _ -> ()
  | Dtype _ -> ()
  | Dalgtype _ ->  assert false


let push_decl d = Encoding.push ~encode_preds:false d

let defpred = Hashtbl.create 97

(*s Pretty print *)

let prefix_table = ref Idmap.empty

let () =
  List.iter (fun (id,s) -> prefix_table := Idmap.add id s !prefix_table)
    [ 
      (* booleans ops *)
      t_bool_and, "bool_and";
      t_bool_or, "bool_or";
      t_bool_xor, "bool_xor";
      t_bool_not, "bool_not";
      (* poly comps *)
      t_lt, "<";
      t_le, "<=";
      t_gt, ">";
      t_ge, ">=";
      (* int cmp *)
      t_lt_int, "<";
      t_le_int, "<=";
      t_gt_int, ">";
      t_ge_int, ">=";
      (* int ops *)
      t_add_int, "+";
      t_sub_int, "-";
      t_mul_int, "*";
(*
      t_div_int, "int_div";
      t_mod_int, "int_mod";
*)
      (* real ops *)
      t_add_real, "real_add";
      t_sub_real, "real_sub";
      t_mul_real, "real_mul";
      t_div_real, "real_div";
      t_neg_real, "real_neg";
      t_sqrt_real, "real_sqrt";
      t_real_of_int, "real_of_int";
      t_int_of_real, "int_of_real";
      t_lt_real, "real_lt";
      t_le_real, "real_le";
      t_gt_real, "real_gt";
      t_ge_real, "real_ge";
      t_abs_real, "real_abs";
      t_real_max, "real_max";
      t_real_min, "real_min";
      t_sqrt_real, "real_sqrt";
    ]

let is_prefix id = Idmap.mem id !prefix_table
	
let prefix id = 
  try
    Idmap.find id !prefix_table
  with Not_found -> assert false


let is_simplify_ident s =
  let is_simplify_char = function
    | 'a'..'z' | 'A'..'Z' | '0'..'9' | '_' -> true 
    | _ -> false
  in
  try 
    if String.length s >= 1 && s.[0] = '_' then raise Exit;
    String.iter (fun c -> if not (is_simplify_char c) then raise Exit) s; true
  with Exit ->
    false

let idents fmt s =
  if s = "store" then fprintf fmt "|why__store|" else
  if is_simplify_ident s then fprintf fmt "%s" s else fprintf fmt "|%s|" s

let ident fmt id = idents fmt (Ident.string id)

let sortp fmt id = idents fmt ("IS" ^ Ident.string id)

let simplify_max_int = Int64.of_string "2147483646"

let pp_exp fmt e =
  if e="" then () else
    if e.[0] = '-' then
      fprintf fmt "minus%s" (String.sub e 1 (String.length e - 1))
    else
      fprintf fmt "%s" e

let print_real fmt = function
  | RConstDecimal (i, f, e) -> 
      fprintf fmt "%s_%se%a" i f (Pp.print_option pp_exp) e
  | RConstHexa (i, f, e) -> 
      fprintf fmt "0x%s_%sp%a" i f pp_exp e

let rec print_term fmt = function
  | Tvar id -> 
      fprintf fmt "%a" ident id
  | Tconst (ConstInt n) ->
      begin try 
	let n64 = Int64.of_string n in
	if n64 < 0L || n64 > simplify_max_int then raise Exit;
	fprintf fmt "%s" n
      with _ -> (* the constant is too large for Simplify *)
	fprintf fmt "constant_too_large_%s" n
      end
  | Tconst (ConstBool b) -> 
      fprintf fmt "|@@%b|" b
  | Tconst ConstUnit -> 
      fprintf fmt "tt" (* TODO: CORRECT? *)
  | Tconst (ConstFloat c) ->
      fprintf fmt "real_constant_%a" print_real c 
(*
      Print_real.print_with_integers 
	"(real_of_int %s)" 
	"(real_of_int ( * %s %s))"
	"(div_real (real_of_int %s) (real_of_int %s))" 
	fmt c
*)
  | Tderef _ -> 
      assert false
(**
  | Tapp (id, [a; b], _) when id == access ->
      fprintf fmt "@[(select@ %a@ %a)@]" print_term a print_term b
  | Tapp (id, [a; b; c], _) when id == store ->
      fprintf fmt "@[(store@ %a@ %a@ %a)@]" 
	print_term a print_term b print_term c
**)
  | Tapp (id, [t], _) when id == t_neg_int ->
      fprintf fmt "@[(- 0 %a)@]" print_term t
  | Tapp (id, tl, _) when is_prefix id ->
      fprintf fmt "@[(%s %a)@]" (prefix id) print_terms tl
  | Tapp (id, [], _) ->
      ident fmt id
  | Tapp (id, tl, _) ->
      fprintf fmt "@[(%a@ %a)@]" 
	ident id (print_list space print_term) tl
  | Tnamed (_n, t) ->
      (*fprintf fmt "@[;;%s@\n%a@]" n pp p*) 
      print_term fmt t

and print_terms fmt tl = 
  print_list space print_term fmt tl

let rec print_pattern fmt = function
  | TPat t -> print_term fmt t
  | PPat (Papp (id, tl, inst)) -> print_term fmt (Tapp (id, tl, inst))
  | PPat _ -> Report.raise_unlocated Error.IllformedPattern
and print_patterns fmt pl =
  print_list space print_pattern fmt pl

let trigger fmt = function
  | [] -> ()
  | [TPat (Tvar _ as t)] -> fprintf fmt "(MPAT %a)" print_term t
  | [t] -> print_pattern fmt t
  | tl -> fprintf fmt "(MPAT %a)" print_patterns tl

let triggers fmt = function
  | [] -> ()
  | tl -> fprintf fmt "@ (PATS %a)" (print_list space trigger) tl

let external_type = function
  | PTexternal _ -> true
  | _ -> false

let has_type ty fmt id = match ty with
  | PTexternal([PTexternal (_,ty)], id) when id == farray ->
      fprintf fmt "(FORALL (k) (EQ (%a (select %a k)) |@@true|))" 
	sortp ty ident id
  | PTexternal(_, ty) ->
      fprintf fmt "(EQ (%a %a) |@@true|)" sortp ty ident id
  | _ -> 
      assert false

let rec print_predicate pos fmt p = 
  let pp = print_predicate pos in
  match p with
  | Ptrue ->
      fprintf fmt "TRUE"
  | Pvar id when id == Ident.default_post ->
      fprintf fmt "TRUE"
  | Pfalse ->
      fprintf fmt "FALSE"
  | Pvar id -> 
      fprintf fmt "%a" ident id
  | Papp (id, [], _) ->
      ident fmt id
  | Papp (id, tl, _) when id == t_distinct ->
      fprintf fmt "@[(DISTINCT@ %a)@]" print_terms tl
  | Papp (id, [_t], _) when id == well_founded ->
      fprintf fmt "FALSE ; was well_founded(...)@\n"
  | Papp (id, [a; b], _) when is_eq id ->
      fprintf fmt "@[(EQ %a@ %a)@]" print_term a print_term b
  | Papp (id, [a; b], _) when is_neq id ->
      fprintf fmt "@[(NEQ %a@ %a)@]" print_term a print_term b
  | Papp (id, tl, _) when is_int_comparison id ->
      fprintf fmt "@[(%s %a)@]" (prefix id) print_terms tl
  | Papp (id, [a;b], _) when id == t_zwf_zero ->
      (match get_types_encoding () with
	Stratified ->
	  fprintf fmt "@[(AND (EQ (le_int_c (c_sort c_int 0) %a) |@@true|)@ (EQ (lt_int_c %a %a) |@@true|))@]" 
	    print_term b print_term a print_term b
      | _ ->
	  fprintf fmt "@[(AND (<= 0 %a)@ (< %a %a))@]" 
	    print_term b print_term a print_term b)
  | Papp (id, tl, _) when Hashtbl.mem defpred id -> 
      fprintf fmt "@[(%a@ %a)@]" ident id print_terms tl
  | Papp (id, tl, _) -> 
      fprintf fmt "@[(EQ (%a@ %a) |@@true|)@]" ident id print_terms tl
  | Pimplies (_, a, b) ->
      fprintf fmt "@[(IMPLIES@ %a@ %a)@]" 
	(print_predicate (not pos)) a pp b
  | Piff (a, b) ->
      fprintf fmt "@[(IFF@ %a@ %a)@]" pp a pp b
  | Pif (a, b, c) ->
      fprintf fmt 
     "@[(AND@ (IMPLIES (EQ %a |@@true|) %a)@ (IMPLIES (NEQ %a |@@true|) %a))@]"
      print_term a pp b print_term a pp c
  | Pand (_, _, a, b) | Forallb (_, a, b) ->
      fprintf fmt "@[(AND@ %a@ %a)@]" pp a pp b
  | Por (a, b) ->
      fprintf fmt "@[(OR@ %a@ %a)@]" pp a pp b
  | Pnot a ->
      fprintf fmt "@[(NOT@ %a)@]" pp a
  | Forall (_,id,n,_,tl,p) 
      when simplify_triggers ||
	get_types_encoding () = Stratified ||
	get_types_encoding () = SortedStratified ->
      let id' = next_away id (predicate_vars p) in
      let s = subst_onev n id' in
      let p' = subst_in_predicate s p in
      let tl' = List.map (List.map (subst_in_pattern s)) tl in
      fprintf fmt "@[(FORALL (%a)%a@ %a)@]" ident id' triggers tl' pp p'
(*  | Forall (_,id,n,_,_,p) ->
      let id' = next_away id (predicate_vars p) in
      let p' = subst_in_predicate (subst_onev n id') p in
      fprintf fmt "@[(FORALL (%a)@ %a)@]" ident id' pp p'
*)
  | Forall _ as p ->
      let bv,p = Util.decomp_forall p in
      let var fmt (x,_) = ident fmt x in
      fprintf fmt "@[(FORALL (%a)@ %a)@]" (print_list space var) bv pp p
  | Exists (id,n,_t,p) -> 
      let id' = next_away id (predicate_vars p) in
      let p' = subst_in_predicate (subst_onev n id') p in
      fprintf fmt "@[(EXISTS (%a)@ %a)@]" ident id' pp p'
  | Pnamed (_n, p) ->
      (*fprintf fmt "@[;;%s@\n%a@]" n pp p*) 
      pp fmt p
  | Plet (_, n, _, t, p) ->
      pp fmt (subst_term_in_predicate n t p)
  (** BUG Simplify
  | Pnamed (n, p) when pos ->
      fprintf fmt "@[(LBLPOS@ |%s|@ %a)@]" n pp p
  | Pnamed (n, p) ->
      fprintf fmt "@[(LBLNEG@ |%s|@ %a)@]" n pp p
  **)

let cc_external_type = function
  | Cc.TTpure ty -> external_type ty
  | Cc.TTarray (Cc.TTpure (PTexternal _)) -> true
  | _ -> false

let cc_has_type ty fmt id = match ty with
  (*JFC :  where is it called ?*)
  | Cc.TTpure ty when external_type ty ->
      has_type ty fmt id
  | Cc.TTarray (Cc.TTpure (PTexternal(_,ty))) ->
      fprintf fmt "(FORALL (k) (EQ (%a (select %a k)) |@@true|))" 
	sortp ty ident id
  | _ -> 
      assert false

let print_sequent fmt (hyps,concl) =
  let rec print_seq fmt = function
    | [] ->
	print_predicate false fmt concl
    | Svar (id, _v) :: hyps -> 
	fprintf fmt "@[(FORALL (%a)@ %a)@]" ident id print_seq hyps
    | Spred (_,p) :: hyps -> 
	fprintf fmt "@[(IMPLIES %a@ %a)@]" 
	  (print_predicate true) p print_seq hyps
  in
  print_seq fmt hyps

let print_obligation fmt loc is_lemma _expl o s = 
  fprintf fmt "@[;; %s, %a@]@\n" o Loc.gen_report_line loc;
  fprintf fmt "@[<hov 2>%a@]@\n@\n" print_sequent s.Env.scheme_type;
  if is_lemma then begin
    fprintf fmt "@[(BG_PUSH@\n ;; lemma %s as axiom@\n" o;
    fprintf fmt "@[<hov 2>%a@])@]@\n@\n" print_sequent s.Env.scheme_type;
  end

let push_foralls p =
  let change = ref false in
  let split vars p =
    let vars_p = predicate_vars p in
    List.fold_left 
      (fun (in_p, out_p) ((_,_,b,_,_) as v) -> 
	 if Idset.mem b vars_p then v :: in_p, out_p else in_p, v :: out_p)
      ([],[]) vars
  in
  let quantify = 
    List.fold_right (fun (w,id,b,v,tl) p -> Forall (w,id,b,v,tl,p)) 
  in
  let rec push vars = function
    | Forall (w, id, b, v, tl, p) -> 
	push ((w,id,b,v,tl) :: vars) p
    | Pimplies (w, p1, p2) -> 
	let in_p1, out_p1 = split vars p1 in 
	if out_p1 <> [] then change := true;
	quantify in_p1 (Pimplies (w, p1, push out_p1 p2))
    | p ->
	quantify vars p
  in
  push [] p, !change


 let print_axiom fmt id p =
  fprintf fmt "@[(BG_PUSH@\n ;; Why axiom %s@\n" id;
  let p = p.Env.scheme_type in
  fprintf fmt " @[<hov 2>%a@]" (print_predicate true) p;
  let p,c = push_foralls p in
  if c then fprintf fmt "@\n@\n @[<hov 2>%a@]" (print_predicate true) p;
  fprintf fmt ")@]@\n@\n" 

let print_predicate fmt id p =
  let (bl,p) = p.Env.scheme_type in
  fprintf fmt "@[<hov 2>(DEFPRED @[(%a %a)@]@ @[%a@])@]@\n@\n" idents id
    (print_list space (fun fmt (x,_) -> ident fmt x)) bl
    (print_predicate false) p;
  Hashtbl.add defpred (Ident.create id) ()

let idents_plus_prefix fmt s  =
  match Ident.create s with
    id when id == t_neg_int -> (* hack *)
      fprintf fmt "@[- 0@]"
  | id when is_arith id || is_relation id ->
      fprintf fmt "%s" (prefix id)
  | _ when is_simplify_ident s ->
      fprintf fmt "%s" s
  | _ ->
      fprintf fmt "|%s|" s

(* TODO: should be handled in Encoding *)
let print_function fmt id p =
  let (bl,_pt,e) = p.Env.scheme_type in
  match bl with 
    [] -> 
      fprintf fmt "@[(BG_PUSH@\n ;; Why function %s@\n" id;
      fprintf fmt "  @[(EQ %a %a)@])@]@\n@\n" idents id	print_term e
  |_ -> 
      fprintf fmt "@[(BG_PUSH@\n ;; Why function %s@\n" id;
      fprintf fmt "  @[(FORALL (%a) (EQ (%a %a) %a))@])@]@\n@\n"
	(print_list space (fun fmt (x,_) -> ident fmt x)) bl
	idents_plus_prefix id
	(print_list space (fun fmt (x,_) -> ident fmt x)) bl 
	print_term e

let print_elem fmt = function
  | Oblig (loc, is_lemma, expl, id, s) -> 
      print_obligation fmt loc is_lemma expl id s
  | Axiom (id, p) -> print_axiom fmt id p
  | Predicate (id, p) -> print_predicate fmt id p
(*
  | FunctionDef (id, f) -> print_function fmt id f
*)

let print_file fmt =
  Encoding.iter decl_to_elem;
  fprintf fmt "(BG_PUSH (NEQ |@@true| |@@false|))@\n@\n";
  Queue.iter (print_elem fmt) queue

let output_file ~allowedit file =
  if allowedit then
    let sep = ";; DO NOT EDIT BELOW THIS LINE" in
    do_not_edit_below ~file
      ~before:(fun _fmt -> ())
      ~sep
      ~after:print_file
  else
    print_in_file print_file file

