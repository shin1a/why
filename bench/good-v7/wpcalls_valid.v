(* This file is generated by Why; do not edit *)

Require Why.
Require Export wpcalls_why.

Definition p (* validation *)
  : (u: unit)(x: Z)(sig_2 Z unit [x0: Z][result: unit](True))
  := [u: unit; x: Z]
       let (result, WP3) =
         let (t, Post1) = (exist_1 [result: unit]result = tt tt
           (refl_equal ? tt)) in
         let (result, WP3) = (exist_1 [result: unit]
           ((x0:Z) (`x0 = 1 - x` -> ((x1:Z) (`x1 = 1 - x0` -> `x1 = x`)))) 
           tt (p_po_1 x t Post1)) in
         (exist_1 [result0: unit]
         ((x0:Z) (`x0 = 1 - x` -> ((x1:Z) (`x1 = 1 - x0` -> `x1 = x`)))) 
         result WP3) in
       let (x0, result0, Post2) =
         let (x0, result2, Post3) = (f tt x) in
         (exist_2 [x1: Z][result3: unit]`x1 = 1 - x` x0 result2 Post3) in
       let (x1, result1, Post4) =
         let (x1, result3, Post5) = (f tt x0) in
         (exist_2 [x2: Z][result4: unit]`x2 = 1 - x0` x1 result3 Post5) in
       let Pre1 =
         let HW_3 = (WP3 x0 Post2) in
         let HW_4 = (HW_3 x1 Post4) in
         HW_4 in
       let (result2, Post6) = (exist_1 [result2: unit]True tt I) in
       (exist_2 [x2: Z][result3: unit]True x1 result2 I).

