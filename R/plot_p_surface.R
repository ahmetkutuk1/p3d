#' Interactive 3D visualization of p-value surface
#'
#' Plots the output of \code{\link{p_surface}} as an interactive
#' three-dimensional surface. Two rendering engines are supported:
#' \code{"rgl"} (default, interactive window) and \code{"plotly"}
#' (HTML widget, ideal for R Markdown / Quarto documents).
#'
#' @param surface A list returned by \code{\link{p_surface}}.
#' @param engine Character; either \code{"rgl"} (default) or
#'   \code{"plotly"}. Determines the rendering backend.
#' @param alpha Significance level. A horizontal plane at
#'   \eqn{p = \alpha} is overlaid on the surface. Default: 0.05.
#' @param col Color palette for the surface. If \code{NULL}
#'   (default), a built-in palette is used.
#' @param show_boundary Logical; if \code{TRUE} (default), the
#'   intersection curve between the surface and the
#'   \eqn{\alpha}-plane is drawn.
#'
#' @return Invisibly returns the input \code{surface} object.
#'   Called for its side effect (a plot).
#'
#' @details
#' The 3D surface shows the p-value as a function of both
#' effect size (\eqn{d}) and sample size (\eqn{n}). The
#' \eqn{\alpha}-plane visualizes the conventional significance
#' threshold. The intersection curve marks the boundary between
#' "significant" and "non-significant" regions.
#'
#' For \code{engine = "rgl"}, the \pkg{rgl} package must be
#' installed. For \code{engine = "plotly"}, the \pkg{plotly}
#' package must be installed. Both are listed in \code{Suggests}.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Compute surface
#' surface <- p_surface(d = seq(-2, 2, 0.1), n = seq(5, 200, 5))
#'
#' # Interactive rgl window
#' plot_p_surface(surface)
#'
#' # Plotly HTML widget
#' plot_p_surface(surface, engine = "plotly")
#' }
plot_p_surface <- function(surface,
                           engine = c("rgl", "plotly"),
                           alpha = 0.05,
                           col = NULL,
                           show_boundary = TRUE) {

  # --- Input validation ---
  if (!is.list(surface) || is.null(surface$d) || is.null(surface$n) ||
      is.null(surface$p)) {
    stop("`surface` must be a list returned by `p_surface()`.",
         call. = FALSE)
  }
  engine <- match.arg(engine)
  if (alpha <= 0 || alpha >= 1) {
    stop("`alpha` must be strictly between 0 and 1.", call. = FALSE)
  }

  # --- Default color palette ---
  if (is.null(col)) {
    col <- grDevices::hcl.colors(100, "Viridis")
  }

  # --- Dispatch to engine ---
  if (engine == "rgl") {
    if (!requireNamespace("rgl", quietly = TRUE)) {
      stop("Package 'rgl' is required for engine = 'rgl'. ",
           "Install it with install.packages('rgl').",
           call. = FALSE)
    }
    .plot_p_surface_rgl(surface, alpha, col, show_boundary)

  } else if (engine == "plotly") {
    if (!requireNamespace("plotly", quietly = TRUE)) {
      stop("Package 'plotly' is required for engine = 'plotly'. ",
           "Install it with install.packages('plotly').",
           call. = FALSE)
    }
    .plot_p_surface_plotly(surface, alpha, col, show_boundary)
  }

  invisible(surface)
}


# --- Internal: rgl engine ---
.plot_p_surface_rgl <- function(surface, alpha, col, show_boundary) {

  # Open a new rgl device
  rgl::open3d()

  # Plot the surface
  rgl::persp3d(
    x = surface$d,
    y = surface$n,
    z = surface$p,
    col = col,
    alpha = 0.8,
    xlab = "Effect size (d)",
    ylab = "Sample size (n)",
    zlab = "p-value",
    main = "p-Value Surface"
  )

  # Overlay the alpha plane
  d_range <- range(surface$d)
  n_range <- range(surface$n)
  rgl::quads3d(
    x = c(d_range[1], d_range[2], d_range[2], d_range[1]),
    y = c(n_range[1], n_range[1], n_range[2], n_range[2]),
    z = rep(alpha, 4),
    col = "red",
    alpha = 0.3
  )

  # Boundary curve (approximation: d_crit vs n)
  if (show_boundary) {
    rgl::lines3d(
      x = c(surface$d_crit, rev(-surface$d_crit)),
      y = c(surface$n, rev(surface$n)),
      z = rep(alpha, 2 * length(surface$n)),
      col = "darkred",
      lwd = 3
    )
  }
}


# --- Internal: plotly engine ---
.plot_p_surface_plotly <- function(surface, alpha, col, show_boundary) {

  # Build plotly surface
  p <- plotly::plot_ly(
    x = surface$d,
    y = surface$n,
    z = surface$p,
    type = "surface",
    colorscale = "Viridis",
    showscale = TRUE
  )

  # Overlay alpha plane as a second surface
  d_range <- range(surface$d)
  n_range <- range(surface$n)
  alpha_plane <- matrix(alpha, nrow = 2, ncol = 2)

  p <- p |> plotly::add_surface(
    x = d_range,
    y = n_range,
    z = alpha_plane,
    type = "surface",
    opacity = 0.3,
    colorscale = list(c(0, "red"), c(1, "red")),
    showscale = FALSE,
    name = paste0("alpha = ", alpha)
  )

  # Layout
  p <- p |> plotly::layout(
    title = "p-Value Surface",
    scene = list(
      xaxis = list(title = "Effect size (d)"),
      yaxis = list(title = "Sample size (n)"),
      zaxis = list(title = "p-value")
    )
  )

  print(p)
}
