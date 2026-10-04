#' Compute p-value surface for single-sample t-test
#'
#' Computes the p-value of a single-sample t-test as a function
#' of effect size (Cohen's d) and sample size (n). Returns a grid
#' of p-values suitable for 3D visualization.
#'
#' @param d Numeric vector of effect sizes (Cohen's d).
#'   Typical range: -2 to 2.
#' @param n Numeric vector of sample sizes. Must be >= 2.
#'   Typical range: 5 to 200.
#' @param alpha Significance level for the critical effect size.
#'   Default: 0.05.
#'
#' @return A list with the following elements:
#'   \describe{
#'     \item{d}{The input vector of effect sizes.}
#'     \item{n}{The input vector of sample sizes.}
#'     \item{p}{A matrix of p-values with dimensions
#'       \code{length(d)} x \code{length(n)}.}
#'     \item{d_crit}{A numeric vector of critical effect sizes
#'       for each sample size at level \code{alpha}.}
#'     \item{alpha}{The significance level used.}
#'     \item{grid}{A data frame with the full grid of
#'       (d, n, p) combinations.}
#'   }
#'
#' @details
#' The p-value is computed using the formula:
#' \deqn{p(d, n) = 2 \left[ 1 - F_{t(n-1)}(d \sqrt{n}) \right]}
#' where \eqn{F_{t(n-1)}} is the cumulative distribution function
#' of the t-distribution with \eqn{n-1} degrees of freedom.
#'
#' The critical effect size at level \eqn{\alpha} is:
#' \deqn{d_{crit}(n) = \frac{F^{-1}_{t(n-1)}(1 - \alpha/2)}{\sqrt{n}}}
#'
#' @export
#'
#' @examples
#' # Small example
#' result <- p_surface(d = seq(-1, 1, 0.1), n = c(10, 30, 100))
#' str(result)
#'
#' # Typical use
#' result <- p_surface(d = seq(-2, 2, 0.05), n = seq(5, 200, 5))
#' image(result$d, result$n, result$p)
p_surface <- function(d, n, alpha = 0.05) {

  # --- Input validation ---
  if (!is.numeric(d) || !is.numeric(n)) {
    stop("`d` and `n` must be numeric vectors.", call. = FALSE)
  }
  if (length(d) < 2 || length(n) < 2) {
    stop("`d` and `n` must each have at least 2 values.", call. = FALSE)
  }
  if (any(n < 2)) {
    stop("All values of `n` must be >= 2 (t-test requires df >= 1).",
         call. = FALSE)
  }
  if (alpha <= 0 || alpha >= 1) {
    stop("`alpha` must be strictly between 0 and 1.", call. = FALSE)
  }

  # --- Create grid ---
  grid <- expand.grid(d = d, n = n)

  # --- Compute t-statistic: t = d * sqrt(n) ---
  grid$t_stat <- grid$d * sqrt(grid$n)

  # --- Degrees of freedom: df = n - 1 ---
  grid$df <- grid$n - 1

  # --- Two-sided p-value: p = 2 * (1 - F_t(|t|)) ---
  grid$p <- 2 * (1 - pt(abs(grid$t_stat), df = grid$df))

  # --- Reshape into matrix for 3D visualization ---
  # Matrix dimensions: length(d) x length(n)
  # expand.grid orders by first variable (d) fastest
  p_matrix <- matrix(grid$p, nrow = length(d), ncol = length(n))

  # --- Critical effect size at level alpha ---
  d_crit <- qt(1 - alpha / 2, df = n - 1) / sqrt(n)

  # --- Return ---
  list(
    d = d,
    n = n,
    p = p_matrix,
    d_crit = d_crit,
    alpha = alpha,
    grid = grid
  )
}
