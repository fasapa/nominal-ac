**A Formalisation (in Coq) of Nominal C-Unification and Nominal A, C and AC-Equivalence**

**The current version of this dataset is also available at [https://doi.org/10.5281/zenodo.3364517](https://doi.org/10.5281/zenodo.3364517)**.

**Compiled with the Coq Proof Assistant Version 8.7.2:**

**File/Folder** | Short description
------------ | -------------
**[thesis20190319.pdf](https://doi.org/10.13140/RG.2.2.17014.14404)** | The text of the doctoral thesis entitled "Nominal Equational Problems Modulo Associativity, Commutativity and Associativity-Commutativity"
**[Impl_Equiv/](https://github.com/wtonribeiro/nominal-ac/tree/master/Impl-Equiv)** | Folder with the implementations of the naive (extracted from the specification) and of the improved nominal A, C and AC-checking algorithms (OCaml code)
**[Impl_Unif/](https://github.com/wtonribeiro/nominal-ac/tree/master/Impl-Unif)** | Folder with the implementation of the nominal C-unification algorithm (OCaml code)
**LibTactics.v**    | Library of tactics given by http://www.chargueraud.org/softs/tlc/
**Basics.v**        | Necessary basic results on arithmetics and lists that are not in the standard libraries of Coq
**Terms.v**         | Syntax definition of nominal terms and some properties about
**Perm.v**          | Permutation action definition and its properties
**Disagr.v**         | Disagreement set definition and its properties
**Tuples.v**        | Definitions of TPlength, TPith and TPithdel and many formalised properties about
**Fresh.v**         | Deftinition of the freshness relation and some related basic properties
**Alpha_Equiv.v**   | Definition of the nominal alpha_equivalence and the formalisation of its soundness
**Equiv.v**         | Extentions of nominal alpha_equivalence in a parametrised way
**AACC_Equiv_rec.v**  | Recursive versions of the inductive definitions fresh and equiv from files Fresh.v and Equiv.v and OCaml code extraction
**Equiv_Tuples.v**  | Interactions between the extentions of nominal alpha_equivalence and tuples
**AACC_Equiv.v**    | Definitions of the nominal A+AC+C, A, AC and C-equivalences and the formalisation of their soundness
**C_Equiv.v**       | Specific Lemmas about nominal C-equivalence
**Problems.v**      | Definition of nominal C-unification problems and some lemmas about
**Substs.v**        | Definition of substitutions and some lemmas about
**C_Unif.v**        | Definition of the rule transformation systems $\Rightarrow_{\#}$ and $\Rightarrow_{\approx}$
**C_Unif_Termination.v**   | Formalisation of the termination of  $\Rightarrow_{\#}$ and $\Rightarrow_{\approx}$
**C_Unif_Soundness.v**     | Formalisation of the soundness of $\Rightarrow_{\#}$ and $\Rightarrow_{\approx}$ and successful leaves characterisation of the derivation tree
**C_Unif_Completeness.v**  | Formalisation of the completeness of  $\Rightarrow_{\#}$ and $\Rightarrow_{\approx}$
**C_Matching**      | Specification and formalisation of the properties of termination, soundness and completeness of the C-matching algorithm
**Makefile**        | Organisation of the code compilation with the "make" tool
















