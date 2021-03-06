(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*           Damien Doligez, projet Cristal, INRIA Rocquencourt        *)
(*                                                                     *)
(*  Copyright 2004 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* $Id: unused_var.mli,v 1.1 2007-11-30 10:16:44 bardou Exp $ *)

val warn : Format.formatter -> Parsetree.structure -> Parsetree.structure;;
(* Warn on unused variables; return the second argument. *)
