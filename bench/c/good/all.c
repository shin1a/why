/**************************************************************************/
/*                                                                        */
/*  The Why platform for program certification                            */
/*                                                                        */
/*  Copyright (C) 2002-2011                                               */
/*                                                                        */
/*    Jean-Christophe FILLIATRE, CNRS & Univ. Paris-sud 11                */
/*    Claude MARCHE, INRIA & Univ. Paris-sud 11                           */
/*    Yannick MOY, Univ. Paris-sud 11                                     */
/*    Romain BARDOU, Univ. Paris-sud 11                                   */
/*                                                                        */
/*  Secondary contributors:                                               */
/*                                                                        */
/*    Thierry HUBERT, Univ. Paris-sud 11  (former Caduceus front-end)     */
/*    Nicolas ROUSSET, Univ. Paris-sud 11 (on Jessie & Krakatoa)          */
/*    Ali AYAD, CNRS & CEA Saclay         (floating-point support)        */
/*    Sylvie BOLDO, INRIA                 (floating-point support)        */
/*    Jean-Francois COUCHOT, INRIA        (sort encodings, hyps pruning)  */
/*    Mehdi DOGGUY, Univ. Paris-sud 11    (Why GUI)                       */
/*                                                                        */
/*  This software is free software; you can redistribute it and/or        */
/*  modify it under the terms of the GNU Lesser General Public            */
/*  License version 2.1, with the special exception on linking            */
/*  described in file LICENSE.                                            */
/*                                                                        */
/*  This software is distributed in the hope that it will be useful,      */
/*  but WITHOUT ANY WARRANTY; without even the implied warranty of        */
/*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  */
/*                                                                        */
/**************************************************************************/


/* all features, orthogonally */

int x;
int y;

/*@ ensures x == 0 */
void f1() { x = 0; }

/*@ requires x == 0 
    ensures x == 1 */ 
void f2() { x++; }

/*@ requires x == 0 
    ensures x == 1 */ 
void f3() { ++x; }

/*@ requires x == 0 
    ensures x == 1 && y == 0 */ 
void f4() { y = x++; }

/*@ requires x == 0 
    ensures x == 1 && y == 1 */ 
void f5() { y = ++x; }

/*@ requires x == 1 
    ensures x == 3 */ 
void f6() { x += 2; }

/*@ requires x == 0 
    ensures y == 1 */ 
void f7a() { y = x == 0 ? 1 : 2; }

/*@ requires x != 0 
    ensures y == 2 */ 
void f7b() { y = x == 0 ? 1 : 2; }

int t[3];

/*@ requires t[0] == 1 
    ensures y == 1 */ 
void t1() { y = t[0]; }

/*@ requires x == 0 && t[0] == 1 
    ensures y == 1 */ 
void t2() { y = t[x++]; }

/*@ requires x == 0 && t[1] == 1 
    ensures y == 1 */ 
void t3() { y = t[++x]; }

/*@ requires x == 2 && t[2] == 3 
    ensures x == 3 && t[2] == 5 */ 
void t4() { t[x] += x++; } 

#if 0
/* evaluation order */

/*@ requires x == 2 
    ensures y == 4 */ 
void e1() { y = x + x++; }

/*@ requires x == 2 
    ensures y == 5 */ 
void e2() { y = x + ++x; }

/*@ requires x == 2 
    ensures y == 5 */ 
void e3() { y = x++ + x; }

/*@ requires x == 2 
    ensures y == 6 */ 
void e4() { y = ++x + x; }

/*@ requires x == 2 
    ensures y == 6 */ 
void e5() { y = ++x + x++; }

#endif


