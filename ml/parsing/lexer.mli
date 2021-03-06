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

(* $Id: lexer.mli,v 1.2 2007-12-05 15:12:51 bardou Exp $ *)

(* The lexical analyzer *)

val token: Lexing.lexbuf -> Parser.token
val skip_sharp_bang: Lexing.lexbuf -> unit

type error =
  | Illegal_character of char
  | Illegal_escape of string
  | Unterminated_comment
  | Unterminated_string
  | Unterminated_string_in_comment
  | Keyword_as_label of string
  | Literal_overflow of string
  | Unknown_backslash_identifer of string
  | Not_in_annotation
;;

exception Error of error * Location.t

open Format

val report_error: formatter -> error -> unit

val in_comment : unit -> bool;;
