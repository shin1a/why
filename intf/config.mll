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

{

  open Lexing
  open Tools
  open Colors

  exception Lexical_error of string
  exception Eof 

  let config_file = Filename.concat (Rc.get_home_dir ()) ".gwhyrc"

  let key = Buffer.create 128
  let string_buffer = Buffer.create 128
  let vals = Queue.create ()
  let config = Hashtbl.create 13
  let colors = Hashtbl.create 13

  let create_default_config () = 
    if not (Sys.file_exists config_file) then begin
      let out_channel = open_out config_file in
      output_string out_channel "prover = \"Simplify\"\n";
      output_string out_channel "cache = \"true\"\n";
      output_string out_channel "timeout = \"10\"\n";
      output_string out_channel "hard_proof = \"true\"\n";
      output_string out_channel "live_update = \"false\"\n";
      try close_out out_channel
      with Sys_error s -> prerr_string s
    end

  let get_values () = 
    Hashtbl.fold
      (fun k v t -> (k,v) :: t)
      config
      []

  let get_colors () =
      Hashtbl.fold 
      (fun k (fc, bc) t -> (k, fc, bc)::t)
      colors
      []

  let write_config () = 
    let out_channel = open_out config_file in
    seek_out out_channel (out_channel_length out_channel);
    output_string out_channel "# \n";
    output_string out_channel "# Configuration file auto-generated by gWhy\n";
    output_string out_channel "# \n\n";
    output_string out_channel "# Parameters \n";
    List.iter 
      (fun (k,v) -> output_string out_channel (k^ " = \""^ v ^ "\"\n"))
      [("prover", Model.prover_id (Model.get_default_prover ()));
       ("cache", string_of_bool (Cache.is_enabled ()));
       ("timeout", string_of_int (Tools.get_timeout ()));
       ("hard_proof", string_of_bool (Cache.hard_proof ()));
       ("live_update", string_of_bool (Tools.live_update ()))];
    output_string out_channel "\n# Selected provers : \"prover1\" \"prover2\" ...  \n";
    output_string out_channel "# It must be contain at least one prover. Otherwise, all valid provers will be selected.\n";
    output_string out_channel "provers = ";
    List.iter 
      (fun (p,s) -> 
	 if s then output_string out_channel ("\""^(Model.prover_id p)^"\" "))
      (Model.get_prover_states ());


    output_string out_channel "\n\n# window parameters\n";
    List.iter 
      (fun (k,v) -> 
	 output_string out_channel (k^" = \"" ^ string_of_int(v) ^ "\"\n"))
      [ "window_width", !window_width ;
	"window_height", !window_height ; 
	"font_size", !font_size ];
	   
    output_string out_channel "\n\n# Colors : color_key = \"forecolor\" \"backcolor\" \n";
    output_string out_channel "# key = {title, comment, keyword, var, ";
    output_string out_channel " predicate, lpredicate, pr_hilight, separator, ";
    output_string out_channel "hypothesis, conclusion, hilight, cc_type} \n";
    List.iter
      (fun {key=k; name=_n; fc=f; bc=b} -> output_string out_channel 
	 ("color_" ^ k ^ " = \"" ^ f ^ "\" \"" ^ b ^ "\" \n"))
      (get_all_colors ());
    try close_out out_channel; None
    with Sys_error s -> Some(s)

  let save () = 
    let w = GWindow.message_dialog 
      ~message:(match write_config () with 
		  | Some s -> s
		  | _  -> "Operation done with success !") 
      ~message_type:`INFO ~buttons:GWindow.Buttons.ok
      ~title:"Saving preferences" ~allow_grow:false
      ~modal:true ~resizable:false ()
    in ignore(w#connect#response ~callback:(fun _t -> w#destroy ()));
    ignore(w#show ())
    

  let get_value key = 
    try Hashtbl.find config key 
    with Not_found -> ""

  let is_key =
    let h = Hashtbl.create 97 in
    List.iter 
      (fun s -> Hashtbl.add h s ())
      [ "provers" ; "prover"; "cache"; "hard_proof"; "timeout"; "live_update"; "window_width"; "window_height" ; "font_size"];
    fun s -> 
      Hashtbl.mem h s

  let get_color = 
    let r_color = Str.regexp "\\color_\\([a-z]+\\)" in
    fun s -> 
      if (Str.string_match r_color s 0)
      then Some(Str.matched_group 1 s)
      else None
	
  let is_color id = match get_color id with
    | None -> false
    | _ -> true
}

let space = [' ' '\010' '\013' '\009' '\012']
let char = ['A'-'Z' 'a'-'z' '_' '0'-'9']
let ident = char+

rule token = parse
  | space+        
      { token lexbuf }
  | '#' [^ '\n']* 
      { token lexbuf }
  | ident as id
      { let ckey = Buffer.contents key in
	(if ckey = "" then 
	   () (* not needed : Buffer.add_string key id *)
	 else 
	   if ckey = "provers" then
	     if Queue.length vals = 0 then
	       () (* Model.add_all_provers () *)
	     else if Queue.length vals <> 0 then
	       Queue.iter 
		 (fun pr -> 
		      let p = Model.get_prover pr in
		      Model.select_prover p)
		 vals
	     else raise (Lexical_error "no provers selected")
	   else if Queue.length vals = 1 then
	     let p = Queue.pop vals in
	     Hashtbl.add config ckey p
	 else if Queue.length vals = 2 then
	   let fst = Queue.pop vals in
	   let snd = Queue.pop vals in
	   (match get_color ckey with 
	      | Some s -> Hashtbl.add colors s (fst, snd)
	      | None -> Format.eprintf ".gwhyrc : unknown color : %s@." ckey)
	 else Format.eprintf ".gwhyrc : invalid parameters for key (%s)@." ckey);
	Buffer.reset key;
	Queue.clear vals;
	if is_key id or is_color id then
	  Buffer.add_string key id
	else 
	  (Format.eprintf ".gwhyrc : invalid key (%s)@." id;
	   raise (Lexical_error "invalid key"))
      }
  | '='   
      { token lexbuf }
  | '"'   
      { string lexbuf }
  | _     
      { let c = lexeme_start lexbuf in
	Format.eprintf ".gwhyrc: invalid character (%d)@." c; 
	raise Eof }
  | eof   
      { let ckey = Buffer.contents key in
	(if ckey <> "" then 
	   if ckey = "provers" then
	     if Queue.length vals = 0 then
	       () (* Model.add_all_provers ()  *)
	     else if Queue.length vals <> 0 then
	        Queue.iter 
		 (fun pr -> 
		      let p = Model.get_prover pr in
		      Model.select_prover p)
		 vals
	     else raise (Lexical_error "no provers selected")
	   else if Queue.length vals = 1 then
	     let p = Queue.pop vals in
	     Hashtbl.add config ckey p
	   else if Queue.length vals = 2 then
	     let fst = Queue.pop vals in
	     let snd = Queue.pop vals in
	     (match get_color ckey with 
		| Some s -> Hashtbl.add colors s (fst, snd)
		| None -> Format.eprintf ".gwhyrc : unknown color : %s@." ckey)
	   else 
	     Format.eprintf ".gwhyrc : invalid parameters for key (%s)@." ckey);
	raise Eof }

and string = parse
  | space+ 
      { string lexbuf }
  | '"'  
      { Queue.add (Buffer.contents string_buffer) vals;
	Buffer.reset string_buffer;
	token lexbuf }
  | '\\' '"' | _ 
	{ Buffer.add_string string_buffer (lexeme lexbuf); 
	  string lexbuf }
  | eof  
      { Format.eprintf ".gwhyrc: unterminated string@.";
	raise Eof}

{

  let load () = 
    try
      let in_channel = open_in config_file in
      begin
        try
          let lexbuf = Lexing.from_channel in_channel in
          while true do
            token lexbuf;
          done
        with
	  | Eof -> ()
	  | Lexical_error s -> 
	      let w = GWindow.message_dialog 
		~message:("Invalid parameters in .gwhyrc file ("^s^") !")
		~message_type:`ERROR ~buttons:GWindow.Buttons.ok
		~title:"Saving preferences" ~allow_grow:false
		~modal:true ~resizable:false ()
	      in ignore(w#connect#response ~callback:(fun _t -> w#destroy ()));
	      ignore(w#show ())
      end;
      close_in in_channel;
    with Sys_error s ->
      begin
        print_endline ("     [...] Sys_error : "^s); flush stdout;
      end

}
