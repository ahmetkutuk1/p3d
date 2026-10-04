test_that("plot_p_static validates inputs", {
  surface <- p_surface(d = seq(-2, 2, 0.5), n = c(10, 30))

  expect_error(plot_p_static("not a surface"), "must be a list")
  expect_error(plot_p_static(surface, alpha = 1.5),
               "must be strictly between 0 and 1")
})

test_that("plot_p_static produces a plot", {
  surface <- p_surface(d = seq(-2, 2, 0.5), n = c(10, 30))

  pdf(NULL)
  expect_silent(plot_p_static(surface))
  dev.off()
})
