# src/functions/model_plot_helpers.R

# Forest plot of fixed-effect coefficients
# Expects columns: term, estimate, conf.low, conf.high
plot_forest <- function(coefs, title = NULL) {
  coefs |>
    filter(term != "(Intercept)") |>
    mutate(term = fct_reorder(term, estimate)) |>
    ggplot(aes(x = estimate, y = term)) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "grey50") +
    geom_pointrange(aes(xmin = conf.low, xmax = conf.high)) +
    labs(title = title, x = "Estimate", y = NULL) +
    theme_minimal()
}

# Pearson residuals for glmer, raw residuals for lmer
get_residuals <- function(model) {
  if (inherits(model, "glmerMod")) residuals(model, type = "pearson")
  else residuals(model)
}

# QQ plot of model residuals
plot_qq <- function(model, title = NULL) {
  df <- data.frame(resid = get_residuals(model))
  ggplot(df, aes(sample = resid)) +
    stat_qq() +
    stat_qq_line(color = "red") +
    labs(title = title, x = "Theoretical quantiles", y = "Sample quantiles") +
    theme_minimal()
}

# Residuals vs fitted values plot
plot_residuals_fitted <- function(model, title = NULL) {
  df <- data.frame(fitted = fitted(model), resid = get_residuals(model))
  ggplot(df, aes(x = fitted, y = resid)) +
    geom_point(alpha = 0.5) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    geom_smooth(method = "loess", se = FALSE, color = "blue", linewidth = 0.5) +
    labs(title = title, x = "Fitted values", y = "Pearson residuals") +
    theme_minimal()
}