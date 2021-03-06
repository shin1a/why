(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* $Id: typemod.ml,v 1.8 2007-12-20 17:10:01 bardou Exp $ *)

(* Type-checking of the module language *)

open Misc
open Longident
open Path
open Asttypes
open Parsetree
open Types
open Typedtree
open Format

type error =
    Unbound_module of Longident.t
  | Unbound_modtype of Longident.t
  | Cannot_apply of module_type
  | Not_included of Includemod.error list
  | Cannot_eliminate_dependency of module_type
  | Signature_expected
  | Structure_expected of module_type
  | With_no_component of Longident.t
  | With_mismatch of Longident.t * Includemod.error list
  | Repeated_name of string * string
  | Non_generalizable of type_expr
  | Non_generalizable_class of Ident.t * class_declaration
  | Non_generalizable_module of module_type
  | Implementation_is_required of string
  | Interface_not_compiled of string

exception Error of Location.t * error

(* Extract a signature from a module type *)

let extract_sig env loc mty =
  match Mtype.scrape env mty with
    Tmty_signature sg -> sg
  | _ -> raise(Error(loc, Signature_expected))

let extract_sig_open env loc mty =
  match Mtype.scrape env mty with
    Tmty_signature sg -> sg
  | _ -> raise(Error(loc, Structure_expected mty))

(* Lookup the type of a module path *)

let type_module_path env loc lid =
  try
    Env.lookup_module lid env
  with Not_found ->
    raise(Error(loc, Unbound_module lid))

(* Record a module type *)
let rm node =
  Stypes.record (Stypes.Ti_mod node);
  node

(* Merge one "with" constraint in a signature *)

let rec add_rec_types env = function
    Tsig_type(id, decl, Trec_next) :: rem ->
      add_rec_types (Env.add_type id decl env) rem
  | _ -> env

let check_type_decl env id row_id newdecl decl rs rem =
  let env = Env.add_type id newdecl env in
  let env =
    match row_id with None -> env | Some id -> Env.add_type id newdecl env in
  let env = if rs = Trec_not then env else add_rec_types env rem in
  Includemod.type_declarations env id newdecl decl

let merge_constraint initial_env loc sg lid constr =
  let rec merge env sg namelist row_id =
    match (sg, namelist, constr) with
      ([], _, _) ->
        raise(Error(loc, With_no_component lid))
    | (Tsig_type(id, decl, rs) :: rem, [s],
       Pwith_type ({ptype_kind = Ptype_private} as sdecl))
      when Ident.name id = s ->
        let decl_row =
          { type_params =
              List.map (fun _ -> Btype.newgenvar()) sdecl.ptype_params;
            type_arity = List.length sdecl.ptype_params;
            type_kind = Type_abstract;
            type_manifest = None;
            type_variance =
              List.map (fun (c,n) -> (not n, not c, not c))
              sdecl.ptype_variance }
        and id_row = Ident.create (s^"#row") in
        let initial_env = Env.add_type id_row decl_row initial_env in
        let newdecl = Typedecl.transl_with_constraint
                        initial_env id (Some(Pident id_row)) sdecl in
        check_type_decl env id row_id newdecl decl rs rem;
        let decl_row = {decl_row with type_params = newdecl.type_params} in
        let rs' = if rs = Trec_first then Trec_not else rs in
        Tsig_type(id_row, decl_row, rs') :: Tsig_type(id, newdecl, rs) :: rem
    | (Tsig_type(id, decl, rs) :: rem, [s], Pwith_type sdecl)
      when Ident.name id = s ->
        let newdecl =
          Typedecl.transl_with_constraint initial_env id None sdecl in
        check_type_decl env id row_id newdecl decl rs rem;
        Tsig_type(id, newdecl, rs) :: rem
    | (Tsig_type(id, decl, rs) :: rem, [s], Pwith_type sdecl)
      when Ident.name id = s ^ "#row" ->
        merge env rem namelist (Some id)
    | (Tsig_module(id, mty, rs) :: rem, [s], Pwith_module lid)
      when Ident.name id = s ->
        let (path, mty') = type_module_path initial_env loc lid in
        let newmty = Mtype.strengthen env mty' path in
        ignore(Includemod.modtypes env newmty mty);
        Tsig_module(id, newmty, rs) :: rem
    | (Tsig_module(id, mty, rs) :: rem, s :: namelist, _)
      when Ident.name id = s ->
        let newsg = merge env (extract_sig env loc mty) namelist None in
        Tsig_module(id, Tmty_signature newsg, rs) :: rem
    | (item :: rem, _, _) ->
        item :: merge (Env.add_item item env) rem namelist row_id in
  try
    merge initial_env sg (Longident.flatten lid) None
  with Includemod.Error explanation ->
    raise(Error(loc, With_mismatch(lid, explanation)))

(* Add recursion flags on declarations arising from a mutually recursive
   block. *)

let map_rec fn decls rem =
  match decls with
  | [] -> rem
  | d1 :: dl -> fn Trec_first d1 :: map_end (fn Trec_next) dl rem

let rec map_rec' fn decls rem =
  match decls with
  | (id,_ as d1) :: dl when Btype.is_row_name (Ident.name id) ->
      fn Trec_not d1 :: map_rec' fn dl rem
  | _ -> map_rec fn decls rem

(* Auxiliary for translating recursively-defined module types.
   Return a module type that approximates the shape of the given module
   type AST.  Retain only module, type, and module type
   components of signatures.  For types, retain only their arity,
   making them abstract otherwise. *)

let approx_modtype transl_mty init_env smty =

  let rec approx_mty env smty =
    match smty.pmty_desc with
      Pmty_ident lid ->
        begin try
          let (path, info) = Env.lookup_modtype lid env in
          Tmty_ident path
        with Not_found ->
          raise(Error(smty.pmty_loc, Unbound_modtype lid))
        end
    | Pmty_signature ssg ->
        Tmty_signature(approx_sig env ssg)
    | Pmty_functor(param, sarg, sres) ->
        let arg = approx_mty env sarg in
        let (id, newenv) = Env.enter_module param arg env in
        let res = approx_mty newenv sres in
        Tmty_functor(id, arg, res)
    | Pmty_with(sbody, constraints) ->
        approx_mty env sbody

  and approx_sig env ssg =
    match ssg with
      [] -> []
    | item :: srem ->
        match item.psig_desc with
        | Psig_type sdecls ->
            let decls = Typedecl.approx_type_decl env sdecls in
            let rem = approx_sig env srem in
            map_rec' (fun rs (id, info) -> Tsig_type(id, info, rs)) decls rem
        | Psig_module(name, smty) ->
            let mty = approx_mty env smty in
            let (id, newenv) = Env.enter_module name mty env in
            Tsig_module(id, mty, Trec_not) :: approx_sig newenv srem
        | Psig_recmodule sdecls ->
            let decls =
              List.map
                (fun (name, smty) ->
                  (Ident.create name, approx_mty env smty))
                sdecls in
            let newenv =
              List.fold_left (fun env (id, mty) -> Env.add_module id mty env)
              env decls in
            map_rec (fun rs (id, mty) -> Tsig_module(id, mty, rs)) decls
                    (approx_sig newenv srem)
        | Psig_modtype(name, sinfo) ->
            let info = approx_mty_info env sinfo in
            let (id, newenv) = Env.enter_modtype name info env in
            Tsig_modtype(id, info) :: approx_sig newenv srem
        | Psig_open lid ->
            let (path, mty) = type_module_path env item.psig_loc lid in
            let sg = extract_sig_open env item.psig_loc mty in
            let newenv = Env.open_signature path sg env in
            approx_sig newenv srem
        | Psig_include smty ->
            let mty = transl_mty init_env smty in
            let sg = Subst.signature Subst.identity
                       (extract_sig env smty.pmty_loc mty) in
            let newenv = Env.add_signature sg env in
            sg @ approx_sig newenv srem
        | Psig_class sdecls | Psig_class_type sdecls ->
            let decls = Typeclass.approx_class_declarations env sdecls in
            let rem = approx_sig env srem in
            List.flatten
              (map_rec
                (fun rs (i1, d1, i2, d2, i3, d3) ->
                  [Tsig_cltype(i1, d1, rs);
                   Tsig_type(i2, d2, rs);
                   Tsig_type(i3, d3, rs)])
                decls [rem])
        | _ ->
            approx_sig env srem

  and approx_mty_info env sinfo =
    match sinfo with
      Pmodtype_abstract ->
        Tmodtype_abstract
    | Pmodtype_manifest smty ->
        Tmodtype_manifest(approx_mty env smty)

  in approx_mty init_env smty

(* Additional validity checks on type definitions arising from
   recursive modules *)

let check_recmod_typedecls env sdecls decls =
  let recmod_ids = List.map fst decls in
  List.iter2
    (fun (_, smty) (id, mty) ->
      List.iter
        (fun path ->
          Typedecl.check_recmod_typedecl env smty.pmty_loc recmod_ids
                                         path (Env.find_type path env))
        (Mtype.type_paths env (Pident id) mty))
    sdecls decls

(* Auxiliaries for checking uniqueness of names in signatures and structures *)

module StringSet = Set.Make(struct type t = string let compare = compare end)

let check cl loc set_ref name =
  if StringSet.mem name !set_ref
  then raise(Error(loc, Repeated_name(cl, name)))
  else set_ref := StringSet.add name !set_ref

let check_sig_item type_names module_names modtype_names loc = function
    Tsig_type(id, _, _) ->
      check "type" loc type_names (Ident.name id)
  | Tsig_module(id, _, _) ->
      check "module" loc module_names (Ident.name id)
  | Tsig_modtype(id, _) ->
      check "module type" loc modtype_names (Ident.name id)
  | _ -> ()

(* Check and translate a module type expression *)

let rec transl_modtype env smty =
  match smty.pmty_desc with
    Pmty_ident lid ->
      begin try
        let (path, info) = Env.lookup_modtype lid env in
        Tmty_ident path
      with Not_found ->
        raise(Error(smty.pmty_loc, Unbound_modtype lid))
      end
  | Pmty_signature ssg ->
      Tmty_signature(transl_signature env ssg)
  | Pmty_functor(param, sarg, sres) ->
      let arg = transl_modtype env sarg in
      let (id, newenv) = Env.enter_module param arg env in
      let res = transl_modtype newenv sres in
      Tmty_functor(id, arg, res)
  | Pmty_with(sbody, constraints) ->
      let body = transl_modtype env sbody in
      let init_sg = extract_sig env sbody.pmty_loc body in
      let final_sg =
        List.fold_left
          (fun sg (lid, sdecl) ->
            merge_constraint env smty.pmty_loc sg lid sdecl)
          init_sg constraints in
      Mtype.freshen (Tmty_signature final_sg)

and transl_signature env sg =
  let type_names = ref StringSet.empty
  and module_names = ref StringSet.empty
  and modtype_names = ref StringSet.empty in
  let rec transl_sig env sg =
    Ctype.init_def(Ident.current_time());
    match sg with
      [] -> []
    | item :: srem ->
        match item.psig_desc with
        | Psig_value(name, sdesc) ->
            let desc = Typedecl.transl_value_decl env sdesc in
            let (id, newenv) = Env.enter_value name desc env in
            let rem = transl_sig newenv srem in
            Tsig_value(id, desc) :: rem
        | Psig_type sdecls ->
            List.iter
              (fun (name, decl) -> check "type" item.psig_loc type_names name)
              sdecls;
            let (decls, newenv) = Typedecl.transl_type_decl env sdecls in
            let rem = transl_sig newenv srem in
            map_rec' (fun rs (id, info) -> Tsig_type(id, info, rs)) decls rem
        | Psig_exception(name, sarg) ->
            let arg = Typedecl.transl_exception env sarg in
            let (id, newenv) = Env.enter_exception name arg env in
            let rem = transl_sig newenv srem in
            Tsig_exception(id, arg) :: rem
        | Psig_module(name, smty) ->
            check "module" item.psig_loc module_names name;
            let mty = transl_modtype env smty in
            let (id, newenv) = Env.enter_module name mty env in
            let rem = transl_sig newenv srem in
            Tsig_module(id, mty, Trec_not) :: rem
        | Psig_recmodule sdecls ->
            List.iter
              (fun (name, smty) ->
                 check "module" item.psig_loc module_names name)
              sdecls;
            let (decls, newenv) =
              transl_recmodule_modtypes item.psig_loc env sdecls in
            let rem = transl_sig newenv srem in
            map_rec (fun rs (id, mty) -> Tsig_module(id, mty, rs)) decls rem
        | Psig_modtype(name, sinfo) ->
            check "module type" item.psig_loc modtype_names name;
            let info = transl_modtype_info env sinfo in
            let (id, newenv) = Env.enter_modtype name info env in
            let rem = transl_sig newenv srem in
            Tsig_modtype(id, info) :: rem
        | Psig_open lid ->
            let (path, mty) = type_module_path env item.psig_loc lid in
            let sg = extract_sig_open env item.psig_loc mty in
            let newenv = Env.open_signature path sg env in
            transl_sig newenv srem
        | Psig_include smty ->
            let mty = transl_modtype env smty in
            let sg = Subst.signature Subst.identity
                       (extract_sig env smty.pmty_loc mty) in
            List.iter
              (check_sig_item type_names module_names modtype_names
                              item.psig_loc)
              sg;
            let newenv = Env.add_signature sg env in
            let rem = transl_sig newenv srem in
            sg @ rem
        | Psig_class cl ->
            List.iter
              (fun {pci_name = name} ->
                 check "type" item.psig_loc type_names name)
              cl;
            let (classes, newenv) = Typeclass.class_descriptions env cl in
            let rem = transl_sig newenv srem in
            List.flatten
              (map_rec
                 (fun rs (i, d, i', d', i'', d'', i''', d''', _, _, _) ->
                    [Tsig_class(i, d, rs);
                     Tsig_cltype(i', d', rs);
                     Tsig_type(i'', d'', rs);
                     Tsig_type(i''', d''', rs)])
                 classes [rem])
        | Psig_class_type cl ->
            List.iter
              (fun {pci_name = name} ->
                 check "type" item.psig_loc type_names name)
              cl;
            let (classes, newenv) = Typeclass.class_type_declarations env cl in
            let rem = transl_sig newenv srem in
            List.flatten
              (map_rec
                 (fun rs (i, d, i', d', i'', d'') ->
                    [Tsig_cltype(i, d, rs);
                     Tsig_type(i', d', rs);
                     Tsig_type(i'', d'', rs)])
                 classes [rem])
    in transl_sig env sg

and transl_modtype_info env sinfo =
  match sinfo with
    Pmodtype_abstract ->
      Tmodtype_abstract
  | Pmodtype_manifest smty ->
      Tmodtype_manifest(transl_modtype env smty)

and transl_recmodule_modtypes loc env sdecls =
  let make_env curr =
    List.fold_left
      (fun env (id, mty) -> Env.add_module id mty env)
      env curr in
  let transition env_c curr =
    List.map2
      (fun (_, smty) (id, mty) -> (id, transl_modtype env_c smty))
      sdecls curr in
  let init =
    List.map
      (fun (name, smty) ->
        (Ident.create name, approx_modtype transl_modtype env smty))
      sdecls in
  let first = transition (make_env init) init in
  let final_env = make_env first in
  let final_decl = transition final_env init in
  check_recmod_typedecls final_env sdecls final_decl;
  (final_decl, final_env)

(* Try to convert a module expression to a module path. *)

exception Not_a_path

let rec path_of_module mexp =
  match mexp.mod_desc with
    Tmod_ident p -> p
  | Tmod_apply(funct, arg, coercion) ->
      Papply(path_of_module funct, path_of_module arg)
  | _ -> raise Not_a_path

(* Check that all core type schemes in a structure are closed *)

let rec closed_modtype = function
    Tmty_ident p -> true
  | Tmty_signature sg -> List.for_all closed_signature_item sg
  | Tmty_functor(id, param, body) -> closed_modtype body

and closed_signature_item = function
    Tsig_value(id, desc) -> Ctype.closed_schema desc.val_type
  | Tsig_module(id, mty, _) -> closed_modtype mty
  | _ -> true

let check_nongen_scheme env = function
    Tstr_value(rec_flag, pat_exp_list) ->
      List.iter
        (fun (pat, exp) ->
          if not (Ctype.closed_schema exp.exp_type) then
            raise(Error(exp.exp_loc, Non_generalizable exp.exp_type)))
        pat_exp_list
  | Tstr_module(id, md) ->
      if not (closed_modtype md.mod_type) then
        raise(Error(md.mod_loc, Non_generalizable_module md.mod_type))
  | _ -> ()

let check_nongen_schemes env str =
  List.iter (check_nongen_scheme env) str

(* Extract the list of "value" identifiers bound by a signature.
   "Value" identifiers are identifiers for signature components that
   correspond to a run-time value: values, exceptions, modules, classes.
   Note: manifest primitives do not correspond to a run-time value! *)

let rec bound_value_identifiers = function
    [] -> []
  | Tsig_value(id, {val_kind = Val_reg}) :: rem ->
      id :: bound_value_identifiers rem
  | Tsig_exception(id, decl) :: rem -> id :: bound_value_identifiers rem
  | Tsig_module(id, mty, _) :: rem -> id :: bound_value_identifiers rem
  | Tsig_class(id, decl, _) :: rem -> id :: bound_value_identifiers rem
  | _ :: rem -> bound_value_identifiers rem

(* Helpers for typing recursive modules *)

let anchor_submodule name anchor =
  match anchor with None -> None | Some p -> Some(Pdot(p, name, nopos))
let anchor_recmodule id anchor =
  Some (Pident id)

let enrich_type_decls anchor decls oldenv newenv =
  match anchor with
    None -> newenv
  | Some p ->
      List.fold_left
        (fun e (id, info) ->
          let info' =
            Mtype.enrich_typedecl oldenv (Pdot(p, Ident.name id, nopos)) info
          in
            Env.add_type id info' e)
        oldenv decls

let enrich_module_type anchor name mty env =
  match anchor with
    None -> mty
  | Some p -> Mtype.enrich_modtype env (Pdot(p, name, nopos)) mty

(* Type a module value expression *)

let rec type_module anchor env smod =
  match smod.pmod_desc with
    Pmod_ident lid ->
      let (path, mty) = type_module_path env smod.pmod_loc lid in
      rm { mod_desc = Tmod_ident path;
           mod_type = Mtype.strengthen env mty path;
           mod_env = env;
           mod_loc = smod.pmod_loc }
  | Pmod_structure sstr ->
      let (str, sg, finalenv) = type_structure anchor env sstr in
      rm { mod_desc = Tmod_structure str;
           mod_type = Tmty_signature sg;
           mod_env = env;
           mod_loc = smod.pmod_loc }
  | Pmod_functor(name, smty, sbody) ->
      let mty = transl_modtype env smty in
      let (id, newenv) = Env.enter_module name mty env in
      let body = type_module None newenv sbody in
      rm { mod_desc = Tmod_functor(id, mty, body);
           mod_type = Tmty_functor(id, mty, body.mod_type);
           mod_env = env;
           mod_loc = smod.pmod_loc }
  | Pmod_apply(sfunct, sarg) ->
      let funct = type_module None env sfunct in
      let arg = type_module None env sarg in
      begin match Mtype.scrape env funct.mod_type with
        Tmty_functor(param, mty_param, mty_res) as mty_functor ->
          let coercion =
            try
              Includemod.modtypes env arg.mod_type mty_param
            with Includemod.Error msg ->
              raise(Error(sarg.pmod_loc, Not_included msg)) in
          let mty_appl =
            try
              let path = path_of_module arg in
              Subst.modtype (Subst.add_module param path Subst.identity)
                            mty_res
            with Not_a_path ->
              try
                Mtype.nondep_supertype
                  (Env.add_module param arg.mod_type env) param mty_res
              with Not_found ->
                raise(Error(smod.pmod_loc,
                            Cannot_eliminate_dependency mty_functor)) in
          rm { mod_desc = Tmod_apply(funct, arg, coercion);
               mod_type = mty_appl;
               mod_env = env;
               mod_loc = smod.pmod_loc }
      | _ ->
          raise(Error(sfunct.pmod_loc, Cannot_apply funct.mod_type))
      end
  | Pmod_constraint(sarg, smty) ->
      let arg = type_module anchor env sarg in
      let mty = transl_modtype env smty in
      let coercion =
        try
          Includemod.modtypes env arg.mod_type mty
        with Includemod.Error msg ->
          raise(Error(sarg.pmod_loc, Not_included msg)) in
      rm { mod_desc = Tmod_constraint(arg, mty, coercion);
           mod_type = mty;
           mod_env = env;
           mod_loc = smod.pmod_loc }

and type_structure anchor env sstr =
  let type_names = ref StringSet.empty
  and module_names = ref StringSet.empty
  and modtype_names = ref StringSet.empty in
  let rec type_struct env sstr =
    Ctype.init_def(Ident.current_time());
    match sstr with
      [] ->
        ([], [], env)
    | {pstr_desc = Pstr_eval sexpr} :: srem ->
        let expr = Typecore.type_expression env sexpr in
        let (str_rem, sig_rem, final_env) = type_struct env srem in
        (Tstr_eval expr :: str_rem, sig_rem, final_env)
    | {pstr_desc = Pstr_value(rec_flag, sdefs)} :: srem ->
        let (defs, newenv) =
          Typecore.type_binding env rec_flag sdefs in
        let (str_rem, sig_rem, final_env) = type_struct newenv srem in
        let bound_idents = let_bound_idents defs in
        let make_sig_value id =
          Tsig_value(id, Env.find_value (Pident id) newenv) in
        (Tstr_value(rec_flag, defs) :: str_rem,
         map_end make_sig_value bound_idents sig_rem,
         final_env)
    | {pstr_desc = Pstr_primitive(name, sdesc)} :: srem ->
        let desc = Typedecl.transl_value_decl env sdesc in
        let (id, newenv) = Env.enter_value name desc env in
        let (str_rem, sig_rem, final_env) = type_struct newenv srem in
        (Tstr_primitive(id, desc) :: str_rem,
         Tsig_value(id, desc) :: sig_rem,
         final_env)
    | {pstr_desc = Pstr_type sdecls; pstr_loc = loc} :: srem ->
        List.iter
          (fun (name, decl) -> check "type" loc type_names name)
          sdecls;
        let (decls, newenv) = Typedecl.transl_type_decl env sdecls in
        let newenv' =
          enrich_type_decls anchor decls env newenv in
        let (str_rem, sig_rem, final_env) = type_struct newenv' srem in
        (Tstr_type decls :: str_rem,
         map_rec' (fun rs (id, info) -> Tsig_type(id, info, rs)) decls sig_rem,
         final_env)
    | {pstr_desc = Pstr_exception(name, sarg)} :: srem ->
        let arg = Typedecl.transl_exception env sarg in
        let (id, newenv) = Env.enter_exception name arg env in
        let (str_rem, sig_rem, final_env) = type_struct newenv srem in
        (Tstr_exception(id, arg) :: str_rem,
         Tsig_exception(id, arg) :: sig_rem,
         final_env)
    | {pstr_desc = Pstr_exn_rebind(name, longid); pstr_loc = loc} :: srem ->
        let (path, arg) = Typedecl.transl_exn_rebind env loc longid in
        let (id, newenv) = Env.enter_exception name arg env in
        let (str_rem, sig_rem, final_env) = type_struct newenv srem in
        (Tstr_exn_rebind(id, path) :: str_rem,
         Tsig_exception(id, arg) :: sig_rem,
         final_env)
    | {pstr_desc = Pstr_module(name, smodl); pstr_loc = loc} :: srem ->
        check "module" loc module_names name;
        let modl = type_module  (anchor_submodule name anchor) env smodl in
        let mty = enrich_module_type anchor name modl.mod_type env in
        let (id, newenv) = Env.enter_module name mty env in
        let (str_rem, sig_rem, final_env) = type_struct newenv srem in
        (Tstr_module(id, modl) :: str_rem,
         Tsig_module(id, modl.mod_type, Trec_not) :: sig_rem,
         final_env)
    | {pstr_desc = Pstr_recmodule sbind; pstr_loc = loc} :: srem ->
        List.iter
          (fun (name, _, _) -> check "module" loc module_names name)
          sbind;
        let (decls, newenv) =
          transl_recmodule_modtypes loc env
            (List.map (fun (name, smty, smodl) -> (name, smty)) sbind) in
        let type_recmodule_binding (id, mty) (name, smty, smodl) =
          let modl =
            type_module (anchor_recmodule id anchor) newenv smodl in
          let coercion =
            try
              Includemod.modtypes newenv
                 (Mtype.strengthen env modl.mod_type (Pident id))
                 mty
            with Includemod.Error msg ->
              raise(Error(smodl.pmod_loc, Not_included msg)) in
          let modl' =
            { mod_desc = Tmod_constraint(modl, mty, coercion);
              mod_type = mty;
              mod_env = newenv;
              mod_loc = smodl.pmod_loc } in
          (id, modl') in
        let bind = List.map2 type_recmodule_binding decls sbind in
        let (str_rem, sig_rem, final_env) = type_struct newenv srem in
        (Tstr_recmodule bind :: str_rem,
         map_rec (fun rs (id, modl) -> Tsig_module(id, modl.mod_type, rs))
                 bind sig_rem,
         final_env)
    | {pstr_desc = Pstr_modtype(name, smty); pstr_loc = loc} :: srem ->
        check "module type" loc modtype_names name;
        let mty = transl_modtype env smty in
        let (id, newenv) = Env.enter_modtype name (Tmodtype_manifest mty) env in
        let (str_rem, sig_rem, final_env) = type_struct newenv srem in
        (Tstr_modtype(id, mty) :: str_rem,
         Tsig_modtype(id, Tmodtype_manifest mty) :: sig_rem,
         final_env)
    | {pstr_desc = Pstr_open lid; pstr_loc = loc} :: srem ->
        let (path, mty) = type_module_path env loc lid in
        let sg = extract_sig_open env loc mty in
        type_struct (Env.open_signature path sg env) srem
    | {pstr_desc = Pstr_class cl; pstr_loc = loc} :: srem ->
         List.iter
           (fun {pci_name = name} -> check "type" loc type_names name)
           cl;
        let (classes, new_env) = Typeclass.class_declarations env cl in
        let (str_rem, sig_rem, final_env) = type_struct new_env srem in
        (Tstr_class
           (List.map (fun (i, d, _,_,_,_,_,_, s, m, c) ->
              let vf = if d.cty_new = None then Virtual else Concrete in
              (i, s, m, c, vf)) classes) ::
         Tstr_cltype
           (List.map (fun (_,_, i, d, _,_,_,_,_,_,_) -> (i, d)) classes) ::
         Tstr_type
           (List.map (fun (_,_,_,_, i, d, _,_,_,_,_) -> (i, d)) classes) ::
         Tstr_type
           (List.map (fun (_,_,_,_,_,_, i, d, _,_,_) -> (i, d)) classes) ::
         str_rem,
         List.flatten
           (map_rec
              (fun rs (i, d, i', d', i'', d'', i''', d''', _, _, _) ->
                 [Tsig_class(i, d, rs);
                  Tsig_cltype(i', d', rs);
                  Tsig_type(i'', d'', rs);
                  Tsig_type(i''', d''', rs)])
              classes [sig_rem]),
         final_env)
    | {pstr_desc = Pstr_class_type cl; pstr_loc = loc} :: srem ->
        List.iter
          (fun {pci_name = name} -> check "type" loc type_names name)
          cl;
        let (classes, new_env) = Typeclass.class_type_declarations env cl in
        let (str_rem, sig_rem, final_env) = type_struct new_env srem in
        (Tstr_cltype
           (List.map (fun (i, d, _, _, _, _) -> (i, d)) classes) ::
         Tstr_type
           (List.map (fun (_, _, i, d, _, _) -> (i, d)) classes) ::
         Tstr_type
           (List.map (fun (_, _, _, _, i, d) -> (i, d)) classes) ::
         str_rem,
         List.flatten
           (map_rec
              (fun rs (i, d, i', d', i'', d'') ->
                 [Tsig_cltype(i, d, rs);
                  Tsig_type(i', d', rs);
                  Tsig_type(i'', d'', rs)])
              classes [sig_rem]),
         final_env)
    | {pstr_desc = Pstr_include smodl; pstr_loc = loc} :: srem ->
        let modl = type_module None env smodl in
        (* Rename all identifiers bound by this signature to avoid clashes *)
        let sg = Subst.signature Subst.identity
                   (extract_sig_open env smodl.pmod_loc modl.mod_type) in
        List.iter
          (check_sig_item type_names module_names modtype_names loc) sg;
        let new_env = Env.add_signature sg env in
        let (str_rem, sig_rem, final_env) = type_struct new_env srem in
        (Tstr_include (modl, bound_value_identifiers sg) :: str_rem,
         sg @ sig_rem,
         final_env)
    | {pstr_desc = Pstr_function_spec fs; pstr_loc = loc} :: srem ->
	(* function *)
	let fun_path, fun_vd = try
	  Env.lookup_value (Lident fs.pfs_name) env;
	with Not_found ->
	  raise (Typecore.Error(loc, Typecore.Unbound_value
				  (Lident fs.pfs_name)))
	in
	(* arguments *)
	let args, spec_env = List.fold_left
	  (fun (args, env) name ->
	     let desc = {
	       val_type = Ctype.newvar ();
	       val_kind = Val_reg;
	     } in
	     let id, new_env = Env.enter_value name desc env in
	     id::args, new_env)
	  ([], env)
	  fs.pfs_arguments
	in
	(* \result *)
	let res_ty =
	  let rec rightmost_type te = match te.desc with
	    | Tarrow(_, _, x, _) -> rightmost_type x
	    | Tlink x -> rightmost_type x
	    | x -> te
	  in
	  rightmost_type fun_vd.val_type
	in
	let res_vd = {
	  val_type = res_ty;
	  val_kind = Val_reg;
	} in
	let _, result_env = Env.enter_value "\\result" res_vd spec_env in
	(* typed spec *)
	let tfs = {
	  fs_function = fun_path;
	  fs_arguments = List.rev args;
	  fs_requires =
	    begin match fs.pfs_requires with
	      | None -> None
	      | Some x -> Some (Typecore.type_expression spec_env x)
	    end;
	  fs_behaviors = List.map
	    (fun b -> {
	       b_name = b.pb_name;
	       b_ensures = Typecore.type_expression result_env b.pb_ensures;
	     })
	    fs.pfs_behaviors;
	} in
	(* finish *)
        let (str_rem, sig_rem, final_env) = type_struct env srem in
        (Tstr_function_spec tfs :: str_rem, sig_rem, final_env)
    | {pstr_desc = Pstr_type_spec ts; pstr_loc = loc} :: srem ->
	(* type *)
	let type_path, type_decl = try
	  Env.lookup_type (Lident ts.pts_name) env;
	with Not_found ->
	  raise (Typetexp.Error(loc, Typetexp.Unbound_type_constructor
				  (Lident ts.pts_name)))
	in
	(* invariants *)
	let invariants, new_env = List.fold_left
	  (fun (acc, env) i ->
	     let env, inv = Typecore.type_invariant env
	       (Ctype.newconstr type_path []) i in
	     inv::acc, env)
	  ([], env)
	  ts.pts_invariants
	in
	(* typed spec *)
	let tts = {
	  ts_type = type_path;
	  ts_invariants = List.rev invariants;
	} in
	(* finish *)
        let (str_rem, sig_rem, final_env) = type_struct new_env srem in
        (Tstr_type_spec tts :: str_rem, sig_rem, final_env)
    | {pstr_desc = Pstr_logic_function_spec lfs; pstr_loc = loc} :: srem ->
	let new_env, tlfs = Typecore.type_logic_function env loc lfs in
        let (str_rem, sig_rem, final_env) = type_struct new_env srem in
        (Tstr_logic_function_spec tlfs :: str_rem, sig_rem, final_env)
    | {pstr_desc = Pstr_logic_type_spec lts; pstr_loc = loc} :: srem ->
	let td = {
	  type_params = [];
	  type_arity = 0;
	  type_kind = Type_abstract;
	  type_manifest = None;
	  type_variance = [];
	} in
	let type_id, new_env = Env.enter_type lts td env in
        let (str_rem, sig_rem, final_env) = type_struct new_env srem in
        (Tstr_logic_type_spec(type_id, td) :: str_rem, sig_rem, final_env)
    | {pstr_desc = Pstr_axiom_spec axs; pstr_loc = loc} :: srem ->
	let taxs = Typecore.type_axiom env axs in
        let (str_rem, sig_rem, final_env) = type_struct env srem in
        (Tstr_axiom_spec taxs :: str_rem, sig_rem, final_env)
  in
  if !Clflags.save_types
  then List.iter (function {pstr_loc = l} -> Stypes.record_phrase l) sstr;
  type_struct env sstr

let type_module = type_module None
let type_structure = type_structure None

(* Fill in the forward declaration *)
let _ =
  Typecore.type_module := type_module

(* Normalize types in a signature *)

let rec normalize_modtype env = function
    Tmty_ident p -> ()
  | Tmty_signature sg -> normalize_signature env sg
  | Tmty_functor(id, param, body) -> normalize_modtype env body

and normalize_signature env = List.iter (normalize_signature_item env)

and normalize_signature_item env = function
    Tsig_value(id, desc) -> Ctype.normalize_type env desc.val_type
  | Tsig_module(id, mty, _) -> normalize_modtype env mty
  | _ -> ()

(* Simplify multiple specifications of a value or an exception in a signature.
   (Other signature components, e.g. types, modules, etc, are checked for
   name uniqueness.)  If multiple specifications with the same name,
   keep only the last (rightmost) one. *)

let rec simplify_modtype mty =
  match mty with
    Tmty_ident path -> mty
  | Tmty_functor(id, arg, res) -> Tmty_functor(id, arg, simplify_modtype res)
  | Tmty_signature sg -> Tmty_signature(simplify_signature sg)

and simplify_signature sg =
  let rec simplif val_names exn_names res = function
    [] -> res
  | (Tsig_value(id, descr) as component) :: sg ->
      let name = Ident.name id in
      simplif (StringSet.add name val_names) exn_names
              (if StringSet.mem name val_names then res else component :: res)
              sg
  | (Tsig_exception(id, decl) as component) :: sg ->
      let name = Ident.name id in
      simplif val_names (StringSet.add name exn_names)
              (if StringSet.mem name exn_names then res else component :: res)
              sg
  | Tsig_module(id, mty, rs) :: sg ->
      simplif val_names exn_names
              (Tsig_module(id, simplify_modtype mty, rs) :: res) sg
  | component :: sg ->
      simplif val_names exn_names (component :: res) sg
  in
    simplif StringSet.empty StringSet.empty [] (List.rev sg)

(* Typecheck an implementation file *)

let type_implementation sourcefile outputprefix modulename initial_env ast =
  Typecore.reset_delayed_checks ();
  let (str, sg, finalenv) =
    Misc.try_finally (fun () -> type_structure initial_env ast)
                     (fun () -> Stypes.dump (outputprefix ^ ".annot"))
  in
  let simple_sg = simplify_signature sg in
  Typecore.force_delayed_checks ();
  if !Clflags.print_types then begin
    fprintf std_formatter "%a@." Printtyp.signature simple_sg;
    (str, Tcoerce_none)   (* result is ignored by Compile.implementation *)
  end else begin
    let sourceintf =
      Misc.chop_extension_if_any sourcefile ^ !Config.interface_suffix in
    if Sys.file_exists sourceintf then begin
      let intf_file =
        try
          find_in_path_uncap !Config.load_path (modulename ^ ".cmi")
        with Not_found ->
          raise(Error(Location.none, Interface_not_compiled sourceintf)) in
      let dclsig = Env.read_signature modulename intf_file in
      let coercion = Includemod.compunit sourcefile sg intf_file dclsig in
      (str, coercion)
    end else begin
      check_nongen_schemes finalenv str;
      normalize_signature finalenv sg;
      let coercion =
        Includemod.compunit sourcefile sg
                            "(inferred signature)" simple_sg in
      if not !Clflags.dont_write_files then
        Env.save_signature simple_sg modulename (outputprefix ^ ".cmi");
      (str, coercion)
    end
  end

(* "Packaging" of several compilation units into one unit
   having them as sub-modules.  *)

let rec package_signatures subst = function
    [] -> []
  | (name, sg) :: rem ->
      let sg' = Subst.signature subst sg in
      let oldid = Ident.create_persistent name
      and newid = Ident.create name in
      Tsig_module(newid, Tmty_signature sg', Trec_not) ::
      package_signatures (Subst.add_module oldid (Pident newid) subst) rem

let package_units objfiles cmifile modulename =
  (* Read the signatures of the units *)
  let units =
    List.map
      (fun f ->
         let pref = chop_extensions f in
         let modname = String.capitalize(Filename.basename pref) in
         let sg = Env.read_signature modname (pref ^ ".cmi") in
         if Filename.check_suffix f ".cmi" &&
            not(Mtype.no_code_needed_sig Env.initial sg)
         then raise(Error(Location.none, Implementation_is_required f));
         (modname, Env.read_signature modname (pref ^ ".cmi")))
      objfiles in
  (* Compute signature of packaged unit *)
  Ident.reinit();
  let sg = package_signatures Subst.identity units in
  (* See if explicit interface is provided *)
  let mlifile =
    chop_extension_if_any cmifile ^ !Config.interface_suffix in
  if Sys.file_exists mlifile then begin
    if not (Sys.file_exists cmifile) then begin
      raise(Error(Location.in_file mlifile, Interface_not_compiled mlifile))
    end;
    let dclsig = Env.read_signature modulename cmifile in
    Includemod.compunit "(obtained by packing)" sg mlifile dclsig
  end else begin
    (* Determine imports *)
    let unit_names = List.map fst units in
    let imports =
      List.filter
        (fun (name, crc) -> not (List.mem name unit_names))
        (Env.imported_units()) in
    (* Write packaged signature *)
    Env.save_signature_with_imports sg modulename cmifile imports;
    Tcoerce_none
  end

(* Error report *)

open Printtyp

let report_error ppf = function
  | Unbound_module lid -> fprintf ppf "Unbound module %a" longident lid
  | Unbound_modtype lid -> fprintf ppf "Unbound module type %a" longident lid
  | Cannot_apply mty ->
      fprintf ppf
        "@[This module is not a functor; it has type@ %a@]" modtype mty
  | Not_included errs ->
      fprintf ppf
        "@[<v>Signature mismatch:@ %a@]" Includemod.report_error errs
  | Cannot_eliminate_dependency mty ->
      fprintf ppf
        "@[This functor has type@ %a@ \
           The parameter cannot be eliminated in the result type.@  \
           Please bind the argument to a module identifier.@]" modtype mty
  | Signature_expected -> fprintf ppf "This module type is not a signature"
  | Structure_expected mty ->
      fprintf ppf
        "@[This module is not a structure; it has type@ %a" modtype mty
  | With_no_component lid ->
      fprintf ppf
        "@[The signature constrained by `with' has no component named %a@]"
        longident lid
  | With_mismatch(lid, explanation) ->
      fprintf ppf
        "@[<v>\
           @[In this `with' constraint, the new definition of %a@ \
             does not match its original definition@ \
             in the constrained signature:@]@ \
           %a@]"
        longident lid Includemod.report_error explanation
  | Repeated_name(kind, name) ->
      fprintf ppf
        "@[Multiple definition of the %s name %s.@ \
           Names must be unique in a given structure or signature.@]" kind name
  | Non_generalizable typ ->
      fprintf ppf
        "@[The type of this expression,@ %a,@ \
           contains type variables that cannot be generalized@]" type_scheme typ
  | Non_generalizable_class (id, desc) ->
      fprintf ppf
        "@[The type of this class,@ %a,@ \
           contains type variables that cannot be generalized@]"
        (class_declaration id) desc
  | Non_generalizable_module mty ->
      fprintf ppf
        "@[The type of this module,@ %a,@ \
           contains type variables that cannot be generalized@]" modtype mty
  | Implementation_is_required intf_name ->
      fprintf ppf
        "@[The interface %s@ declares values, not just types.@ \
           An implementation must be provided.@]" intf_name
  | Interface_not_compiled intf_name ->
      fprintf ppf
        "@[Could not find the .cmi file for interface@ %s.@]" intf_name
