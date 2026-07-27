#src/04_models.R

source(here("src", "functions", "model_helpers.R"))
source(here("src", "functions", "model_plot_helpers.R"))

model_data <- rbind(manip_change_up_shown, manip_change_down_shown) |> add_deviation_columns() |> scale_predictors()

# ---- Main mixed models ----

lmer_model  <- fit_lmer(model_data)
glmer_model <- fit_glmer(model_data)

summary(lmer_model)
summary(glmer_model)

lmer_coefs  <- get_coefficients(lmer_model)
glmer_coefs <- get_coefficients(glmer_model)

# ---- Per-post linear models ----

lm_by_post <- fit_lm_by_post(model_data)

lm_by_post_coefs <- imap_dfr(lm_by_post, function(model, item_num) {
  broom::tidy(model, conf.int = TRUE) |> mutate(item_num = item_num, .before = 1)
})

# ---- Save outputs ----

output_dir <- here("outputs", "models")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

write_csv(lmer_coefs, file.path(output_dir, "lmer_coefficients.csv"))
write_csv(glmer_coefs, file.path(output_dir, "glmer_coefficients.csv"))
write_csv(lm_by_post_coefs, file.path(output_dir, "lm_by_post_coefficients.csv"))

# ---- Forest plots ----

ggsave(file.path(output_dir, "forest_lmer.png"),
       plot_forest(lmer_coefs, title = "LMER fixed effects"), width = 6, height = 4)

ggsave(file.path(output_dir, "forest_glmer.png"),
       plot_forest(glmer_coefs, title = "GLMER fixed effects (log-odds)"), width = 6, height = 4)

# ---- Diagnostics ----

ggsave(file.path(output_dir, "qq_lmer.png"), plot_qq(lmer_model, "LMER: QQ plot"), width = 5, height = 5)
ggsave(file.path(output_dir, "resid_fitted_lmer.png"), plot_residuals_fitted(lmer_model, "LMER: residuals vs fitted"), width = 5, height = 4)
ggsave(file.path(output_dir, "qq_glmer.png"), plot_qq(glmer_model, "GLMER: QQ plot"), width = 5, height = 5)
ggsave(file.path(output_dir, "resid_fitted_glmer.png"), plot_residuals_fitted(glmer_model, "GLMER: residuals vs fitted"), width = 5, height = 4)

# ---- Per-post coefficients from the mixed model itself (fixed + random intercept) ----

lmer_coefs_by_post <- coef(lmer_model)$item_num |>
  rownames_to_column("item_num")

write_csv(lmer_coefs_by_post, file.path(output_dir, "lmer_coefficients_by_post.csv"))