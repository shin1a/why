(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*          Jerome Vouillon, projet Cristal, INRIA Rocquencourt        *)
(*                                                                     *)
(*  Copyright 1997 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* $Id: includeclass.mli,v 1.1 2007-11-30 10:16:43 bardou Exp $ *)

(* Inclusion checks for the class language *)

open Types
open Typedtree
open Ctype
open Format

val class_types:
        Env.t -> class_type -> class_type -> class_match_failure list
val class_type_declarations:
        Env.t -> cltype_declaration -> cltype_declaration ->
        class_match_failure list
val class_declarations:
        Env.t -> class_declaration -> class_declaration ->
        class_match_failure list

val report_error: formatter -> class_match_failure list -> unit
