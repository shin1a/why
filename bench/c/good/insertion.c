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

/* Insertion sort */

#include "sorting.h"

/*@ requires 
  @   0 <= n && \valid_range(a, 0, n-1)
  @ ensures  
  @   Permut(contents(a), \old(contents(a)), 0, n-1) && 
  @   Sorted(a, 0, n-1)
  @*/
void insertion_sort(int* a, unsigned int n) {
  unsigned int i;
  if (n <= 1) return;
  /*@ invariant
    @   0 < i <= n &&
    @   Permut(contents(a), \at(contents(a), init), 0, n-1) &&
    @   Sorted(a, 0, i-1) 
    @ loop_assigns
    @   a[0..n-1]
    @ variant
    @   n - i
    @*/
  for (i = 1; i < n; i++) {
    int v = a[i];
    unsigned int j = i;
    /*@ invariant
      @   0 <= j <= i &&
      @   Permut(update(contents(a), j, v), \at(contents(a), init), 0, n-1) &&
      @   Sorted(a, 0, j-1) &&
      @   Sorted(a, j+1, i) &&
      @   (j < i => v < a[j+1]) &&
      @   (0 < j < i => a[j-1] <= a[j+1])
      @ loop_assigns
      @   a[0..i]
      @ variant
      @   j
      @*/
    while (j > 0 && a[j-1] > v) { a[j] = a[j-1]; j--; }
    a[j] = v;
  }
}

/* test 
int main() {
  int i;
  int t[10] = { 3,5,1,0,6,8,4,2,9,7 };
  insertion_sort(t, 10);
  for (i = 0; i < 10; i++) printf("%d ", t[i]);
}
*/

/*
Local Variables: 
compile-command: "make insertion.gui"
End: 
*/
