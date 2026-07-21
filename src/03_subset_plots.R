#src/03_subset_manipulated_plots.R

source(here("src", "functions", "filter_subsets.R"))
source(here("src", "functions", "plot_helpers.R"))

# ---- load main data + all saved subsets ----
subset_data_dir <- here("data", "processed", "subsets")
subset_files  <- list.files(subset_data_dir, pattern = "\\.rds$", full.names = TRUE)

datasets <- map(subset_files, read_rds) |>
  set_names(tools::file_path_sans_ext(basename(subset_files)))
datasets <- c(list(main = long_preferences), datasets)

# --- set plot root ----

plot_root <- here("outputs", "plots")
subset_plots_dir <- here(plot_root, "subsets")

# ---- manipulated plots ----
source(here("src", "subset_plots", "03a_manipulated_plots.R"))
