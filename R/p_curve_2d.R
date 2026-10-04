#' Compute 2D p-value curve for a fixed sample size
#'
#' Computes the p-value as a function of effect size (Cohen's d)
#' for a single, fixed sample size. This is the 2D analogue of
#' \code{\link{p_surface}} and is provided for comparison with
#' existing 2D visualization packages such as \pkg{pvaluefunctions}.
#'
#' @param d Numeric vector of effect sizes (Cohen's d).
#' @param n Single sample size. Must be >= 2.
#' @param alpha Significance level. Default: 0.05.
#'
#' @return A data frame with columns:
#'   \describe{
#'     \item{d}{Effect sizes.}
#'     \item{p}{Two-sided p-values.}
#'     \item{significant}{Logical; whether \code{p < alpha}.}
#'   }
#'
#' @details
#' The p-value is computed as:
#' \deqn{p(d) = 2 \left[ 1 - F_{t(n-1)}(d \sqrt{n}) \right]}
#'
#' @export
#'
#' @examples
#' # 2D curve for n = 30
#' curve_30 <- p_curve_2d(d = seq(-2, 2, 0.1), n = 30)
#' head(curve_30)
#'
#' # Compare with 3D surface
#' surface <- p_surface(d = seq(-2, 2, 0.1), n = c(10, 30, 100))
p_curve_2d <- function(d, n, alpha = 0.05) {

  # --- Input validation ---
  if (!is.numeric(d)) {
    stop("`d` must be a numeric vector.", call. = FALSE)
  }
  if (length(n) != 1 || !is.numeric(n)) {
    stop("`n` must be a single numeric value.", call. = FALSE)
  }
  if (n < 2) {
    stop("`n` must be >= 2.", call. = FALSE)
  }
  if (alpha <= 0 || alpha >= 1) {
    stop("`alpha` must be strictly between 0 and 1.", call. = FALSE)
  }

  # --- Compute t-statistic and p-value ---
  t_stat <- d * sqrt(n)
  p_val <- 2 * (1 - pt(abs(t_stat), df = n - 1))

  # --- Return as data frame ---
  data.frame(
    d = d,
    p = p_val,
    significant = p_val < alpha
  )
}
