# src/functions/model_helpers.R

# Post-centered deviation columns
add_deviation_columns <- function(data) {
  data |>
    group_by(item_num) |>
    mutate(
      value_deviation      = r1_rating - mean(r1_rating, na.rm = TRUE),
      confidence_deviation = r1_confidence - mean(r1_confidence, na.rm = TRUE)
    ) |>
    ungroup()
}

# Standardize continuous predictors (mean 0, SD 1)
scale_predictors <- function(data) {
  data |>
    mutate(across(
      c(r1_confidence, manipulation_magnitude, manipulation_magnitude_signed, value_deviation, confidence_deviation),
      ~ as.numeric(scale(.x))
    ))
}


# Linear mixed model: attitude_change ~ confidence * magnitude + deviations, random intercepts
fit_lmer <- function(data) {
  lmer(attitude_change_signed ~ r1_confidence * manipulation_magnitude_signed +
         # value_deviation + confidence_deviation +
         (1 | item_num) + (1 | participant_id),
       data = data)
}

# Logistic mixed model: did attitude change at all (attitude_change != 0)
fit_glmer <- function(data) {
  data <- data |> mutate(attitude_change_signed = attitude_change_signed != 0)
  glmer(attitude_change_signed ~ r1_confidence * manipulation_magnitude_signed +
          # value_deviation + confidence_deviation +
          (1 | item_num) + (1 | participant_id),
        data = data, family = binomial)
}

# Per-post linear model (no random effects — one post at a time)
fit_lm_by_post <- function(data) {
  data |>
    group_by(item_num) |>
    group_map(~ lm(attitude_change_signed ~ r1_confidence * manipulation_magnitude_signed
                     # + value_deviation + confidence_deviation
                   , data = .x)) |>
    set_names(unique(data$item_num))
}

# Tidy coefficient table (works for lmer, glmer, and lm)
get_coefficients <- function(model) {
  broom.mixed::tidy(model, effects = "fixed", conf.int = TRUE)
}

# Check specific residual cutoffs
# model_data |>
#   mutate(resid = residuals(lmer_model)) |>
#   filter(resid > 20) |>
#   arrange(desc(resid)) |>
#   select(participant_id, item_num, attitude_change, r1_confidence, manipulation_magnitude, resid)