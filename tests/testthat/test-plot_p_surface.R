test_that("plot_p_surface validates inputs", {
  surface <- p_surface(d = seq(-2, 2, 0.5), n = seq(10, 100, 10))

  expect_error(plot_p_surface("not a surface"), "must be a list")
  expect_error(plot_p_surface(surface, alpha = 1.5),
               "must be strictly between 0 and 1")
  expect_error(plot_p_surface(surface, engine = "invalid"),
               "should be one of")
})
