(* This file is generated by Why; do not edit *)

Require Why.
Require Export set_why.

Definition p (* validation *)
  : (x: Z)(sig_2 Z Z [x0: Z][result: Z](`result = 1`))
  := [x: Z]
       let (x0, result, Bool1) =
         let (x0, result1, Post2) = (set_and_test_zero `0` x) in
         (exist_2 [x1: Z][result2: bool]`x1 = 0` /\
         ((if result2 then `x1 = 0` else `x1 <> 0`)) x0 result1 Post2) in
       Cases
         (btest
          [result:bool]`x0 = 0` /\ ((if result then `x0 = 0` else `x0 <> 0`)) result
          Bool1) of
       | (left Test2) =>
           let (result0, Post4) = (exist_1 [result0: Z]`result0 = 1` 
             `1` (refl_equal ? `1`)) in
           (exist_2 [x1: Z][result1: Z]`result1 = 1` x0 result0 Post4)
       | (right Test1) =>
           let (result0, Post3) = (exist_1 [result0: Z]`result0 = 1` 
             `2` (p_po_1 x0 Test1)) in
           (exist_2 [x1: Z][result1: Z]`result1 = 1` x0 result0 Post3) end.

Definition p2 (* validation *)
  : (x: Z)(y: Z)(_: `y >= 0`)
    (sig_3 Z Z unit [x0: Z][y0: Z][result: unit](`y0 = 0`))
  := [x: Z; y: Z; Pre6: `y >= 0`]
       (well_founded_induction Z (Zwf ZERO) (Zwf_well_founded `0`)
         [Variant1: Z](x0: Z)(y0: Z)(_: Variant1 = y0)(_0: `y0 >= 0`)
         (sig_3 Z Z unit [x1: Z][y1: Z][result: unit](`y1 = 0`))
         [Variant1: Z; wf1: (Variant2: Z)(Pre1: (Zwf `0` Variant2 Variant1))
          (x0: Z)(y0: Z)(_: Variant2 = y0)(_0: `y0 >= 0`)
          (sig_3 Z Z unit [x1: Z][y1: Z][result: unit](`y1 = 0`)); x0: Z;
          y0: Z; Pre5: Variant1 = y0; Pre4: `y0 >= 0`]
           let (x1, result, Bool1) =
             let (x1, result1, Post3) = (set_and_test_nzero y0 x0) in
             (exist_2 [x2: Z][result2: bool]`x2 = y0` /\
             ((if result2 then `x2 <> 0` else `x2 = 0`)) x1 result1 Post3) in
           Cases
             (btest
              [result:bool]`x1 = y0` /\
              ((if result then `x1 <> 0` else `x1 = 0`)) result Bool1) of
           | (left Test2) =>
               let Pre3 = Pre4 in
               let (x2, y1, result0, Post5) =
                 let (y1, result0, Post2) =
                   let (y1, result0, Post1) =
                     let (result0, Post1) = (exist_1 [result0: Z]
                       result0 = `y0 - 1` `y0 - 1`
                       (refl_equal ? `y0 - 1`)) in
                     (exist_2 [y2: Z][result1: unit]y2 = `y0 - 1` result0 
                     tt Post1) in
                   (exist_2 [y2: Z][result1: unit]`y2 >= 0` /\
                   (Zwf `0` y2 y0) y1 result0
                   (p2_po_1 y Pre6 Variant1 y0 Pre5 Pre4 x1 Test2 Pre3 y1
                   Post1)) in
                 ((wf1 y1) (loop_variant_1 Pre5 Post2) x1 y1
                   (refl_equal ? y1) (proj1 ? ? Post2)) in
               (exist_3 [x3: Z][y2: Z][result1: unit]`y2 = 0` x2 y1 result0
               Post5)
           | (right Test1) =>
               let Pre2 = Pre4 in
               let (x2, y1, result0, Post4) = (exist_3 [x2: Z][y1: Z]
                 [result0: unit]`y1 = 0` x1 y0 tt
                 (p2_po_2 y Pre6 Variant1 y0 Pre5 Pre4 x1 Test1 Pre2)) in
               (exist_3 [x3: Z][y2: Z][result1: unit]`y2 = 0` x2 y1 result0
               Post4) end y x y (refl_equal ? y) Pre6).

Definition p3 (* validation *)
  : (x: Z)(y: Z)(_: `y >= 0`)
    (sig_3 Z Z unit [x0: Z][y0: Z][result: unit](`y0 = 0`))
  := [x: Z; y: Z; Pre4: `y >= 0`]
       let (x0, y0, result, Post4) =
         (well_founded_induction Z (Zwf ZERO) (Zwf_well_founded `0`)
           [Variant1: Z](x0: Z)(y0: Z)(_: Variant1 = y0)(_0: `y0 >= 0`)
           (sig_3 Z Z (EM unit unit) [x1: Z][y1: Z][result: (EM unit unit)]
            (((qcomb [result0: unit]`y1 = 0` [result0: unit]`y1 = 0`) result)))
           [Variant1: Z; wf1: (Variant2: Z)
            (Pre1: (Zwf `0` Variant2 Variant1))(x0: Z)(y0: Z)
            (_: Variant2 = y0)(_0: `y0 >= 0`)
            (sig_3 Z Z (EM unit unit) [x1: Z][y1: Z][result: (EM unit unit)]
             (((qcomb [result0: unit]`y1 = 0` [result0: unit]`y1 = 0`) result)));
            x0: Z; y0: Z; Pre3: Variant1 = y0; Pre2: `y0 >= 0`]
             let (result, Post5) = (exist_1 [result: bool]result = true 
               true (refl_equal ? true)) in
             Cases (btest [result:bool]result = true result Post5) of
             | (left Test2) =>
                 let (x1, y1, result0, Post8) =
                   let (x1, y1, result0, Post9) =
                     let (x1, result0, WP7) =
                       let (x1, b, Post10) =
                         let (x1, result2, Post11) =
                           (set_and_test_nzero y0 x0) in
                         (exist_2 [x2: Z][result3: bool]`x2 = y0` /\
                         ((if result3 then `x2 <> 0` else `x2 = 0`)) 
                         x1 result2 Post11) in
                       let (result0, WP7) = (exist_1 [result0: bool]
                         (if result0
                          then ((y:Z)
                                (y = `y0 - 1` -> `y >= 0` /\ (Zwf `0` y y0)))
                          else `y0 = 0`) b
                         (p3_po_1 y Pre4 Variant1 y0 Pre3 Pre2 Test2 x1 b
                         Post10)) in
                       (exist_2 [x2: Z][result1: bool]
                       (if result1
                        then ((y:Z)
                              (y = `y0 - 1` -> `y >= 0` /\ (Zwf `0` y y0)))
                        else `y0 = 0`) x1
                       result0 WP7) in
                     Cases
                       (btest
                        [result0:bool]
                        (if result0
                         then ((y:Z)
                               (y = `y0 - 1` -> `y >= 0` /\ (Zwf `0` y y0)))
                         else `y0 = 0`) result0
                        WP7) of
                     | (left WP8) =>
                         let (y1, result1, Post2) =
                           let (y1, result1, Post1) =
                             let (result1, Post1) = (exist_1 [result1: Z]
                               result1 = `y0 - 1` `y0 - 1`
                               (refl_equal ? `y0 - 1`)) in
                             (exist_2 [y2: Z][result2: unit]
                             y2 = `y0 - 1` result1 tt Post1) in
                           (exist_2 [y2: Z][result2: unit]`y2 >= 0` /\
                           (Zwf `0` y2 y0) y1 result1
                           let HW_1 = (WP8 y1 Post1) in
                           HW_1) in
                         (exist_3 [x2: Z][y2: Z]
                         (qcomb [result2: unit]`y2 = 0` [result2: unit]
                          `y2 >= 0` /\ (Zwf `0` y2 y0)) x1
                         y1 (Val unit result1) Post2)
                     | (right WP8) =>
                         let (result1, Post12) =
                           (exist_1 (qcomb [result1: unit]`y0 = 0`
                                     [result1: unit]`y0 >= 0` /\
                                     (Zwf `0` y0 y0)) (Exn unit tt) WP8) in
                         Cases (decomp1 Post12) of
                         | (Qval (exist result2 Post2)) => (exist_3 [x2: Z]
                           [y1: Z]
                           (qcomb [result3: unit]`y1 = 0` [result3: unit]
                            `y1 >= 0` /\ (Zwf `0` y1 y0)) x1 y0
                           (Val unit result2) Post2)
                         | (Qexn _ WP1) => (exist_3 [x2: Z][y1: Z]
                           (qcomb [result2: unit]`y1 = 0` [result2: unit]
                            `y1 >= 0` /\ (Zwf `0` y1 y0)) x1 y0 (Exn unit tt)
                           WP1)
                         end end in
                   Cases (decomp1 Post9) of
                   | (Qval (exist result1 Post2)) =>
                     ((wf1 y1) (loop_variant_1 Pre3 Post2) x1 y1
                       (refl_equal ? y1) (proj1 ? ? Post2))
                   | (Qexn _ WP1) => (exist_3 [x2: Z][y2: Z]
                     (qcomb [result1: unit]`y2 = 0` [result1: unit]`y2 = 0`) 
                     x1 y1 (Exn unit tt) WP1)
                   end in
                 Cases (decomp1 Post8) of
                 | (Qval (exist result1 Post13)) => (exist_3 [x2: Z][y2: Z]
                   (qcomb [result2: unit]`y2 = 0` [result2: unit]`y2 = 0`) 
                   x1 y1 (Val unit result1) Post13)
                 | (Qexn _ WP1) => (exist_3 [x2: Z][y2: Z]
                   (qcomb [result1: unit]`y2 = 0` [result1: unit]`y2 = 0`) 
                   x1 y1 (Exn unit tt) WP1)
                 end
             | (right Test1) =>
                 let (x1, y1, result0, Post6) = (exist_3 [x1: Z][y1: Z]
                   (qcomb [result0: unit]`y1 = 0` [result0: unit]`y1 = 0`) 
                   x0 y0 (Val unit tt)
                   (why_boolean_discriminate Test1 `y0 = 0`)) in
                 Cases (decomp1 Post6) of
                 | (Qval (exist result1 Post7)) => (exist_3 [x2: Z][y2: Z]
                   (qcomb [result2: unit]`y2 = 0` [result2: unit]`y2 = 0`) 
                   x1 y1 (Val unit result1) Post7)
                 | (Qexn _ WP1) => (exist_3 [x2: Z][y2: Z]
                   (qcomb [result1: unit]`y2 = 0` [result1: unit]`y2 = 0`) 
                   x1 y1 (Exn unit tt) WP1)
                 end end y x y (refl_equal ? y) Pre4) in
       Cases (decomp1 Post4) of
       | (Qval (exist result0 Post14)) => (exist_3 [x1: Z][y1: Z]
         [result1: unit]`y1 = 0` x0 y0 result0 Post14)
       | (Qexn _ WP1) =>
         let (result0, Post15) = (exist_1 [result0: unit]`y0 = 0` tt WP1) in
         (exist_3 [x1: Z][y1: Z][result1: unit]`y1 = 0` x0 y0 result0 Post15)
       end.

Definition p4 (* validation *)
  : (x: Z)(y: Z)(_: `y >= 1`)
    (sig_3 Z Z unit [x0: Z][y0: Z][result: unit](`y0 = 0`))
  := [x: Z; y: Z; Pre4: `y >= 1`]
       let (x0, y0, result, Post4) =
         (well_founded_induction Z (Zwf ZERO) (Zwf_well_founded `0`)
           [Variant1: Z](x0: Z)(y0: Z)(_: Variant1 = y0)(_0: `y0 >= 1`)
           (sig_3 Z Z (EM unit unit) [x1: Z][y1: Z][result: (EM unit unit)]
            (((qcomb [result0: unit]`y1 = 0` [result0: unit]`y1 = 0`) result)))
           [Variant1: Z; wf1: (Variant2: Z)
            (Pre1: (Zwf `0` Variant2 Variant1))(x0: Z)(y0: Z)
            (_: Variant2 = y0)(_0: `y0 >= 1`)
            (sig_3 Z Z (EM unit unit) [x1: Z][y1: Z][result: (EM unit unit)]
             (((qcomb [result0: unit]`y1 = 0` [result0: unit]`y1 = 0`) result)));
            x0: Z; y0: Z; Pre3: Variant1 = y0; Pre2: `y0 >= 1`]
             let (result, Post5) = (exist_1 [result: bool]result = true 
               true (refl_equal ? true)) in
             Cases (btest [result:bool]result = true result Post5) of
             | (left Test2) =>
                 let (x1, y1, result0, Post8) =
                   let (x1, y1, result0, Post9) =
                     let (x1, y1, result0, WP6) =
                       let (y1, result0, Post1) =
                         let (result0, Post1) = (exist_1 [result0: Z]
                           result0 = `y0 - 1` `y0 - 1`
                           (refl_equal ? `y0 - 1`)) in
                         (exist_2 [y2: Z][result1: unit]y2 = `y0 - 1` 
                         result0 tt Post1) in
                       let (x1, result1, Post10) =
                         let (x1, result3, Post11) =
                           (set_and_test_nzero y1 x0) in
                         (exist_2 [x2: Z][result4: bool]`x2 = y1` /\
                         ((if result4 then `x2 <> 0` else `x2 = 0`)) 
                         x1 result3 Post11) in
                       (exist_3 [x2: Z][y2: Z][result2: bool]
                       (if result2 then `y2 >= 1` /\ (Zwf `0` y2 y0)
                        else `y2 = 0`) x1
                       y1 result1
                       (p4_po_1 y Pre4 Variant1 y0 Pre3 Pre2 Test2 y1 Post1
                       x1 result1 Post10)) in
                     Cases
                       (btest
                        [result0:bool]
                        (if result0 then `y1 >= 1` /\ (Zwf `0` y1 y0)
                         else `y1 = 0`) result0
                        WP6) of
                     | (left WP7) =>
                         let (result1, Post2) =
                           let (result1, Post2) = (exist_1 [result1: unit]
                             `y1 >= 1` /\ (Zwf `0` y1 y0) tt WP7) in
                           (exist_1 [result2: unit]`y1 >= 1` /\
                           (Zwf `0` y1 y0) result1 Post2) in
                         (exist_3 [x2: Z][y2: Z]
                         (qcomb [result2: unit]`y2 = 0` [result2: unit]
                          `y2 >= 1` /\ (Zwf `0` y2 y0)) x1
                         y1 (Val unit result1) Post2)
                     | (right WP7) =>
                         let (result1, Post12) =
                           (exist_1 (qcomb [result1: unit]`y1 = 0`
                                     [result1: unit]`y1 >= 1` /\
                                     (Zwf `0` y1 y0)) (Exn unit tt) WP7) in
                         Cases (decomp1 Post12) of
                         | (Qval (exist result2 Post2)) => (exist_3 [x2: Z]
                           [y2: Z]
                           (qcomb [result3: unit]`y2 = 0` [result3: unit]
                            `y2 >= 1` /\ (Zwf `0` y2 y0)) x1 y1
                           (Val unit result2) Post2)
                         | (Qexn _ WP1) => (exist_3 [x2: Z][y2: Z]
                           (qcomb [result2: unit]`y2 = 0` [result2: unit]
                            `y2 >= 1` /\ (Zwf `0` y2 y0)) x1 y1 (Exn unit tt)
                           WP1)
                         end end in
                   Cases (decomp1 Post9) of
                   | (Qval (exist result1 Post2)) =>
                     ((wf1 y1) (loop_variant_1 Pre3 Post2) x1 y1
                       (refl_equal ? y1) (proj1 ? ? Post2))
                   | (Qexn _ WP1) => (exist_3 [x2: Z][y2: Z]
                     (qcomb [result1: unit]`y2 = 0` [result1: unit]`y2 = 0`) 
                     x1 y1 (Exn unit tt) WP1)
                   end in
                 Cases (decomp1 Post8) of
                 | (Qval (exist result1 Post13)) => (exist_3 [x2: Z][y2: Z]
                   (qcomb [result2: unit]`y2 = 0` [result2: unit]`y2 = 0`) 
                   x1 y1 (Val unit result1) Post13)
                 | (Qexn _ WP1) => (exist_3 [x2: Z][y2: Z]
                   (qcomb [result1: unit]`y2 = 0` [result1: unit]`y2 = 0`) 
                   x1 y1 (Exn unit tt) WP1)
                 end
             | (right Test1) =>
                 let (x1, y1, result0, Post6) = (exist_3 [x1: Z][y1: Z]
                   (qcomb [result0: unit]`y1 = 0` [result0: unit]`y1 = 0`) 
                   x0 y0 (Val unit tt)
                   (why_boolean_discriminate Test1 `y0 = 0`)) in
                 Cases (decomp1 Post6) of
                 | (Qval (exist result1 Post7)) => (exist_3 [x2: Z][y2: Z]
                   (qcomb [result2: unit]`y2 = 0` [result2: unit]`y2 = 0`) 
                   x1 y1 (Val unit result1) Post7)
                 | (Qexn _ WP1) => (exist_3 [x2: Z][y2: Z]
                   (qcomb [result1: unit]`y2 = 0` [result1: unit]`y2 = 0`) 
                   x1 y1 (Exn unit tt) WP1)
                 end end y x y (refl_equal ? y) Pre4) in
       Cases (decomp1 Post4) of
       | (Qval (exist result0 Post14)) => (exist_3 [x1: Z][y1: Z]
         [result1: unit]`y1 = 0` x0 y0 result0 Post14)
       | (Qexn _ WP1) =>
         let (result0, Post15) = (exist_1 [result0: unit]`y0 = 0` tt WP1) in
         (exist_3 [x1: Z][y1: Z][result1: unit]`y1 = 0` x0 y0 result0 Post15)
       end.

