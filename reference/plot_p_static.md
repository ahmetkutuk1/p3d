# Static 2D perspective plot of p-value surface

Plots the output of
[`p_surface`](https://ahmetkutuk1.github.io/p3d/reference/p_surface.md)
using base R's [`persp`](https://rdrr.io/r/graphics/persp.html)
function. This produces a static 3D perspective plot with no external
dependencies, making it suitable for PDF output, journal figures, and
CRAN checks.

## Usage

``` r
plot_p_static(
  surface,
  theta = 30,
  phi = 20,
  col = "steelblue",
  shade = TRUE,
  alpha = 0.05
)
```

## Arguments

- surface:

  A list returned by
  [`p_surface`](https://ahmetkutuk1.github.io/p3d/reference/p_surface.md).

- theta, phi:

  Viewing angles in degrees. See
  [`persp`](https://rdrr.io/r/graphics/persp.html) for details.
  Defaults: `theta = 30`, `phi = 20`.

- col:

  Color palette for the surface. Either a single color or a vector of
  colors matching the number of \\d \times n\\ grid cells.

- shade:

  Logical; if `TRUE` (default), the surface is shaded using
  [`persp`](https://rdrr.io/r/graphics/persp.html)'s shading.

- alpha:

  Significance level. A horizontal plane at \\p = \alpha\\ is overlaid
  on the surface. Default: 0.05.

## Value

Invisibly returns the input `surface` object. Called for its side effect
(a plot).

## Details

Unlike
[`plot_p_surface`](https://ahmetkutuk1.github.io/p3d/reference/plot_p_surface.md),
which requires rgl or plotly, this function uses only base R graphics.
It is ideal for inclusion in static documents such as PDF articles and
printed reports.

## Examples

``` r
# Compute surface
surface <- p_surface(d = seq(-2, 2, 0.1), n = seq(5, 200, 5))

# Static perspective plot
plot_p_static(surface)


# Different viewing angle
plot_p_static(surface, theta = 45, phi = 30)
```
