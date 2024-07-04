import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Topology.MetricSpace.Basic

/-

Franklin and McNicholl define a metric on a graph by:
d_G(v₀,v₁) =
0 if v₀ = v₁
1 if (v₀,v₁) ∈ E;
2 otherwise

They say this is "clearly" a metric. We prove this formally and
generalize it, by replacing 1 and 2 by real numbers
0 < a ≤ 2b, b ≤ 2a (the fact that 0 < b follows but does not need to be mentioned).

-/

open Classical
noncomputable instance {U : Type}  (G : SimpleGraph U) (a b : ℝ)
(h₀ : 0 < a) (h₁ : a ≤ b + b) (h₂ : b ≤ a + a)
: MetricSpace U := {
  dist := λ x y ↦ ite (x=y) 0 (ite (G.Adj x y) a b)
  dist_self := λ x ↦ by simp only [reduceIte]
  dist_comm := λ x y ↦ by
    unfold dist
    simp
    by_cases H : x = y
    . rw [if_pos H, if_pos H.symm]
    . rw [if_neg H]
      have hne: ¬ y = x := fun a ↦ H (id (Eq.symm a))
      by_cases H' : G.Adj x y
      . rw [if_pos H', if_neg hne]
        have : G.Adj y x := SimpleGraph.adj_symm G H'
        rw [if_pos this]
      . rw [if_neg H', if_neg hne]
        have : ¬ G.Adj y x := fun a ↦ H' (SimpleGraph.adj_symm G a)
        rw [if_neg this]
  dist_triangle := λ x y z ↦ by
    aesop; repeat linarith
  edist_dist := (λ x y ↦ by exact (ENNReal.ofReal_eq_coe_nnreal _).symm)
  eq_of_dist_eq_zero := by
    intro x y h
    simp at h
    contrapose h
    push_neg
    use h
    by_cases H : G.Adj x y
    rw [if_pos H]
    linarith
    rw [if_neg H]
    linarith
}

