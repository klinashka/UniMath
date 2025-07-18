(** * ω-cocontinuous functors

This file contains theory about (omega-) cocontinuous functors, i.e. functors
which preserve (sequential-) colimits ([is_omega_cocont] and [is_cocont]).

This file contains proofs that the following functors are (omega-)cocontinuous:

- Identity functor
  [is_cocont_functor_identity] [is_omega_cocont_functor_identity]
- Constant functor: F_x : C -> D, c |-> x
  [is_omega_cocont_constant_functor]
- Composition of omega-cocontinuous functors
  [is_cocont_functor_composite] [is_omega_cocont_functor_composite]
- Iteration of omega-cocontinuous functors: F^n : C -> C
  [is_cocont_iter_functor] [is_omega_cocont_iter_functor]
- Pairing of (omega-)cocont functors (F,G) : A * B -> C * D, (x,y) |-> (F x,G y)
  [is_cocont_pair_functor] [is_omega_cocont_pair_functor]
- Indexed families of (omega-)cocont functors F^I : A^I -> B^I
  [is_cocont_family_functor] [is_omega_cocont_family_functor]
- Binary delta functor: C -> C^2, x |-> (x,x)
  [is_cocont_bindelta_functor] [is_omega_cocont_bindelta_functor]
- General delta functor: C -> C^I
  [is_cocont_delta_functor] [is_omega_cocont_delta_functor]
- Binary coproduct functor: C^2 -> C, (x,y) |-> x + y
  [is_cocont_bincoproduct_functor] [is_omega_cocont_bincoproduct_functor]
- General coproduct functor: C^I -> C
  [is_cocont_coproduct_functor] [is_omega_cocont_coproduct_functor]
- Binary coproduct of functors: F + G : C -> D, x |-> F x + G x
  [is_cocont_BinCoproduct_of_functors_alt] [is_omega_cocont_BinCoproduct_of_functors_alt]
  [is_cocont_BinCoproduct_of_functors_alt2] [is_omega_cocont_BinCoproduct_of_functors_alt2]
  [is_cocont_BinCoproduct_of_functors] [is_omega_cocont_BinCoproduct_of_functors]
- Coproduct of families of functors: + F_i : C -> D  (generalization of coproduct of functors)
  [is_cocont_coproduct_of_functors_alt] [is_cocont_coproduct_of_functors]
  [is_omega_cocont_coproduct_of_functors_alt] [is_omega_cocont_coproduct_of_functors]
- Constant product functors: C -> C, x |-> a * x  and  x |-> x * a
  [is_cocont_constprod_functor1] [is_cocont_constprod_functor2]
  [is_omega_cocont_constprod_functor1] [is_omega_cocont_constprod_functor2]
- Binary product functor: C^2 -> C, (x,y) |-> x * y
  [is_omega_cocont_binproduct_functor]
- Product of functors: F * G : C -> D, x |-> (x,x) |-> (F x,G x) |-> F x * G x
  [is_omega_cocont_BinProduct_of_functors_alt] [is_omega_cocont_BinProduct_of_functors]
- Precomposition functor: _ o K : ⟦C,A⟧ -> ⟦M,A⟧ for K : M -> C
  [preserves_colimit_pre_composition_functor] [is_omega_cocont_pre_composition_functor]
- Postcomposition with a left adjoint:
  [is_cocont_post_composition_functor] [is_omega_cocont_post_composition_functor]
- Swapping of functor category arguments:
  [is_cocont_functor_cat_swap] [is_omega_cocont_functor_cat_swap]
- The forgetful functor from Set/X to Set preserves colimits
  ([preserves_colimit_slicecat_to_cat_HSET])

Written by: Anders Mörtberg and Benedikt Ahrens, 2015-2016
*)


Require Import UniMath.Foundations.PartD.
Require Import UniMath.Foundations.Propositions.
Require Import UniMath.Foundations.Sets.
Require Import UniMath.Foundations.NaturalNumbers.
Require Import UniMath.MoreFoundations.PartA.
Require Import UniMath.MoreFoundations.Tactics.

Require Import UniMath.CategoryTheory.Core.Categories.
Require Import UniMath.CategoryTheory.Core.Isos.
Require Import UniMath.CategoryTheory.Core.NaturalTransformations.
Require Import UniMath.CategoryTheory.Core.Univalence.
Require Import UniMath.CategoryTheory.Core.Functors.
Require Import UniMath.CategoryTheory.FunctorCategory.
Require Import UniMath.CategoryTheory.Limits.Graphs.Colimits.
Require Import UniMath.CategoryTheory.Categories.HSET.Core.
Require Import UniMath.CategoryTheory.Categories.HSET.Slice.
Require Import UniMath.CategoryTheory.Categories.HSET.Limits.
Require Import UniMath.CategoryTheory.Categories.HSET.Colimits.
Require Import UniMath.CategoryTheory.Categories.HSET.Structures.
Require Import UniMath.CategoryTheory.Limits.Initial.
Require Import UniMath.CategoryTheory.FunctorAlgebras.
Require Import UniMath.CategoryTheory.Limits.BinProducts.
Require Import UniMath.CategoryTheory.Limits.Products.
Require Import UniMath.CategoryTheory.Limits.BinCoproducts.
Require Import UniMath.CategoryTheory.Limits.Coproducts.
Require Import UniMath.CategoryTheory.Limits.Terminal.
Require Import UniMath.CategoryTheory.Limits.Graphs.Limits.
Require Import UniMath.CategoryTheory.PrecategoryBinProduct.
Require Import UniMath.CategoryTheory.ProductCategory.
Require Import UniMath.CategoryTheory.Adjunctions.Core.
Require Import UniMath.CategoryTheory.Adjunctions.Examples.
Require Import UniMath.CategoryTheory.Exponentials.
Require Import UniMath.CategoryTheory.whiskering.
Require Import UniMath.CategoryTheory.RightKanExtension.
Require Import UniMath.CategoryTheory.slicecat.

Require Import UniMath.CategoryTheory.Chains.Chains.

Local Open Scope cat.

(** * Examples of (omega) cocontinuous functors *)
Section cocont_functors.

(** ** Left adjoints preserve colimits *)
Lemma left_adjoint_cocont (C D : category) (F : functor C D)
  (H : is_left_adjoint F) : is_cocont F.
Proof.
  intros g d L ccL.
  apply left_adjoint_preserves_colimit.
  exact H.
Defined.

(* Print Assumptions left_adjoint_cocont. *)

(** Cocontinuity is preserved by isomorphic functors *)
Section cocont_iso.

(* As this section is proving a proposition, the hypothesis can be weakened from a specified iso to
F and G being isomorphic. *)
Context {C D : category} {F G : functor C D}
        (αiso : @z_iso [C, D] F G).

Section preserves_colimit_iso.

Context {g : graph} (d : diagram g C) (L : C) (cc : cocone d L) (HF : preserves_colimit F d L cc).

Let αinv := inv_from_z_iso αiso.
Let α := pr1 αiso.
Let Hα : is_z_isomorphism α := pr2 αiso.

Local Definition ccFy y (ccGy : cocone (mapdiagram G d) y) : cocone (mapdiagram F d) y.
Proof.
use make_cocone.
- intro v; apply (pr1 α (dob d v) · coconeIn ccGy v).
- abstract (simpl; intros u v e; rewrite <- (coconeInCommutes ccGy u v e), !assoc;
            apply cancel_postcomposition, nat_trans_ax).
Defined.

Lemma αinv_f_commutes y (ccGy : cocone (mapdiagram G d) y) (f : D⟦F L,y⟧)
      (Hf : is_cocone_mor (mapcocone F d cc) (ccFy y ccGy) f) :
       ∏ v, # G (coconeIn cc v) · (pr1 αinv L · f) = coconeIn ccGy v.
Proof.
intro v; rewrite assoc.
eapply pathscomp0; [apply cancel_postcomposition, nat_trans_ax|].
rewrite <- assoc; eapply pathscomp0; [apply maponpaths, (Hf v)|]; simpl; rewrite assoc.
eapply pathscomp0.
  apply cancel_postcomposition.
  apply (nat_trans_eq_pointwise (@z_iso_after_z_iso_inv [C, D] _ _ (make_z_iso' _ Hα))).
now rewrite id_left.
Qed.

Lemma αinv_f_unique y (ccGy : cocone (mapdiagram G d) y) (f : D⟦F L,y⟧)
     (Hf : is_cocone_mor (mapcocone F d cc) (ccFy y ccGy) f)
     (HHf : ∏ t : ∑ x, is_cocone_mor (mapcocone F d cc) (ccFy y ccGy) x, t = f,, Hf)
      f' (Hf' : ∏ v, # G (coconeIn cc v) · f' = coconeIn ccGy v) :
      f' = pr1 αinv L · f.
Proof.
transparent assert (HH : (∑ x : D ⟦ F L, y ⟧, is_cocone_mor (mapcocone F d cc) (ccFy y ccGy) x)).
{ use tpair.
  - apply (pr1 α L · f').
  - unfold is_cocone_mor; cbn. abstract (intro v; rewrite <- Hf', !assoc; apply cancel_postcomposition, nat_trans_ax).
}
apply pathsinv0.
generalize (maponpaths pr1 (HHf HH)); intro Htemp; simpl in *.
rewrite <- Htemp; simpl; rewrite assoc.
eapply pathscomp0.
  apply cancel_postcomposition.
  apply (nat_trans_eq_pointwise (@z_iso_after_z_iso_inv [C, D] _ _ (make_z_iso' _ Hα))).
now apply id_left.
Qed.

Lemma preserves_colimit_z_iso  : preserves_colimit G d L cc.
Proof.
intros HccL y ccGy.
set (H := HF HccL y (ccFy y ccGy)).
set (f := pr1 (pr1 H)); set (Hf := pr2 (pr1 H)); set (HHf := pr2 H).
use unique_exists.
- apply (pr1 αinv L · f).
- unfold is_cocone_mor; simpl; apply (αinv_f_commutes y ccGy f Hf).
- abstract (intro; apply impred; intro; apply homset_property).
- abstract (simpl in *; intros f' Hf'; apply (αinv_f_unique y ccGy f Hf); trivial;
            intro t; rewrite (HHf t); reflexivity).
Defined.

End preserves_colimit_iso.

Lemma is_cocont_z_iso : is_cocont F -> is_cocont G.
Proof.
now intros H g d c cc; apply (preserves_colimit_z_iso).
Defined.

Lemma is_omega_cocont_z_iso : is_omega_cocont F -> is_omega_cocont G.
Proof.
now intros H g d c cc; apply (preserves_colimit_z_iso).
Defined.

End cocont_iso.

(** ** The identity functor is (omega) cocontinuous *)
Section functor_identity.

Context (C : category).

Lemma preserves_colimit_identity {g : graph} (d : diagram g C) (L : C)
  (cc : cocone d L) : preserves_colimit (functor_identity C) d L cc.
Proof.
intros HcL y ccy; simpl.
set (CC := make_ColimCocone _ _ _ HcL).
use tpair.
- use tpair.
  + apply (colimArrow CC), ccy.
  + abstract (simpl; intro n; apply (colimArrowCommutes CC)).
- abstract (simpl; intro t; apply subtypePath;
    [ simpl; intro v; apply impred; intro; apply homset_property
    | apply (colimArrowUnique CC); intro n; apply (pr2 t)]).
Defined.

Lemma is_cocont_functor_identity : is_cocont (functor_identity C).
Proof.
now intros g; apply preserves_colimit_identity.
Defined.

Lemma is_omega_cocont_functor_identity : is_omega_cocont (functor_identity C).
Proof.
now intros c; apply is_cocont_functor_identity.
Defined.

Definition omega_cocont_functor_identity : omega_cocont_functor C C :=
  tpair _ _ is_omega_cocont_functor_identity.

End functor_identity.

(** ** The constant functor is omega cocontinuous *)
Section constant_functor.

Context {C D : category} (x : D).

(* Without the conn argument this is is too weak as diagrams are not necessarily categories *)
Lemma preserves_colimit_constant_functor {g : graph} (v : vertex g)
  (conn : ∏ (u : vertex g), edge v u)
  (d : diagram g C) (L : C) (cc : cocone d L) :
  preserves_colimit (constant_functor C D x) d L cc.
Proof.
intros HcL y ccy; simpl.
use tpair.
- apply (tpair _ (coconeIn ccy v)).
  abstract (now intro u; generalize (coconeInCommutes ccy _ _ (conn u));
            rewrite !id_left; intro H; rewrite H).
- abstract (intro p; apply subtypePath;
              [ intro; apply impred; intro; apply homset_property
              | now destruct p as [p H]; rewrite <- (H v), id_left ]).
Defined.

(** The constant functor is omega cocontinuous *)
Lemma is_omega_cocont_constant_functor : is_omega_cocont (constant_functor C D x).
Proof.
intros c L ccL HccL y ccy.
use tpair.
- apply (tpair _ (coconeIn ccy 0)).
  abstract (intro n; rewrite id_left; destruct ccy as [f Hf]; simpl;
            now induction n as [|n IHn]; [apply idpath|]; rewrite IHn, <- (Hf n (S n) (idpath _)), id_left).
- abstract (intro p; apply subtypePath;
              [ intros f; apply impred; intro; apply homset_property
              | now simpl; destruct p as [p H]; rewrite <- (H 0), id_left]).
Defined.

Definition omega_cocont_constant_functor : omega_cocont_functor C D :=
  tpair _ _ is_omega_cocont_constant_functor.

End constant_functor.

(** ** Functor composition preserves omega cocontinuity *)
Section functor_composite.

Context {C D E : category}.

Lemma preserves_colimit_functor_composite (F : functor C D) (G : functor D E)
  {g : graph} (d : diagram g C) (L : C) (cc : cocone d L)
  (H1 : preserves_colimit F d L cc)
  (H2 : preserves_colimit G (mapdiagram F d) (F L) (mapcocone F _ cc)) :
  preserves_colimit (functor_composite F G) d L cc.
Proof.
intros HcL y ccy; simpl.
set (CC := make_ColimCocone _ _ _ (H2 (H1 HcL))).
use tpair.
- use tpair.
  + apply (colimArrow CC), ccy.
  + abstract (simpl; intro v; apply (colimArrowCommutes CC)).
- abstract (simpl; intro t; apply subtypePath;
    [ intros f; apply impred; intro; apply homset_property
    | simpl; apply (colimArrowUnique CC), (pr2 t) ]).
Defined.

Lemma is_cocont_functor_composite (F : functor C D) (G : functor D E)
  (HF : is_cocont F) (HG : is_cocont G) : is_cocont (functor_composite F G).
Proof.
intros g d L cc.
apply preserves_colimit_functor_composite; [ apply HF | apply HG ].
Defined.

Lemma is_omega_cocont_functor_composite (F : functor C D) (G : functor D E) :
  is_omega_cocont F -> is_omega_cocont G -> is_omega_cocont (functor_composite F G).
Proof.
intros hF hG c L cc.
apply preserves_colimit_functor_composite; [ apply hF | apply hG ].
Defined.

Definition omega_cocont_functor_composite
  (F : omega_cocont_functor C D) (G : omega_cocont_functor D E) :
  omega_cocont_functor C E := tpair _ _ (is_omega_cocont_functor_composite _ _ (pr2 F) (pr2 G)).

End functor_composite.

(** ** Functor iteration preserves (omega)-cocontinuity *)
Section iter_functor.

Lemma is_cocont_iter_functor {C : category}
  (F : functor C C) (hF : is_cocont F) n : is_cocont (iter_functor F n).
Proof.
induction n as [|n IH]; simpl.
- apply (is_cocont_functor_identity _).
- apply (is_cocont_functor_composite _ _ IH hF).
Defined.

Lemma is_omega_cocont_iter_functor {C : category}
  (F : functor C C) (hF : is_omega_cocont F) n : is_omega_cocont (iter_functor F n).
Proof.
induction n as [|n IH]; simpl.
- apply (is_omega_cocont_functor_identity _).
- apply (is_omega_cocont_functor_composite _ _ IH hF).
Defined.

Definition omega_cocont_iter_functor {C : category}
  (F : omega_cocont_functor C C) n : omega_cocont_functor C C :=
  tpair _ _ (is_omega_cocont_iter_functor _ (pr2 F) n).

End iter_functor.

(** ** A pair of functors (F,G) : A * B -> C * D is omega cocontinuous if F and G are *)
Section pair_functor.

Context {A B C D : category} (F : functor A C) (G : functor B D).


Local Definition cocone_pr1_functor {g : graph} (cAB : diagram g (category_binproduct A B))
  (ab : A × B) (ccab : cocone cAB ab) :
  cocone (mapdiagram (pr1_functor A B) cAB) (ob1 ab).
Proof.
use make_cocone.
- simpl; intro n; apply (mor1 (coconeIn ccab n)).
- simpl; intros m n e.
  set (X:= coconeInCommutes ccab m n e).
  etrans. 2: { apply maponpaths. apply X. }
  apply idpath.
Defined.

Local Lemma isColimCocone_pr1_functor {g : graph} (cAB : diagram g (category_binproduct A B))
  (ab : A × B) (ccab : cocone cAB ab) (Hccab : isColimCocone cAB ab ccab) :
   isColimCocone (mapdiagram (pr1_functor A B) cAB) (ob1 ab)
     (mapcocone (pr1_functor A B) cAB ccab).
Proof.
intros x ccx.
transparent assert (HHH : (cocone cAB (x,, ob2 ab))).
{ use make_cocone.
  - simpl; intro n; split;
      [ apply (pr1 ccx n) | apply (# (pr2_functor A B) (pr1 ccab n)) ].
  - abstract(simpl; intros m n e; apply pathsdirprod;
               [ apply (pr2 ccx m n e) | apply (maponpaths dirprod_pr2 ((pr2 ccab) m n e)) ]).
}
destruct (Hccab _ HHH) as [[[x1 x2] p1] p2].
use tpair.
- apply (tpair _ x1).
  abstract (intro n; apply (maponpaths pr1 (p1 n))).
- intro t.
  transparent assert (X : (∑ x0, ∏ v, coconeIn ccab v · x0 =
                                 catbinprodmor (pr1 ccx v) (pr2 (pr1 ccab v)))).
  { use tpair.
    - split; [ apply (pr1 t) | apply (identity _) ].
    - cbn. abstract (intro n; rewrite id_right; apply pathsdirprod;
                 [ apply (pr2 t) | apply idpath ]).
  }
  abstract (apply subtypePath; simpl;
            [ intro f; apply impred; intro; apply homset_property
            | apply (maponpaths (λ x, pr1 (pr1 x)) (p2 X))]).
Defined.

Lemma is_cocont_pr1_functor : is_cocont (pr1_functor A B).
Proof.
now intros c L ccL M H; apply isColimCocone_pr1_functor.
Defined.

Local Definition cocone_pr2_functor {g : graph} (cAB : diagram g (category_binproduct A B))
  (ab : A × B) (ccab : cocone cAB ab) :
  cocone (mapdiagram (pr2_functor A B) cAB) (pr2 ab).
Proof.
use make_cocone.
- simpl; intro n; apply (pr2 (coconeIn ccab n)).
- simpl; intros m n e.
  etrans. 2: { apply maponpaths. apply (coconeInCommutes ccab m n e). }
  apply idpath.
Defined.

Local Lemma isColimCocone_pr2_functor {g : graph} (cAB : diagram g (category_binproduct A B))
  (ab : A × B) (ccab : cocone cAB ab) (Hccab : isColimCocone cAB ab ccab) :
   isColimCocone (mapdiagram (pr2_functor A B) cAB) (pr2 ab)
     (mapcocone (pr2_functor A B) cAB ccab).
Proof.
intros x ccx.
transparent assert (HHH : (cocone cAB (pr1 ab,, x))).
{ use make_cocone.
  - simpl; intro n; split;
      [ apply (# (pr1_functor A B) (pr1 ccab n)) | apply (pr1 ccx n) ].
  - abstract (simpl; intros m n e; apply pathsdirprod;
                [ apply (maponpaths pr1 (pr2 ccab m n e)) | apply (pr2 ccx m n e) ]).
 }
destruct (Hccab _ HHH) as [[[x1 x2] p1] p2].
use tpair.
- apply (tpair _ x2).
  abstract (intro n; apply (maponpaths dirprod_pr2 (p1 n))).
- intro t.
  transparent assert (X : (∑ x0, ∏ v, coconeIn ccab v · x0 =
                                 catbinprodmor (pr1 (pr1 ccab v)) (pr1 ccx v))).
  { use tpair.
    - split; [ apply (identity _) | apply (pr1 t) ].
    - cbn. abstract (intro n; rewrite id_right; apply pathsdirprod;
                 [ apply idpath | apply (pr2 t) ]).
  }
  abstract (apply subtypePath; simpl;
              [ intro f; apply impred; intro; apply homset_property
              | apply (maponpaths (λ x, dirprod_pr2 (pr1 x)) (p2 X)) ]).
Defined.

Lemma is_cocont_pr2_functor : is_cocont (pr2_functor A B).
Proof.
now intros c L ccL M H; apply isColimCocone_pr2_functor.
Defined.

Lemma isColimCocone_pair_functor {gr : graph}
  (HF : ∏ (d : diagram gr A) (c : A) (cc : cocone d c) (h : isColimCocone d c cc),
        isColimCocone _ _ (mapcocone F d cc))
  (HG : ∏ (d : diagram gr B) (c : B) (cc : cocone d c) (h : isColimCocone d c cc),
        isColimCocone _ _ (mapcocone G d cc)) :
  ∏ (d : diagram gr (category_binproduct A B)) (cd : A × B) (cc : cocone d cd),
  isColimCocone _ _ cc ->
  isColimCocone _ _ (mapcocone (pair_functor F G) d cc).
Proof.
intros cAB ml ccml Hccml xy ccxy.
transparent assert (cFAX : (cocone (mapdiagram F (mapdiagram (pr1_functor A B) cAB)) (pr1 xy))).
{ use make_cocone.
  - intro n; apply (pr1 (pr1 ccxy n)).
  - abstract (intros m n e; apply (maponpaths dirprod_pr1 (pr2 ccxy m n e))).
}
transparent assert (cGBY : (cocone (mapdiagram G (mapdiagram (pr2_functor A B) cAB)) (pr2 xy))).
{ use make_cocone.
  - intro n; apply (pr2 (pr1 ccxy n)).
  - abstract (intros m n e; apply (maponpaths dirprod_pr2 (pr2 ccxy m n e))).
}
destruct (HF _ _ _ (isColimCocone_pr1_functor cAB ml ccml Hccml) _ cFAX) as [[f hf1] hf2].
destruct (HG _ _ _ (isColimCocone_pr2_functor cAB ml ccml Hccml) _ cGBY) as [[g hg1] hg2].
unfold is_cocone_mor in *. simpl in *.
use tpair.
- apply (tpair _ (f,,g)).
  abstract (intro n; unfold catbinprodmor, compose; simpl;
            now rewrite hf1, hg1).
- abstract (intro t; apply subtypePath; simpl;
             [ intro x; apply impred; intro; apply isaset_dirprod; apply homset_property
             | induction t as [[f1 f2] p]; simpl in *; apply pathsdirprod;
               [ apply (maponpaths pr1 (hf2 (f1,, (λ n, maponpaths pr1 (p n)))))
               | apply (maponpaths pr1 (hg2 (f2,, (λ n, maponpaths dirprod_pr2 (p n)))))]]).
Defined.

Lemma is_cocont_pair_functor (HF : is_cocont F) (HG : is_cocont G) :
  is_cocont (pair_functor F G).
Proof.
intros gr cAB ml ccml Hccml.
now apply isColimCocone_pair_functor; [apply HF|apply HG|].
Defined.

Lemma is_omega_cocont_pair_functor (HF : is_omega_cocont F) (HG : is_omega_cocont G) :
  is_omega_cocont (pair_functor F G).
Proof.
now intros cAB ml ccml Hccml; apply isColimCocone_pair_functor.
Defined.

End pair_functor.

(** ** A functor F : A -> product_category I B is (omega-)cocontinuous if each F_i : A -> B_i is *)
Section functor_into_product_category.
(* NOTE: section below on [power_category] may be easily(?) generalised to [product_category]. *)
(* NOTE: binary analogue for this section. *)

Context {I : UU} {A : category} {B : I -> category}.

(* A cocone in the [product_category] is a colimit cocone if each of its components is.

Cf. the converse [isColimCocone_functor_into_power] below (currently only for special case of power,
not product), which seems to require some additional assumption (e.g. decidable equality on [I];
perhaps other conditions might also suffice. *)
(* NOTE: other lemmas in below on cocones in [power_category] may be able to be simplified using this. *)
Lemma isColimCocone_in_product_category
  {g : graph} (c : diagram g (product_category B))
  (b : product_precategory B) (cc : cocone c b)
  (M : ∏ i, isColimCocone _ _ (mapcocone (pr_functor I B i) _ cc))
  : isColimCocone c b cc.
Proof.
  intros b' cc'.
  apply iscontraprop1.
  - abstract (
    apply invproofirrelevance; intros f1 f2;
    apply subtypePath;
    [ intros f; apply impred_isaprop; intros v;
      apply has_homsets_product_precategory | ];
    apply funextsec; intros i;
    assert (MM := M i _ (mapcocone (pr_functor I B i) _ cc'));
    assert (H := proofirrelevancecontr MM);
    use (maponpaths pr1 (H (pr1 f1 i,,_) (pr1 f2 i,,_)));
      clear MM H; intros v ;
      [ exact (toforallpaths _ _ _ (pr2 f1 v) i) |
        exact (toforallpaths _ _ _ (pr2 f2 v) i) ]
      ) .
  - use tpair.
    + intros i.
      use (pr1 (pr1 (M i _ (mapcocone (pr_functor I B i) _ cc')))).
    + abstract (
          intros v; apply funextsec; intros i;
          use (pr2 (pr1 (M i _ (mapcocone (pr_functor I B i) _ cc'))) v)
        ).
Defined.

Lemma is_cocont_functor_into_product_category
  {F : functor A (product_category B)}
  (HF : ∏ (i : I), is_cocont (functor_composite F (pr_functor I B i))) :
  is_cocont F.
Proof.
  intros gr cA a cc Hcc.
  apply isColimCocone_in_product_category.
  intros i.
  rewrite <- mapcocone_functor_composite.
  now apply HF, Hcc.
Defined.

Lemma is_omega_cocont_functor_into_product_category
  {F : functor A (product_category B)}
  (HF : ∏ (i : I), is_omega_cocont (functor_composite F (pr_functor I B i))) :
  is_omega_cocont F.
Proof.
  intros cA a cc Hcc.
  apply isColimCocone_in_product_category.
  intros i.
  rewrite <- mapcocone_functor_composite.
  now apply HF, Hcc.
Defined.

End functor_into_product_category.

Section tuple_functor.

Context {I : UU} {A : category} {B : I -> category}.

Lemma is_cocont_tuple_functor {F : ∏ i, functor A (B i)}
  (HF : ∏ i, is_cocont (F i)) : is_cocont (tuple_functor F).
Proof.
  apply is_cocont_functor_into_product_category.
  intro i; rewrite pr_tuple_functor; apply HF.
Defined.

Lemma is_omega_cocont_tuple_functor {F : ∏ i, functor A (B i)}
  (HF : ∏ i, is_omega_cocont (F i)) : is_omega_cocont (tuple_functor F).
Proof.
  apply is_omega_cocont_functor_into_product_category.
  intro i; rewrite pr_tuple_functor; apply HF.
Defined.

End tuple_functor.

(** ** A family of functor F^I : A^I -> B^I is omega cocontinuous if each F_i is *)
(** TODO: split out section [pr_functor], and then factor results on [family_functor] using that
together with [tuple_functor] (maybe after redefining [family_functor] using [tuple_functor]. *)
Section family_functor.

Context {I : UU} {A B : category}.

(* The index set I needs decidable equality for pr_functor to be cocont *)
Hypothesis (HI : isdeceq I).

Local Definition ifI (i j : I) (a b : A) : A :=
  coprod_rect (λ _, A) (λ _,a) (λ _,b) (HI i j).

Local Lemma ifI_eq i x y : ifI i i x y = x.
Proof.
now unfold ifI; destruct (HI i i) as [p|p]; [|destruct (p (idpath _))].
Defined.

Local Lemma isColimCocone_pr_functor
  {g : graph} (c : diagram g (power_category I A))
  (L : power_category I A) (ccL : cocone c L)
  (M : isColimCocone c L ccL) : ∏ i,
  isColimCocone _ _ (mapcocone (pr_functor I (λ _, A) i) c ccL).
Proof.
intros i x ccx; simpl in *.
transparent assert (HHH : (cocone c (λ j, ifI i j x (L j)))).
{ unfold ifI.
  use make_cocone.
  - simpl; intros n j.
    destruct (HI i j) as [p|p].
    + apply (transportf (λ i, A ⟦ dob c n i, x ⟧) p (coconeIn ccx n)).
    + apply (# (pr_functor I (λ _, A) j) (coconeIn ccL n)).
  - abstract (simpl; intros m n e;
      apply funextsec; intro j; unfold compose; simpl;
      destruct (HI i j);
        [ destruct p; apply (pr2 ccx m n e)
        | apply (toforallpaths _ _ _ (pr2 ccL m n e) j)]).
}
destruct (M _ HHH) as [[x1 p1] p2].
use tpair.
- apply (tpair _ (transportf _ (ifI_eq _ _ _) (x1 i))).
  abstract (intro n;
    rewrite <- idtoiso_postcompose, assoc;
    eapply pathscomp0;
      [eapply cancel_postcomposition, (toforallpaths _ _ _ (p1 n) i)|];
    unfold ifI, ifI_eq; simpl;
    destruct (HI i i); [|destruct (n0 (idpath _))];
    rewrite idtoiso_postcompose, idpath_transportf;
    assert (hp : p = idpath i); [apply (isasetifdeceq _ HI)|];
    now rewrite hp, idpath_transportf).
- intro t.
  transparent assert (X : (∑ x0, ∏ n, coconeIn ccL n · x0 = coconeIn HHH n)).
  { use tpair.
    - simpl; intro j; unfold ifI.
      destruct (HI i j).
      + apply (transportf (λ i, A ⟦ L i, x ⟧) p (pr1 t)).
      + apply identity.
    - cbn. abstract (intro n; apply funextsec; intro j; unfold ifI; destruct (HI i j);
          [ now destruct p; rewrite <- (pr2 t), !idpath_transportf
          | apply id_right ]).
  }
  apply subtypePath; simpl; [intro f; apply impred; intro; apply homset_property|].
  set (H := toforallpaths _ _ _ (maponpaths pr1 (p2 X)) i); simpl in H.
  rewrite <- H; clear H; unfold ifI_eq, ifI.
  destruct (HI i i) as [p|p]; [|destruct (p (idpath _))].
  assert (hp : p = idpath i); [apply (isasetifdeceq _ HI)|].
  now rewrite hp, idpath_transportf.
Defined.

Lemma is_cocont_pr_functor (i : I) : is_cocont (pr_functor I (λ _, A) i).
Proof.
now intros c L ccL M H; apply isColimCocone_pr_functor.
Defined.

Lemma isColimCocone_family_functor {gr : graph} (F : ∏ (i : I), functor A B)
  (HF : ∏ i (d : diagram gr A) (c : A) (cc : cocone d c) (h : isColimCocone d c cc),
        isColimCocone _ _ (mapcocone (F i) d cc)) :
  ∏ (d : diagram gr (product_category (λ _, A))) (cd : I -> A) (cc : cocone d cd),
  isColimCocone _ _ cc ->
  isColimCocone _ _ (mapcocone (family_functor I F) d cc).
Proof.
intros cAB ml ccml Hccml xy ccxy; simpl in *.
transparent assert (cc : (∏ i, cocone (mapdiagram (F i) (mapdiagram (pr_functor I (λ _ : I, A) i) cAB)) (xy i))).
{ intro i; use make_cocone.
  - intro n; use (pr1 ccxy n).
  - abstract (intros m n e; apply (toforallpaths _ _ _ (pr2 ccxy m n e) i)).
}
set (X i := HF i _ _ _ (isColimCocone_pr_functor _ _ _ Hccml i) (xy i) (cc i)).
use tpair.
- use tpair.
  + intro i; apply (pr1 (pr1 (X i))).
  + abstract (intro n; apply funextsec; intro j; apply (pr2 (pr1 (X j)) n)).
- abstract (intro t; apply subtypePath; simpl;
             [ intro x; apply impred; intro; apply impred_isaset; intro i; apply homset_property
             | destruct t as [f1 f2]; simpl in *;  apply funextsec; intro i;
               transparent assert (H : (∑ x : B ⟦ (F i) (ml i), xy i ⟧,
                                       ∏ n, # (F i) (coconeIn ccml n i) · x =
                                       coconeIn ccxy n i));
                [apply (tpair _ (f1 i)); intro n; apply (toforallpaths _ _ _ (f2 n) i)|];
               apply (maponpaths pr1 (pr2 (X i) H))]).
Defined.

Lemma is_cocont_family_functor
  {F : ∏ (i : I), functor A B} (HF : ∏ (i : I), is_cocont (F i)) :
  is_cocont (family_functor I F).
Proof.
  intros gr cAB ml ccml Hccml.
  apply isColimCocone_family_functor; trivial; intro i; apply HF.
Defined.

Lemma is_omega_cocont_family_functor
  {F : ∏ (i : I), functor A B} (HF : ∏ (i : I), is_omega_cocont (F i)) :
  is_omega_cocont (family_functor I F).
Proof.
  now intros cAB ml ccml Hccml; apply isColimCocone_family_functor.
Defined.

End family_functor.


(** ** The bindelta functor C -> C^2 mapping x to (x,x) is omega cocontinuous *)
Section bindelta_functor.

Context {C : category} (PC : BinProducts C).

Lemma is_cocont_bindelta_functor : is_cocont (bindelta_functor C).
Proof.
  apply (left_adjoint_cocont _ _ _ (is_left_adjoint_bindelta_functor PC)).
Defined.

Lemma is_omega_cocont_bindelta_functor : is_omega_cocont (bindelta_functor C).
Proof.
  now intros c L ccL; apply is_cocont_bindelta_functor.
Defined.

End bindelta_functor.

(** ** The generalized delta functor C -> C^I is omega cocontinuous *)
Section delta_functor.
(* TODO: factor this using [tuple_functor] results above, after redefining [delta_functor] in terms of [tuple_functor]. *)

Context {I : UU} {C : category} (PC : Products I C).

Lemma is_cocont_delta_functor : is_cocont (delta_functor I C).
Proof.
  apply (left_adjoint_cocont _ _ _ (is_left_adjoint_delta_functor _ PC)).
Defined.

Lemma is_omega_cocont_delta_functor :
  is_omega_cocont (delta_functor I C).
Proof.
  now intros c L ccL; apply is_cocont_delta_functor.
Defined.

End delta_functor.

(** ** The functor "+ : C^2 -> C" is cocontinuous *)
Section bincoprod_functor.

Context {C : category} (PC : BinCoproducts C).

Lemma is_cocont_bincoproduct_functor : is_cocont (bincoproduct_functor PC).
Proof.
  apply (left_adjoint_cocont _ _ _ (is_left_adjoint_bincoproduct_functor PC)).
Defined.

Lemma is_omega_cocont_bincoproduct_functor :
  is_omega_cocont (bincoproduct_functor PC).
Proof.
  now intros c L ccL; apply is_cocont_bincoproduct_functor.
Defined.

End bincoprod_functor.

(** ** The functor "+ : C^I -> C" is cocontinuous *)
Section coprod_functor.

Context {I : UU} {C : category} (PC : Coproducts I C).

Lemma is_cocont_coproduct_functor :
  is_cocont (coproduct_functor _ PC).
Proof.
  apply (left_adjoint_cocont _ _ _ (is_left_adjoint_coproduct_functor _ PC)).
Defined.

Lemma is_omega_cocont_coproduct_functor :
  is_omega_cocont (coproduct_functor _ PC).
Proof.
  now intros c L ccL; apply is_cocont_coproduct_functor.
Defined.

End coprod_functor.

(** ** Binary coproduct of functors: F + G : C -> D is omega cocontinuous *)
Section BinCoproduct_of_functors.

Context {C D : category} (HD : BinCoproducts D).

Lemma is_cocont_BinCoproduct_of_functors_alt {F G : functor C D}
  (HF : is_cocont F) (HG : is_cocont G) :
  is_cocont (BinCoproduct_of_functors_alt HD F G).
Proof.
apply is_cocont_functor_composite.
- apply is_cocont_tuple_functor.
  induction i; assumption.
- apply is_cocont_coproduct_functor.
Defined.

Lemma is_omega_cocont_BinCoproduct_of_functors_alt {F G : functor C D}
  (HF : is_omega_cocont F) (HG : is_omega_cocont G) :
  is_omega_cocont (BinCoproduct_of_functors_alt HD F G).
Proof.
apply is_omega_cocont_functor_composite.
- apply is_omega_cocont_tuple_functor.
  induction i; assumption.
- apply is_omega_cocont_coproduct_functor.
Defined.

Definition omega_cocont_BinCoproduct_of_functors_alt (F G : omega_cocont_functor C D) :
  omega_cocont_functor C D :=
    tpair _ _ (is_omega_cocont_BinCoproduct_of_functors_alt (pr2 F) (pr2 G)).

Lemma is_cocont_BinCoproduct_of_functors (F G : functor C D)
  (HF : is_cocont F) (HG : is_cocont G) :
  is_cocont (BinCoproduct_of_functors _ _ HD F G).
Proof.
exact (transportf _
         (BinCoproduct_of_functors_alt_eq_BinCoproduct_of_functors _ _ _ F G)
         (is_cocont_BinCoproduct_of_functors_alt HF HG)).
Defined.

Lemma is_omega_cocont_BinCoproduct_of_functors (F G : functor C D)
  (HF : is_omega_cocont F) (HG : is_omega_cocont G) :
  is_omega_cocont (BinCoproduct_of_functors _ _ HD F G).
Proof.
exact (transportf _
         (BinCoproduct_of_functors_alt_eq_BinCoproduct_of_functors _ _ _ F G)
         (is_omega_cocont_BinCoproduct_of_functors_alt HF HG)).
Defined.

Definition omega_cocont_BinCoproduct_of_functors
 (F G : omega_cocont_functor C D) :
  omega_cocont_functor C D :=
    tpair _ _ (is_omega_cocont_BinCoproduct_of_functors _ _ (pr2 F) (pr2 G)).

(* Keep these as they have better computational behavior than the one for _alt above *)
Lemma is_cocont_BinCoproduct_of_functors_alt2
  (PC : BinProducts C) (F G : functor C D)
  (HF : is_cocont F) (HG : is_cocont G) :
  is_cocont (BinCoproduct_of_functors_alt2 HD F G).
Proof.
apply is_cocont_functor_composite.
  apply (is_cocont_bindelta_functor PC).
apply is_cocont_functor_composite.
  apply (is_cocont_pair_functor _ _ HF HG).
apply is_cocont_bincoproduct_functor.
Defined.

Lemma is_omega_cocont_BinCoproduct_of_functors_alt2
  (PC : BinProducts C) (F G : functor C D)
  (HF : is_omega_cocont F) (HG : is_omega_cocont G) :
  is_omega_cocont (BinCoproduct_of_functors_alt2 HD F G).
Proof.
apply is_omega_cocont_functor_composite.
  apply (is_omega_cocont_bindelta_functor PC).
apply is_omega_cocont_functor_composite.
  apply (is_omega_cocont_pair_functor _ _ HF HG).
apply is_omega_cocont_bincoproduct_functor.
Defined.

Definition omega_cocont_BinCoproduct_of_functors_alt2
  (PC : BinProducts C) (F G : omega_cocont_functor C D) :
  omega_cocont_functor C D :=
    tpair _ _ (is_omega_cocont_BinCoproduct_of_functors_alt2 PC _ _ (pr2 F) (pr2 G)).

End BinCoproduct_of_functors.

(** ** Coproduct of families of functors: + F_i : C -> D is omega cocontinuous *)
Section coproduct_of_functors.

Context {I : UU} {C D : category} (HD : Coproducts I D).

Lemma is_cocont_coproduct_of_functors
  {F : ∏ (i : I), functor C D} (HF : ∏ i, is_cocont (F i)) :
  is_cocont (coproduct_of_functors I _ _ HD F).
Proof.
  use (transportf _
        (coproduct_of_functors_alt_eq_coproduct_of_functors _ _ _ _ F)
        _).
  apply is_cocont_functor_composite.
  - apply is_cocont_tuple_functor.
    apply HF.
  - apply is_cocont_coproduct_functor.
Defined.

Lemma is_omega_cocont_coproduct_of_functors
  {F : ∏ (i : I), functor C D} (HF : ∏ i, is_omega_cocont (F i)) :
  is_omega_cocont (coproduct_of_functors I _ _ HD F).
Proof.
  use (transportf _
        (coproduct_of_functors_alt_eq_coproduct_of_functors _ _ _ _ F)
        _).
  apply is_omega_cocont_functor_composite.
  - apply is_omega_cocont_tuple_functor.
    apply HF.
  - apply is_omega_cocont_coproduct_functor.
Defined.

Definition omega_cocont_coproduct_of_functors
  (F : ∏ i, omega_cocont_functor C D) :
  omega_cocont_functor C D :=
    tpair _ _ (is_omega_cocont_coproduct_of_functors (λ i, pr2 (F i))).

End coproduct_of_functors.

(** ** Constant product functors: C -> C, x |-> a * x  and  x |-> x * a are cocontinuous *)
Section constprod_functors.

Context {C : category} (PC : BinProducts C) (hE : Exponentials PC).

Lemma is_cocont_constprod_functor1 (x : C) : is_cocont (constprod_functor1 PC x).
Proof.
  exact (left_adjoint_cocont _ _ _ (hE _)).
Defined.

Lemma is_omega_cocont_constprod_functor1 (x : C) : is_omega_cocont (constprod_functor1 PC x).
Proof.
  now intros c L ccL; apply is_cocont_constprod_functor1.
Defined.

Definition omega_cocont_constprod_functor1 (x : C) :
  omega_cocont_functor C C := tpair _ _ (is_omega_cocont_constprod_functor1 x).

Lemma is_cocont_constprod_functor2 (x : C) : is_cocont (constprod_functor2 PC x).
Proof.
  apply left_adjoint_cocont.
  apply (is_exponentiable_to_is_exponentiable' PC), hE.
Defined.

Lemma is_omega_cocont_constprod_functor2 (x : C) : is_omega_cocont (constprod_functor2 PC x).
Proof.
  now intros c L ccL; apply is_cocont_constprod_functor2.
Defined.

Definition omega_cocont_constprod_functor2 (x : C) :
  omega_cocont_functor C C := tpair _ _ (is_omega_cocont_constprod_functor2 x).

End constprod_functors.

(** ** The functor "* : C^2 -> C" is omega cocontinuous *)
Section binprod_functor.

Context {C : category} (PC : BinProducts C).

(* This hypothesis follow directly if C has exponentials *)
Variable omega_cocont_constprod_functor1 :
  ∏ x : C, is_omega_cocont (constprod_functor1 PC x).

Let omega_cocont_constprod_functor2 :
  ∏ x : C, is_omega_cocont (constprod_functor2 PC x).
Proof.
now intro x; apply (is_omega_cocont_z_iso (flip_z_iso PC x)).
Defined.

Local Definition fun_lt (cAB : chain (category_binproduct C C)) :
  ∏ i j, i < j ->
              C ⟦ BinProductObject C (PC (ob1 (dob cAB i)) (ob2 (dob cAB j))),
                  BinProductObject C (PC (ob1 (dob cAB j)) (ob2 (dob cAB j))) ⟧.
Proof.
intros i j hij.
apply (BinProductOfArrows _ _ _ (mor1 (chain_mor cAB hij)) (identity _)).
Defined.

Local Definition fun_gt (cAB : chain (category_binproduct C C)) :
  ∏ i j, i > j ->
              C ⟦ BinProductObject C (PC (ob1 (dob cAB i)) (ob2 (dob cAB j))),
                  BinProductObject C (PC (ob1 (dob cAB i)) (ob2 (dob cAB i))) ⟧.
Proof.
intros i j hij.
apply (BinProductOfArrows _ _ _ (identity _) (mor2 (chain_mor cAB hij))).
Defined.

(* The map to K from the "grid" *)
Local Definition map_to_K (cAB : chain (category_binproduct C C)) (K : C)
  (ccK : cocone (mapchain (binproduct_functor PC) cAB) K) i j :
  C⟦BinProductObject C (PC (ob1 (dob cAB i)) (ob2 (dob cAB j))), K⟧.
Proof.
destruct (natlthorgeh i j).
- apply (fun_lt cAB _ _ h · coconeIn ccK j).
- destruct (natgehchoice _ _ h) as [H|H].
  * apply (fun_gt cAB _ _ H · coconeIn ccK i).
  * destruct H; apply (coconeIn ccK i).
Defined.

Local Lemma map_to_K_commutes (cAB : chain (category_binproduct C C)) (K : C)
  (ccK : cocone (mapchain (binproduct_functor PC) cAB) K)
  i j k (e : edge j k) :
   BinProduct_of_functors_mor C C PC (constant_functor C C (pr1 (pr1 cAB i)))
     (functor_identity C) (pr2 (dob cAB j)) (pr2 (dob cAB k))
     (mor2 (dmor cAB e)) · map_to_K cAB K ccK i k =
   map_to_K cAB K ccK i j.
Proof.
destruct e; simpl.
unfold BinProduct_of_functors_mor, map_to_K.
destruct (natlthorgeh i j) as [h|h].
- destruct (natlthorgeh i (S j)) as [h0|h0].
  * rewrite assoc, <- (coconeInCommutes ccK j (S j) (idpath _)), assoc; simpl.
    apply cancel_postcomposition; unfold fun_lt.
    rewrite BinProductOfArrows_comp, id_left.
    eapply pathscomp0; [apply BinProductOfArrows_comp|].
    rewrite id_right.
    apply maponpaths_12; try apply idpath; rewrite id_left; simpl.
    destruct (natlehchoice4 i j h0) as [h1|h1].
    + apply cancel_postcomposition, maponpaths, maponpaths, isasetbool.
    + destruct h1; destruct (isirreflnatlth _ h).
  * destruct (isirreflnatlth _ (natlthlehtrans _ _ _ (natlthtolths _ _ h) h0)).
- destruct (natlthorgeh i (S j)) as [h0|h0].
  * destruct (natgehchoice i j h) as [h1|h1].
    + destruct (natlthchoice2 _ _ h1) as [h2|h2].
      { destruct (isirreflnatlth _ (istransnatlth _ _ _ h0 h2)). }
      { destruct h2; destruct (isirreflnatlth _ h0). }
    + destruct h1; simpl.
      rewrite <- (coconeInCommutes ccK i (S i) (idpath _)), assoc.
      eapply pathscomp0; [apply cancel_postcomposition, BinProductOfArrows_comp|].
      rewrite id_left, id_right.
      apply cancel_postcomposition,
        (maponpaths_12 (BinProductOfArrows _ _ _)); try apply idpath.
      simpl; destruct (natlehchoice4 i i h0) as [h1|h1]; [destruct (isirreflnatlth _ h1)|].
      apply maponpaths, maponpaths, isasetnat.
  * destruct (natgehchoice i j h) as [h1|h1].
    + destruct (natgehchoice i (S j) h0) as [h2|h2].
      { unfold fun_gt; rewrite assoc.
        eapply pathscomp0; [eapply cancel_postcomposition, BinProductOfArrows_comp|].
        rewrite id_right.
        apply cancel_postcomposition, maponpaths_12; try apply idpath.
        now rewrite <- (chain_mor_right h1 h2). }
      { destruct h; unfold fun_gt; simpl.
        destruct (!h2).
        assert (eq: h2 = (idpath _)). { apply isasetnat. }
        rewrite eq.
        apply cancel_postcomposition.
        apply maponpaths_12; try apply idpath; simpl.
        destruct (natlehchoice4 j j h1); [destruct (isirreflnatlth _ h)|].
        apply maponpaths, maponpaths, isasetnat. }
    + destruct h1; destruct (negnatgehnsn _ h0).
Qed.

(* The cocone over K from the A_i * B chain *)
Local Definition ccAiB_K (cAB : chain (category_binproduct C C)) (K : C)
  (ccK : cocone (mapchain (binproduct_functor PC) cAB) K) i :
  cocone (mapchain (constprod_functor1 PC (pr1 (pr1 cAB i)))
         (mapchain (pr2_functor C C) cAB)) K.
Proof.
use make_cocone.
+ intro j; apply (map_to_K cAB K ccK i j).
+ simpl; intros j k e; apply map_to_K_commutes.
Defined.

Section omega_cocont_binproduct.

Context {cAB : chain (category_binproduct C C)} {LM : C × C}
        {ccLM : cocone cAB LM} (HccLM : isColimCocone cAB LM ccLM)
        {K : C} (ccK : cocone (mapchain (binproduct_functor PC) cAB) K).

Let L := pr1 LM : C.
Let M := pr2 LM : (λ _ : C, C) (pr1 LM).
Let cA := mapchain (pr1_functor C C) cAB : chain C.
Let cB := mapchain (pr2_functor C C) cAB : chain C.
Let HA := isColimCocone_pr1_functor _ _ _ HccLM
  : isColimCocone cA L (cocone_pr1_functor cAB LM ccLM).
Let HB := isColimCocone_pr2_functor _ _ _ HccLM
  : isColimCocone cB M (cocone_pr2_functor cAB LM ccLM).

(* Form the colimiting cocones of "A_i * B_0 -> A_i * B_1 -> ..." *)
Let HAiB := λ i, omega_cocont_constprod_functor1 (pr1 (pr1 cAB i)) _ _ _ HB.

(* Turn HAiB into a ColimCocone: *)
Let CCAiB := λ i, make_ColimCocone _ _ _ (HAiB i).

(* Define the HAiM ColimCocone: *)
Let HAiM := make_ColimCocone _ _ _ (omega_cocont_constprod_functor2 M _ _ _ HA).

Let ccAiB_K := λ i, ccAiB_K _ _ ccK i.

(* The f which is used in colimOfArrows *)
Local Definition f i j : C
   ⟦ BinProduct_of_functors_ob C C PC (constant_functor C C (pr1 (dob cAB i)))
       (functor_identity C) (pr2 (dob cAB j)),
     BinProduct_of_functors_ob C C PC (constant_functor C C (pr1 (dob cAB (S i))))
       (functor_identity C) (pr2 (dob cAB j)) ⟧.
Proof.
  apply BinProductOfArrows; [apply (dmor cAB (idpath _)) | apply identity ].
Defined.

Local Lemma fNat : ∏ i u v (e : edge u v),
   dmor (mapchain (constprod_functor1 PC _) cB) e · f i v =
   f i u · dmor (mapchain (constprod_functor1 PC _) cB) e.
Proof.
  intros i j k e; destruct e; simpl.
  eapply pathscomp0; [apply BinProductOfArrows_comp|].
  eapply pathscomp0; [|eapply pathsinv0; apply BinProductOfArrows_comp].
  now rewrite !id_left, !id_right.
Qed.

(* Define the chain A_i * M *)
Local Definition AiM_chain : chain C.
Proof.
  use tpair.
  - intro i; apply (colim (CCAiB i)).
  - intros i j e; destruct e.
    apply (colimOfArrows (CCAiB i) (CCAiB (S i)) (f i) (fNat i)).
Defined.

Local Lemma AiM_chain_eq : ∏ i, dmor AiM_chain (idpath (S i)) =
                       dmor (mapchain (constprod_functor2 PC M) cA) (idpath _).
Proof.
  intro i; simpl; unfold colimOfArrows, BinProduct_of_functors_mor; simpl.
  apply pathsinv0, colimArrowUnique.
  simpl; intro j.
  unfold colimIn; simpl; unfold BinProduct_of_functors_mor, f; simpl.
  eapply pathscomp0; [apply BinProductOfArrows_comp|].
  apply pathsinv0.
  eapply pathscomp0; [apply BinProductOfArrows_comp|].
  now rewrite !id_left, !id_right.
Qed.

(* Define a cocone over K from the A_i * M chain *)
Local Lemma ccAiM_K_subproof : forms_cocone (mapdiagram (constprod_functor2 PC M) cA)
                                            (fun u => colimArrow (CCAiB u) K (ccAiB_K u)).
Proof.
  intros i j e; destruct e; simpl.
  generalize (AiM_chain_eq i); simpl; intro H; rewrite <- H; clear H; simpl.
  eapply pathscomp0.
  apply (precompWithColimOfArrows _ _ (CCAiB i) (CCAiB (S i)) _ _ K (ccAiB_K (S i))).
  apply (colimArrowUnique (CCAiB i) K (ccAiB_K i)).
  simpl; intros j.
  eapply pathscomp0; [apply (colimArrowCommutes (CCAiB i) K)|]; simpl.
  unfold map_to_K.
  destruct (natlthorgeh (S i) j).
  + destruct (natlthorgeh i j).
    * rewrite assoc; apply cancel_postcomposition.
      unfold f, fun_lt; simpl.
      eapply pathscomp0; [apply BinProductOfArrows_comp|].
      now rewrite id_right, <- (chain_mor_right h0 h).
    * destruct (isasymmnatgth _ _ h h0).
  + destruct (natgehchoice (S i) j h).
    * destruct h.
      { destruct (natlthorgeh i j).
        - destruct (natlthchoice2 _ _ h) as [h2|h2].
          + destruct (isirreflnatlth _ (istransnatlth _ _ _ h0 h2)).
          + destruct h2; destruct (isirreflnatlth _ h0).
        - destruct (natgehchoice i j h).
          + destruct h.
            rewrite <- (coconeInCommutes ccK i _ (idpath _)); simpl.
            rewrite !assoc; apply cancel_postcomposition.
            unfold f, fun_gt.
            rewrite BinProductOfArrows_comp.
            eapply pathscomp0; [apply BinProductOfArrows_comp|].
            now rewrite !id_left, !id_right, <- (chain_mor_left h1 h0).
          + destruct p.
            rewrite <- (coconeInCommutes ccK i _ (idpath _)), assoc.
            apply cancel_postcomposition.
            unfold f, fun_gt.
            eapply pathscomp0; [apply BinProductOfArrows_comp|].
            rewrite id_left, id_right.
            apply (maponpaths_12 (BinProductOfArrows _ _ _)); try apply idpath; simpl.
            destruct (natlehchoice4 i i h0); [destruct (isirreflnatlth _ h1)|].
            apply maponpaths, maponpaths, isasetnat.
       }
    * destruct p, h.
      destruct (natlthorgeh i (S i)); [|destruct (negnatgehnsn _ h)].
      apply cancel_postcomposition; unfold f, fun_lt.
      apply maponpaths_12; try apply idpath; simpl.
      destruct (natlehchoice4 i i h); [destruct (isirreflnatlth _ h0)|].
      assert (H : idpath (S i) = maponpaths S p). apply isasetnat.
      now rewrite H.
Qed.

Local Definition ccAiM_K := make_cocone _ ccAiM_K_subproof.

Local Lemma is_cocone_morphism :
 ∏ v : nat,
   BinProductOfArrows C (PC L M) (PC (pr1 (dob cAB v)) (pr2 (dob cAB v)))
     (pr1 (coconeIn ccLM v)) (pr2 (coconeIn ccLM v)) ·
   colimArrow HAiM K ccAiM_K = coconeIn ccK v.
Proof.
  intro i.
  generalize (colimArrowCommutes HAiM K ccAiM_K i).
  assert (H : coconeIn ccAiM_K i = colimArrow (CCAiB i) K (ccAiB_K i)).
  { apply idpath. }
  rewrite H; intros HH.
  generalize (colimArrowCommutes (CCAiB i) K (ccAiB_K i) i).
  rewrite <- HH; simpl; unfold map_to_K.
  destruct (natlthorgeh i i); [destruct (isirreflnatlth _ h)|].
  destruct (natgehchoice i i h); [destruct (isirreflnatgth _ h0)|].
  simpl; destruct h, p.
  intros HHH.
  rewrite <- HHH, assoc.
  apply cancel_postcomposition.
  unfold colimIn; simpl; unfold BinProduct_of_functors_mor; simpl.
  apply pathsinv0.
  eapply pathscomp0; [apply BinProductOfArrows_comp|].
  now rewrite id_left, id_right.
Qed.

Local Lemma is_unique_cocone_morphism :
 ∏ t : ∑ x : C ⟦ BinProductObject C (PC L M), K ⟧,
       ∏ v : nat,
       BinProductOfArrows C (PC L M) (PC (pr1 (dob cAB v)) (pr2 (dob cAB v)))
         (pr1 (coconeIn ccLM v)) (pr2 (coconeIn ccLM v)) · x =
       coconeIn ccK v, t = colimArrow HAiM K ccAiM_K,, is_cocone_morphism.
Proof.
  intro t.
  apply subtypePath; simpl.
  + intro; apply impred; intros; apply homset_property.
  + apply (colimArrowUnique HAiM K ccAiM_K).
    induction t as [t p]; simpl; intro i.
    apply (colimArrowUnique (CCAiB i) K (ccAiB_K i)).
    simpl; intros j; unfold map_to_K.
    induction (natlthorgeh i j) as [h|h].
    * rewrite <- (p j); unfold fun_lt.
      rewrite !assoc.
      apply cancel_postcomposition.
      unfold colimIn; simpl; unfold BinProduct_of_functors_mor; simpl.
      eapply pathscomp0; [apply BinProductOfArrows_comp|].
      apply pathsinv0.
      eapply pathscomp0; [apply BinProductOfArrows_comp|].
      rewrite !id_left, id_right.
      apply maponpaths_12; try apply idpath.
      apply (maponpaths pr1 (chain_mor_coconeIn cAB LM ccLM i j h)).
    * destruct (natgehchoice i j h).
      { unfold fun_gt; rewrite <- (p i), !assoc.
        apply cancel_postcomposition.
        unfold colimIn; simpl; unfold BinProduct_of_functors_mor; simpl.
        eapply pathscomp0; [apply BinProductOfArrows_comp|].
        apply pathsinv0.
        eapply pathscomp0; [apply BinProductOfArrows_comp|].
        rewrite !id_left, id_right.
        set (X := (chain_mor_coconeIn cAB LM ccLM _ _ h0)).
        apply maponpaths.
        etrans. 2: { apply maponpaths. apply X. }
              apply idpath.
      }
      { destruct p0.
        rewrite <- (p i), assoc.
        apply cancel_postcomposition.
        unfold colimIn; simpl; unfold BinProduct_of_functors_mor; simpl.
        eapply pathscomp0; [apply BinProductOfArrows_comp|].
        now rewrite id_left, id_right. }
Qed.

Local Definition isColimProductOfColims :  ∃! x : C ⟦ BinProductObject C (PC L M), K ⟧,
   ∏ v : nat,
   BinProductOfArrows C (PC L M) (PC (pr1 (dob cAB v)) (pr2 (dob cAB v)))
     (pr1 (coconeIn ccLM v)) (pr2 (coconeIn ccLM v)) · x =
   coconeIn ccK v.
Proof.
use tpair.
- use tpair.
  + apply (colimArrow HAiM K ccAiM_K).
  + cbn. apply is_cocone_morphism.
- cbn. apply is_unique_cocone_morphism.
Defined.

End omega_cocont_binproduct.

Lemma is_omega_cocont_binproduct_functor : is_omega_cocont (binproduct_functor PC).
Proof.
  intros cAB LM ccLM HccLM K ccK; simpl in *.
  cbn.
apply isColimProductOfColims, HccLM.
Defined.

End binprod_functor.

(** ** Binary product of functors: F * G : C -> D is omega cocontinuous *)
Section BinProduct_of_functors.

Context {C D : category} (PC : BinProducts C) (PD : BinProducts D).

Variable omega_cocont_constprod_functor1 :
  ∏ x : D, is_omega_cocont (constprod_functor1 PD x).

Lemma is_omega_cocont_BinProduct_of_functors_alt (F G : functor C D)
  (HF : is_omega_cocont F) (HG : is_omega_cocont G) :
  is_omega_cocont (BinProduct_of_functors_alt PD F G).
Proof.
apply is_omega_cocont_functor_composite.
- apply (is_omega_cocont_bindelta_functor PC).
- apply is_omega_cocont_functor_composite.
  + apply (is_omega_cocont_pair_functor _ _ HF HG).
  + now apply is_omega_cocont_binproduct_functor.
Defined.

Definition omega_cocont_BinProduct_of_functors_alt (F G : omega_cocont_functor C D) :
  omega_cocont_functor C D :=
    tpair _ _ (is_omega_cocont_BinProduct_of_functors_alt _ _ (pr2 F) (pr2 G)).

Lemma is_omega_cocont_BinProduct_of_functors (F G : functor C D)
  (HF : is_omega_cocont F) (HG : is_omega_cocont G) :
  is_omega_cocont (BinProduct_of_functors _ _ PD F G).
Proof.
exact (transportf _
        (BinProduct_of_functors_alt_eq_BinProduct_of_functors C D PD F G)
        (is_omega_cocont_BinProduct_of_functors_alt _ _ HF HG)).
Defined.

Definition omega_cocont_BinProduct_of_functors (F G : omega_cocont_functor C D) :
  omega_cocont_functor C D :=
    tpair _ _ (is_omega_cocont_BinProduct_of_functors _ _ (pr2 F) (pr2 G)).

End BinProduct_of_functors.

(** ** Direct proof that the precomposition functor is cocontinuous *)
Section pre_composition_functor.

Context {A B C : category} (F : functor A B).
(* Context (CC : Colims C). *) (* This is too strong *)

Lemma preserves_colimit_pre_composition_functor {g : graph}
  (d : diagram g [B, C]) (G : [B, C])
  (ccG : cocone d G) (H : ∏ b, ColimCocone (diagram_pointwise d b)) :
  preserves_colimit (pre_composition_functor A B C F) d G ccG.
Proof.
intros HccG.
apply pointwise_Colim_is_isColimFunctor; intro a.
now apply (isColimFunctor_is_pointwise_Colim _ H _ _ HccG).
Defined.

(* Lemma is_cocont_pre_composition_functor *)
(*   (H : ∏ (g : graph) (d : diagram g [B,C,hsC]) (b : B), *)
(*        ColimCocone (diagram_pointwise hsC d b)) : *)
(*   is_cocont (pre_composition_functor _ _ _ hsB hsC F). *)
(* Proof. *)
(* now intros g d G ccG; apply preserves_colimit_pre_composition_functor. *)
(* Defined. *)

Lemma is_omega_cocont_pre_composition_functor
  (H : Colims_of_shape nat_graph C) :
  is_omega_cocont (pre_composition_functor _ _ C F).
Proof.
now intros c L ccL; apply preserves_colimit_pre_composition_functor.
Defined.

Definition omega_cocont_pre_composition_functor
  (H : Colims_of_shape nat_graph C) :
  omega_cocont_functor [B, C] [A, C] :=
  tpair _ _ (is_omega_cocont_pre_composition_functor H).

End pre_composition_functor.

(** ** Precomposition functor is cocontinuous using construction of right Kan extensions *)
Section pre_composition_functor_kan.

Context {A B C : category} (F : functor A B).
Context (LC : Lims C).

Lemma is_cocont_pre_composition_functor_kan :
  is_cocont (pre_composition_functor _ _ C F).
Proof.
  apply left_adjoint_cocont; try apply functor_category_has_homsets.
  apply (RightKanExtension_from_limits _ _ _ _ LC).
Qed.

Lemma is_omega_cocont_pre_composition_functor_kan :
  is_omega_cocont (pre_composition_functor _ _ C F).
Proof.
  now intros c L ccL; apply is_cocont_pre_composition_functor_kan.
Defined.

Definition omega_cocont_pre_composition_functor_kan :
  omega_cocont_functor [B, C] [A, C] :=
  tpair _ _ is_omega_cocont_pre_composition_functor_kan.

End pre_composition_functor_kan.

Section post_composition_functor.

Context {C D E : category}.
Context (F : functor D E) (HF : is_left_adjoint F).

Lemma is_cocont_post_composition_functor :
  is_cocont (post_composition_functor C D E F).
Proof.
  apply left_adjoint_cocont; try apply functor_category_has_homsets.
  apply (is_left_adjoint_post_composition_functor _ HF).
Defined.

Lemma is_omega_cocont_post_composition_functor :
  is_omega_cocont (post_composition_functor C D E F).
Proof.
  now intros c L ccL; apply is_cocont_post_composition_functor.
Defined.

End post_composition_functor.

(** * Swapping of functor category arguments *)
Section functor_swap.

Lemma is_cocont_functor_cat_swap (C D E : category) :
  is_cocont (functor_cat_swap C D E).
Proof.
  apply left_adjoint_cocont.
  apply is_left_adjoint_functor_cat_swap.
Defined.

Lemma is_omega_cocont_functor_cat_swap (C D E : category) :
  is_omega_cocont (functor_cat_swap C D E).
Proof.
  intros d L ccL HccL.
  apply (is_cocont_functor_cat_swap _ _ _ _ d L ccL HccL).
Defined.

End functor_swap.

(** * The forgetful functor from Set/X to Set preserves colimits *)
Section cocont_slicecat_to_cat_HSET.

Local Notation "HSET / X" := (slice_cat HSET X) (only parsing).

Lemma preserves_colimit_slicecat_to_cat_HSET (X : HSET)
  (g : graph) (d : diagram g (HSET / X)) (L : HSET / X) (ccL : cocone d L) :
  preserves_colimit (slicecat_to_cat HSET X) d L ccL.
Proof.
  apply left_adjoint_preserves_colimit.
  - apply is_left_adjoint_slicecat_to_cat_HSET.
Defined.

Lemma is_cocont_slicecat_to_cat_HSET (X : HSET) :
  is_cocont (slicecat_to_cat HSET X).
Proof.
  intros g d L cc.
  now apply preserves_colimit_slicecat_to_cat_HSET.
Defined.

Lemma is_omega_cocont_slicecat_to_cat (X : HSET) :
  is_omega_cocont (slicecat_to_cat HSET X).
Proof.
  intros d L cc.
  now apply preserves_colimit_slicecat_to_cat_HSET.
Defined.

(** Direct proof that the forgetful functor Set/X to Set preserves colimits *)
Lemma preserves_colimit_slicecat_to_cat_HSET_direct (X : HSET)
  (g : graph) (d : diagram g (HSET / X)) (L : HSET / X) (ccL : cocone d L) :
  preserves_colimit (slicecat_to_cat HSET X) d L ccL.
Proof.
  intros HccL y ccy.
  set (CC := make_ColimCocone _ _ _ HccL).
  transparent assert (c : (HSET / X)).
  { use tpair.
    - exists (∑ (x : pr1 X), pr1 y).
      abstract (apply isaset_total2; intros; apply setproperty).
    - cbn. apply pr1.
  }
  transparent assert (cc : (cocone d c)).
  { use make_cocone.
    - intros n.
      use tpair; simpl.
      + intros z.
        use tpair.
        * exact (pr2 L (pr1 (coconeIn ccL n) z)).
        * apply (coconeIn ccy n z).
      + abstract (now apply funextsec; intro z;
                  apply (toforallpaths _ _ _ (pr2 (coconeIn ccL n)) z)).
    - abstract (intros m n e; apply eq_mor_slicecat, funextsec; intro z;
                use total2_paths_f;
                [ apply (maponpaths _ (toforallpaths _ _ _
                                                     (maponpaths pr1 (coconeInCommutes ccL m n e)) z))|];
                cbn in *; induction (maponpaths pr1 _);
                simpl;
                now rewrite idpath_transportf, <- (coconeInCommutes ccy m n e)).
  }
  use unique_exists.
  - intros l; apply (pr2 (pr1 (colimArrow CC c cc) l)).
  - simpl; intro n.
    apply funextsec; intro x; cbn.
    now etrans; [apply maponpaths,
        (toforallpaths _ _ _ (maponpaths pr1 (colimArrowCommutes CC c cc n)) x)|].
  - intro ; apply impred_isaprop.
    intro ; apply homset_property.
  - simpl; intros f Hf.
    apply funextsec; intro l.
    transparent assert (k : (HSET/X⟦colim CC,c⟧)).
    { use tpair.
      - intros l'.
        exists (pr2 L l').
        apply (f l').
      - abstract (now apply funextsec).
    }
    assert (Hk : (∏ n, colimIn CC n · k = coconeIn cc n)).
    { intros n.
      apply subtypePath; [intros x; apply homset_property|].
      apply funextsec; intro z.
      use total2_paths_f; [apply idpath|].
      now rewrite idpath_transportf; cbn; rewrite <- (toforallpaths _ _ _ (Hf n) z).
    }
    apply (maponpaths dirprod_pr2
                      (toforallpaths _ _ _ (maponpaths pr1 (colimArrowUnique CC c cc k Hk)) l)).
Defined.

End cocont_slicecat_to_cat_HSET.
End cocont_functors.

(** Specialized notations for HSET *)
Declare Scope cocont_functor_hset_scope.
Delimit Scope cocont_functor_hset_scope with CS.

Notation "' x" := (omega_cocont_constant_functor x)
                    (at level 10) : cocont_functor_hset_scope.

Notation "'Id'" := (omega_cocont_functor_identity _) :
                     cocont_functor_hset_scope.

Notation "F * G" :=
  (omega_cocont_BinProduct_of_functors_alt BinProductsHSET _
     (is_omega_cocont_constprod_functor1 _ Exponentials_HSET)
     F G) : cocont_functor_hset_scope.

Notation "F + G" :=
  (omega_cocont_BinCoproduct_of_functors_alt2
     BinCoproductsHSET BinProductsHSET F G) : cocont_functor_hset_scope.

Notation "1" := (unitHSET) : cocont_functor_hset_scope.
Notation "0" := (emptyHSET) : cocont_functor_hset_scope.


Section NotationTest.
Variable A : HSET.

Local Open Scope cocont_functor_hset_scope.

(** F(X) = 1 + (A * X) *)
Definition L_A : omega_cocont_functor HSET HSET := '1 + 'A * Id.

End NotationTest.
