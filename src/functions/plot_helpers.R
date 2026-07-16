# src/functions/plot_helpers.R

plot_histogram <- function(data, column, binwidth = 1, title = NULL) {
  ggplot(data, aes(x = .data[[column]])) +
    geom_histogram(binwidth = binwidth, fill = "steelblue", color = "white") +
    labs(title = title %||% column, x = column, y = "Count") +
    theme_minimal()
}

plot_bar <- function(data, column, title = NULL) {
  ggplot(data, aes(x = .data[[column]])) +
    geom_bar(fill = "steelblue") +
    labs(title = title %||% column, x = column, y = "Count") +
    theme_minimal()
}

plot_boxplot <- function(data, column, group_var, title = NULL) {
  ggplot(data, aes(x = .data[[group_var]], y = .data[[column]])) +
    geom_boxplot(fill = "steelblue") +
    labs(title = title %||% paste(column, "by", group_var), x = group_var, y = column) +
    theme_minimal()
}

plot_violin <- function(data, column, group_var, title = NULL) {
  ggplot(data, aes(x = .data[[group_var]], y = .data[[column]])) +
    geom_violin(fill = "steelblue") +
    labs(title = title %||% paste(column, "by", group_var), x = group_var, y = column) +
    theme_minimal()
}

plot_scatter <- function(data, x_col, y_col, title = NULL) {
  ggplot(data, aes(x = .data[[x_col]], y = .data[[y_col]])) +
    geom_point(alpha = 0.4) +
    labs(title = title %||% paste(y_col, "vs", x_col), x = x_col, y = y_col) +
    theme_minimal()
}

plot_strandberg <- function(data, group_var = "manipulated", title = NULL) {
  plot_data <- data |>
    pivot_longer(cols = c(rating_original, rating_shown, r2_rating),
                 names_to = "timepoint", values_to = "rating") |>
    mutate(timepoint = factor(timepoint,
                              levels = c("rating_original", "rating_shown", "r2_rating"),
                              labels = c("Original (R1)", "Shown (R2, manipulated)", "Final (R2)")
    )) |>
    group_by(.data[[group_var]], timepoint) |>
    summarise(mean_rating = mean(rating, na.rm = TRUE),
              se = sd(rating, na.rm = TRUE) / sqrt(n()), .groups = "drop")
  
  ggplot(plot_data, aes(x = timepoint, y = mean_rating,
                        color = as.factor(.data[[group_var]]),
                        group = as.factor(.data[[group_var]]))) +
    geom_line() +
    geom_point() +
    geom_errorbar(aes(ymin = mean_rating - se, ymax = mean_rating + se), width = 0.1) +
    labs(title = title %||% "Mean rating across timepoints", x = NULL, y = "Mean rating", color = group_var) +
    theme_minimal()
}

plot_strandberg_change <- function(data, group_var, title = NULL) {
  plot_data <- data |>
    group_by(.data[[group_var]]) |>
    summarise(mean_change = mean(attitude_change, na.rm = TRUE),
              se = sd(attitude_change, na.rm = TRUE) / sqrt(n()), .groups = "drop")
  
  ggplot(plot_data, aes(x = as.factor(.data[[group_var]]), y = mean_change)) +
    geom_col(fill = "steelblue") +
    geom_errorbar(aes(ymin = mean_change - se, ymax = mean_change + se), width = 0.1) +
    labs(title = title %||% paste("Attitude change by", group_var), x = group_var, y = "Mean attitude change") +
    theme_minimal()
}

classify_correction <- function(data, tolerance = 5) {
  data |>
    mutate(response_type = case_when(
      r2_rating == rating_shown              ~ "accepted",
      abs(r2_rating - r1_rating) <= tolerance ~ "corrected",
      TRUE                                     ~ "other"
    ))
}

plot_qq <- function(model, title = NULL) {
  residuals_df <- tibble(resid = residuals(model))
  ggplot(residuals_df, aes(sample = resid)) +
    stat_qq() +
    stat_qq_line() +
    labs(title = title %||% "QQ plot of residuals", x = "Theoretical", y = "Sample") +
    theme_minimal()
}

plot_residuals_fitted <- function(model, title = NULL) {
  residuals_df <- tibble(fitted = fitted(model), resid = residuals(model))
  ggplot(residuals_df, aes(x = fitted, y = resid)) +
    geom_point(alpha = 0.4) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    labs(title = title %||% "Residuals vs fitted", x = "Fitted", y = "Residuals") +
    theme_minimal()
}