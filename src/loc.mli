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



open Format

(*s Line number for an absolute position *)

val report_line : formatter -> Lexing.position -> unit

(* Lexing positions *)

type position = Lexing.position * Lexing.position

exception Located of position * exn

val string : position -> string
val parse : string -> position

val dummy_position : position

type floc = string * int * int * int

val dummy_floc : floc

val extract :  position -> floc
val gen_report_line : formatter -> floc -> unit
val gen_report_position : formatter -> position -> unit
val report_position : formatter -> position -> unit
val report_obligation_position : ?onlybasename:bool -> formatter -> floc -> unit


(* for both type [t] and [position] *)

val join : 'a * 'b -> 'a * 'b -> 'a * 'b

val current_offset : int ref
val reloc : Lexing.position -> Lexing.position

(* Identifiers localization *)

val add_ident : string -> floc -> unit
val ident : string -> floc
