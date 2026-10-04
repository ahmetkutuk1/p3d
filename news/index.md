# Changelog

## p3d 0.1.0

### Initial release

#### Core functions

- [`p_surface()`](https://ahmetkutuk1.github.io/p3d/reference/p_surface.md):
  Compute the p-value surface of a single-sample t-test as a function of
  effect size (*d*) and sample size (*n*).
- [`p_curve_2d()`](https://ahmetkutuk1.github.io/p3d/reference/p_curve_2d.md):
  Compute a 2D p-value curve for a fixed sample size, for comparison
  with existing 2D packages.

#### Visualization

- [`plot_p_surface()`](https://ahmetkutuk1.github.io/p3d/reference/plot_p_surface.md):
  Interactive 3D visualization of the p-value surface, with engines for
  `rgl` (native window) and `plotly` (HTML widget).
- [`plot_p_static()`](https://ahmetkutuk1.github.io/p3d/reference/plot_p_static.md):
  Static 3D perspective plot using base R graphics (`persp`), with no
  external dependencies.

#### Documentation

- Vignette `p3d-intro`: Introduction to the package with usage examples
  and a real-data application (`mtcars`).
- Vignette `p3d-comparison`: Comparison of 2D and 3D p-value
  visualizations, including the moderating effect of sample size.

#### Testing

- 29 unit tests covering all functions.
- Monte Carlo verification against
  [`t.test()`](https://rdrr.io/r/stats/t.test.html).

#### Performance

- [`p_surface()`](https://ahmetkutuk1.github.io/p3d/reference/p_surface.md)
  computes a 60,100-cell grid in ~0.02 seconds (~3 million p-values per
  second).
- Memory usage is under 3 MB for the largest grids.
