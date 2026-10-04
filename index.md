# p3d: Interactive 3D Visualization of p-Value Surfaces

**p3d** is an R package for computing and visualizing the
**three-dimensional p-value surface** of a single-sample t-test. It
expresses the p-value as a function of both effect size (Cohen’s *d*)
and sample size (*n*).

## Why p3d?

Traditional p-value visualizations are two-dimensional and show the
effect of only one parameter at a time. **p3d** visualizes the p-value
simultaneously across effect size and sample size. This answers
questions such as:

- How does the same effect size (*d* = 0.5) produce different
  significance outcomes at *n* = 10 versus *n* = 100?
- Why is the p-value a **continuous measure of evidence**, not a fixed
  threshold?
- How does sample size moderate the p-value?

## Installation

``` r

# From CRAN (coming soon)
install.packages("p3d")

# Development version from GitHub
# install.packages("remotes")
remotes::install_github("ahmetkutuk1/p3d")
```

## Basic Usage

``` r

library(p3d)

# Compute a 3D p-value surface
surface <- p_surface(d = seq(-2, 2, 0.1), n = seq(5, 200, 5))

# Interactive 3D visualization (plotly engine)
plot_p_surface(surface, engine = "plotly")

# Static 3D perspective (base R)
plot_p_static(surface)

# 2D p-value curve (for comparison)
curve_30 <- p_curve_2d(d = seq(-2, 2, 0.1), n = 30)
head(curve_30)
```

## Main Functions

| Function | Purpose |
|----|----|
| `p_surface(d, n, alpha)` | Compute the 3D p-value surface |
| `p_curve_2d(d, n, alpha)` | Compute a 2D p-value curve (fixed *n*) |
| `plot_p_surface(surface, engine)` | Interactive 3D visualization (rgl / plotly) |
| `plot_p_static(surface)` | Static 3D perspective (base R) |

## Mathematical Foundation

For a single-sample t-test, the p-value is:

``` math
p(d, n) = 2 \left[ 1 - F_{t(n-1)}(d \sqrt{n}) \right]
```

where $`F_{t(n-1)}`$ is the cumulative distribution function of the
t-distribution with $`n-1`$ degrees of freedom.

The critical effect size at level $`\alpha`$ is:

``` math
d_{\text{crit}}(n) = \frac{F^{-1}_{t(n-1)}(1 - \alpha/2)}{\sqrt{n}}
```

## Motivation

The p-value is a continuous measure of evidence, yet in practice it is
often reduced to a binary decision: “p \< 0.05 is significant, p ≥ 0.05
is not.” This dichotomous thinking is a major contributor to the
reproducibility crisis in science.

**p3d** aims to weaken the visual basis of this dichotomous thinking by
visualizing the p-value over a two-dimensional parameter space. The
significance boundary is a **curve**, not a **point**.

## Performance

[`p_surface()`](https://ahmetkutuk1.github.io/p3d/reference/p_surface.md)
computes a 60,100-cell grid in **0.02 seconds** (approximately 3 million
p-values per second). Memory usage is under 3 MB.

## Contributing

Please use [GitHub Issues](https://github.com/ahmetkutuk1/p3d/issues)
for bug reports and feature requests.

## License

GPL-3 © Ahmet Kutuk
