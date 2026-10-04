test_that("p_curve_2d returns correct structure", {
  result <- p_curve_2d(d = seq(-1, 1, 0.5), n = 30)

  expect_s3_class(result, "data.frame")
  expect_named(result, c("d", "p", "significant"))
  expect_equal(nrow(result), 5)
})

test_that("p_curve_2d is consistent with p_surface", {
  curve <- p_curve_2d(d = seq(-2, 2, 0.1), n = 30)
  surface <- p_surface(d = seq(-2, 2, 0.1), n = c(10, 30, 100))

  p_curve <- curve$p[curve$d == 0.5]
  p_surface <- surface$p[surface$d == 0.5, surface$n == 30]

  expect_equal(p_curve, p_surface, tolerance = 1e-10)
})

test_that("p_curve_2d correctly flags significance", {
  result <- p_curve_2d(d = c(0, 0.5, 2), n = 30, alpha = 0.05)

  expect_false(result$significant[result$d == 0])
  expect_true(result$significant[result$d == 2])
})

test_that("p_curve_2d validates inputs", {
  expect_error(p_curve_2d(d = 0.5, n = c(10, 20)), "single numeric value")
  expect_error(p_curve_2d(d = 0.5, n = 1), "must be >= 2")
  expect_error(p_curve_2d(d = 0.5, n = 30, alpha = 1.5),
               "must be strictly between 0 and 1")
})
