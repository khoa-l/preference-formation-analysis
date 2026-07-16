#src/02_standard_plots.R

source(here("src", "functions", "filter_subsets.R"))
source(here("src", "functions", "plot_helpers.R"))

# ---- Load main data + all saved subsets ----
processed_dir <- here("data", "processed")
subset_files  <- list.files(processed_dir, pattern = "\\.rds$", full.names = TRUE)

datasets <- map(subset_files, read_rds) |>
  set_names(tools::file_path_sans_ext(basename(subset_files)))
datasets <- c(list(main = long_preferences), datasets)

# ---- Per-subset plots: r1/r2 rating histograms, confidence histogram, scatter ----

plot_root <- here("outputs", "plots")

iwalk(datasets, function(data, name) {
  subset_dir <- file.path(plot_root, name)
  dir.create(subset_dir, showWarnings = FALSE, recursive = TRUE)
  
  ggsave(file.path(subset_dir, "r1_rating_hist.png"),
         plot_histogram(data, "r1_rating", title = paste(name, "- R1 rating")),
         width = 6, height = 4)
  
  ggsave(file.path(subset_dir, "r2_rating_hist.png"),
         plot_histogram(data, "r2_rating", title = paste(name, "- R2 rating")),
         width = 6, height = 4)
  
  ggsave(file.path(subset_dir, "r1_confidence_hist.png"),
         plot_histogram(data, "r1_confidence", title = paste(name, "- R1 confidence")),
         width = 6, height = 4)
  
  ggsave(file.path(subset_dir, "magnitude_vs_change_scatter.png"),
         plot_scatter(data, "manipulation_magnitude", "attitude_change",
                      title = paste(name, "- manipulation magnitude vs attitude change")),
         width = 6, height = 4)
})

# ---- Bar chart: manipulated/not-manipulated x accepted/up/down ----

response_categories <- long_preferences |>
  mutate(
    change_direction = case_when(
      r2_rating == rating_shown ~ "accepted",
      r2_rating > rating_shown  ~ "up",
      r2_rating < rating_shown  ~ "down",
      TRUE                       ~ NA_character_
    ),
    category = paste0(if_else(manipulated, "manipulated", "not_manipulated"),
                      "_", change_direction)
  )

ggsave(file.path(plot_root, "response_category_counts.png"),
       plot_bar(response_categories, "category", title = "Response categories"),
       width = 7, height = 4)

# ---- Strandberg plots ----

# Manipulated vs not manipulated: mean rating across timepoints
ggsave(file.path(plot_root, "strandberg_manipulated.png"),
       plot_strandberg(long_preferences, group_var = "manipulated",
                       title = "Rating across timepoints: manipulated vs not"),
       width = 6, height = 4)

# Attitude change: manipulated vs not manipulated
ggsave(file.path(plot_root, "strandberg_change_manipulated.png"),
       plot_strandberg_change(long_preferences, group_var = "manipulated",
                              title = "Attitude change: manipulated vs not"),
       width = 6, height = 4)

# Within manipulated subset: accepted vs corrected
manipulated_classified <- long_preferences |>
  filter_manipulated(TRUE) |>
  classify_correction() |>
  filter(response_type != "other")

ggsave(file.path(plot_root, "strandberg_change_accepted_vs_corrected.png"),
       plot_strandberg_change(manipulated_classified, group_var = "response_type",
                              title = "Attitude change: accepted vs corrected (manipulated only)"),
       width = 6, height = 4)