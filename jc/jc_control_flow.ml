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


(* control-flow graph *)

open Jc_ast

type node_info =
    | Statement of expr
    | FunctionExit

type node =
    {
      node_label : int;
      node_statement : node_info;
    }


module NodeComp =
struct
  type t = node
  let compare n1 n2 = Stdlib.compare n1.node_label n2.node_label 
  let hash n = n.node_label
  let equal n1 n2 = n1.node_label = n2.node_label
end

module EdgeOrd =
struct
  type t = Forward | BackEdge
  let compare = Stdlib.compare
  let default = Forward
end

module G = 
  Graph.Imperative.Digraph.ConcreteLabeled(NodeComp)(EdgeOrd)

let node_counter = ref 0

let new_node_gen s =
  incr node_counter;
  { node_label = !node_counter; 
    node_statement = s }

let new_node s = new_node_gen (Statement s)

let rec statement g fun_exit_node s =
  match s.jc_statement_node with
    | JCSreturn_void
    | JCSreturn _ -> 
	let n = new_node s in
	G.add_vertex g n;
	G.add_edge g n fun_exit_node;
	n,[]
    | JCSif (e, s1, s2) ->
	let n = new_node s in
	G.add_vertex g n;
	let entry1,exits1 = statement g fun_exit_node s1 in
	let entry2,exits2 = statement g fun_exit_node s2 in
	G.add_edge g n entry1;
	G.add_edge g n entry2;
	n,exits1@exits2
    | JCSloop (inv, s1) ->
	let n = new_node s in
	G.add_vertex g n;
	let entry1,exits1 = statement g fun_exit_node s1 in
	List.iter (fun v -> G.add_edge g v n) exits1;
	n,[n]	
    | JCSmatch(e, psl) ->
	assert false (* TODO *)
    | JCSassign_heap (_, _, _)
    | JCSassign_var (_, _)
    | JCScall (_, _, _)
    | JCSunpack (_, _, _)
    | JCSpack (_, _, _)
    | JCSthrow (_, _)
    | JCSlabel _
    | JCStry (_, _, _)
    | JCSdecl (_, _, _)
    | JCSassert _
    | JCSblock _ -> assert false

and statement_list g fun_exit_node l =
  match l with
    | [] -> assert false
    | [s] -> statement g fun_exit_node s 
    | s::r ->
	let entry,exits = statement g fun_exit_node s in
	let entry',exits' = statement_list g fun_exit_node r in
	List.iter (fun v -> G.add_edge g v entry') exits;
	entry,exits'
	  
	
let make l =
  let g = G.create () in
  let fun_exit_node = new_node_gen FunctionExit in 
  let entry_node,exits = statement_list g fun_exit_node l in
  List.iter (fun v -> G.add_edge g v fun_exit_node) exits;
  g,entry_node,fun_exit_node


  
(*
Local Variables: 
compile-command: "LC_ALL=C make -C .. bin/jessie.byte"
End: 
*)
