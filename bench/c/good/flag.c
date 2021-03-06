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

/* Dijkstra's dutch flag */

typedef enum { BLUE, WHITE, RED } color;

/*@ predicate isColor(int i) { i == BLUE || i == WHITE || i == RED }
  @*/

/*@ predicate isMonochrome(int t[], int i, int j, color c)
  @   { \valid_range(t,i,j) && \forall int k; i <= k && k <= j => t[k] == c } 
  @*/

/*@ requires \valid_index(t,i) && \valid_index(t,j)
  @ assigns t[i],t[j]
  @ ensures t[i] == \old(t[j]) && t[j] == \old(t[i])
  @*/
void swap(color t[], int i, int j) {
  int tmp = t[i];
  t[i] = t[j];
  t[j] = tmp;
}

/*@ requires 
  @   n >= 0 && \valid_range(t,0,n-1) &&
  @   (\forall int k; 0 <= k && k < n => isColor(t[k]))
  @ assigns t[0 .. n-1]
  @ ensures 
  @   (\exists int b, int r; 
  @            isMonochrome(t,0,b-1,BLUE) &&
  @            isMonochrome(t,b,r-1,WHITE) &&
  @            isMonochrome(t,r,n-1,RED))
  @*/
void flag(color t[], int n) {
  int b = 0;
  int i = 0;
  int r = n;
  /*@ invariant
    @   (\forall int k; 0 <= k && k < n => isColor(t[k])) &&
    @   0 <= b && b <= i && i <= r && r <= n &&
    @   isMonochrome(t,0,b-1,BLUE) &&
    @   isMonochrome(t,b,i-1,WHITE) &&
    @   isMonochrome(t,r,n-1,RED)
    @ loop_assigns b,i,r,t[0 .. n-1]
    @ variant r - i
    @*/
  while (i < r) {
    switch (t[i]) {
    case BLUE:  
      swap(t, b++, i++);
      break;	    
    case WHITE: 
      i++; 
      break;
    case RED: 
      swap(t, --r, i);
      break;
    }
  }
}

    
/*
Local Variables: 
compile-command: "make flag.gui"
End: 
*/
