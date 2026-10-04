test_that("p_surface returns correct structure", {
  result <- p_surface(d = c(-1, 0, 1), n = c(10, 30, 100))

  expect_type(result, "list")
  expect_named(result, c("d", "n", "p", "d_crit", "alpha", "grid"))
  expect_equal(dim(result$p), c(3, 3))
  expect_equal(length(result$d), 3)
  expect_equal(length(result$n), 3)
  expect_equal(length(result$d_crit), 3)
  expect_equal(result$alpha, 0.05)
})

test_that("p_surface matches t.test for single case", {
  set.seed(42)
  n <- 30
  d <- 0.5
  x <- rnorm(n, mean = d, sd = 1)

  d_obs <- mean(x) / sd(x)
  p_formula <- p_surface(d = d_obs, n = n)$p[1, 1]
  p_ttest <- t.test(x, mu = 0)$p.value

  expect_equal(p_formula, p_ttest, tolerance = 1e-10)
})

test_that("p_surface is symmetric in d", {
  result <- p_surface(d = c(-0.5, 0, 0.5), n = 30)

  expect_equal(result$p[1, 1], result$p[3, 1], tolerance = 1e-10)
})

test_that("p_surface returns p = 1 when d = 0", {
  result <- p_surface(d = 0, n = 30)

  expect_equal(result$p[1, 1], 1, tolerance = 1e-10)
})

test_that("p_surface validates inputs", {
  expect_error(p_surface(d = 0.5, n = 1), "must be >= 2")
  expect_error(p_surface(d = 0.5, n = 30, alpha = 1.5),
               "must be strictly between 0 and 1")     # ← backtick'siz
  expect_error(p_surface(d = "a", n = 30), "must be numeric")
  expect_error(p_surface(d = 0.5, n = "a"), "must be numeric")
})
