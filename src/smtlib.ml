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



open Ident
open Options
open Misc
open Error
open Logic
open Logic_decl
open Env
open Cc
open Format
open Pp

(*s Pretty print *)

let int2U = "int2U"
let u2Int = "u2Int"


let prefix id =
  if id == t_lt then assert false
  else if id == t_le then assert false
  else if id == t_gt then assert false
  else if id == t_ge then assert false
  (* int cmp *)
  else if id == t_lt_int then "<"
  else if id == t_le_int then "<="
  else if id == t_gt_int then ">"
  else if id == t_ge_int then ">="
  (* int ops *)
  else if id == t_add_int then "+"
  else if id == t_sub_int then "-"
  else if id == t_mul_int then "*"
(*
  else if id == t_div_int then "div_int"
  else if id == t_mod_int then
    if Options.modulo then "%" else "modulo"
*)
  else if id == t_neg_int then "-"
  (* real ops *)
  else if id == t_add_real then "+"
  else if id == t_sub_real then "-"
  else if id == t_mul_real then "*"
  else if id == t_neg_real then "-"
  else if id == t_lt_real then "<"
  else if id == t_le_real then "<="
  else if id == t_gt_real then ">"
  else if id == t_ge_real then ">="
  else if id == t_div_real
       || id == t_sqrt_real
       || id == t_real_of_int
  then
    Ident.string id
  else (eprintf "%a@." Ident.print id; assert false)

let is_smtlib_keyword =
  let ht = Hashtbl.create 50  in
  List.iter (fun kw -> Hashtbl.add ht kw ())
    ["and";" benchmark";" distinct";"exists";"false";"flet";"forall";
     "if then else";"iff";"implies";"ite";"let";"logic";"not";"or";
     "sat";"theory";"true";"unknown";"unsat";"xor";
     "assumption";"axioms";"defintion";"extensions";"formula";
     "funs";"extrafuns";"extrasorts";"extrapreds";"language";
     "notes";"preds";"sorts";"status";"theory";"Int";"Real";"Bool";
     "Array";"U";"select";"store"];
  Hashtbl.mem ht

let leading_underscore s = s <> "" && s.[0] = '_'

let removeChar =
  let lc = ('\'','p')::('_','u')::('-','t')::[] in
  function s ->
    for i=0 to (String.length s)-1 do
      let c = (String.get s i) in
      try
	let c' =  List.assoc c lc  in
	Bytes.set (Bytes.of_string s) i c'
      with Not_found -> ()
    done;
    s

let idents fmt s =
  (* Yices does not expect names to begin with an underscore. *)
  if is_smtlib_keyword s || leading_underscore s then
    fprintf fmt "smtlib__%s" s
  else
    fprintf fmt "%s" s

let ident fmt id = idents fmt (Ident.string id)

let print_bvar fmt id = fprintf fmt "?%a" ident id

let rec print_term fmt = function
  | Tvar id ->
      print_bvar fmt id
  | Tconst (ConstInt n) ->
      fprintf fmt "%s" n
  | Tconst (ConstBool b) ->
      fprintf fmt "c_Boolean_%b" b
  | Tconst ConstUnit ->
      fprintf fmt "tt"
  | Tconst (ConstFloat c) ->
      Print_real.print_no_exponent fmt ~prefix_div:true c
(*
	"(real_of_int %s)"
	"(real_of_int ( * %s %s))"
	"(div_real (real_of_int %s) (real_of_int %s))"
	fmt c
*)
  | Tderef _ ->
      assert false
  | Tapp (id, [a; b; c], _) when id == if_then_else ->
      if (Options.get_types_encoding() = SortedStratified) then
	fprintf fmt
	  "@[(smtlib__ite@ %a @ %a@ %a)@]"
	   print_term a print_term b print_term c
      else
	fprintf fmt "@[(ite@ (= %a c_Boolean_true) @ %a@ %a)@]"
	  print_term a print_term b print_term c
(*
  | Tapp (id, [a], _) when id = t_real_of_int ->
      print_term fmt a
*)
  | Tapp (id, tl, _) when is_relation id || is_arith id ->
      fprintf fmt "@[(%s %a)@]" (prefix id) print_terms tl
  | Tapp (id, [], i) ->
      fprintf fmt "%a" idents (Encoding.symbol (id, i))
  | Tapp (id, tl, i) ->
      fprintf fmt "@[(%a@ %a)@]"
	idents (Encoding.symbol (id, i)) (print_list space print_term) tl
  | Tnamed (_, t) -> (* TODO: print name *)
      print_term fmt t

and print_terms fmt tl =
  print_list space print_term fmt tl

let rec print_pure_type fmt = function
  | PTint -> fprintf fmt "Int"
  | PTbool -> fprintf fmt "c_Boolean"
  | PTreal -> fprintf fmt "Real"
  | PTunit -> fprintf fmt "Unit"
  | PTexternal(_,id) when id==farray -> fprintf fmt "Array"
  | PTvar {type_val=Some pt} -> print_pure_type fmt pt
  | PTvar v -> fprintf fmt "A%d" v.tag
  | PTexternal (i,id) -> idents fmt (Encoding.symbol (id, i))

and instance fmt = function
  | [] -> ()
  | ptl -> fprintf fmt "_%a" (print_list underscore print_pure_type) ptl

let bound_variable =
  let count = ref 0 in
  function n ->
    count := !count+1 ;
    Ident.create ((removeChar (completeString n))^"_"^ (string_of_int !count))

let rec print_predicate fmt = function
  | Ptrue ->
      fprintf fmt "true"
  | Pvar id when id == Ident.default_post ->
      fprintf fmt "true"
  | Pfalse ->
      fprintf fmt "false"
  | Pvar id ->
      fprintf fmt "%a" ident id
  | Papp (id, [_t], _) when id == well_founded ->
      fprintf fmt "true;; was well founded @\n"
  | Papp (id, [a; b], _) when is_eq id ->
      fprintf fmt "@[(= %a@ %a)@]" print_term a print_term b
  | Papp (id, [a; b], _) when is_neq id ->
      fprintf fmt "@[(not (= %a@ %a))@]" print_term a print_term b
  | Papp (id, tl, _) when is_relation id || is_arith id ->
      fprintf fmt "@[(%s %a)@]" (prefix id) print_terms tl
  | Papp (id, [a;b], _) when id == t_zwf_zero ->
      (** TODO : DIRTY WAY TO translate such predicate;
	  may be previously dispatched into an inequality **)
      fprintf fmt "@[(and (<= 0 %a)@ (< %a %a))@]"
	print_term b print_term a print_term b
  | Papp (id, tl, _) when id == t_distinct ->
      fprintf fmt "@[(distinct@ %a)@]" print_terms tl
  | Papp (id, tl, i) ->
      fprintf fmt "@[(%a@ %a)@]"
	idents (Encoding.symbol (id, i)) print_terms tl
  | Pimplies (_, a, b) ->
      fprintf fmt "@[(implies@ %a@ %a)@]" print_predicate a print_predicate b
  | Pif (a, b, c) ->
      if (Options.get_types_encoding() = SortedStratified) then
      fprintf fmt "@[(if_then_else@ (= %a c_Boolean_true)@ %a@ %a)@]"
	print_term a print_predicate b print_predicate c
      else
	fprintf fmt "@[(if_then_else@ (= %a c_Boolean_true)@ %a@ %a)@]"
	  print_term a print_predicate b print_predicate c
  | Pand (_, _, a, b) | Forallb (_, a, b) ->
      fprintf fmt "@[(and@ %a@ %a)@]" print_predicate a print_predicate b
  | Por (a, b) ->
      fprintf fmt "@[(or@ %a@ %a)@]" print_predicate a print_predicate b
  | Piff (a, b) ->
      fprintf fmt "@[(iff@ %a@ %a)@]" print_predicate a print_predicate b
  | Pnot a ->
      fprintf fmt "@[(not@ %a)@]" print_predicate a
  | Forall (_,_id,n,t,_,p) ->
      (*Printf.printf "Forall : %s\n" (Ident.string id);  *)
      (*let id' = next_away id (predicate_vars p) in*)
      let id' = (bound_variable n) in
      (***Format.printf
	" Forall : %a , " Ident.dbprint n ;
      Format.printf
	" %a" Ident.dbprint id' ;**)
      let p' = subst_in_predicate (subst_onev n id') p in
      fprintf fmt "@[(forall (%a %a)@ %a)@]"
	print_bvar id' print_pure_type t print_predicate p'
  | Exists (_id,n,t,p) ->
      (*let id' = next_away id (predicate_vars p) in*)
      let id' = bound_variable n in
      let p' = subst_in_predicate (subst_onev n id') p in
      fprintf fmt "@[(exists (%a %a) %a)@]"
	print_bvar id' print_pure_type t print_predicate p'
  | Pnamed (_, p) -> (* TODO: print name *)
      print_predicate fmt p
  | Plet (_, n, _, t, p) ->
      let id' = bound_variable n in
      let s = subst_onev n id' in
      let t' = subst_in_term s t in
      let p' = subst_in_predicate s p in
      fprintf fmt "@[(let (%a %a)@ %a)@]" print_bvar id' print_term t'
	print_predicate p'

let print_axiom fmt id p =
  fprintf fmt "@[;; Why axiom %s@]@\n" id;
  fprintf fmt " @[<hov 2>:assumption@ %a@]" print_predicate p;
  fprintf fmt "@]@\n@\n"

let print_quantifiers =
  let print_quantifier fmt (x,t) =
    fprintf fmt "(%a %a)" print_bvar x print_pure_type t
  in
  print_list space print_quantifier

let pure_type_list = print_list space print_pure_type

(* Function and predicate definitions are handled in Encoding *)
(*
let print_predicate_def fmt id (bl,p) =
  let tl = List.map snd bl in
  fprintf fmt "@[:extrapreds ((%a %a))@]@\n@\n" idents id pure_type_list tl;
  fprintf fmt "@[:assumption@ (forall %a@ (iff (%a %a)@ @[%a@]))@]@\n@\n"
    print_quantifiers bl
    idents id
    (print_list space (fun fmt (x,_) -> print_bvar fmt x)) bl
    print_predicate p

let print_function_def fmt id (bl,pt,e) =
  let tl = List.map snd bl in
  fprintf fmt "@[:extrafuns ((%a %a %a))@]@\n@\n" idents id pure_type_list tl
    print_pure_type pt;
  fprintf fmt "@[:assumption@ (forall %a@ (= (%a %a)@ @[%a@]))@]@\n@\n"
    print_quantifiers bl
    idents id
    (print_list space (fun fmt (x,_) -> print_bvar fmt x)) bl
    print_term e
*)

let output_sequent fmt (hyps,concl) =
  let rec print_seq fmt = function
    | [] ->
	print_predicate fmt concl
    | Svar (id, v) :: hyps ->
	fprintf fmt "@[(forall (%a %a)@ %a)@]"
	  print_bvar id print_pure_type v print_seq hyps
(* TODO : update this for renaming each variable *)
    | Spred (_,p) :: hyps ->
	fprintf fmt "@[(implies@ %a@ %a)@]" print_predicate p print_seq hyps
  in
  print_seq fmt hyps

let print_obligation fmt loc _is_lemma _o s =
  fprintf fmt "@[:formula@\n";
  fprintf fmt "  @[;; %a@]@\n" Loc.gen_report_line loc;
  fprintf fmt "  @[(not@ %a)@]" output_sequent s;
  fprintf fmt "@]@\n@\n"
(* 

   useless since goals are split
   (moreover, may trigger a bug with Z3: proves the lemma using the aussmption given after)

  if is_lemma then begin
    fprintf fmt "@[;; %s as axiom@]@\n" o;
    fprintf fmt " @[<hov 2>:assumption@ %a@]" output_sequent s;
    fprintf fmt "@]@\n@\n"
  end
*)

let push_decl d = Encoding.push d

let iter = Encoding.iter

let reset () = Encoding.reset ()

let declare_type fmt id =
  fprintf fmt ":extrasorts (%a)@\n" ident id

let print_logic fmt id t =
  fprintf fmt ";;;; Why logic %s@\n" id;
  match t with
    | Predicate tl ->
	fprintf fmt "@[:extrapreds ((%a %a))@]@\n@\n"
	  idents id pure_type_list tl
    | Function (tl, pt) ->
	fprintf fmt "@[:extrafuns ((%a %a %a))@]@\n@\n"
	  idents id pure_type_list tl print_pure_type pt

let output_elem fmt = function
  | Dtype (_loc, id, []) -> declare_type fmt id
  | Dtype (_, id, _) ->
      fprintf fmt ";; polymorphic type %s@\n@\n" (Ident.string id)
  | Dalgtype _ ->
      assert false
(*
      failwith "SMTLIB output: algebraic types are not supported"
*)
  | Dlogic (_, id, t)  when not (Ident.is_simplify_arith id)
      -> print_logic fmt (Ident.string id) t.scheme_type
  | Dlogic (_, _, _) -> fprintf fmt ""
  | Dpredicate_def (_loc, _id, _d) ->
      assert false
(*
      print_predicate_def fmt (Ident.string id) d.scheme_type
*)
  | Dinductive_def(_loc, _ident, _inddef) ->
      assert false
(*
      failwith "SMTLIB output: inductive def not yet supported"
*)
  | Dfunction_def (_loc, _id, _d) ->
      assert false
(*
      print_function_def fmt (Ident.string id) d.scheme_type
*)
  | Daxiom (_loc, id, p) -> print_axiom fmt id p.scheme_type
  | Dgoal (loc, is_lemma, _expl, id, s) -> 
      print_obligation fmt loc is_lemma id s.Env.scheme_type




let output_file ?logic fname =
  let cout = Options.open_out_file fname in
  let fmt = formatter_of_out_channel cout in
  fprintf fmt "(benchmark %a@\n" idents (removeChar (Filename.basename fname));
  fprintf fmt "  :status unknown@\n";
  begin
    match logic with
      | None -> ()
      | Some l ->
	  fprintf fmt "  :logic %s@\n" l;
  end;
(*   if (Options.get_types_encoding() != SortedStratified) then   *)
  begin
    fprintf fmt "  :extrasorts (c_Boolean)@\n";
    fprintf fmt "  :extrafuns ((c_Boolean_true c_Boolean))@\n";
    fprintf fmt "  :extrafuns ((c_Boolean_false c_Boolean))@\n";
    fprintf fmt "  :assumption
                   (forall (?bcd c_Boolean) (or (= ?bcd c_Boolean_true)
                                            (= ?bcd c_Boolean_false)))@\n";
    fprintf fmt "  :assumption
                   (not
                      (= c_Boolean_true  c_Boolean_false))@\n";
  end;
  fprintf fmt "  :extrasorts (Unit)@\n";
  fprintf fmt "  :extrafuns ((tt Unit))@\n";
(*
  fprintf fmt "  :extrafuns ((div_int Int Int Int))@\n";
  if not modulo then begin
    fprintf fmt "  :extrafuns ((modulo Int Int Int))@\n";
  end;
*)
  iter (output_elem fmt);

  (* end of smtlib file *)
  fprintf fmt "@\n)@\n";
  pp_print_flush fmt ();
  Options.close_out_file cout


(*
Local Variables:
compile-command: "unset LANG; nice make -j -C .. bin/why.byte"
End:
*)
