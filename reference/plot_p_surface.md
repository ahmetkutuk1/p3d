# Interactive 3D visualization of p-value surface

Plots the output of
[`p_surface`](https://ahmetkutuk1.github.io/p3d/reference/p_surface.md)
as an interactive three-dimensional surface. Two rendering engines are
supported: `"rgl"` (default, interactive window) and `"plotly"` (HTML
widget, ideal for R Markdown / Quarto documents).

## Usage

``` r
plot_p_surface(
  surface,
  engine = c("rgl", "plotly"),
  alpha = 0.05,
  col = NULL,
  show_boundary = TRUE
)
```

## Arguments

- surface:

  A list returned by
  [`p_surface`](https://ahmetkutuk1.github.io/p3d/reference/p_surface.md).

- engine:

  Character; either `"rgl"` (default) or `"plotly"`. Determines the
  rendering backend.

- alpha:

  Significance level. A horizontal plane at \\p = \alpha\\ is overlaid
  on the surface. Default: 0.05.

- col:

  Color palette for the surface. If `NULL` (default), a built-in palette
  is used.

- show_boundary:

  Logical; if `TRUE` (default), the intersection curve between the
  surface and the \\\alpha\\-plane is drawn.

## Value

Invisibly returns the input `surface` object. Called for its side effect
(a plot).

## Details

The 3D surface shows the p-value as a function of both effect size
(\\d\\) and sample size (\\n\\). The \\\alpha\\-plane visualizes the
conventional significance threshold. The intersection curve marks the
boundary between "significant" and "non-significant" regions.

For `engine = "rgl"`, the rgl package must be installed. For
`engine = "plotly"`, the plotly package must be installed. Both are
listed in `Suggests`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Compute surface
surface <- p_surface(d = seq(-2, 2, 0.1), n = seq(5, 200, 5))

# Interactive rgl window
plot_p_surface(surface)

# Plotly HTML widget
plot_p_surface(surface, engine = "plotly")
} # }
```
