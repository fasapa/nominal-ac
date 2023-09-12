(*
 ============================================================================
 Project     : Nominal A, AC and C Unification
 File        : Terms.v
 Authors     : Washington Luís R. de Carvalho Segundo and
               Mauricio Ayala Rincón 
               Universidade de Brasília (UnB) - Brazil
               Group of Theory of Computation

 Description : This file contains the definition of the grammar of
               terms in the nominal syntax and basic results about.

 
 Last Modified On: Jul 24, 2018.
 ============================================================================
*)

Set Implicit Arguments.
Require Export Basics.

Inductive Atom : Set := atom : nat -> Atom.
Inductive Var  : Set := var  : nat -> Var.
Definition Perm := list (Atom * Atom).
Definition Context := list (Atom * Var).


(** Grammar of terms *)

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
Notation "pi |. X" := (Su pi X) (at level 67).


(** Atoms decidability *)

Definition eq_atom_rec (a b : Atom) :=
  match a, b with atom m, atom n => eq_nat_rec m n end.

Lemma atom_eqdec : forall (a b : Atom), {a = b} + {a <> b}.
Proof.
  intros. destruct a. destruct b.
  case (nat_eqdec n n0); intro H.
  rewrite H. left. trivial.
  right. intro H0. apply H.
  inversion H0. trivial.
Defined.

Lemma atom_pair_eqdec: forall (p1 p2 : Atom * Atom), {p1 = p2} + {p1 <> p2}. 
Proof.
  intros. apply (Aeq_pair_eqdec _ atom_eqdec).
Defined.

Lemma atom_list_eqdec: forall (l1 l2 : list Atom), {l1 = l2} + {l1 <> l2}. 
Proof.
  intros. apply (eq_list_dec _ atom_eqdec).
Defined.  

(** Variables decidability. *)

Definition eq_var_rec (X Y : Var) :=
  match X, Y with var m, var n => eq_nat_rec m n end.

Lemma var_eqdec : forall (X Y : Var), {X = Y} + {X <> Y}.
Proof.  
  intros. destruct X. destruct Y.
  case (nat_eqdec n n0); intro H.
  rewrite H. left. trivial.
  right. intro H0. apply H.
  inversion H0. trivial.
Defined.

(** Contexts membership decidability *)

Lemma atom_var_eqdec : forall (c c' : Atom * Var), {c = c'} + {c <> c'}.
Proof.
  intros. destruct c. destruct c'.
  case (atom_eqdec a a0); intro H.  
  case (var_eqdec v v0); intro H0.
  left~. f_equal; trivial.
  right~. intro H1. inverts H1. false.
  right~. intro H2. inverts H2. false.
Defined.  

Lemma in_context_dec : forall (c : Atom * Var) (C : Context),
  {In c C} + {~In c C}.   
Proof.
  intros. apply (eq_mem_list_dec _ atom_var_eqdec).
Defined.


(** Permutations decidability. *)
   
Lemma perm_eqdec : forall pi pi' : Perm, {pi = pi'} + {pi <> pi'}.
Proof.
  intros. apply (eq_list_dec _ atom_pair_eqdec).
Defined.


(** Terms decidability. *)

Fixpoint eq_term_rec (t1 t2 : term) : bool :=
  match t1, t2 with
  | <<>>, <<>> => true
  | %a, %b => eq_atom_rec a b
  | [a]^s, [b]^t => eq_atom_rec a b && eq_term_rec s t
  | Fc E n s, Fc E' n' t => eq_nat_rec E E' &&
                            eq_nat_rec n n' &&
                            eq_term_rec s t           
  | <|s0, s1|>, <|t0, t1|> => eq_term_rec s0 t0 &&
                              eq_term_rec s1 t1
  | pi|.X, pi'|.Y => if perm_eqdec pi pi'
                     then eq_var_rec X Y
                     else false
  | _, _ => false                          
  end.                         

Lemma eq_term_refl : forall t1 t2,
      eq_term_rec t1 t2 = true <-> t1 = t2.
Proof.
  intro t1. induction t1; intro t2; destruct t2; simpl;
            split~; intro H; trivial; inverts H.  
  destruct a. destruct a0. simpl in H1.
  apply eq_nat_refl' in H1. rewrite H1. trivial.
  destruct a0. simpl. apply eq_nat_refl.
  symmetry in H1. apply andb_true_eq in H1.
  destruct H1. symmetry in H. symmetry in H0.
  destruct a. destruct a0. simpl in H.
  apply eq_nat_refl' in H. rewrite H.
  f_equal. apply IHt1; trivial.
  destruct a0. simpl. rewrite eq_nat_refl.
  simpl. apply IHt1; trivial.
  symmetry in H1. apply andb_true_eq in H1.
  destruct H1. symmetry in H. symmetry in H0.
  f_equal; [apply IHt1_1 | apply IHt1_2]; trivial.
  assert (Q : eq_term_rec t2_1 t2_1 = true).
   apply IHt1_1. trivial.
   rewrite Q. simpl.
  apply IHt1_2. trivial.   
  symmetry in H1. apply andb_true_eq in H1.
  destruct H1. apply andb_true_eq in H.
  destruct H. symmetry in H. symmetry in H1.
  symmetry in H0.
  rewrite eq_nat_refl' in H. rewrite eq_nat_refl' in H1.
  rewrite H. rewrite H1. f_equal.
  apply IHt1; trivial.
  rewrite 2 eq_nat_refl. simpl. apply IHt1; trivial.
  gen H1. case (perm_eqdec p p0); intros H H0.
  rewrite H. destruct v. destruct v0.
  simpl in H0. apply eq_nat_refl' in H0.
  rewrite H0. trivial. inverts H0.
  destruct v0. simpl. rewrite eq_nat_refl.
  case (perm_eqdec p0 p0); intro H; trivial.
  apply False_ind. apply H; trivial.
Defined.

Lemma eq_term_diff : forall t1 t2,
      eq_term_rec t1 t2 = false <-> t1 <> t2.
Proof.
  intros.
  gen_eq b : (eq_term_rec t1 t2); intro H.
  symmetry in H. destruct b.
  apply eq_term_refl in H. split~; intro.
  inverts H0. contradiction.
  split~; intro H0. inverts H0.
  intro H0. apply eq_term_refl in H0.
  rewrite H in H0. inverts H0.
Defined.

Lemma term_eqdec : forall t1 t2 : term, {t1 = t2} + {t1 <> t2}.
Proof.
  intros. gen_eq b : (eq_term_rec t1 t2); intro H.
  symmetry in H. destruct b;
  [apply eq_term_refl in H; left~| apply eq_term_diff in H; right~].
Defined.


(** Size of a term  *)

Fixpoint term_size (t : term) {struct t} : nat :=
 match t with
  | [a]^t1  => 1 + term_size t1
  | <|t1,t2|> => 1 + term_size t1 + term_size t2 
  | Fc E n t1  => 1 + term_size t1
  | _   => 1  
 end.


Lemma term_size_1_le : forall t, 1 <= term_size t.
Proof.
  intros. induction t; simpl; try apply le_n.
  apply le_S; trivial. apply le_S.
  apply le_trans' with (l := term_size t1); trivial.
  apply le_plus. apply le_S; trivial.
Defined.

Lemma term_size_gt_0 : forall t, term_size t > 0.
Proof.
  intros. unfold gt. unfold lt. apply term_size_1_le.
Defined.  

Hint Resolve term_size_gt_0.


(** The set of variables that occur in a term *)

Fixpoint term_vars (t : term) {struct t} : set Var := 
match t with
 | Ut       => empty_set _
 | At a     => empty_set _
 | Su p X   => set_add var_eqdec X (empty_set _)
 | Pr t1 t2 => set_union var_eqdec (term_vars t1) (term_vars t2)
 | Ab a t1  => term_vars t1
 | Fc E n t1  => term_vars t1
end.

(** Subterms *)

Fixpoint subterms (t : term) {struct t} : set term :=
match t with
| Ut        => set_add term_eqdec Ut (empty_set _)
| At a      => set_add term_eqdec (At a) (empty_set _)
| Su p Y    => set_add term_eqdec (Su p Y) (empty_set _)
| Ab a t1   => set_add term_eqdec (Ab a t1) (subterms t1)
| Pr t1 t2  => set_add term_eqdec (Pr t1 t2) 
              (set_union term_eqdec (subterms t1) (subterms t2))
| Fc E n t1   => set_add term_eqdec (Fc E n t1) (subterms t1)
end.

Definition psubterms (t : term) := set_remove term_eqdec t (subterms t).



Definition is_Fc  (s:term) (E n : nat) : Prop :=
  match s with
  | Fc E0 n0 t => if eq_nat_rec E0 E &&
                     eq_nat_rec n0 n           
                  then True
                  else False
    | _ => False
  end .

Definition is_Fc' (s:term) : Prop :=
  match s with
    | Fc E n t => True
    | _ => False
  end .

Definition is_Pr (s:term) : Prop :=
  match s with
    | <|s0,s1|> => True
    | _ => False
  end .

Definition is_Ab (s:term) : Prop :=
  match s with
    | [a]^t => True
    | _ => False
  end . 

Definition is_Su (s:term) : Prop :=
  match s with
    | pi|.X => True
    | _ => False
  end .
           

Lemma is_Fc_dec : forall s E n, is_Fc s E n \/ ~ is_Fc s E n.
Proof.
  intros. destruct s; simpl.
  right~. right~. right~. right~.
  case (nat_pair_eqdec (n0, n1) (E, n)); intro H.
  inverts H. rewrite 2 eq_nat_refl. simpl.
  left~. right~. 
  intro H0. gen_eq b : (eq_nat_rec n0 E && eq_nat_rec n1 n); intro H1.
  destruct b. apply andb_true_eq in H1.
  destruct H1. symmetry in H1. symmetry in H2.
  apply eq_nat_refl' in H1. rewrite eq_nat_refl' in H2.
  rewrite H1 in H. rewrite H2 in H. apply H; trivial.
  contradiction. right~.
Qed.


Lemma is_Pr_dec : forall s, is_Pr s \/ ~ is_Pr s.
Proof.
  intros. destruct s; simpl.
  right~. right~. right~.
  left~.  right~. right~. 
Qed.

Lemma is_Ab_dec : forall s, is_Ab s \/ ~ is_Ab s.
Proof.
  intros. destruct s; simpl.
  right~. right~. left~.
  right~. right~. right~.
Qed.

Lemma is_Su_dec : forall s, is_Su s \/ ~ is_Su s.
Proof.
  intros. destruct s; simpl.
  right~. right~. right~.
  right~. right~. left~. 
Qed.


Lemma is_Fc_exists : forall E n s, is_Fc s E n -> exists t, s = Fc E n t.
Proof.
  intros. destruct s; simpl in H; try contradiction.
  gen H. case (nat_pair_eqdec  (n0, n1) (E, n));
           intros H0 H; try contradiction.
  inverts H0. exists s. trivial.
  gen_eq b : (eq_nat_rec n0 E && eq_nat_rec n1 n); intro H1.
  destruct b. apply andb_true_eq in H1. destruct H1.
  symmetry in H1. symmetry in H2.
  apply eq_nat_refl' in H1.  apply eq_nat_refl' in H2.  
  false. contradiction.
Qed.  

Lemma is_Ab_exists : forall s, is_Ab s -> exists a t, s = [a]^t.
Proof.
  intros. destruct s; simpl in H; try contradiction.
  exists a. exists s. trivial.
Qed.
  
Lemma is_Pr_exists : forall s, is_Pr s -> exists u v, s = <|u,v|>.
Proof.
  intros. destruct s; simpl in H; try contradiction.
  exists s1. exists s2; trivial.
Qed.

Lemma is_Su_exists : forall s, is_Su s -> exists pi X, s = pi|.X .
Proof.
  intros. destruct s; simpl in H; try contradiction.
  exists p. exists v; trivial.
Qed.


Lemma isnt_Pr : forall s, (forall u v, s <> <| u, v |>) -> ~ is_Pr s.
Proof.
  intros. intro H0. destruct s; simpl in H0; trivial.
  apply (H s1 s2); trivial.
Qed.  

Lemma isnt_Su : forall s, (forall pi X, s <> pi|.X) -> ~ is_Su s.
Proof.
  intros. intro H0. destruct s; simpl in H0; trivial.
  apply (H p v); trivial.
Qed.
  

(** Lemmas about subterms and psubterms *)

Lemma nodup_subterms : forall s, NoDup (subterms s).
Proof.
  induction s; simpl.
  apply NoDup_cons. simpl. intro; trivial. apply NoDup_nil.
  apply NoDup_cons. simpl. intro; trivial. apply NoDup_nil.
  apply set_add_nodup; trivial.
  apply set_add_nodup. apply set_union_nodup; trivial.
  apply set_add_nodup; trivial.
  apply NoDup_cons. simpl. intro; trivial. apply NoDup_nil.
Qed.  

Lemma psubterms_to_subterms : forall s t, set_In s (psubterms t) -> set_In s (subterms t).
Proof.
  intros. unfold psubterms in H. apply set_remove_1 in H; trivial.
Qed.

Lemma In_subterms : forall s, set_In s (subterms s).
Proof.
  intros. destruct s; simpl; auto;
  try apply set_add_intro2; trivial.
Qed.
  
Lemma not_In_psubterms : forall s, ~ set_In s (psubterms s).
Proof.
  intros. intro H. unfold psubterms in H.
  apply set_remove_2 in H.
  apply H; trivial.
  apply nodup_subterms.
Qed.

Lemma Ab_psubterms : forall a s, set_In s (psubterms ([a]^s)).
Proof.
  intros. unfold psubterms. apply set_remove_3; simpl.
  apply set_add_intro1. apply In_subterms.
  intro H. induction s; inverts H. apply IHs; trivial.
Qed.

Lemma Fc_psubterms : forall E n s,  set_In s (psubterms (Fc E n s)).
Proof.
  intros. unfold psubterms. apply set_remove_3; simpl.
  apply set_add_intro1. apply In_subterms.
  intro H. induction s; inverts H. apply IHs; trivial.
Qed.

Lemma Pr_psubterms : forall s t, set_In s (psubterms (<|s,t|>)) /\ set_In t (psubterms (<|s,t|>)).
Proof.
  intros. unfold psubterms. split~; apply set_remove_3; simpl;
  try apply set_add_intro1; try apply In_subterms.
  apply set_union_intro1. apply In_subterms; trivial. 
  intro H. induction s; inverts H. apply IHs1; trivial.
  apply set_union_intro2. apply In_subterms; trivial. 
  intro H. induction t; inverts H. apply IHt2; trivial.
Qed.


Require Import Lia.
  
Lemma subterms_term_size_leq : forall s t, set_In s (subterms t) -> term_size s <= term_size t.
Proof.
  intros. induction t; simpl in *|-*.
  destruct H; try contradiction. rewrite <- H; simpl; lia.
  destruct H; try contradiction. rewrite <- H; simpl; lia.  
  apply set_add_elim in H. destruct H. rewrite H; simpl; lia.
  assert (Q: term_size s <= term_size t).  apply IHt. trivial. lia.
  apply set_add_elim in H. destruct H. rewrite H. simpl; lia.
  apply set_union_elim in H. destruct H.
  assert (Q: term_size s <= term_size t1). apply IHt1; trivial. lia. 
  assert (Q: term_size s <= term_size t2). apply IHt2; trivial. lia.
  apply set_add_elim in H. destruct H. rewrite H; simpl; lia.
  assert (Q: term_size s <= term_size t).  apply IHt. trivial. lia.
  destruct H; try contradiction. rewrite <- H; simpl; lia.
Qed.  

Lemma psubterms_term_size_lt : forall s t, set_In s (psubterms t) -> term_size s < term_size t.
Proof.
  intros. unfold psubterms in H.
  induction t; simpl in *|-*.
  gen H. case (term_eqdec (<<>>) (<<>>));
    intros; simpl in H; try contradiction. false.
  gen H. case (term_eqdec (%a) (%a));
    intros; simpl in H; try contradiction.   
  apply set_remove_add in H.
  case (term_eqdec s t); intro H0. rewrite H0. lia.
  assert (Q : term_size s < term_size t).
   apply IHt. apply set_remove_3; trivial.
  lia.
  apply set_remove_add in H.
  apply set_union_elim in H. destruct H.
  case (term_eqdec s t1); intro H0. rewrite H0. lia.
  assert (Q : term_size s < term_size t1).
   apply IHt1. apply set_remove_3; trivial.
  lia.
  case (term_eqdec s t2); intro H0. rewrite H0. lia.
  assert (Q : term_size s < term_size t2).
   apply IHt2. apply set_remove_3; trivial.
  lia.
  apply set_remove_add in H. 
  case (term_eqdec s t); intro H0. rewrite H0. lia.
  assert (Q : term_size s < term_size t).
   apply IHt. apply set_remove_3; trivial.
  lia.
 gen H. case (term_eqdec (p|.v) (p|.v));
    intros; simpl in H; try contradiction. 
Qed.

Lemma psubterms_not_In_subterms: forall s t, set_In s (psubterms t) -> ~ set_In t (subterms s).
Proof.
  intros. intro H'.
  apply psubterms_term_size_lt in H.
  apply subterms_term_size_leq in H'.
  lia.
Qed.  

Lemma subterms_trans : forall s t u,
                       set_In s (subterms t) -> set_In t (subterms u) -> set_In s (subterms u).
Proof.
  intros. induction u; simpl in *|-*.
  destruct H0; try contradiction.
  rewrite <- H0 in H. simpl in H; trivial.
  destruct H0; try contradiction.
  rewrite <- H0 in H. simpl in H; trivial.
  apply set_add_elim in H0. destruct H0.
  rewrite H0 in H. simpl in H; trivial.
  apply set_add_intro1. apply IHu; trivial.
  apply set_add_elim in H0. destruct H0. 
  rewrite H0 in H. simpl in H; trivial.
  apply set_union_elim in H0. apply set_add_intro1. destruct H0.
  apply set_union_intro1. apply IHu1; trivial. 
  apply set_union_intro2. apply IHu2; trivial.  
  apply set_add_elim in H0. destruct H0.
  rewrite H0 in H. simpl in H; trivial.
  apply set_add_intro1. apply IHu; trivial.
  destruct H0; try contradiction.
  rewrite <- H0 in H. simpl in H; trivial.
Qed.

Lemma psubterms_trans : forall s t u,
                        set_In s (psubterms t) -> set_In t (subterms u) -> set_In s (psubterms u).
Proof.
  intros. unfold psubterms.
  generalize H; intro H'. unfold psubterms in H'.
  apply set_remove_1 in H'.
  apply set_remove_3.
  apply subterms_trans with (t:=t); trivial.
  intro H1. rewrite H1 in H.
  apply psubterms_not_In_subterms in H.
  contradiction.
Qed.

  
Lemma subterms_eq : forall s t, (set_In s (subterms t) /\ set_In t (subterms s)) -> s = t.
Proof.
  intros. destruct H.
  gen t. induction s; intros; simpl in H0.
  destruct H0; try contradiction; trivial.
  destruct H0; try contradiction; trivial.
  apply set_add_elim in H0. destruct H0; auto.
  assert (Q : set_In ([a]^ s) (subterms s)).
   apply subterms_trans with (t:=t); trivial.
  assert (Q': set_In s (psubterms ([a]^s))). 
   apply Ab_psubterms.
  apply psubterms_not_In_subterms in Q'.
  contradiction.   
  apply set_add_elim in H0. destruct H0; auto.
  apply set_union_elim in H0. destruct H0.
  assert (Q : set_In (<|s1,s2|>) (subterms s1)).
   apply subterms_trans with (t:=t); trivial.
  assert (Q': set_In s1 (psubterms (<|s1,s2|>))). 
   apply Pr_psubterms.
  apply psubterms_not_In_subterms in Q'.
  contradiction.      
  assert (Q : set_In (<|s1,s2|>) (subterms s2)).
   apply subterms_trans with (t:=t); trivial.
  assert (Q': set_In s2 (psubterms (<|s1,s2|>))). 
   apply Pr_psubterms.
  apply psubterms_not_In_subterms in Q'.
  contradiction. 
  apply set_add_elim in H0. destruct H0; auto.
  assert (Q : set_In (Fc n n0 s) (subterms s)).
   apply subterms_trans with (t:=t); trivial.
  assert (Q': set_In s (psubterms (Fc n n0 s))). 
   apply Fc_psubterms.
  apply psubterms_not_In_subterms in Q'.
  contradiction. 
  destruct H0; try contradiction; trivial.  
Qed.  


Lemma Ab_neq_psub : forall a s, [a]^s <> s.
Proof.
  intros.
  assert (Q : set_In s (psubterms ([a]^s))).  
   apply Ab_psubterms.
  apply psubterms_not_In_subterms in Q. intro H.   
  assert (Q': set_In s (subterms s)).
   apply In_subterms.
  rewrite H in Q. contradiction.
Qed.

Lemma Fc_neq_psub : forall E n s, Fc E n s <> s.
Proof.
  intros.
  assert (Q : set_In s (psubterms (Fc E n s))).  
   apply Fc_psubterms.
  apply psubterms_not_In_subterms in Q. intro H.   
  assert (Q': set_In s (subterms s)).
   apply In_subterms.
  rewrite H in Q. contradiction.
Qed.

Lemma Pr_neq_psub_1 : forall s t, <|s,t|> <> s.
Proof.
  intros.
  assert (Q : set_In s (psubterms (<|s,t|>))).  
   apply Pr_psubterms.
  apply psubterms_not_In_subterms in Q. intro H.   
  assert (Q': set_In s (subterms s)).
   apply In_subterms.
  rewrite H in Q. contradiction.
Qed.

Lemma Pr_neq_psub_2 : forall s t, <|s,t|> <> t.
Proof.
  intros.
  assert (Q : set_In t (psubterms (<|s,t|>))).  
   apply Pr_psubterms.
  apply psubterms_not_In_subterms in Q. intro H.   
  assert (Q': set_In t (subterms t)).
   apply In_subterms.
  rewrite H in Q. contradiction.
Qed.


Lemma Fc_Pr_neq_psub_1 : forall E n s t, Fc E n (<|s,t|>) <> s.
Proof.
  intros.
  assert (Q : set_In s (psubterms (Fc E n (<|s,t|>)))).  
   apply psubterms_trans with (t := (<|s,t|>)).
   apply Pr_psubterms. simpl. apply set_add_intro1.
   apply set_add_intro2; trivial.
  apply psubterms_not_In_subterms in Q. intro H.
  assert (Q': set_In s (subterms s)).
   apply In_subterms.
  rewrite H in Q. contradiction.
Qed.


Lemma Fc_Pr_neq_psub_2 : forall E n s t, Fc E n (<|s,t|>) <> t.
Proof.
  intros.
  assert (Q : set_In t (psubterms (Fc E n (<|s,t|>)))).  
   apply psubterms_trans with (t := (<|s,t|>)).
   apply Pr_psubterms. simpl. apply set_add_intro1.
   apply set_add_intro2; trivial.
  apply psubterms_not_In_subterms in Q. intro H.
  assert (Q': set_In t (subterms t)).
   apply In_subterms.
  rewrite H in Q. contradiction.
Qed.


(** About proper terms *)

(**
	The following is a restriction over the syntax. 
	commutative function symbols can have only pairs as 
	arguments.
*)  
  
Definition Proper_term (t : term) :=
  forall n s, set_In (Fc 2 n s) (subterms t) -> is_Pr s .


Lemma Proper_subterm : forall s t, set_In s (subterms t) -> Proper_term t -> Proper_term s.
Proof.
  intros. unfold Proper_term in *|-*; intros.
  apply H0 with (n:=n).
  apply subterms_trans with (t := s); trivial.
Qed.
