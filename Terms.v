(***************************************************************************
 * Terms.v                    						   *		
***************************************************************************)

Set Implicit Arguments.
Require Import Max.
Require Export List ListSet Omega LibTactics.


Inductive Atom : Set := atom : nat -> Atom.
Inductive Var  : Set := var  : nat -> Var.
Definition Perm := list (Atom * Atom).

Notation "[]"    := nil  (at level 67). 
Notation "|[ s ]" := (s::nil) (at level 67).

(** Grammar *)

Inductive term : Set :=
  | Ut : term
  | At : Atom -> term 
  | Ab : Atom -> term -> term
  | Pr : term -> term -> term 
  | Fc : nat -> nat -> term -> term
  | Su : Perm -> Var -> term  
.

Notation "<<>>" := (Ut) (at level 67). 
Notation "% a " := (At a) (at level 67). 
Notation "[ a ] ^ t" := (Ab a t) (at level 67).
Notation "<| t1 , t2 |>" := (Pr t1 t2) (at level 67).
Notation "pi \ X" := (Su pi X) (at level 67).


(** Atoms decidability *)

Lemma Atom_eqdec : forall a b : Atom, {a = b} + {a <> b}.
Proof.
 intros. destruct a. destruct b. case (n === n0); intros.
 left. rewrite e. trivial. right. intro. inversion H. contradiction.
Qed.

Notation "a ==at b" := (Atom_eqdec a b) (at level 67).


(** Size of a term  *)

Fixpoint size_term (t : term) {struct t} : nat :=
 match t with
  | [a]^t1  => 1 + size_term t1
  | <|t1,t2|> => 1 + size_term t1 + size_term t2 
  | Fc m n t1  => 1 + size_term t1
  | _   => 1  
 end.



