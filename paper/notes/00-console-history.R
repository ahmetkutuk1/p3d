getwd()
usethis::use_gpl3_license()
# DESCRIPTION dosyasını oku
readLines("DESCRIPTION")
file.edit("DESCRIPTION")
Package: p3d
Title: Interactive 3D Visualization of p-Value Surfaces
Version: 0.0.0.9000
Authors@R:
  person("Ahmet", "Soyadın", email = "ahmet@example.com", role = c("aut", "cre"))
Description: Provides interactive three-dimensional visualization of
p-value surfaces for single-sample t-tests. Enables simultaneous
exploration of effect size, sample size, and significance level,
making the continuous nature of p-values and the moderating effect
of sample size visually apparent. Includes both interactive (rgl,
                                                             plotly) and static (persp) rendering options.
License: GPL (>= 3)
Encoding: UTF-8
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.0.0
readLines("DESCRIPTION")
person("Ahmet", "Kutuk", email = "ahmetkutuk@gmail.com", role = c("aut", "cre"))
Sys.which("git")
usethis::use_git()
## Kendi bilgilerini gir
3
usethis::use_git_config(
  user.name = "Ahmet Kutuk",
  user.email = "ahmetkutuk@gmail.com"
)
system("git config user.name")
system("git config user.email")
usethis::use_git()
0
cat("\014")
usethis::use_git_config(
  user.name = "Ahmet Kutuk",
  user.email = "ahmetkutuk@gmail.com"
)
system("git config user.name", intern = TRUE)
system("git config user.email", intern = TRUE)
system('git config --global user.name "Ahmet Kutuk"')
system('git config --global user.email "ahmetkutuk@gmail.com"')
system("git config --global user.name", intern = TRUE)
system("git config --global user.email", intern = TRUE)
usethis::use_git()
system("git log --oneline", intern = TRUE)
system("git status", intern = TRUE)

# Formül Türetimi
# Tek örneklem t-testi için p-değeri formülü
# p(d, n) = 2 * (1 - pt(d * sqrt(n), df = n - 1))
# Test: d = 0.5, n = 30
d <- 0.5
n <- 30

# Formül ile p-değeri
p_formula <- 2 * (1 - pt(d * sqrt(n), df = n - 1))
print(p_formula)

# Simülasyon ile karşılaştırma: aynı etki büyüklüğü ve örneklemle t-testi
set.seed(42)
x <- rnorm(n, mean = d, sd = 1)  # d = 0.5, sd = 1
t_test_result <- t.test(x, mu = 0)
print(t_test_result$p.value)

# Örneklemdeki gerçek etki büyüklüğünü hesapla
d_observed <- mean(x) / sd(x)
print(d_observed)

# Bu d ile formülü tekrar hesapla
p_formula_observed <- 2 * (1 - pt(d_observed * sqrt(n), df = n - 1))
print(p_formula_observed)

# t.test sonucu
print(t_test_result$p.value)

# Monte Carlo doğrulaması
set.seed(42)
n_sim <- 10000   # simülasyon sayısı
n <- 30          # örneklem büyüklüğü
d <- 0.5         # gerçek etki büyüklüğü

# Her simülasyonda t-testi p-değerini hesapla
p_values <- replicate(n_sim, {
  x <- rnorm(n, mean = d, sd = 1)
  t.test(x, mu = 0)$p.value
})

# Monte Carlo ortalaması
p_mc <- mean(p_values)
cat("Monte Carlo ortalama p-değeri:", p_mc, "\n")

# Formülden hesaplanan p-değeri
p_formula <- 2 * (1 - pt(d * sqrt(n), df = n - 1))
cat("Formülden p-değeri:", p_formula, "\n")

# Fark
cat("Fark:", abs(p_mc - p_formula), "\n")
cat("Bağıl fark (%):", 100 * abs(p_mc - p_formula) / p_formula, "\n")

# Histogram (isteğe bağlı görselleştirme)
hist(p_values, breaks = 50, main = "10.000 Simülasyon p-Değeri Dağılımı",
     xlab = "p-değeri", col = "steelblue")
abline(v = p_formula, col = "red", lwd = 2)
legend("topright", legend = c("Formül değeri"), col = "red", lwd = 2)

# Doğru Monte Carlo testi
set.seed(42)
n_sim <- 10000
n <- 30
d <- 0.5

# Her simülasyonda formül ve t.test karşılaştırması
farklar <- replicate(n_sim, {
  x <- rnorm(n, mean = d, sd = 1)
  d_obs <- mean(x) / sd(x)

  p_formula <- 2 * (1 - pt(d_obs * sqrt(n), df = n - 1))
  p_ttest <- t.test(x, mu = 0)$p.value

  abs(p_formula - p_ttest)
})

cat("Ortalama fark:", mean(farklar), "\n")
cat("Maksimum fark:", max(farklar), "\n")

# Tek bir simülasyonla incele
set.seed(1)
n <- 30
d <- 0.5
x <- rnorm(n, mean = d, sd = 1)

# İki farklı d hesabı
d_1 <- mean(x) / sd(x)
d_2 <- mean(x) / sqrt(sum((x - mean(x))^2) / (n - 1))

print(c(d_1 = d_1, d_2 = d_2))

# t testi
t_result <- t.test(x, mu = 0)
print(c(t_statistic = t_result$statistic, d_sqrt_n = d_1 * sqrt(n)))

# p değerleri
cat("p formula (d_1):", 2 * (1 - pt(d_1 * sqrt(n), df = n - 1)), "\n")
cat("p formula (d_2):", 2 * (1 - pt(d_2 * sqrt(n), df = n - 1)), "\n")
cat("p t.test:       ", t_result$p.value, "\n")


# Anlamlılık sınırı eğrisi
alpha <- 0.05
n_values <- seq(5, 200, by = 5)

# Her n için kritik d değeri
d_crit <- qt(1 - alpha/2, df = n_values - 1) / sqrt(n_values)

# Sonuçları göster
result <- data.frame(n = n_values, d_crit = round(d_crit, 4))
print(head(result, 10))
print(tail(result, 5))

# Görselleştirme
plot(n_values, d_crit, type = "l", lwd = 2, col = "darkred",
     xlab = "Örneklem Büyüklüğü (n)",
     ylab = "Kritik Etki Büyüklüğü (d_crit)",
     main = "α = 0.05 için Anlamlılık Sınırı")
grid()

# Belirli n değerleri için yorum
cat("\n--- Yorum ---\n")
cat("n = 10 için kritik d:", round(qt(0.975, 9) / sqrt(10), 4), "\n")
cat("n = 30 için kritik d:", round(qt(0.975, 29) / sqrt(30), 4), "\n")
cat("n = 100 için kritik d:", round(qt(0.975, 99) / sqrt(100), 4), "\n")
cat("n = 1000 için kritik d:", round(qt(0.975, 999) / sqrt(1000), 4), "\n")

install.packages(c("pvaluefunctions", "concurve"))
install.packages("concurve")
library(pvaluefunctions)
library(concurve)
packageVersion("pvaluefunctions")
packageVersion("concurve")

# Önce remotes paketini kur (eğer yoksa)
install.packages("remotes")

# Sonra concurve'yi GitHub'dan kur
remotes::install_github("zadrafi/concurve@master", dependencies = TRUE)
