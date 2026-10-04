# ============================================================
# p3d PAKETİ GELİŞTİRME - AŞAMA 9'DAN İTİBAREN
# Tarih: 2026-10-04
# Çalışma dizini: C:/Users/Ahmet/R-projects/p3d
# ============================================================

# ------------------------------------------------------------
# ÖN KONTROL: Çalışma dizinini doğrula
# ------------------------------------------------------------
getwd()
# Beklenen: "C:/Users/Ahmet/R-projects/p3d"

# Eğer yanlışsa:
# setwd("C:/Users/Ahmet/R-projects/p3d")


# ============================================================
# ADIM 9: .gitignore GÜÇLENDİR
# ============================================================

# 9a: Mevcut .gitignore'u kontrol et
readLines(".gitignore")

# 9b: Eksik girdileri ekle
usethis::use_git_ignore(".Rproj.user")
usethis::use_git_ignore(".Rhistory")
usethis::use_git_ignore(".RData")
usethis::use_git_ignore(".Ruserdata")
usethis::use_git_ignore("*.docx")
usethis::use_git_ignore("~$*")

# 9c: .gitignore'u doğrula
readLines(".gitignore")


# ============================================================
# ADIM 10: .Rbuildignore GÜÇLENDİR
# ============================================================

# 10a: Mevcut .Rbuildignore'u kontrol et
readLines(".Rbuildignore")

# 10b: paper/ klasörünü ekle
usethis::use_build_ignore("paper")

# 10c: .Rbuildignore'u doğrula
readLines(".Rbuildignore")


# ============================================================
# ADIM 11: GIT DURUMUNU KONTROL ET
# ============================================================

system("git status", intern = TRUE)


# ============================================================
# ADIM 12: GIT'TEN SİLİNEN DOSYALARI ÇIKAR
# ============================================================

# Silinen dosyaları Git'ten çıkar
system("git rm --cached R/p3d.R", intern = TRUE)
system("git rm --cached p3d.docx", intern = TRUE)
system("git rm --cached DESCRIPTION.dcf", intern = TRUE)


# ============================================================
# ADIM 13: TÜM DEĞİŞİKLİKLERİ STAGE'E EKLE
# ============================================================

system("git add -A", intern = TRUE)


# ============================================================
# ADIM 14: GIT DURUMUNU KONTROL ET (COMMIT ÖNCESİ)
# ============================================================

system("git status", intern = TRUE)


# ============================================================
# ADIM 15: COMMIT YAP
# ============================================================

system('git commit -m "Clean up: remove console history, organize paper folder, update ignore files"', intern = TRUE)


# ============================================================
# ADIM 16: SON DOĞRULAMA
# ============================================================

# Git log
system("git log --oneline", intern = TRUE)

# Git durumu
system("git status", intern = TRUE)

# Paket kök dizini
list.files(all.files = TRUE)

# R klasörü
list.files("R/", all.files = TRUE)

# paper klasörü
list.files("paper/", recursive = TRUE, all.files = TRUE)


# ============================================================
# AŞAMA 2.1: GITHUB BAĞLANTISI
# ============================================================

# Önce GitHub token oluştur
usethis::create_github_token()
# Tarayıcıda açılan sayfada:
# - Token ismi: p3d-rstudio
# - Expiration: 90 gün
# - Scopes: repo, workflow, gist
# - Generate token
# - Token'ı kopyala (ghp_xxxxxxxxxxxx)

# Token'ı RStudio'ya kaydet
gitcreds::gitcreds_set()
# Konsolda token'ı yapıştır (görünmez)

# GitHub reposu oluştur ve bağla
usethis::use_github()
# Bu komut:
# - GitHub'da ahmetkutuk1/p3d reposu oluşturur
# - Yerel Git'i bu repoya bağlar
# - İlk push'u yapar


# ============================================================
# AŞAMA 2.2: GITHUB ACTIONS CI KURULUMU
# ============================================================

usethis::use_github_action("check-standard")

# Commit ve push
system("git add .")
system('git commit -m "Add GitHub Actions CI"')
system("git push")


# ============================================================
# AŞAMA 2.3: p_surface() FONKSİYONU
# ============================================================

# R/p_surface.R dosyası oluştur
usethis::use_r("p_surface")

# p_surface.R içeriği:
# (Bu kod RStudio'da açılacak - içeriği yapıştır)

#' Compute p-value surface for single-sample t-test
#'
#' Computes the p-value of a single-sample t-test as a function
#' of effect size (Cohen's d) and sample size (n).
#'
#' @param d Numeric vector of effect sizes (Cohen's d)
#' @param n Numeric vector of sample sizes
#' @param alpha Significance level (default: 0.05)
#'
#' @return A list with elements:
#'   \item{d}{Effect sizes}
#'   \item{n}{Sample sizes}
#'   \item{p}{Matrix of p-values (length(d) x length(n))}
#'   \item{d_crit}{Critical effect size for each n at level alpha}
#'
#' @export
#'
#' @examples
#' result <- p_surface(d = seq(-1, 1, 0.1), n = c(10, 30, 100))
#' str(result)
p_surface <- function(d, n, alpha = 0.05) {

  # Girdi doğrulama
  if (!is.numeric(d) || !is.numeric(n)) {
    stop("d and n must be numeric vectors")
  }
  if (any(n < 2)) {
    stop("n must be >= 2 (need at least 2 observations for t-test)")
  }
  if (alpha <= 0 || alpha >= 1) {
    stop("alpha must be between 0 and 1")
  }

  # Izgara oluştur
  grid <- expand.grid(d = d, n = n)

  # t istatistiği: t = d * sqrt(n)
  grid$t_stat <- grid$d * sqrt(grid$n)

  # Serbestlik derecesi: df = n - 1
  grid$df <- grid$n - 1

  # İki yönlü p-değeri: p = 2 * (1 - F_t(|t|))
  grid$p <- 2 * (1 - pt(abs(grid$t_stat), df = grid$df))

  # Matris formatına dönüştür (görselleştirme için)
  p_matrix <- matrix(grid$p,
                     nrow = length(d),
                     ncol = length(n))

  # Anlamlılık sınırı: her n için kritik d
  d_crit <- qt(1 - alpha/2, df = n - 1) / sqrt(n)

  # Sonuç
  list(
    d = d,
    n = n,
    p = p_matrix,
    d_crit = d_crit,
    alpha = alpha,
    grid = grid
  )
}


# ============================================================
# AŞAMA 2.4: p_curve_2d() FONKSİYONU
# ============================================================

usethis::use_r("p_curve_2d")

#' Compute 2D p-value curve for comparison with existing packages
#'
#' @param d Numeric vector of effect sizes
#' @param n Single sample size
#' @param alpha Significance level
#'
#' @return Data frame with columns d, p, significant
#' @export
p_curve_2d <- function(d, n, alpha = 0.05) {

  if (length(n) != 1) {
    stop("n must be a single value for 2D curve")
  }

  t_stat <- d * sqrt(n)
  p_val <- 2 * (1 - pt(abs(t_stat), df = n - 1))

  data.frame(
    d = d,
    p = p_val,
    significant = p_val < alpha
  )
}


# ============================================================
# AŞAMA 2.5: plot_p_surface() FONKSİYONU
# ============================================================

usethis::use_r("plot_p_surface")

#' Interactive 3D visualization of p-value surface
#'
#' @param surface Result from p_surface()
#' @param engine Either "rgl" (default, interactive) or "plotly"
#' @param alpha Significance level plane to overlay
#' @param col Color palette
#'
#' @return Invisibly returns the surface object
#' @export
plot_p_surface <- function(surface,
                           engine = c("rgl", "plotly"),
                           alpha = 0.05,
                           col = NULL) {

  engine <- match.arg(engine)

  if (engine == "rgl") {
    if (!requireNamespace("rgl", quietly = TRUE)) {
      stop("Package 'rgl' required for engine = 'rgl'")
    }

    # 3D yüzey oluştur
    rgl::open3d()
    rgl::persp3d(
      x = surface$d,
      y = surface$n,
      z = surface$p,
      col = "steelblue",
      alpha = 0.8,
      xlab = "Effect size (d)",
      ylab = "Sample size (n)",
      zlab = "p-value",
      main = "p-Value Surface"
    )

  } else if (engine == "plotly") {
    if (!requireNamespace("plotly", quietly = TRUE)) {
      stop("Package 'plotly' required for engine = 'plotly'")
    }

    plotly::plot_ly(
      x = surface$d,
      y = surface$n,
      z = surface$p,
      type = "surface"
    ) |>
      plotly::layout(
        scene = list(
          xaxis = list(title = "Effect size (d)"),
          yaxis = list(title = "Sample size (n)"),
          zaxis = list(title = "p-value")
        )
      )
  }

  invisible(surface)
}


# ============================================================
# AŞAMA 2.6: plot_p_static() FONKSİYONU
# ============================================================

usethis::use_r("plot_p_static")

#' Static 2D perspective plot of p-value surface
#'
#' @param surface Result from p_surface()
#' @param theta,phi Viewing angles
#' @param col Color palette
#'
#' @return Invisibly returns the surface object
#' @export
plot_p_static <- function(surface,
                          theta = 30,
                          phi = 20,
                          col = "steelblue") {

  graphics::persp(
    x = surface$d,
    y = surface$n,
    z = surface$p,
    theta = theta,
    phi = phi,
    col = col,
    xlab = "Effect size (d)",
    ylab = "Sample size (n)",
    zlab = "p-value",
    main = "p-Value Surface (static)"
  )

  invisible(surface)
}


# ============================================================
# AŞAMA 2.7: ANLAMLILIK SINIRI GÖRSELİ
# ============================================================

# Bu, plot_p_surface() içine entegre edilecek

plot_significance_boundary <- function(surface, alpha = 0.05) {
  plot(
    surface$n,
    surface$d_crit,
    type = "l",
    lwd = 2,
    col = "darkred",
    xlab = "Sample size (n)",
    ylab = "Critical effect size (d_crit)",
    main = paste0("Significance boundary at alpha = ", alpha)
  )
  grid()
}


# ============================================================
# AŞAMA 2.9: UNIT TESTLER
# ============================================================

usethis::use_testthat()
usethis::use_test("p_surface")

# tests/testthat/test-p_surface.R içeriği:

test_that("p_surface returns correct structure", {
  result <- p_surface(d = c(0.2, 0.5), n = c(10, 30))

  expect_type(result, "list")
  expect_named(result, c("d", "n", "p", "d_crit", "alpha", "grid"))
  expect_equal(dim(result$p), c(2, 2))
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

test_that("p_surface handles edge cases", {
  expect_error(p_surface(d = 0.5, n = 1), "n must be >= 2")
  expect_error(p_surface(d = 0.5, n = 30, alpha = 1.5),
               "alpha must be between 0 and 1")
  expect_error(p_surface(d = "a", n = 30), "must be numeric")
})


# ============================================================
# AŞAMA 2.11: PERFORMANS TESTİ
# ============================================================

# Küçük ızgara
system.time({
  result_small <- p_surface(d = seq(-2, 2, 0.1), n = seq(5, 200, 5))
})
# Beklenen: < 0.1 saniye

# Büyük ızgara
system.time({
  result_large <- p_surface(d = seq(-2, 2, 0.01), n = seq(5, 1000, 10))
})
# Beklenen: < 1 saniye


# ============================================================
# DOKÜMANTASYON: VIGNETTE OLUŞTUR
# ============================================================

usethis::use_vignette("p3d-intro")
usethis::use_vignette("p3d-comparison")


# ============================================================
# README VE PKGDOWN
# ============================================================

usethis::use_readme_md()
usethis::use_pkgdown()
pkgdown::build_site()


# ============================================================
# CRAN GÖNDERİMİ ÖNCESİ SON KONTROLLER
# ============================================================

devtools::check()
devtools::document()
devtools::build()
