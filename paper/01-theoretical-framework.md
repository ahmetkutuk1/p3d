# Why 3D Visualization?

The p-value is a continuous measure of statistical evidence, yet in practice it is often reduced to a binary decision: "p < 0.05 is significant, p ≥ 0.05 is not." This dichotomous thinking is a major contributor to the reproducibility crisis in science. Existing visualization tools (pvaluefunctions, concurve, confMeta) present the p-value in a two-dimensional plane. While these tools represent an important step toward showing the continuous nature of the p-value, they cannot reveal the moderating effect of sample size. The same effect size (e.g., d = 0.5) can be non-significant at n = 10 and significant at n = 100. A two-dimensional graph cannot show this interaction.

In this study, we present the p3d package, which models the p-value as a three-dimensional surface. The package visualizes the p-value as a function of both effect size (d) and sample size (n). The user can:

- See that the significance boundary is a curve, not a point.
- Observe the moderating effect of sample size on the p-value.
- Recognize that the visual basis of dichotomous thinking is weakened.

A Monte Carlo simulation study reveals that the p-value admits two distinct interpretations, which we term the *conditional* and the *expected* p-value:

1. **Conditional p-value** (fixed effect size): $p(d, n) = 2\left[1 - F_{t(n-1)}(d\sqrt{n})\right]$
2. **Expected p-value** (random effect size): $\mathbb{E}[p(d_{\text{obs}}, n)] = \int p(d_{\text{obs}}, n) \, f(d_{\text{obs}} \mid d, n) \, dd_{\text{obs}}$

Due to Jensen's inequality, these two quantities need not coincide. Because the p-value function $p(d)$ is strictly convex in $d$, we have $\mathbb{E}[p(d_{\text{obs}})] \geq p(\mathbb{E}[d_{\text{obs}}])$, with strict inequality whenever $d_{\text{obs}}$ is non-degenerate.

The magnitude of this difference depends jointly on the effect size $d$ and the sample size $n$. Table 1 reports the two p-values and their relative difference for a grid of representative values.

**Table 1.** Conditional and expected p-values for selected combinations of effect size $d$ and sample size $n$. The expected p-value was computed via Monte Carlo simulation with $B = 10{,}000$ replications. The relative difference is defined as $\left| \mathbb{E}[p] - p \right| / p \times 100\%$.

| $d$ | $n$ | Conditional $p$ | Expected $p$ | Relative difference |
|-----|-----|-----------------|--------------|---------------------|
| 0.2 | 10  | $5.43 \times 10^{-1}$ | $4.48 \times 10^{-1}$ | 17% |
| 0.5 | 10  | $1.48 \times 10^{-1}$ | $2.47 \times 10^{-1}$ | 67% |
| 0.8 | 10  | $3.22 \times 10^{-2}$ | $9.02 \times 10^{-2}$ | 180% |
| 0.2 | 30  | $2.82 \times 10^{-1}$ | $3.46 \times 10^{-1}$ | 23% |
| 0.5 | 30  | $1.04 \times 10^{-2}$ | $5.89 \times 10^{-2}$ | 464% |
| 0.8 | 30  | $1.41 \times 10^{-4}$ | $3.30 \times 10^{-3}$ | 2,242% |
| 0.2 | 100 | $4.82 \times 10^{-2}$ | $1.47 \times 10^{-1}$ | 205% |
| 0.5 | 100 | $2.48 \times 10^{-6}$ | $4.50 \times 10^{-4}$ | 18,018% |
| 0.8 | 100 | $2.40 \times 10^{-12}$ | $3.68 \times 10^{-8}$ | 1,534,687% |

The relative difference ranges from 17% to more than $1.5 \times 10^6$%, demonstrating that the two interpretations of the p-value are not interchangeable. In the present study, we adopt the *conditional* p-value, which is the convention in power analysis and sample size planning and is consistent with existing R packages such as `pvaluefunctions` and `concurve`. A formal proof of the inequality, based on Jensen's inequality, is provided in Appendix A.

Appendix A: Mathematical Proof of the Inequality
We prove that $\mathbb{E}[p(d_{\text{obs}})] \geq p(\mathbb{E}[d_{\text{obs}}])$ for the p-value function

$$p(d) = 2\left[1 - F_{t(n-1)}(d\sqrt{n})\right]$$

where $F_{t(n-1)}$ is the cumulative distribution function of the t-distribution with $n - 1$ degrees of freedom.

**Step 1: Convexity of $p(d)$.**

The function $p(d)$ is the composition of the linear function $u \mapsto d\sqrt{n}$ and the strictly decreasing function $v \mapsto 2[1 - F_{t(n-1)}(v)]$. The latter is strictly convex because the t-distribution is symmetric and unimodal. Therefore, $p(d)$ is strictly convex in $d$.

**Step 2: Jensen's inequality.**

For any random variable $D$ with finite expectation and any convex function $\varphi$,

$$\varphi(\mathbb{E}[D]) \leq \mathbb{E}[\varphi(D)]$$

Applying this with $\varphi = p$ and $D = d_{\text{obs}}$ yields

$$p(\mathbb{E}[d_{\text{obs}}]) \leq \mathbb{E}[p(d_{\text{obs}})]$$

**Step 3: Strictness.**

Equality holds if and only if $D$ is constant or $p(\cdot)$ is linear on the support of $D$. Since $p(\cdot)$ is strictly convex, equality holds only when $d_{\text{obs}}$ is degenerate (i.e., when the effect size is known with certainty). For a non-degenerate sampling distribution of $d_{\text{obs}}$, the inequality is strict.

$\square$
