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

type t

exception Not_found_str of string

val empty: t

val add_var: string -> Jc_env.jc_type -> t -> t * Jc_env.var_info
val add_fun: string -> Jc_env.var_info list -> Jc_env.jc_type -> t -> t
(*val add_field: string -> Jc_env.jc_type -> Jc_env.struct_info -> t ->
  t * Jc_env.field_info
val add_constructor: string -> Jc_env.jc_type list -> Jc_env.struct_info ->
  int -> t -> t * Jc_env.field_info list
val add_struct: Jc_env.struct_info -> t -> t*)
val add_logic_fun: string -> Jc_env.var_info list -> Jc_env.jc_type option ->
  t -> t * Jc_fenv.logic_info
(*val add_tag: Jc_env.struct_info -> t -> t * Jc_env.field_info*)
val add_fun_spec: Ml_ocaml.Ident.t -> Ml_ocaml.Typedtree.function_spec -> t -> t
(*val add_type_spec: Ml_ocaml.Ident.t -> Ml_ocaml.Typedtree.type_spec -> t -> t*)

val find_var: string -> t -> Jc_env.var_info
val find_fun: string -> t -> Jc_fenv.fun_info
(*val find_field: string -> t -> Jc_env.field_info
val find_constructor: string -> t ->
  Jc_env.struct_info * int * Jc_env.field_info list
val find_struct: string -> t -> Jc_env.struct_info*)
val find_logic_fun: string -> t -> Jc_fenv.logic_info
(*val find_tag: Jc_env.struct_info -> t -> Jc_env.field_info*)
val find_fun_spec: Ml_ocaml.Ident.t -> t -> Ml_ocaml.Typedtree.function_spec
(*val find_type_spec: Ml_ocaml.Ident.t -> t -> Ml_ocaml.Typedtree.type_spec*)

(*
Local Variables: 
compile-command: "unset LANG; make -j -C .. bin/jessica.byte"
End: 
*)
