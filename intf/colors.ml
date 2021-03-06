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



let window_width = ref 1024
let window_height = ref 768

let colorblind = ref false

let font_size = ref 10
let font_family = "Monospace"

type color = {
  key : string;
  name : string;
  fc : string;
  bc : string;
}

let changed = ref false

let colors = [
  {key="title"; name="Title"; fc="brown"; bc="lightgreen"};
  {key="comment"; name="Commentary"; fc="red"; bc="white"};
  {key="keyword"; name="Keyword"; fc="darkgreen"; bc="white"};
  {key="var"; name="Variable"; fc="darkgreen"; bc="white"};
  {key="predicate"; name="Predicate"; fc="blue"; bc="white"};
  {key="lpredicate"; name="Predicate (localised)"; fc="blue"; bc="lightyellow"};
  {key="pr_hilight"; name="Predicate (Hilight)"; fc="red"; bc="lightgreen"};
  {key="separator"; name="Separator"; fc="red"; bc="white"};
  {key="hypothesis"; name="Hypothesis"; fc="orange"; bc="white"};
  {key="conclusion"; name="Conclusion"; fc="blue"; bc="white"};
  {key="hilight"; name="Hilight"; fc="black"; bc="yellow"};
  {key="cc_type"; name="Type"; fc="darkgreen"; bc="white"}]

let fcolors = Hashtbl.create 13
let bcolors = Hashtbl.create 13
let kcolors = Hashtbl.create 13

let add_color k item fc bc = 
  Hashtbl.add kcolors k item;
  if fc <> "black" then begin 
    Hashtbl.add fcolors k fc 
  end;  
  if bc <> "white" then begin 
    Hashtbl.add bcolors k bc 
  end  

let _ = 
  List.iter
    (fun c -> add_color c.key c.name c.fc c.bc)
    colors

let get_fc ty = 
  (try Hashtbl.find fcolors ty with Not_found -> "black")

let get_bc ty = 
  (try Hashtbl.find bcolors ty with Not_found -> "white")

let get_color ty = 
  (get_fc ty) , (get_bc ty)

let get_fc_predicate () = 
  get_fc "lpredicate"

let get_bc_predicate () = 
  get_bc "lpredicate"

let color_exists ty = 
  (Hashtbl.mem fcolors ty) or (Hashtbl.mem bcolors ty)

let get_all_colors () = 
  List.map 
    (fun {key=k; name=n; fc=_; bc=_} -> 
       {key=k; name=n; fc=(get_fc k); bc=(get_bc k)})
    colors

let set_all_colors l = 
  List.iter 
    (fun (k, f, b) -> 
       Hashtbl.replace fcolors k f;
       Hashtbl.replace bcolors k b)
    l

let replace_color k f b = 
  changed := true;
  Hashtbl.replace fcolors k f;
  Hashtbl.replace bcolors k b

let has_changed () = !changed
