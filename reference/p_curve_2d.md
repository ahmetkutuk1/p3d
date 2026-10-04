# Compute 2D p-value curve for a fixed sample size

Computes the p-value as a function of effect size (Cohen's d) for a
single, fixed sample size. This is the 2D analogue of
[`p_surface`](https://ahmetkutuk1.github.io/p3d/reference/p_surface.md)
and is provided for comparison with existing 2D visualization packages
such as pvaluefunctions.

## Usage

``` r
p_curve_2d(d, n, alpha = 0.05)
```

## Arguments

- d:

  Numeric vector of effect sizes (Cohen's d).

- n:

  Single sample size. Must be \>= 2.

- alpha:

  Significance level. Default: 0.05.

## Value

A data frame with columns:

- d:

  Effect sizes.

- p:

  Two-sided p-values.

- significant:

  Logical; whether `p < alpha`.

## Details

The p-value is computed as: \$\$p(d) = 2 \left\[ 1 - F\_{t(n-1)}(d
\sqrt{n}) \right\]\$\$

## Examples

``` r
# 2D curve for n = 30
curve_30 <- p_curve_2d(d = seq(-2, 2, 0.1), n = 30)
head(curve_30)
#>      d            p significant
#> 1 -2.0 8.021139e-12        TRUE
#> 2 -1.9 2.650857e-11        TRUE
#> 3 -1.8 9.099432e-11        TRUE
#> 4 -1.7 3.247269e-10        TRUE
#> 5 -1.6 1.205427e-09        TRUE
#> 6 -1.5 4.654771e-09        TRUE

# Compare with 3D surface
surface <- p_surface(d = seq(-2, 2, 0.1), n = c(10, 30, 100))
```
