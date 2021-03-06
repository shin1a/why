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

open Tools
open Colors

exception Save

let set_window_settings w = 
  let _ = w#event#connect#key_press ~callback:
    (fun k -> if GdkEvent.Key.keyval k = GdkKeysyms._Escape then w#destroy ();false)
  in
  w#set_modal true;
  w#set_skip_pager_hint true;
  w#set_skip_pager_hint true

let colors r () =
  let w = GWindow.window 
    ~allow_grow:false ~allow_shrink:true
    ~border_width:20
    ~title:"Colors" () in
  let quit result () = 
    List.iter
      (fun (k, tf, tb) -> Colors.replace_color k (tf#text) (tb#text))
      result;
    w#destroy ();
    r ()
  in
  let vbox = GPack.vbox ~homogeneous:false ~packing:w#add () in
  let table = GPack.table ~homogeneous:true ~packing:vbox#add () in
  (* colors *)
  let colors_l = GMisc.label ~text:"Colors (forecolor, backcolor)" () in
  table#attach ~left:0 ~top:0 ~right:3 (colors_l#coerce);
  let r = ref 2 in
  let result = 
    List.map
      (fun {key=k; name=n; fc=f; bc=b} -> 
	 let l = GMisc.label ~text:n () in
	 let tf = GEdit.entry ~text:f () in
	 let tb = GEdit.entry ~text:b () in
	 table#attach ~left:0 ~top:!r (l#coerce);
	 table#attach ~left:1 ~top:!r (tf#coerce);
	 table#attach ~left:2 ~top:!r (tb#coerce);
	 incr r;
	 (k, tf, tb))
      (Colors.get_all_colors ()) in
  
  let hbox = GPack.hbox ~homogeneous:true ~packing:vbox#add () in
  let button_ok = GButton.button ~label:"OK" ~stock:`OK ~packing:hbox#add () in
  let _ = button_ok#connect#clicked ~callback:(quit result) in
  let button_cancel = GButton.button ~label:"Cancel" ~stock:`CANCEL ~packing:hbox#add () in
  let _ = button_cancel#connect#clicked ~callback:(w#destroy) in
  
  (* window settings *)
  set_window_settings w;
  w#show ()
  

(* Main *)
let show window_type refresh () = 
  ignore (GtkMain.Main.init ());
  (match window_type with
     | Color -> colors refresh ()
     | _ -> ());
  GtkThread.main ()
