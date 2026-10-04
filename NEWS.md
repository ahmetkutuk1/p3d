# p3d 0.1.0

## Initial release

### Core functions

* `p_surface()` — Compute the p-value surface of a single-sample
  t-test as a function of effect size (*d*) and sample size (*n*).
* `p_curve_2d()` — Compute a 2D p-value curve for a fixed sample size,
  for comparison with existing 2D packages.

### Visualization

* `plot_p_surface()` — Interactive 3D visualization of the p-value
  surface, with engines for `rgl` (native window) and `plotly`
  (HTML widget).
* `plot_p_static()` — Static 3D perspective plot using base R graphics
  (`persp`), with no external dependencies.

### Documentation

* Vignette `p3d-intro` — Introduction to the package with usage
  examples and a real-data application (`mtcars`).
* Vignette `p3d-comparison` — Comparison of 2D and 3D p-value
  visualizations, including the moderating effect of sample size.

### Testing

* 29 unit tests covering all functions.
* Monte Carlo verification against `t.test()`.

### Performance

* `p_surface()` computes a 60,100-cell grid in ~0.02 seconds
  (~3 million p-values per second).
* Memory usage is under 3 MB for the largest grids.
