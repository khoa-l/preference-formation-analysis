# src/functions/model_helpers.R

# Post-centered deviation columns
add_deviation_columns <- function(data) {
  data |>
    group_by(post_num) |>
    mutate(
      value_deviation      = rating_original - mean(rating_original, na.rm = TRUE),
      confidence_deviation = r1_confidence - mean(r1_confidence, na.rm = TRUE)
    ) |>
    ungroup()
}

# Linear mixed model: attitude_change ~ confidence * magnitude + deviations, random intercepts
fit_lmer <- function(data) {
  lmer(attitude_change ~ r1_confidence * manipulation_magnitude +
         value_deviation + confidence_deviation +
         (1 | post_num) + (1 | response_id),
       data = data)
}

# Logistic mixed model: did attitude change at all (attitude_change != 0)
fit_glmer <- function(data) {
  data <- data |> mutate(attitude_changed = attitude_change != 0)
  glmer(attitude_changed ~ r1_confidence * manipulation_magnitude +
          value_deviation + confidence_deviation +
          (1 | post_num) + (1 | response_id),
        data = data, family = binomial)
}

# Per-post linear model (no random effects — one post at a time)
fit_lm_by_post <- function(data) {
  data |>
    group_by(post_num) |>
    group_map(~ lm(attitude_change ~ r1_confidence * manipulation_magnitude +
                     value_deviation + confidence_deviation, data = .x)) |>
    set_names(unique(data$post_num))
}

# Tidy coefficient table (works for lmer, glmer, and lm)
get_coefficients <- function(model) {
  broom.mixed::tidy(model, effects = "fixed", conf.int = TRUE)
}