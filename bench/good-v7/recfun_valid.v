(* This file is generated by Why; do not edit *)

Require Why.
Require Export recfun_why.

Definition f1 (* validation *)
  : (x: Z)(_: `x >= 0`)(sig_1 Z [result: Z](`result = 0`))
  := [x: Z; Pre8: `x >= 0`]
       (well_founded_induction Z (Zwf ZERO) (Zwf_well_founded `0`)
         [Variant1: Z](x0: Z)(_: Variant1 = x0)(_0: `x0 >= 0`)
         (sig_1 Z [result: Z](`result = 0`))
         [Variant1: Z; wf1: (Variant2: Z)(Pre1: (Zwf `0` Variant2 Variant1))
          (x0: Z)(_: Variant2 = x0)(_0: `x0 >= 0`)
          (sig_1 Z [result: Z](`result = 0`)); x0: Z; Pre7: Variant1 = x0;
          Pre6: `x0 >= 0`]
           let (result, Bool3) =
             let (result1, Post2) = (Z_gt_le_bool x0 `0`) in
             (exist_1 [result2: bool]
             (if result2 then `x0 > 0` else `x0 <= 0`) result1 Post2) in
           Cases
             (btest
              [result:bool](if result then `x0 > 0` else `x0 <= 0`) result
              Bool3) of
           | (left Test2) =>
               let Pre5 = (f1_po_1 x Pre8 Variant1 x0 Pre7 Pre6 Test2) in
               let (result0, Post4) =
                 let Pre3 = Pre5 in
                 let Pre4 = Pre3 in
                 let (result2, Post5) =
                   ((wf1 `x0 - 1`)
                     (f1_po_2 x Pre8 Variant1 x0 Pre7 Pre6 Test2 Pre5 Pre3
                     Pre4) `x0 - 1` (refl_equal ? `x0 - 1`) Pre4) in
                 (exist_1 [result3: Z]`result3 = 0` result2 Post5) in
               (exist_1 [result1: Z]`result1 = 0` result0 Post4)
           | (right Test1) =>
               let (result0, Post3) = (exist_1 [result0: Z]`result0 = 0` 
                 x0 (f1_po_3 x Pre8 Variant1 x0 Pre7 Pre6 Test1)) in
               (exist_1 [result1: Z]`result1 = 0` result0 Post3) end 
         x x (refl_equal ? x) Pre8).

Definition f2 (* validation *)
  : (u: unit)(x: Z)(_: `x >= 0`)
    (sig_2 Z unit [x0: Z][result: unit](`x0 = 0`))
  := [u: unit; x: Z; Pre8: `x >= 0`]
       (well_founded_induction Z (Zwf ZERO) (Zwf_well_founded `0`)
         [Variant1: Z](u0: unit)(x0: Z)(_: Variant1 = x0)(_0: `x0 >= 0`)
         (sig_2 Z unit [x1: Z][result: unit](`x1 = 0`))
         [Variant1: Z; wf1: (Variant2: Z)(Pre1: (Zwf `0` Variant2 Variant1))
          (u0: unit)(x0: Z)(_: Variant2 = x0)(_0: `x0 >= 0`)
          (sig_2 Z unit [x1: Z][result: unit](`x1 = 0`)); u0: unit; x0: Z;
          Pre7: Variant1 = x0; Pre6: `x0 >= 0`]
           let (result, Bool3) =
             let (result1, Post5) = (Z_gt_le_bool x0 `0`) in
             (exist_1 [result2: bool]
             (if result2 then `x0 > 0` else `x0 <= 0`) result1 Post5) in
           Cases
             (btest
              [result:bool](if result then `x0 > 0` else `x0 <= 0`) result
              Bool3) of
           | (left Test2) =>
               let (x1, result0, Post7) =
                 let (x1, result0, Post3) =
                   let (result0, Post3) = (exist_1 [result0: Z]
                     result0 = `x0 - 1` `x0 - 1` (refl_equal ? `x0 - 1`)) in
                   (exist_2 [x2: Z][result1: unit]x2 = `x0 - 1` result0 
                   tt Post3) in
                 let Pre5 =
                   (f2_po_1 x Pre8 Variant1 x0 Pre7 Pre6 Test2 x1 Post3) in
                 let (x2, result1, Post8) =
                   let Pre3 = Pre5 in
                   let Pre4 = Pre3 in
                   let (x2, result3, Post9) =
                     ((wf1 x1)
                       (f2_po_2 x Pre8 Variant1 x0 Pre7 Pre6 Test2 x1 Post3
                       Pre5 Pre3 Pre4) tt x1 (refl_equal ? x1) Pre4) in
                   (exist_2 [x3: Z][result4: unit]`x3 = 0` x2 result3 Post9) in
                 (exist_2 [x3: Z][result2: unit]`x3 = 0` x2 result1 Post8) in
               (exist_2 [x2: Z][result1: unit]`x2 = 0` x1 result0 Post7)
           | (right Test1) =>
               let (result0, Post6) = (exist_1 [result0: unit]`x0 = 0` 
                 tt (f2_po_3 x Pre8 Variant1 x0 Pre7 Pre6 Test1)) in
               (exist_2 [x1: Z][result1: unit]`x1 = 0` x0 result0 Post6) end
         x u x (refl_equal ? x) Pre8).

Definition f3 (* validation *)
  : (a: Z)(x: Z)(_: `a >= 0`)
    (sig_2 Z unit [x0: Z][result: unit](`x0 = x + a`))
  := [a: Z; x: Z; Pre8: `a >= 0`]
       (well_founded_induction Z (Zwf ZERO) (Zwf_well_founded `0`)
         [Variant1: Z](a0: Z)(x0: Z)(_: Variant1 = a0)(_0: `a0 >= 0`)
         (sig_2 Z unit [x1: Z][result: unit](`x1 = x0 + a0`))
         [Variant1: Z; wf1: (Variant2: Z)(Pre1: (Zwf `0` Variant2 Variant1))
          (a0: Z)(x0: Z)(_: Variant2 = a0)(_0: `a0 >= 0`)
          (sig_2 Z unit [x1: Z][result: unit](`x1 = x0 + a0`)); a0: Z; x0: Z;
          Pre7: Variant1 = a0; Pre6: `a0 >= 0`]
           let (result, Bool3) =
             let (result1, Post5) = (Z_gt_le_bool a0 `0`) in
             (exist_1 [result2: bool]
             (if result2 then `a0 > 0` else `a0 <= 0`) result1 Post5) in
           Cases
             (btest
              [result:bool](if result then `a0 > 0` else `a0 <= 0`) result
              Bool3) of
           | (left Test2) =>
               let (x1, result0, Post7) =
                 let (x1, result0, Post3) =
                   let (result0, Post3) = (exist_1 [result0: Z]
                     result0 = `x0 + 1` `x0 + 1` (refl_equal ? `x0 + 1`)) in
                   (exist_2 [x2: Z][result1: unit]x2 = `x0 + 1` result0 
                   tt Post3) in
                 let Pre5 =
                   (f3_po_1 a Pre8 Variant1 a0 x0 Pre7 Pre6 Test2 x1 Post3) in
                 let (x2, result1, Post8) =
                   let Pre3 = Pre5 in
                   let Pre4 = Pre3 in
                   let (x2, result3, Post9) =
                     ((wf1 `a0 - 1`)
                       (f3_po_2 a Pre8 Variant1 a0 x0 Pre7 Pre6 Test2 x1
                       Post3 Pre5 Pre3 Pre4) `a0 - 1` x1
                       (refl_equal ? `a0 - 1`) Pre4) in
                   (exist_2 [x3: Z][result4: unit]`x3 = x1 + (a0 - 1)` 
                   x2 result3 Post9) in
                 (exist_2 [x3: Z][result2: unit]`x3 = x0 + a0` x2 result1
                 (f3_po_3 a Pre8 Variant1 a0 x0 Pre7 Pre6 Test2 x1 Post3 Pre5
                 x2 Post8)) in
               (exist_2 [x2: Z][result1: unit]`x2 = x0 + a0` x1 result0
               Post7)
           | (right Test1) =>
               let (result0, Post6) = (exist_1 [result0: unit]
                 `x0 = x0 + a0` tt
                 (f3_po_4 a Pre8 Variant1 a0 x0 Pre7 Pre6 Test1)) in
               (exist_2 [x1: Z][result1: unit]`x1 = x0 + a0` x0 result0
               Post6) end a a x (refl_equal ? a) Pre8).

Definition f4 (* validation *)
  : (a: Z)(x: Z)(_: `a >= 0`)
    (sig_3 Z Z unit [a0: Z][x0: Z][result: unit](`x0 = x + a`))
  := [a: Z; x: Z; Pre8: `a >= 0`]
       (well_founded_induction Z (Zwf ZERO) (Zwf_well_founded `0`)
         [Variant1: Z](a0: Z)(x0: Z)(_: Variant1 = a0)(_0: `a0 >= 0`)
         (sig_3 Z Z unit [a1: Z][x1: Z][result: unit](`x1 = x0 + a0`))
         [Variant1: Z; wf1: (Variant2: Z)(Pre1: (Zwf `0` Variant2 Variant1))
          (a0: Z)(x0: Z)(_: Variant2 = a0)(_0: `a0 >= 0`)
          (sig_3 Z Z unit [a1: Z][x1: Z][result: unit](`x1 = x0 + a0`));
          a0: Z; x0: Z; Pre7: Variant1 = a0; Pre6: `a0 >= 0`]
           let (result, Bool3) =
             let (result1, Post8) = (Z_gt_le_bool a0 `0`) in
             (exist_1 [result2: bool]
             (if result2 then `a0 > 0` else `a0 <= 0`) result1 Post8) in
           Cases
             (btest
              [result:bool](if result then `a0 > 0` else `a0 <= 0`) result
              Bool3) of
           | (left Test2) =>
               let (a1, x1, result0, Post10) =
                 let (x1, result0, Post5) =
                   let (result0, Post5) = (exist_1 [result0: Z]
                     result0 = `x0 + 1` `x0 + 1` (refl_equal ? `x0 + 1`)) in
                   (exist_2 [x2: Z][result1: unit]x2 = `x0 + 1` result0 
                   tt Post5) in
                 let (a1, result1, Post6) =
                   let (result1, Post6) = (exist_1 [result1: Z]
                     result1 = `a0 - 1` `a0 - 1` (refl_equal ? `a0 - 1`)) in
                   (exist_2 [a2: Z][result2: unit]a2 = `a0 - 1` result1 
                   tt Post6) in
                 let Pre5 =
                   (f4_po_1 a Pre8 Variant1 a0 x0 Pre7 Pre6 Test2 x1 Post5 a1
                   Post6) in
                 let (a2, x2, result2, Post11) =
                   let Pre3 = Pre5 in
                   let Pre4 = Pre3 in
                   let (a2, x2, result3, Post12) =
                     ((wf1 a1)
                       (f4_po_2 a Pre8 Variant1 a0 x0 Pre7 Pre6 Test2 x1
                       Post5 a1 Post6 Pre5 Pre3 Pre4) a1 x1 (refl_equal ? a1)
                       Pre4) in
                   (exist_3 [a3: Z][x3: Z][result4: unit]`x3 = x1 + a1` 
                   a2 x2 result3 Post12) in
                 (exist_3 [a3: Z][x3: Z][result3: unit]`x3 = x0 + a0` 
                 a2 x2 result2
                 (f4_po_3 a Pre8 Variant1 a0 x0 Pre7 Pre6 Test2 x1 Post5 a1
                 Post6 Pre5 x2 Post11)) in
               (exist_3 [a2: Z][x2: Z][result1: unit]`x2 = x0 + a0` a1 
               x1 result0 Post10)
           | (right Test1) =>
               let (result0, Post9) = (exist_1 [result0: unit]
                 `x0 = x0 + a0` tt
                 (f4_po_4 a Pre8 Variant1 a0 x0 Pre7 Pre6 Test1)) in
               (exist_3 [a1: Z][x1: Z][result1: unit]`x1 = x0 + a0` a0 
               x0 result0 Post9) end a a x (refl_equal ? a) Pre8).

