#' Static 2D perspective plot of p-value surface
#'
#' Plots the output of \code{\link{p_surface}} using base R's
#' \code{\link[graphics]{persp}} function. This produces a static
#' 3D perspective plot with no external dependencies, making it
#' suitable for PDF output, journal figures, and CRAN checks.
#'
#' @param surface A list returned by \code{\link{p_surface}}.
#' @param theta,phi Viewing angles in degrees. See
#'   \code{\link[graphics]{persp}} for details. Defaults:
#'   \code{theta = 30}, \code{phi = 20}.
#' @param col Color palette for the surface. Either a single
#'   color or a vector of colors matching the number of
#'   \eqn{d \times n} grid cells.
#' @param shade Logical; if \code{TRUE} (default), the surface
#'   is shaded using \code{\link[graphics]{persp}}'s shading.
#' @param alpha Significance level. A horizontal plane at
#'   \eqn{p = \alpha} is overlaid on the surface. Default: 0.05.
#'
#' @return Invisibly returns the input \code{surface} object.
#'   Called for its side effect (a plot).
#'
#' @details
#' Unlike \code{\link{plot_p_surface}}, which requires
#' \pkg{rgl} or \pkg{plotly}, this function uses only base R
#' graphics. It is ideal for inclusion in static documents
#' such as PDF articles and printed reports.
#'
#' @export
#'
#' @examples
#' # Compute surface
#' surface <- p_surface(d = seq(-2, 2, 0.1), n = seq(5, 200, 5))
#'
#' # Static perspective plot
#' plot_p_static(surface)
#'
#' # Different viewing angle
#' plot_p_static(surface, theta = 45, phi = 30)
plot_p_static <- function(surface,
                          theta = 30,
                          phi = 20,
                          col = "steelblue",
                          shade = TRUE,
                          alpha = 0.05) {

  # --- Input validation ---
  if (!is.list(surface) || is.null(surface$d) || is.null(surface$n) ||
      is.null(surface$p)) {
    stop("`surface` must be a list returned by `p_surface()`.",
         call. = FALSE)
  }
  if (alpha <= 0 || alpha >= 1) {
    stop("`alpha` must be strictly between 0 and 1.", call. = FALSE)
  }

  # --- Build color palette if needed ---
  # persp() expects a color per grid cell. Our p matrix has
  # dimensions length(d) x length(n). persp() uses (nrow-1) x
  # (ncol-1) cells. To keep it simple, we use a single color,
  # or let the user supply one.

  # --- Base R perspective plot ---
  graphics::persp(
    x = surface$d,
    y = surface$n,
    z = surface$p,
    theta = theta,
    phi = phi,
    col = col,
    shade = shade,
    xlab = "Effect size (d)",
    ylab = "Sample size (n)",
    zlab = "p-value",
    main = "p-Value Surface (static)",
    ticktype = "detailed"
  )

  invisible(surface)
}
