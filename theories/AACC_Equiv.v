(*
 ============================================================================
 Project     : Nominal A, AC and C Unification
 File        : AAAC_Equiv.v 
 Authors     : Washington Luis R. de Carvalho Segundo and
               Mauricio Ayala Rincon 
               Universidade de Brasilia (UnB) - Brazil
               Group of Theory of Computation

 Description : This file contains the soundness proofs of 
               the relations ~aacc, ~a, ~c and ~ac. 
 
 Last Modified On: Sep 17, 2018.
 ============================================================================
*)

Require Export Equiv_Tuples.


Lemma alpha_to_aacc_equiv : forall C t t', 
 C |- t ~alpha t' -> C |- t ~aacc t'.
Proof. 
 intros. induction H; auto; 
 simpl in H; try contradiction. 
 apply aacc_equiv_Fc; trivial.
Qed.

Hint Resolve alpha_to_aacc_equiv.


(** Some auxiliary lemmas about is_Pr *)

Lemma alpha_neg_is_Pr : forall C t t', C |- t ~alpha t' -> (~ is_Pr t <-> ~ is_Pr t').
Proof.
  intros. inverts H; simpl in *|-*; split~; intros; trivial.
Qed.

Lemma aacc_neg_is_Pr : forall C t t', C |- t ~aacc t' -> (~ is_Pr t <-> ~ is_Pr t').
Proof.
  intros. inverts H; simpl in *|-*; split~; intros; trivial.
Qed.

Lemma perm_neg_is_Pr : forall pi t, ~ is_Pr (pi @ t) <-> ~ is_Pr t.
Proof.
  intros. destruct t; autorewrite with perm; simpl; split~; intros; trivial. 
Qed.

(** Intermediate transitivity for aacc_equiv with alpha_equiv *)

Lemma aacc_alpha_equiv_trans : forall C t1 t3, 
  (exists t2, C |- t1 ~aacc t2 /\ C |- t2 ~alpha t3) <-> C |- t1 ~aacc t3.
Proof.
  intros. split~; intro.
  case H; clear H; intros t2 H. destruct H.

  (* -> *)
  
  gen t3 H0. induction H; intros; auto.
  inverts H1. apply equiv_Pr; [apply IHequiv1 | apply IHequiv2]; trivial.
  inverts H1. apply equiv_Fc; auto. destruct H.
  left~. destruct H. right~. split~. destruct H1. left~.
  right~. apply alpha_neg_is_Pr in H7. apply H7; trivial.
  inverts H0. apply equiv_Ab_1; apply IHequiv; trivial.
  apply equiv_Ab_2; trivial. apply IHequiv; trivial.
  inverts H2. apply equiv_Ab_2; trivial.
  apply IHequiv. apply alpha_equiv_eq_equiv.
  apply alpha_equiv_eq_equiv; trivial.
  apply alpha_equiv_equivariance; trivial.
  apply alpha_equiv_fresh with (t1 := t'); trivial.
  case (atom_eqdec a a'0); intro H10. rewrite H10.
  apply equiv_Ab_1. apply IHequiv. apply alpha_equiv_sym.
  replace (|[(a, a')]|) with (! (|[(a, a')]|)). apply perm_inv_side.
  apply alpha_equiv_trans with (t2 := (|[(a', a)]|) @ t'0).
  apply alpha_equiv_pi. intros b H11. false. apply H11. apply swap_comm.
  apply alpha_equiv_sym. rewrite H10; trivial. simpl; trivial.
  assert (Q : C |- a # t'0).
   apply alpha_equiv_fresh with (a := a) in H7; trivial.
   apply fresh_lemma_1 in H7. simpl rev in H7. 
   rewrite swap_neither in H7; auto.
  apply equiv_Ab_2; trivial. apply IHequiv.
  replace (|[(a, a')]|) with (!(|[(a, a')]|)). 
  apply perm_inv_side. simpl.
  apply alpha_equiv_trans with (t2 := (|[(a', a'0)]|) @ t'0); trivial.
  apply alpha_equiv_trans with 
  (t2 := (|[(|[(a, a')]| $ a, |[(a, a')]| $ a'0)]|) @ ((|[(a, a')]|) @ t'0)); trivial.
  rewrite swap_left. rewrite swap_neither; auto.
  apply alpha_equiv_equivariance. apply alpha_equiv_sym. 
  apply alpha_equiv_swap_neither; trivial. apply alpha_equiv_sym. 
  apply alpha_equiv_pi_comm. simpl; trivial.

  inverts H0. apply equiv_Su. intros. unfold In_ds in *|-.
  case (atom_eqdec a (!p $ (p' $ a))); intro H1. rewrite H1. apply H5.
  rewrite <- H1. apply perm_inv_side_atom in H1. rewrite <- H1. trivial.
  rewrite perm_diff_atom with (p:=p) in H1. gen_eq g : (!p). intro H2.
  replace (p $ (g $ (p' $ a))) with (!g $ (g $ (p' $ a))) in H1.
  rewrite perm_inv_atom in H1. apply H; trivial. rewrite H2.
  rewrite perm_inv_inv_atom; trivial.

  inverts H2. 
  apply equiv_A; simpl set_In; try lia.
  apply IHequiv1. apply alpha_equiv_TPith; auto.
  generalize H8; intro H8'.
  assert (Q : C |- Fc 0 n t ~aacc Fc 0 n t').
   apply equiv_A; simpl set_In; try lia; trivial.              
  apply alpha_equiv_TPlength with (E:=0) (n:=n) in H8'.
  apply aacc_equiv_TPlength with (E:=0) (n:=n) in Q.
  autorewrite with tuples in Q.
  case (nat_eqdec (TPlength t 0 n) 1); intro H9.
  rewrite 2 TPithdel_TPlength_1;
  autorewrite with tuples; try lia; auto.
  apply IHequiv2.
  rewrite 2 TPithdel_Fc_eq; autorewrite with tuples; try lia.
  apply alpha_equiv_Fc. apply alpha_equiv_TPithdel; trivial.

  inverts H2. generalize H8; intro H8'.
  assert (Q : C |- Fc 1 n t ~aacc Fc 1 n t').
   apply equiv_AC with (i:=i); repeat split~; simpl set_In; try lia; trivial.              
  apply alpha_equiv_TPlength with (E:=1) (n:=n) in H8'.
  apply aacc_equiv_TPlength with (E:=1) (n:=n) in Q.
  autorewrite with tuples in Q.
  apply equiv_AC with (i:=i); simpl set_In; repeat split~; try lia.
  apply IHequiv1. apply alpha_equiv_TPith; auto.
  case (nat_eqdec (TPlength t 1 n) 1); intro H9.
  rewrite 2 TPithdel_TPlength_1;
  autorewrite with tuples; try lia; auto.
  apply IHequiv2.
  rewrite 2 TPithdel_Fc_eq; autorewrite with tuples; try lia.
  apply alpha_equiv_Fc. apply alpha_equiv_TPithdel; trivial.
 
  inverts H2. inverts H8.
  apply IHequiv1 in H5.
  apply IHequiv2 in H7.
  apply equiv_C1; trivial.

  inverts H2. inverts H8.
  apply IHequiv1 in H7.
  apply IHequiv2 in H5.
  apply equiv_C2; trivial.

  (* <- *)

  induction H.
  exists (<<>>). split~.
  exists (%a). split~.
  case IHequiv1; clear IHequiv1; intros t1'' IH1.
  case IHequiv2; clear IHequiv2; intros t2'' IH2.
  destruct IH1. destruct IH2. exists (<|t1'',t2''|>). split~.
  case IHequiv; clear IHequiv; intros t'' H1. destruct H1.
  exists (Fc E n t''). split~. apply equiv_Fc; trivial.
  destruct H. left~. right~. destruct H. split~.
  destruct H3. left~. left~. apply aacc_neg_is_Pr in H0. apply H0; trivial.
  case IHequiv; clear IHequiv; intros t'' H0. destruct H0.
  exists ([a]^t''). split~.
  case IHequiv; clear IHequiv; intros t'' H2. destruct H2.
  exists ([a]^t''). split~.
  exists (p|.X). split~. apply equiv_Su; intros. false.
  case IHequiv1; clear IHequiv1; intros t3 H2.
  case IHequiv2; clear IHequiv2; intros t4 H3.
  destruct H2. destruct H3.
  assert (Q : C |- Fc 0 n t ~aacc Fc 0 n t').
   apply equiv_A; trivial.
  exists (Fc 0 n t'). split~. apply alpha_equiv_refl.
  assert (Q : C |- Fc 1 n t ~aacc Fc 1 n t').
   apply equiv_AC with (i:=i); trivial.
  exists (Fc 1 n t'). split~. apply alpha_equiv_refl.  
  assert (Q : C |- Fc 2 n (<| s0, s1 |>) ~aacc Fc 2 n (<| t0, t1 |>)).
   apply equiv_C1; trivial.
  exists (Fc 2 n (<| t0, t1 |>)). split~. apply alpha_equiv_refl.
  assert (Q : C |- Fc 2 n (<| s0, s1 |>) ~aacc Fc 2 n (<| t0, t1 |>)).
   apply equiv_C2; trivial.
  exists (Fc 2 n (<| t0, t1 |>)). split~. apply alpha_equiv_refl.
  
Qed.


(** Equivariance of aacc_equiv *)

Lemma aacc_equivariance : forall C t1 t2 pi,  
 C |- t1 ~aacc t2 -> C |- (pi @ t1) ~aacc (pi @ t2).
Proof.
  intros. induction H; intros; 
      autorewrite with tuples in *|-*; simpl perm_act in *|-*; auto.        

 destruct H. apply equiv_Fc; trivial.
 left~. destruct H. apply equiv_Fc; trivial.
 right~; intros. split~; intros.
 destruct H1; [left~ | right~]; apply perm_neg_is_Pr; trivial.
 
 apply equiv_Ab_2. apply perm_diff_atom; trivial.
 apply aacc_alpha_equiv_trans.
 exists (pi @ ((|[(a, a')]|) @ t')). split~.
 apply alpha_equiv_pi_comm.
 apply fresh_lemma_2; trivial.

 apply equiv_Su. intros. apply H. intro. apply H0.
 rewrite <- 2 perm_comp_atom. rewrite H1; trivial. 

 apply equiv_AC with (i:=i); repeat split~; simpl set_In; try lia.
 autorewrite with tuples in *|-*; trivial.
 assert (Q : C |- Fc 1 n t ~aacc Fc 1 n t').
  apply equiv_AC with (i:=i); repeat split~; simpl set_In; try lia;
  autorewrite with tuples; trivial.              
 apply aacc_equiv_TPlength with (E:=1) (n:=n) in Q.
 autorewrite with tuples in Q.
 case (nat_eqdec (TPlength t 1 n) 1); intro H4.
 rewrite 2 TPithdel_TPlength_1;
 autorewrite with tuples; try lia; auto.
 rewrite 2 TPithdel_Fc_eq in *|-*; autorewrite with tuples; try lia.
 autorewrite with perm in IHequiv2; trivial.
Qed.


(** A corollary about the swapping inversion of side in aacc_equiv *) 

Lemma aacc_equiv_swap_inv_side : forall C a a' t t', 
 C |- t ~aacc ((|[(a, a')]|) @ t') -> C |- ((|[(a', a)]|) @ t) ~aacc t'. 
Proof.
 intros. 
 apply aacc_alpha_equiv_trans.
 exists ((|[(a', a)]|) @ ((|[(a, a')]|) @ t')). split~.
 apply aacc_equivariance; trivial.
 apply perm_inv_side. simpl.
 apply alpha_equiv_pi. intros b H11. false. apply H11. apply swap_comm.
Qed.

(** Freshness preservation under aacc_equiv *) 

Lemma aacc_equiv_fresh : forall C a t1 t2,
                          C |- t1 ~aacc t2 ->
                          C |- a # t1 ->
                          C |- a # t2.
Proof.
 intros. induction H; trivial.
 apply fresh_Pr_elim in H0. destruct H0.
 apply fresh_Pr; [apply IHequiv1 | apply IHequiv2]; trivial.
 apply fresh_Fc_elim in H0. apply fresh_Fc; apply IHequiv; trivial.
 apply fresh_Ab_elim in H0. destruct H0. rewrite H0. apply fresh_Ab_1.
 destruct H0. apply fresh_Ab_2; trivial. apply IHequiv; trivial.
 apply fresh_Ab_elim in H0. destruct H0. apply fresh_Ab_2.
 intro. apply H. rewrite <- H0. trivial. rewrite <- H0 in H2. trivial.
 destruct H0. case (atom_eqdec a a'); intros.
 rewrite e. apply fresh_Ab_1. apply fresh_Ab_2; trivial.
 assert (Q : C |- a # ((|[(a0, a')]|) @ t')).  apply IHequiv; trivial.
 apply fresh_lemma_1 in Q. simpl rev in Q. rewrite swap_neither in Q; trivial.
 intro. apply H0. rewrite H4; trivial. intro. apply n. rewrite H4; trivial.
 apply fresh_Su. apply fresh_Su_elim in H0.
 case (atom_eqdec ((!p) $ a) ((!p') $ a)); intros. rewrite <- e; trivial.
 apply H; intros. intro. apply n. gen_eq g : (!p'); intro. 
 replace p' with (!g) in H1. rewrite perm_inv_atom in H1. 
 replace ((!p) $ a) with ((!p) $ (p $ (g $ a))). rewrite perm_inv_atom. trivial.
 rewrite H1. trivial. rewrite EQg. rewrite rev_involutive. trivial.

 apply fresh_Fc. apply fresh_Fc_elim in H0.
 apply fresh_TPith_TPithdel with (i:=1) (E:=0) (n:=n).
 apply fresh_TPith_TPithdel with (i:=1) (E:=0) (n:=n) in H0.
 destruct H0. split~. autorewrite with tuples in *|-. auto.
 assert (Q : C |- Fc 0 n t ~aacc Fc 0 n t').
  apply equiv_A; simpl set_In; try lia; trivial.              
 apply aacc_equiv_TPlength with (E:=0) (n:=n) in Q.
 autorewrite with tuples in Q. 
 case (nat_eqdec (TPlength t 0 n) 1); intro H4.
 rewrite TPithdel_TPlength_1;
 autorewrite with tuples; try lia; auto.
 rewrite 2 TPithdel_Fc_eq in *|-; autorewrite with tuples; try lia.
 apply fresh_Fc_elim with (E:=0) (n:=n).
 apply IHequiv2. apply fresh_Fc; trivial.

 apply fresh_Fc. apply fresh_Fc_elim in H0.
 apply fresh_TPith_TPithdel with (i:=i) (E:=1) (n:=n).
 apply fresh_TPith_TPithdel with (i:=1) (E:=1) (n:=n) in H0.
 destruct H0. split~. autorewrite with tuples in *|-. auto.
 assert (Q : C |- Fc 1 n t ~aacc Fc 1 n t').
  apply equiv_AC with (i:=i); repeat split~; simpl set_In; try lia; trivial.              
 apply aacc_equiv_TPlength with (E:=1) (n:=n) in Q.
 autorewrite with tuples in Q.
 case (nat_eqdec (TPlength t 1 n) 1); intro H7.
 rewrite TPithdel_TPlength_1;
 autorewrite with tuples; try lia; auto.
 rewrite 2 TPithdel_Fc_eq in *|-; autorewrite with tuples; try lia.
 apply fresh_Fc_elim with (E:=1) (n:=n).
 apply IHequiv2. apply fresh_Fc; trivial. 

 apply fresh_Fc. apply fresh_Fc_elim in H0.
 apply fresh_Pr_elim in H0. destruct H0.
 apply fresh_Pr; [apply IHequiv1 | apply IHequiv2]; trivial. 

 apply fresh_Fc. apply fresh_Fc_elim in H0.
 apply fresh_Pr_elim in H0. destruct H0.
 apply fresh_Pr; [apply IHequiv2 | apply IHequiv1]; trivial. 

Qed.


(** Reflexivity of aacc_equiv *)
  
Lemma aacc_equiv_refl : forall C t, C |- t ~aacc t.
Proof.
  intros. induction t; auto.
  apply aacc_equiv_Fc; trivial.
  apply equiv_Su; intros. false.
Qed.

Hint Resolve aacc_equiv_refl.


(** A Corollary: the order of the atoms inside a swapping doesn't matter in aacc_equiv *)

Corollary aacc_equiv_swap_comm : forall C t a a', 
  C |- (|[(a, a')]|) @ t ~aacc ((|[(a', a)]|) @ t) .
Proof.
 intros. apply aacc_alpha_equiv_trans. 
 exists ((|[(a, a')]|) @ t). split~.
 apply alpha_equiv_pi. intros b H11. false. apply H11. apply swap_comm.
Qed.


(** Combination of AC arguments *)

Lemma aacc_equiv_TPith_l : forall C t t' i E n, C |- t ~aacc t' -> 
                         i > 0 -> i <= TPlength t E n ->
               exists j, j > 0 /\ j <= TPlength t' E n /\
                         C |- TPith i t E n ~aacc TPith j t' E n /\ 
                         C |- TPithdel i t E n ~aacc TPithdel j t' E n.
Proof.
  intros. gen_eq l : (term_size t).
  intro H2. gen i t t' H2 H0 H1. induction l using peano_induction; intros.
  destruct H0.
  
  exists 1. simpl. repeat split~; try lia; auto.
  exists 1. simpl. repeat split~; try lia; auto.
 
  simpl in H2. generalize H0_ H0_0. intros H0' H0_0'.
  apply aacc_equiv_TPlength with (E:=E) (n:=n) in H0'.
  apply aacc_equiv_TPlength with (E:=E) (n:=n) in H0_0'.
  assert (Q:TPlength t1 E n >= 1 /\ TPlength t2 E n >= 1). auto. destruct Q.
  case (le_dec i (TPlength t1 E n)); intro H5.
  case H with (m:=term_size t1) (i:=i) (t:=t1) (t':=t1'); try lia; trivial; clear H.
  intros j H6. destruct H6. destruct H6. destruct H7. exists j.
  rewrite 2 TPith_Pr_le; try lia. 
  case (nat_eqdec (TPlength t1 E n) 1); intro H9.
  rewrite 2 TPithdel_t1_Pr; try lia. simpl.
  repeat split~; try lia; trivial.
  rewrite 2 TPithdel_Pr_le; try lia.
  simpl; repeat split~; try lia; auto.
  case H with (m:=term_size t2)
              (i:=i - TPlength t1 E n) (t:=t2) (t':=t2'); try lia; trivial; clear H.
  simpl in H3. lia.
  intros j H6. destruct H6. destruct H6. destruct H7. exists (TPlength t1 E n + j).
  rewrite 2 TPith_Pr_gt; try lia. rewrite <- H0'.
  replace (TPlength t1 E n + j - TPlength t1 E n) with j; try lia. 
  case (nat_eqdec (TPlength t2 E n) 1); intro H9.
  rewrite 2 TPithdel_t2_Pr; try lia.
  repeat split~; try lia; trivial. simpl; lia.
  rewrite 2 TPithdel_Pr_gt; try lia.
  replace (TPlength t1 E n + j - TPlength t1' E n) with j; try lia.
  simpl; repeat split~; try lia; auto.

  case (nat_pair_eqdec (E0,n0) (E,n)); intro H5. inverts H5.
  generalize H4; intro H4'.
  apply aacc_equiv_TPlength with (E:=E) (n:=n) in H4'.
  case (nat_eqdec (TPlength t E n) 1); intro H5. exists 1.
  rewrite 2 TPithdel_TPlength_1; autorewrite with tuples; try lia; auto.
  assert (i=1). autorewrite with tuples in H3. lia. rewrite H6 in *|-*.
  repeat split~; try lia; trivial.
  apply aacc_equiv_TPith_l1 with (E:=E) (n:=n) in H4.
  destruct H4. destruct H4. destruct H7. destruct H8.
  assert (x = 1). lia. rewrite H10 in H8; trivial.  
  destruct H0. exists i.
  autorewrite with tuples in *|-*.
  generalize H4; intro H4''.
  apply aacc_equiv_TPith_E_diff_1_2 with (i:=i) (E:=E) (n:=n) in H4. destruct H4.
  rewrite 2 TPithdel_Fc_eq; try lia.
  repeat split~; try lia; trivial.
  simpl in *|-*. lia.
  destruct H0. rewrite H0 in *|-*.
  autorewrite with tuples in H3. simpl in H2.
  case H with (m := term_size t) (i := i) (t := t) (t' := t'); try lia; trivial.
  intros j Hj. exists j. autorewrite with tuples.
  rewrite 2 TPithdel_Fc_eq; try lia.
  destruct Hj. destruct H8. destruct H9. repeat split~.
  apply equiv_Fc_c; trivial.
  exists 1. rewrite TPlength_Fc_diff in *|-*; trivial.
  rewrite 2 TPith_Fc_diff; trivial.
  rewrite 2 TPithdel_Fc_diff; trivial.
  repeat split~; try lia; auto.
  
  exists 1. simpl. repeat split~; try lia; auto.
  exists 1. simpl. repeat split~; try lia; auto.
  exists 1. simpl. repeat split~; try lia; auto.
  
  clear H0. case (set_In_dec nat_eqdec E (1::(|[2]|))); intro H4.
  exists 1. assert (Q:(0,n0) <> (E,n)). intro. inverts H0.
  simpl in H4. lia.
  rewrite TPlength_Fc_diff in *|-*; trivial.
  rewrite 2 TPith_Fc_diff; trivial.
  rewrite 2 TPithdel_Fc_diff; trivial.
  repeat split~; try lia; auto. 
  apply equiv_A; simpl set_In; try lia; trivial.
  exists i. split~; auto.
  assert (Q: C |- Fc 0 n0 t ~aacc Fc 0 n0 t').
   apply equiv_A; simpl set_In; try lia; trivial.
  generalize Q; intro Q'. apply aacc_equiv_TPlength with (E:=E) (n:=n) in Q'.
  apply aacc_equiv_TPith_E_diff_1_2 with (E:=E) (n:=n) (i:=i) in Q; trivial.
  destruct Q. repeat split~; try lia; trivial.

  clear H0. case (nat_pair_eqdec (1,n0) (E,n)); intro H4. inverts H4.
  autorewrite with tuples in *|-*.  
  
  case (nat_eqdec i 1); intro H4. rewrite H4.
  case (le_dec i0 1); intro H5.
  exists 1. case (nat_eqdec i0 0); intro H6; repeat rewrite H6 in *|-;
  repeat rewrite TPith_0 in *|-; repeat rewrite TPithdel_0 in *|-. 
  repeat split~; trivial; autorewrite with tuples; auto.
  assert (Qi0:i0=1). lia. rewrite Qi0 in *|-.
  repeat split~; trivial; autorewrite with tuples; auto.

  case (le_dec i0 (TPlength t' 1 n)); intro H6.

  exists i0. repeat split~; autorewrite with tuples; try lia; trivial.
  exists (TPlength t' 1 n).
  rewrite TPith_overflow with (i:=i0) in H0_; autorewrite with tuples; try lia.
  rewrite TPithdel_overflow with (i:=i0) in H0_0; autorewrite with tuples; try lia.
  repeat split~; try lia; autorewrite with tuples in *|-*; auto.
  
  assert (Q0 : C |- Fc 1 n t ~aacc Fc 1 n t').
   apply equiv_AC with (i:=i0); repeat split~; simpl set_In;
   autorewrite with tuples; try lia; trivial.              
  apply aacc_equiv_TPlength with (E:=1) (n:=n) in Q0.
  autorewrite with tuples in Q0. 
  assert (Q: TPlength t 1 n >=1). auto.
  case (nat_eqdec (TPlength t 1 n) 1); intro H5; try lia.
  rewrite 2 TPithdel_Fc_eq in H0_0; try lia. 
  
  case H with (m  := term_size (Fc 1 n (TPithdel 1 t 1 n))) (i := i-1)
              (t  := Fc 1 n (TPithdel 1 t 1 n))
              (t' := Fc 1 n (TPithdel i0 t' 1 n));
              autorewrite with tuples;
              try rewrite TPlength_TPithdel; try lia; trivial; clear H.
     
  simpl. simpl in H2.
  assert (Q1: term_size (TPithdel 1 t 1 n) < term_size t).
   apply term_size_TPithdel; trivial. lia.
  intros j Hj. destruct Hj. destruct H0 . destruct H6.  
  autorewrite with tuples in H6.
  apply aacc_equiv_TPlength with (E:=1) (n:=n) in H0_0.
  autorewrite with tuples in H0_0.
  rewrite 2 TPlength_TPithdel in H0_0; try lia.

  case (le_dec i0 j); intro H8.
 
  exists (j + 1). autorewrite with tuples.
  rewrite 2 TPith_TPithdel_geq in H6; try lia.
  replace (i - 1 + 1) with i in *|-; try lia.
  rewrite 2 TPithdel_Fc_eq; try lia. 
  repeat split~; try lia; trivial.
  case (nat_eqdec i0 0); intro H9. rewrite H9 in *|-.
  rewrite TPith_0 in H0_. rewrite TPithdel_0 in H7.
  
  apply equiv_AC with (i:=1); simpl set_In;
  repeat split~; try rewrite TPlength_TPithdel; try lia; trivial. 
  autorewrite with tuples. 
  rewrite 2 TPith_TPithdel_lt; try lia; trivial.
  case (nat_eqdec (TPlength t 1 n) 2); intro H10.
  rewrite 2 TPithdel_TPlength_1; autorewrite with tuples;
  try rewrite TPlength_TPithdel; try lia; auto.
  rewrite 2 TPithdel_Fc_eq; try rewrite TPlength_TPithdel; try lia.
  rewrite 2 TPithdel_Fc_eq in H7; try rewrite TPlength_TPithdel; try lia.
  rewrite TPithdel_geq_comm in H7; try lia.
  rewrite TPithdel_geq_comm with (i:=j) in H7; try lia.
  replace (i - 1 + 1) with i in H7; try lia; trivial.

  apply equiv_AC with (i:=i0); simpl set_In;
  repeat split~; try rewrite TPlength_TPithdel; try lia; trivial. 
  autorewrite with tuples. 
  rewrite 2 TPith_TPithdel_lt; try lia; trivial.
  case (nat_eqdec (TPlength t 1 n) 2); intro H10.
  rewrite 2 TPithdel_TPlength_1; autorewrite with tuples;
  try rewrite TPlength_TPithdel; try lia; auto.
  rewrite 2 TPithdel_Fc_eq; try rewrite TPlength_TPithdel; try lia.
  rewrite 2 TPithdel_Fc_eq in H7; try rewrite TPlength_TPithdel; try lia.
  rewrite TPithdel_geq_comm in H7; try lia.
  rewrite TPithdel_geq_comm with (i:=j) in H7; try lia.
  replace (i - 1 + 1) with i in H7; try lia; trivial.
  
  exists j.
  rewrite TPith_TPithdel_geq in H6; try lia.
  rewrite TPith_TPithdel_lt in H6; try lia.
  replace (i - 1 + 1) with i in *|-; try lia.
  rewrite 2 TPithdel_Fc_eq; try lia. autorewrite with tuples.
  repeat split~; try lia; trivial.

  case (le_dec i0 (TPlength t' 1 n)); intro H9.
  
  apply equiv_AC with (i:=i0-1); simpl set_In;
  repeat split~; try rewrite TPlength_TPithdel; try lia; trivial. 
  autorewrite with tuples. rewrite TPith_TPithdel_lt; try lia; trivial.
  rewrite TPith_TPithdel_geq; try lia; trivial.
  replace (i0 - 1 + 1) with i0; try lia; trivial.
  case (nat_eqdec (TPlength t 1 n) 2); intro H10.
  assert (Qi0:i0=2). lia. rewrite Qi0.
  replace (2-1) with 1; try lia.
  rewrite 2 TPithdel_TPlength_1; autorewrite with tuples;
  try rewrite TPlength_TPithdel; try lia; auto.
  rewrite 2 TPithdel_Fc_eq; try rewrite TPlength_TPithdel; try lia.
  rewrite 2 TPithdel_Fc_eq in H7; try rewrite TPlength_TPithdel; try lia.
  rewrite TPithdel_geq_comm in H7; try lia.
  rewrite TPithdel_lt_comm with (i:=j) in H7; try lia.
  replace (i - 1 + 1) with i in H7; try lia; trivial.

  rewrite TPithdel_overflow with (i:=i0) in H7; try lia.
  rewrite TPith_overflow with (i:=i0) in H0_; try lia.

  apply equiv_AC with (i:=TPlength t' 1 n -1); simpl set_In;
  repeat split~; try rewrite TPlength_TPithdel; try lia; trivial. 
  autorewrite with tuples. rewrite TPith_TPithdel_lt; try lia; trivial.
  rewrite TPith_TPithdel_geq; try lia; trivial.
  replace (TPlength t' 1 n - 1 + 1) with (TPlength t' 1 n); try lia; trivial.
  case (nat_eqdec (TPlength t 1 n) 2); intro H10.
  assert (Qi0:TPlength t' 1 n=2). lia. rewrite Qi0.
  replace (2-1) with 1; try lia.
  rewrite 2 TPithdel_TPlength_1; autorewrite with tuples;
  try rewrite TPlength_TPithdel; try lia; auto.
  rewrite 2 TPithdel_Fc_eq; try rewrite TPlength_TPithdel; try lia.
  rewrite 2 TPithdel_Fc_eq in H7; try rewrite TPlength_TPithdel; try lia.
  rewrite TPithdel_geq_comm in H7; try lia.
  rewrite TPithdel_lt_comm with (i:=j) in H7; try lia.
  replace (i - 1 + 1) with i in H7; try lia; trivial.
  
  exists 1. 
  rewrite TPlength_Fc_diff;
  try rewrite 2 TPith_Fc_diff; 
  try rewrite 2 TPithdel_Fc_diff; trivial.
  repeat split~; try lia.
  apply equiv_AC with (i:=i0); simpl set_In; try lia; trivial.  

  simpl in H2. clear H0. case (nat_pair_eqdec (2,n0) (E,n)); intro H4.
  inverts H4. autorewrite with tuples in H3|-*. simpl in H3.
  case H with (m := term_size (<|s0,s1|>)) (i:=i) (t:=<| s0, s1 |>) (t':=<| t0, t1 |>);
    simpl TPlength; simpl term_size; try lia.
  apply equiv_Pr; trivial. intros j Hj. exists j. autorewrite with tuples.
  rewrite 2 TPithdel_Fc_eq. destruct Hj. destruct H4. destruct H5.
  repeat split~. apply equiv_Fc_c; trivial.
  assert (Q: TPlength t0 2 n >=1 /\ TPlength t1 2 n >=1). split~. simpl. lia.
  assert (Q: TPlength s0 2 n >=1 /\ TPlength s1 2 n >=1). split~. simpl. lia.
  exists 1. rewrite TPlength_Fc_diff in *|-*; trivial.
  assert (i=1). lia. rewrite H0. rewrite 2 TPith_Fc_diff; trivial.
  rewrite 2 TPithdel_TPlength_1; try rewrite TPlength_Fc_diff; trivial.
  repeat split~. apply equiv_C1; trivial. simpl. right~.

  simpl in H2. clear H0. case (nat_pair_eqdec (2,n0) (E,n)); intro H4.
  inverts H4. autorewrite with tuples in H3. simpl in H3.
 
  generalize H0_ H0_0. intros H' H''.
  apply aacc_equiv_TPlength with (E:=2) (n:=n) in H'.
  apply aacc_equiv_TPlength with (E:=2) (n:=n) in H''.
  assert (Q: TPlength s0 2 n >=1 /\ TPlength s1 2 n >=1). split~. 

  case (le_dec i (TPlength s0 2 n)); intro H7.

  case H with (m := term_size (<|s0,s1|>)) (i:=TPlength s1 2 n + i) (t:=<| s1, s0 |>) (t':=<| t0, t1 |>);
    simpl term_size; try lia; clear H.
  apply equiv_Pr; trivial.
  simpl; lia. intros j Hj. destruct Hj. destruct H0. destruct H4.
  exists j. autorewrite with tuples.
  
  rewrite 2 TPithdel_Fc_eq; simpl TPlength; try lia.
  case (le_dec j (TPlength t0 2 n)); intro H8.
  repeat split~; try lia. 
  rewrite 2 TPith_Pr_le; trivial.
  rewrite TPith_Pr_gt in H4; try lia. rewrite TPith_Pr_le in H4; trivial.
  replace (TPlength s1 2 n + i - TPlength s1 2 n) with i in H4;try lia; trivial.
  case (nat_eqdec (TPlength s0 2 n) 1); intro H9.
  rewrite TPithdel_t1_Pr; try lia.
  rewrite TPithdel_t2_Pr in H5; try lia.
  apply equiv_Fc_c; trivial.
  rewrite TPithdel_Pr_le; trivial.
  rewrite TPithdel_Pr_gt in H5; try lia.
  replace (TPlength s1 2 n + i - TPlength s1 2 n) with i in H5; try lia.
  case (nat_eqdec (TPlength t0 2 n) 1); intro H10.
  rewrite TPithdel_t1_Pr; try lia.
  rewrite TPithdel_t1_Pr in H5; try lia. inverts H5.
  apply equiv_C2; trivial. simpl; right~.
  rewrite TPithdel_Pr_le; try lia.
  rewrite TPithdel_Pr_le in H5; try lia. inverts H5.
  apply equiv_C2; trivial. simpl; right~.

  repeat split~; try lia. 
  rewrite TPith_Pr_le; trivial.
  rewrite TPith_Pr_gt; try lia.
  rewrite TPith_Pr_gt in H4; try lia. rewrite TPith_Pr_gt in H4; try lia.
  replace (TPlength s1 2 n + i - TPlength s1 2 n) with i in H4;try lia; trivial.
  case (nat_eqdec (TPlength s0 2 n) 1); intro H9.
  rewrite TPithdel_t1_Pr; try lia.
  rewrite TPithdel_t2_Pr in H5; try lia.
  apply equiv_Fc_c; trivial.
  rewrite TPithdel_Pr_le; trivial.
  rewrite TPithdel_Pr_gt in H5; try lia.
  replace (TPlength s1 2 n + i - TPlength s1 2 n) with i in H5; try lia.
  case (nat_eqdec (TPlength t1 2 n) 1); intro H10.
  rewrite TPithdel_t2_Pr; try lia.
  rewrite TPithdel_Pr_gt; try lia.
  rewrite TPithdel_Pr_gt in H5; try lia. inverts H5.
  apply equiv_C2; trivial. simpl; right~.


  case H with (m := term_size (<|s0,s1|>)) (i:=i - TPlength s0 2 n) (t:=<| s1, s0 |>) (t':=<| t0, t1 |>);
    simpl term_size; try lia; clear H.
  apply equiv_Pr; trivial.
  simpl; lia. intros j Hj. destruct Hj. destruct H0. destruct H4.
  exists j. autorewrite with tuples.
  
  rewrite 2 TPithdel_Fc_eq; simpl TPlength; try lia.
  case (le_dec j (TPlength t0 2 n)); intro H8.
  repeat split~; try lia. 
  rewrite TPith_Pr_gt; try lia.
  rewrite TPith_Pr_le; try lia.
  rewrite 2 TPith_Pr_le in H4; try lia; trivial.
   case (nat_eqdec (TPlength s1 2 n) 1); intro H9.
  rewrite TPithdel_t2_Pr; try lia.
  rewrite TPithdel_t1_Pr in H5; try lia.
  apply equiv_Fc_c; trivial.
  rewrite TPithdel_Pr_gt; try lia.
  rewrite TPithdel_Pr_le in H5; try lia.
  case (nat_eqdec (TPlength t0 2 n) 1); intro H10.
  rewrite TPithdel_t1_Pr; try lia.
  rewrite TPithdel_Pr_le; try lia.
  rewrite TPithdel_Pr_le in H5; try lia. inverts H5.
  apply equiv_C2; trivial. simpl; right~.

  repeat split~; try lia. 
  rewrite 2 TPith_Pr_gt; try lia.
  rewrite TPith_Pr_le in H4; try lia. rewrite TPith_Pr_gt in H4; try lia; trivial.
   case (nat_eqdec (TPlength s1 2 n) 1); intro H9.
  rewrite TPithdel_t2_Pr; try lia.
  rewrite TPithdel_t1_Pr in H5; try lia.
  apply equiv_Fc_c; trivial.
  rewrite TPithdel_Pr_gt; try lia.
  rewrite TPithdel_Pr_le in H5; try lia.
   case (nat_eqdec (TPlength t1 2 n) 1); intro H10.
  rewrite TPithdel_t2_Pr; try lia.
  rewrite TPithdel_t2_Pr in H5; try lia. inverts H5.
  apply equiv_C2; trivial. simpl; right~.
  rewrite TPithdel_Pr_gt; try lia.
  rewrite TPithdel_Pr_gt in H5; try lia. inverts H5.
  apply equiv_C2; trivial. simpl. right~.
  
  exists 1. rewrite TPlength_Fc_diff in *|-*; trivial.
  assert (i=1). lia. rewrite H0. rewrite 2 TPith_Fc_diff; trivial.
  rewrite 2 TPithdel_TPlength_1; try rewrite TPlength_Fc_diff; trivial.
  repeat split~. apply equiv_C2; trivial. simpl. right~.
  
Qed.

Lemma aacc_equiv_TPith_l' : forall C t t' E n,  C |- t ~aacc t' -> 
                           forall i, exists j, C |- TPith i t E n ~aacc TPith j t' E n /\ 
                                               C |- TPithdel i t E n ~aacc TPithdel j t' E n.
Proof.
  intros. case (nat_eqdec i 0); intro H0.
  rewrite H0. rewrite TPith_0. rewrite TPithdel_0.
  apply aacc_equiv_TPith_l with (i:=1) (E:=E) (n:=n) in H; try lia; auto.
  destruct H. destruct H. destruct H1. destruct H2.
  exists x. split~.
  case (le_dec i (TPlength t E n)); intro H1.
  apply aacc_equiv_TPith_l with (i:=i) (E:=E) (n:=n) in H; try lia.
  destruct H. destruct H. destruct H2. destruct H3.
  exists x. split~. 
  rewrite TPith_overflow; try lia.
  rewrite TPithdel_overflow; try lia.
  apply aacc_equiv_TPith_l with (i:=TPlength t E n) (E:=E) (n:=n) in H; try lia; auto.
  destruct H. destruct H. destruct H2. destruct H3.
  exists x. split~.
Qed.
  


(** Transitivity of aacc_equiv *)

Lemma aacc_equiv_trans : forall C t1 t2 t3,
 C |- t1 ~aacc t2 -> C |- t2 ~aacc t3 -> C |- t1 ~aacc t3.
Proof.
(* introv. gen_eq l : (term_size t1). gen t1 t2 t3.
 induction l using peano_induction; intros. 

 inverts H0; inverts H1; auto; simpl term_size in *|-; try lia; try contradiction.
 
 simpl in *. apply equiv_Pr. 
 apply H with (t2 := t1') (m := term_size t0); try lia; trivial.
 apply H with (t2 := t2') (m := term_size t4); try lia; trivial. 

 simpl in *. apply equiv_Fc; trivial.
 destruct H3. left~. destruct H1. right~. split~.
 destruct H2. left~. right~. apply aacc_neg_is_Pr in H10.
 apply H10; trivial.
 
 apply H with (t2 := t') (m := term_size t); try lia; trivial.

 false. destruct H3. apply H1. simpl. left~.
 destruct H1. lia.
 false. destruct H3. apply H1. simpl. right~.
 destruct H1. lia.
 inverts H4. destruct H3; try contradiction.
 destruct H1. simpl in H2. false. destruct H2; apply H2; trivial.
 inverts H4. destruct H3; try contradiction.
 destruct H1. simpl in H2. false. destruct H2; apply H2; trivial. 

 apply equiv_Ab_1. 
 apply H with (t2 := t') (m := term_size t); try lia; trivial.
 simpl in H0. apply equiv_Ab_2; trivial.
 apply H with (t2 := t') (m := term_size t); try lia; trivial. 
 simpl in H0. apply equiv_Ab_2; trivial.
 apply H with (t2 := ((|[(a, a')]|) @ t')) (m := term_size t); try lia; trivial.
 apply aacc_equivariance; trivial. 
 apply aacc_equiv_fresh with (a:=a) in H9; trivial.

 case (atom_eqdec a a'0); intro H1. rewrite H1. 
 simpl in H0. apply equiv_Ab_1.
 apply H with (t2 := ((|[(a, a')]|) @ t')) (m := term_size t); try lia; trivial.
 apply aacc_equiv_swap_inv_side. rewrite H1. trivial.

 assert (Q:  C |- a # t'0). 
  apply aacc_equiv_fresh with (a:=a) in H9; trivial.
  apply fresh_lemma_1 in H9. simpl rev in H9. 
  rewrite swap_neither in H9; auto.
 apply equiv_Ab_2; trivial.
 assert (Q' : C |- t ~aacc ((|[(a, a')]|) @ ((|[(a', a'0)]|) @ t'0))). 
  apply H with (t2 := ((|[(a, a')]|) @ t')) (m := term_size t); trivial. 
  simpl in H0. lia. apply aacc_equivariance; trivial.
 apply aacc_alpha_equiv_trans.
 exists (((|[(a, a')]|) @ ((|[(a', a'0)]|) @ t'0))); split~. 
 apply alpha_equiv_trans with 
 (t2 := (|[((|[(a,a')]|) $ a', (|[(a,a')]|) $ a'0)]|) @ ((|[(a, a')]|) @ t'0)). 
 apply alpha_equiv_pi_comm. rewrite swap_right. rewrite swap_neither; trivial.
 apply alpha_equiv_equivariance. apply alpha_equiv_swap_neither; trivial.

 apply equiv_Su; intros.
 case (In_ds_dec p p' a); intros. apply H3; trivial.
 apply H7. apply not_In_ds in H2. unfold In_ds in *|-*. 
 rewrite <- H2; trivial.

 false. destruct H10. apply H1. simpl. left~.
 destruct H1. lia.
 
 apply equiv_A; simpl set_In; try lia.
 autorewrite with tuples in *|-*.
 apply H with (m:=term_size (TPith 1 t 0 n))
              (t2:=  TPith 1 t' 0 n); trivial.
 assert (Q: term_size (TPith 1 t 0 n) <= term_size t).
  apply term_size_TPith.
 lia.
 assert (Q0: C |- Fc 0 n t ~aacc Fc 0 n t'). 
  apply equiv_A; simpl set_In; try lia; trivial.
 assert (Q1: C |- Fc 0 n t' ~aacc Fc 0 n t'0). 
  apply equiv_A; simpl set_In; try lia; trivial.
 apply aacc_equiv_TPlength with (E:=0) (n:=n) in Q0. 
 apply aacc_equiv_TPlength with (E:=0) (n:=n) in Q1.
 autorewrite with tuples in *|-.
 case (nat_eqdec (TPlength t 0 n) 1); intro H8.
 rewrite 2 TPithdel_TPlength_1;
 autorewrite with tuples; try lia; auto.
 rewrite 2 TPithdel_Fc_eq in *|-*; autorewrite with tuples; try lia.
 apply H with (t2:=Fc 0 n (TPithdel 1 t' 0 n)) 
              (m:=term_size (Fc 0 n (TPithdel 1 t 0 n))); trivial.
 assert (Q2 : term_size (TPithdel 1 t 0 n) < term_size t).
  apply term_size_TPithdel; trivial.
 simpl. lia.

 false. destruct H10. apply H1. simpl. right~.
 destruct H1. lia.
 
 assert (Q0: C |- Fc 1 n t ~aacc Fc 1 n t'). 
  apply equiv_AC with (i:=i); repeat split~; simpl set_In; try lia; trivial.
 assert (Q1: C |- Fc 1 n t' ~aacc Fc 1 n t'0). 
  apply equiv_AC with (i:=i0); repeat split~; simpl set_In; try lia; trivial.
 generalize Q1; intro Q2.
 apply aacc_equiv_TPlength with (E:=1) (n:=n) in Q0. autorewrite with tuples in Q0.
 apply aacc_equiv_TPlength with (E:=1) (n:=n) in Q1. autorewrite with tuples in Q1.
 apply aacc_equiv_TPith_l' with (i:=i) (E:=1) (n:=n) in Q2;
 autorewrite with tuples; try lia.
 destruct Q2. destruct H1. 
 apply equiv_AC with (i:=x); try split~; simpl set_In; try lia;
 autorewrite with tuples in *|-*; trivial. 
 apply H with (t2:=TPith i t' 1 n) (m:=term_size (TPith 1 t 1 n)); trivial. 
 assert (Q2 : term_size (TPith 1 t 1 n) <= term_size t).
  apply term_size_TPith. 
 lia.
 case (nat_eqdec (TPlength t 1 n) 1); intro H12.
 rewrite 2 TPithdel_TPlength_1;
 autorewrite with tuples; try lia; auto.
 rewrite 2 TPithdel_Fc_eq in *|-*; autorewrite with tuples; try lia. 
 apply H with (t2:=Fc 1 n (TPithdel i t' 1 n)) (m:=term_size (Fc 1 n (TPithdel 1 t 1 n))); trivial. 
 assert (Q2 : term_size (TPithdel 1 t 1 n) < term_size t).
  apply term_size_TPithdel; trivial.
 simpl. lia.

 inverts H11. destruct H10; try contradiction.
 destruct H1. simpl in H2. false. destruct H2; apply H2; trivial.
 
 apply equiv_C1. simpl. right~.
  apply H with (t2 := t0) (m := term_size s0); try lia; trivial.
  apply H with (t2 := t4) (m := term_size s1); try lia; trivial.
  
 apply equiv_C2. simpl. right~.
  apply H with (t2 := t0) (m := term_size s0); try lia; trivial.
  apply H with (t2 := t4) (m := term_size s1); try lia; trivial.

 inverts H11. destruct H10; try contradiction.
 destruct H1. simpl in H2. false. destruct H2; apply H2; trivial.
 
 apply equiv_C2. simpl. right~.
  apply H with (t2 := t4) (m := term_size s0); try lia; trivial.
  apply H with (t2 := t0) (m := term_size s1); try lia; trivial.

 apply equiv_C1. simpl. right~.
  apply H with (t2 := t4) (m := term_size s0); try lia; trivial.
  apply H with (t2 := t0) (m := term_size s1); try lia; trivial.  

Qed. *) Admitted.


(** In AC choosing the ith element is arbitrary in both sides *)

Lemma aacc_equiv_AC : forall C t t' i j n,
      C |- TPith i (Fc 1 n t) 1 n ~aacc TPith j (Fc 1 n t') 1 n  ->
      C |- TPithdel i (Fc 1 n t) 1 n ~aacc TPithdel j (Fc 1 n t') 1 n ->
                           C |- Fc 1 n t ~aacc Fc 1 n t'.
Proof.
  intros. gen_eq l : (TPlength t 1 n); intro H1.
  gen t t' H1 i j. induction l using peano_induction; intros.
  case (nat_eqdec i 1); intro Qi. rewrite Qi in *|-.
  apply equiv_AC with (i:=j); repeat split~; simpl set_In;
  try lia; trivial. 
  case (nat_eqdec i 0); intro Qi'. rewrite Qi' in *|-.
  repeat rewrite TPith_0 in *|-; repeat rewrite TPithdel_0 in *|-.
  apply equiv_AC with (i:=j); simpl set_In; try lia; trivial.  
  
  case (nat_eqdec (TPlength t 1 n) 1);
  case (nat_eqdec (TPlength t' 1 n) 1); intros H3 H4.
  apply equiv_AC with (i:=j); simpl set_In; try lia.
  autorewrite with tuples in *|-*. 
  try rewrite TPith_overflow with (i:=i) in H0; try lia.
  rewrite H4 in H0; trivial.
  rewrite 2 TPithdel_TPlength_1; autorewrite with tuples; trivial.
  rewrite TPithdel_TPlength_1 in H2; autorewrite with tuples; trivial.
  rewrite TPithdel_Fc_eq in H2; trivial. inverts H2.
  rewrite TPithdel_Fc_eq in H2; trivial.
  rewrite TPithdel_TPlength_1 with (t:= (Fc 1 n t'))in H2;
  autorewrite with tuples; trivial. inverts H2.  
  rewrite 2 TPithdel_Fc_eq in H2; try lia.
  autorewrite with tuples in H0.  
  generalize H2; intro H2'.
  apply aacc_equiv_TPlength with (E:=1) (n:=n) in H2'.
  autorewrite with tuples in H2'.
  rewrite 2 TPlength_TPithdel in H2'; try lia; trivial.
  apply aacc_equiv_TPith_l1 with (E:=1) (n:=n) in H2.
  destruct H2. destruct H2. destruct H5. destruct H6.
  autorewrite with tuples in *|-.
  rewrite TPlength_TPithdel in *|-; try lia.

  case (le_dec j x); intro H8.
   
  rewrite TPith_TPithdel_lt in H6; try lia.
  rewrite TPith_TPithdel_geq in H6; try lia.
  apply equiv_AC with (i:=x+1); 
  repeat split~; simpl set_In; try lia; trivial;
  try rewrite 2 TPithdel_Fc_eq; try lia.
  autorewrite with tuples; trivial.
  apply H with (i:=i-1) (j:=j) (m:=TPlength (TPithdel 1 t 1 n) 1 n);
  try rewrite TPlength_TPithdel; autorewrite with tuples; try lia.

  case (le_dec i (TPlength t 1 n)); intro H9.
  rewrite TPith_TPithdel_geq; try lia.

  case (nat_eqdec j 0); intro H10; try rewrite H10 in *|-*;
  repeat rewrite TPith_0 in *|-*;
  rewrite TPith_TPithdel_lt; try lia;
  replace (i -1 + 1) with i; try lia; trivial.
  rewrite TPith_overflow with (i:=i-1);
  try rewrite TPlength_TPithdel; try lia.
  rewrite TPith_overflow with (i:=i) in H0; try lia.
  rewrite TPith_TPithdel_geq; try lia.
  case (nat_eqdec j 0); intro H10; try rewrite H10 in *|-*;
  repeat rewrite TPith_0 in *|-*;
  rewrite TPith_TPithdel_lt; try lia;
  replace (TPlength t 1 n -1 + 1) with (TPlength t 1 n); try lia; trivial.  
  
  case (nat_eqdec (TPlength t 1 n) 2); intro H9.
  rewrite 2 TPithdel_TPlength_1; autorewrite with tuples; 
  try rewrite TPlength_TPithdel; try lia; auto.
  
  rewrite 2 TPithdel_Fc_eq; try rewrite TPlength_TPithdel; try lia.
  rewrite 2 TPithdel_Fc_eq in H7;
  try rewrite TPlength_TPithdel; try lia.

  case (le_dec i (TPlength t 1 n)); intro H10.
  
  rewrite TPithdel_lt_comm in H7; try lia.
  rewrite TPithdel_geq_comm with (i:=x) in H7; try lia; trivial.

  rewrite TPithdel_overflow with (i:=i-1);
  try rewrite TPlength_TPithdel; try lia.
  rewrite TPithdel_overflow with (i:=i) in H7; try lia.  
  rewrite TPithdel_lt_comm in H7; try lia.
  rewrite TPithdel_geq_comm with (i:=x) in H7; try lia; trivial.
  
  rewrite 2 TPith_TPithdel_lt in H6; try lia.
  apply equiv_AC with (i:=x); 
  repeat split~; simpl set_In; try lia; trivial;
  try rewrite 2 TPithdel_Fc_eq; try lia. autorewrite with tuples; trivial.
  
  apply H with (i:=i-1) (j:=j-1) (m:=TPlength (TPithdel 1 t 1 n) 1 n);
  try rewrite TPlength_TPithdel; try lia.
  autorewrite with tuples.
  
  case (le_dec i (TPlength t 1 n));
  case (le_dec j (TPlength t 1 n)); intros H9 H10.
  
  rewrite 2 TPith_TPithdel_geq; try lia.
  replace (i -1 + 1) with i; try lia.
  replace (j -1 + 1) with j; try lia; trivial.

  rewrite TPith_overflow with (i:=j-1);
  try rewrite TPlength_TPithdel; try lia.
  rewrite TPith_overflow with (i:=j) in H0; try lia.
  rewrite 2 TPith_TPithdel_geq; try lia.
  replace (i -1 + 1) with i; try lia.
  replace (TPlength t' 1 n -1 + 1) with (TPlength t' 1 n); try lia; trivial.

  rewrite TPith_overflow with (i:=i-1);
  try rewrite TPlength_TPithdel; try lia.
  rewrite TPith_overflow with (i:=i) in H0; try lia.
  rewrite 2 TPith_TPithdel_geq; try lia.
  replace (j -1 + 1) with j; try lia.
  replace (TPlength t 1 n -1 + 1) with (TPlength t 1 n); try lia; trivial.

  rewrite TPith_overflow with (i:=i-1);
  try rewrite TPlength_TPithdel; try lia.
  rewrite TPith_overflow with (i:=j-1);
  try rewrite TPlength_TPithdel; try lia.  
  rewrite TPith_overflow with (i:=i) in H0; try lia.
  rewrite TPith_overflow with (i:=j) in H0; try lia.
  rewrite 2 TPith_TPithdel_geq; try lia.
  replace (TPlength t' 1 n -1 + 1) with (TPlength t' 1 n); try lia; trivial.
  replace (TPlength t 1 n -1 + 1) with (TPlength t 1 n); try lia; trivial.
  
  case (nat_eqdec (TPlength t 1 n) 2); intro H10.
  rewrite 2 TPithdel_TPlength_1; autorewrite with tuples; 
  try rewrite TPlength_TPithdel; try lia; auto.
  rewrite 2 TPithdel_Fc_eq; try rewrite TPlength_TPithdel; try lia.
  rewrite 2 TPithdel_Fc_eq in H7;
  try rewrite TPlength_TPithdel; try lia.

  case (le_dec i (TPlength t 1 n));
  case (le_dec j (TPlength t 1 n)); intros H11 H12.
  
  rewrite TPithdel_lt_comm in H7; try lia.
  rewrite TPithdel_lt_comm with (i:=x) in H7; try lia; trivial.

  rewrite TPithdel_overflow with (i:=j-1);
  try rewrite TPlength_TPithdel; try lia.
  rewrite TPithdel_overflow with (i:=j) in H7; try lia.
  rewrite TPithdel_lt_comm in H7; try lia.
  rewrite TPithdel_lt_comm with (i:=x) in H7; try lia; trivial.

  rewrite TPithdel_overflow with (i:=i-1);
  try rewrite TPlength_TPithdel; try lia.
  rewrite TPithdel_overflow with (i:=i) in H7; try lia.
  rewrite TPithdel_lt_comm in H7; try lia.
  rewrite TPithdel_lt_comm with (i:=x) in H7; try lia; trivial.

  rewrite TPithdel_overflow with (i:=i-1);
  try rewrite TPlength_TPithdel; try lia.
  rewrite TPithdel_overflow with (i:=j-1);
  try rewrite TPlength_TPithdel; try lia.  
  rewrite TPithdel_overflow with (i:=i) in H7; try lia.
  rewrite TPithdel_overflow with (i:=j) in H7; try lia.
  rewrite TPithdel_lt_comm in H7; try lia.
  rewrite TPithdel_lt_comm with (i:=x) in H7; try lia; trivial.
Qed.

(** Symmetry of aacc_equiv *)

Lemma aacc_equiv_sym : forall C t1 t2, C |- t1 ~aacc t2 -> C |- t2 ~aacc t1 .
Proof.
 intros. induction H; auto; try lia; trivial. 
  
 apply equiv_Fc; trivial. destruct H.
 left~. right~. destruct H. split~.
 destruct H1. right~. left~. 
 
 assert (Q0 : C |- t' ~aacc ((|[(a', a)]|) @ t)).
  apply aacc_equiv_trans with (t2 := (|[(a, a')]|) @ t).
  apply aacc_equiv_trans with (t2 := (|[(a, a')]|) @ ((|[(a, a')]|) @ t')).
  apply aacc_alpha_equiv_trans. exists t'. split~.
  replace (|[(a, a')]|) with (!(|[(a, a')]|)).   
  apply perm_inv_side. apply alpha_equiv_refl. simpl; trivial.
  apply aacc_equivariance; trivial.  apply aacc_equiv_swap_comm. 
 assert (Q1 : C |- a # ((|[(a', a)]|) @ t)).
  apply aacc_equiv_fresh with (t1 := t'); trivial.
 apply fresh_lemma_1 in Q1. simpl rev in Q1. rewrite swap_right in Q1.
 apply equiv_Ab_2; trivial; auto.
 
 apply equiv_Su. intros. apply H. apply ds_sym. trivial.

 apply aacc_equiv_AC with (i:=i) (j:=1); try lia; trivial.
Qed.

Lemma aacc_equiv_sub_context : forall C C' s t,
      sub_context C C' -> C |- s ~aacc t -> C' |- s ~aacc t.
Proof.
  intros. induction H0.
  apply equiv_Ut. apply equiv_At.
  apply equiv_Pr.
   apply IHequiv1; trivial.
   apply IHequiv2; trivial.
  apply aacc_equiv_Fc.
   apply IHequiv; trivial.
  apply equiv_Ab_1.  
   apply IHequiv; trivial.
  apply equiv_Ab_2; trivial.
   apply IHequiv; trivial.
  apply fresh_lemma_3 with (C:=C); trivial.
  apply equiv_Su; intros.
   unfold sub_context in H. 
   apply H. apply H0; trivial.
  apply equiv_A; trivial.
   apply IHequiv1; trivial.
   apply IHequiv2; trivial.  
  apply equiv_AC with (i:=i); trivial. 
   apply IHequiv1; trivial.
   apply IHequiv2; trivial.
  apply equiv_C1; trivial.
   apply IHequiv1; trivial.
   apply IHequiv2; trivial.
  apply equiv_C2; trivial.
   apply IHequiv1; trivial.
   apply IHequiv2; trivial.
Qed.
   
(** Soundness of aacc_equiv *)

Theorem aacc_equivalence : forall C, Equivalence (equiv (0::1::|[2]|) C).
Proof.
  split~.
  unfold Symmetric; intros. apply aacc_equiv_sym; trivial.
  unfold Transitive; intros. apply aacc_equiv_trans with (t2:=y); trivial.
Qed.

(** Soundness of a_equiv *)

Corollary a_equivalence : forall C, Equivalence (equiv (|[0]|) C).
Proof.
  intros. apply subset_equivalence with (S2:=0::1::|[2]|).
  unfold subset. simpl; intros. lia.
  unfold proper_equiv_Fc; intros. apply aacc_equiv_Fc; trivial.
  apply aacc_equivalence.
Qed.

(** Soundness of ac_equiv *)

Corollary ac_equivalence : forall C, Equivalence (equiv (|[1]|) C).
Proof.
  intros. apply subset_equivalence with (S2:=0::1::|[2]|).
  unfold subset. simpl; intros. lia.
  unfold proper_equiv_Fc; intros. apply aacc_equiv_Fc; trivial.
  apply aacc_equivalence.
Qed.

(** Soundness of c_equiv *)

Corollary c_equivalence : forall C, Equivalence (equiv (|[2]|) C).
Proof.
  intros. apply subset_equivalence with (S2:=0::1::|[2]|).
  unfold subset. simpl; intros. lia.
  unfold proper_equiv_Fc; intros. apply aacc_equiv_Fc; trivial.
  apply aacc_equivalence.
Qed.

(** Soundness of acc_equiv *)

Corollary acc_equivalence : forall C, Equivalence (equiv (1::|[2]|) C).
Proof.
  intros. apply subset_equivalence with (S2:=0::1::|[2]|).
  unfold subset. simpl; intros. lia.
  unfold proper_equiv_Fc; intros. apply aacc_equiv_Fc; trivial.
  apply aacc_equivalence.
Qed.


Corollary aacc_perm_inv_side : forall C pi s t, C |- (!pi) @ s ~aacc t -> C |- s ~aacc (pi @ t).
Proof.
  intros.
  apply aacc_equivariance with (pi:=pi) in H.
  apply aacc_equiv_trans with (t2:= pi @ ((!pi) @ s)); trivial.
  apply aacc_alpha_equiv_trans. exists s. split~.
  rewrite perm_comp. gen_eq g : (!pi); intro H0.
  replace pi with (!g). apply alpha_equiv_sym.
  apply alpha_equiv_perm_inv. rewrite H0.
  rewrite rev_involutive. trivial.
Qed.

Corollary aacc_perm_inv_side' : forall C pi s t, C |- s ~aacc (pi @ t) <-> C |- (!pi) @ s ~aacc t.
Proof.
  intros. split~; intro.
  apply aacc_equiv_sym.
  apply aacc_perm_inv_side.
  rewrite rev_involutive.
  apply aacc_equiv_sym. trivial.
  apply aacc_perm_inv_side; trivial.
Qed.  

                            
(** Some results about collections of arguments of a term *)

Lemma aacc_Args_col_TPith_TPithdel : forall L0 L1 C s t E n,

    C |- (Args_col L0 ([]) s E n) ~aacc (Args_col L1 ([]) t E n) ->

    forall i,
         
      C |- TPith i (Args_col L0 ([]) s E n) E n ~aacc
           TPith i (Args_col L1 ([]) t E n) E n
      /\
           
      C |- TPithdel i (Args_col L0 ([]) s E n) E n ~aacc
           TPithdel i (Args_col L1 ([]) t E n) E n
. 

Proof.
  intros.

  unfold Args_col in H|-*.
  rewrite Args_assoc_nil in H|-*.
 
  replace (Args_assoc 0 ([]) (Args_col_list L1 t E n))
          with (Args_right_assoc (Args_col_list L1 t E n)) in *|-*.
  
  gen_eq l : (length L0); intro H0.
  gen H0 H. gen i L0 L1 s t.
  
  induction l using peano_induction; intros.

  destruct L0.
  simpl Args_col_list in H1|-*.
  simpl in *|-*. inverts H1. simpl. auto.
  destruct L1. simpl Args_col_list in H1|-*.
 
  gen_eq L2 : (TPith n0 s E n :: Args_col_list L0 s E n).
  intro H2. simpl. inverts H1. simpl. auto.

  assert (Q : length L0 = length L1).
   apply aacc_equiv_TPlength with (E:=E) (n:=n) in H1.
   rewrite 2 Args_right_assoc_TPlength in H1; simpl; try lia; trivial.
   simpl in H1. lia.
  simpl in H0.

  simpl Args_col_list in *|-*.

  case (nil_eqdec _ term_eqdec (Args_col_list L0 s E n)); intro H2.
  rewrite H2 in *|-*. apply length_zero_iff_nil in H2.
  rewrite Args_col_list_length in H2.
  rewrite Q in H2. apply length_zero_iff_nil in H2.
  rewrite H2 in H1|-*. simpl in H1|-*.
  rewrite 2 TPith_TPith. split~.
  rewrite 2 TPithdel_TPlength_1; auto.
  rewrite TPlength_TPith; trivial.
  rewrite TPlength_TPith; trivial.
  
  assert (H4: Args_col_list L1 t E n <> []).
   intro H3. apply H2.
   apply length_zero_iff_nil in H3.
   apply length_zero_iff_nil.
   rewrite Args_col_list_length.
   rewrite Args_col_list_length in H3. lia.

  assert (H5 : length (Args_col_list L0 s E n) <> 0).
   intro H5. apply length_zero_iff_nil in H5. contradiction.   
  assert (H6 : length (Args_col_list L1 t E n) <> 0).
   intro H6. apply length_zero_iff_nil in H6. contradiction.
  
  rewrite 2 Args_right_assoc_cons in *|-*; trivial.
  inverts H1. 
   
  case (le_dec i 1); intro H7.
  rewrite 2 TPith_Pr_le;
    try rewrite TPlength_TPith; trivial.
  rewrite 2 TPithdel_t1_Pr;
    try rewrite TPlength_TPith; trivial.
  split~. rewrite 2 TPith_TPith; trivial.
  
  rewrite 2 TPith_Pr_gt;
    try rewrite TPlength_TPith; try lia.
  
  rewrite 1 TPlength_TPith.  
  split~.
  apply H with (m:= length L0); try lia. trivial.  
  
  case (nat_eqdec (length L0) 1); intro H13.

  rewrite 2 TPithdel_t2_Pr;
    try rewrite TPlength_TPith; try lia; trivial.
  rewrite Args_right_assoc_TPlength; try lia.
  rewrite Args_right_assoc_TPlength; try lia.

  rewrite Args_col_list_length in H5.
  rewrite Args_col_list_length in H6.

  rewrite 2 TPithdel_Pr_gt;
    try rewrite TPlength_TPith; try lia.
  apply equiv_Pr; trivial.
  rewrite TPlength_TPith.
  apply H with (m:= length L0); try lia. trivial.
  rewrite Args_right_assoc_TPlength; try lia.
  rewrite Args_right_assoc_TPlength; try lia.

  symmetry. apply Args_assoc_nil. 
Qed.




Lemma aacc_equiv_Args_col_AC : forall L0 L1 C n s t,

      valid_col L0 s 1 n -> valid_col L1 t 1 n ->

      length L0 = TPlength s 1 n ->
      length L1 = TPlength t 1 n ->

      C |- (Args_col L0 ([]) s 1 n) ~aacc
           (Args_col L1 ([]) t 1 n) ->
         
           C |- Fc 1 n s ~aacc Fc 1 n t .

Proof. (*
  intros. gen_eq l : (length L0). intro H4.
  gen H4 H H0 H1 H2 H3. gen L0 L1 s t.
  induction l using peano_induction; intros.

  assert (Q : TPlength s 1 n = TPlength t 1 n).
   apply aacc_equiv_TPlength with (E:=1) (n:=n) in H5.
   rewrite 2 Args_col_TPlength in H5; simpl; trivial; try lia.
   assert (TPlength t 1 n >= 1). auto. lia.
   apply NoDup_nil. intros. subst. contradiction.
   assert (TPlength s 1 n >= 1). auto. lia. 
   apply NoDup_nil. intros. contradiction.
   
  apply aacc_Args_col_TPith_TPithdel with (i:=1) in H5.
  destruct H5.
  
  case  Args_col_TPith_TPithdel
    with (L:=L0) (s:=s) (E:=1) (n:=n); trivial.
  assert (Q' : TPlength s 1 n >= 1). auto. lia.
  intros i H7. destruct H7.
  case H8; clear H8; intros L0' H8. destruct H8.
  destruct H9. destruct H10.
  rewrite H7 in H5. rewrite H8 in H6.

  case Args_col_TPith_TPithdel
    with (L:=L1) (s:=t) (E:=1) (n:=n); trivial.
  assert (Q' : TPlength t 1 n >= 1). auto. lia.
  intros j H12. destruct H12.
  case H13; clear H13; intros L1' H13. destruct H13.
  destruct H14. destruct H15.
  rewrite H12 in H5. rewrite H13 in H6.
  
  apply aacc_equiv_AC with (i:=i) (j:=j).
  autorewrite with tuples; trivial.

  case (nat_eqdec (TPlength s 1 n) 1); intro H17.
  rewrite 2 TPithdel_TPlength_1;
    autorewrite with tuples; try lia; auto. 
  rewrite 2 TPithdel_Fc_eq; try lia.  

  apply H with (m:=length L0') (L0 := L0') (L1 := L1');
    try lia; trivial.

  assert (Q' : TPlength s 1 n >= 1). auto. lia.
  rewrite TPlength_TPithdel; lia.
  rewrite TPlength_TPithdel; lia.  
    
Qed. *) Admitted.

  
Lemma aacc_equiv_Args_assoc : forall C L0 L1 L' i,

     length L0 = length L1 ->   

      C |- Args_assoc i L' L0 ~aacc Args_assoc i L' L1  ->
      C |- Args_right_assoc L0 ~aacc Args_right_assoc L1 .

Proof.

  intros.  gen_eq l : (length L'). intro H1.
  gen H1 H H0. gen i L0 L1 L'.
  induction l using peano_induction; intros.

  destruct L'; simpl in *|-; trivial.
  inverts H2. apply H with (m := length L') in H9; try lia.
  gen_eq k : (n - i); intro H10.

  Focus 2.
(*  2:{ *)
  case (le_dec (n - i) (length L0)); intro H10.
   rewrite 2 tail_list_length; lia.
  rewrite 2 tail_list_overflow; try lia. (* } *)
   
  clear L' n i l H H1 H10.

  gen_eq l : (length L0); intro H10.
  gen H10 H0 H7 H9. gen L0 L1 k.
  induction l using peano_induction; intros.

  destruct L0. simpl in H10.
  assert (Q : L1 = []).
   rewrite H10 in H0. symmetry in H0.
   apply length_zero_iff_nil; trivial.
  rewrite Q in *|-*.
  destruct k; simpl in *|-*; trivial.
  simpl in H10. destruct L1; simpl in H0; try lia.

  case (nil_eqdec _ term_eqdec L0); intro H11.
  rewrite H11 in *|-*. simpl in H10.
  assert (Q : L1 = []).
   assert (length L1 = 0). lia.
   apply length_zero_iff_nil; trivial.
  rewrite Q in *|-*.
  destruct k; simpl in *|-*; trivial.
  destruct k; simpl in *|-; trivial.

  assert (Q0 : length L0 <> 0). 
   intro H12;
    apply length_zero_iff_nil in H12; contradiction.
   
  assert (Q1 : length L1 <> 0). 
   intro H12;
    apply length_zero_iff_nil in H12.
   rewrite H12 in H0. simpl in H0. lia.

  rewrite 2 Args_right_assoc_cons; trivial.
   
  case (nat_eqdec k 0); intro H12.
  rewrite H12 in *|-.
  simpl tail_list in *|-.
  rewrite 2 Args_right_assoc_cons in H9; trivial.

  case (nat_eqdec (k - 1) 0); intro H13.

  rewrite 2 head_list_cons in *|-; trivial.
  rewrite 2 tail_list_cons in *|-; trivial.

  rewrite H13 in *|-. simpl in *|-.

  apply equiv_Pr; trivial.
  
  case (le_dec k (length L0)); intro H14.

  rewrite 2 head_list_cons in *|-; trivial.
  rewrite 2 tail_list_cons in *|-; trivial.
  
  rewrite 2 Args_right_assoc_cons in *|-. 

  inverts H7. apply equiv_Pr; trivial.
  apply H with (m := length L0) (k:=k-1); try lia; trivial.
  rewrite head_list_length; lia.
  rewrite head_list_length; lia.

  rewrite 2 head_list_overflow in *|-; simpl; try lia.
  rewrite 2 Args_right_assoc_cons in *|-; trivial.

Qed.
