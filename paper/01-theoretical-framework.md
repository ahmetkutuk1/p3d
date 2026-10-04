# Why 3D Visualization?

The p-value is a continuous measure of statistical evidence, yet in practice it is often reduced to a binary decision: "p < 0.05 is significant, p ≥ 0.05 is not." This dichotomous thinking is a major contributor to the reproducibility crisis in science. Existing visualization tools (pvaluefunctions, concurve, confMeta) present the p-value in a two-dimensional plane. While these tools represent an important step toward showing the continuous nature of the p-value, they cannot reveal the moderating effect of sample size. The same effect size (e.g., d = 0.5) can be non-significant at n = 10 and significant at n = 100. A two-dimensional graph cannot show this interaction.

In this study, we present the p3d package, which models the p-value as a three-dimensional surface. The package visualizes the p-value as a function of both effect size (d) and sample size (n). The user can:

- See that the significance boundary is a curve, not a point.
- Observe the moderating effect of sample size on the p-value.
- Recognize that the visual basis of dichotomous thinking is weakened.

Monte Carlo simulations reveal two distinct interpretations of the p-value: (1) the conditional p-value given a fixed effect size, and (2) the expected p-value given a random effect size. Due to Jensen's inequality, these two approaches yield systematically different results (a relative difference of 464%). In this study, the conditional p-value approach, commonly used in power analysis and sample size planning, has been adopted.
