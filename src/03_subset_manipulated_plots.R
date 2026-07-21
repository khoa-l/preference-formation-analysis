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

# ---- manipulated subset ----
manipulated_plots_dir <- here(subset_plots_dir, "manipulated")

.m1 <- plot_histogram(datasets$manipulated, "r1_rating", title = "R1 Value Alignment", x_label = "Value rating")
.m2 <- plot_histogram(datasets$manipulated, "r2_rating", title = "R2 Value Alignment", x_label = "Value rating")

y_max <- max(layer_data(.m1)$count, layer_data(.m2)$count)
y_max_rounded <- ceiling(y_max / 20) * 20 + 20

combined_plot <- (.m1 + coord_cartesian(ylim = c(0, y_max)) + scale_y_continuous(breaks = seq(0, y_max_rounded, by = 20))) +
  (.m2 + coord_cartesian(ylim = c(0, y_max)) + scale_y_continuous(breaks = seq(0, y_max_rounded, by = 20)))

ggsave(file.path(manipulated_plots_dir, "hist_r1r2_rating.png"),
       combined_plot,
       width = 10, height = 4)

ggsave(file.path(manipulated_plots_dir, "hist_r1_rating.png"),
       plot_histogram(datasets$manipulated, "r1_rating", title ="R1 Value Alignment"),
       width = 6, height = 4)

ggsave(file.path(manipulated_plots_dir, "hist_r1_confidence.png"),
       plot_histogram(datasets$manipulated, "r1_confidence", title ="R1 Confidence"),
       width = 6, height = 4)

ggsave(file.path(manipulated_plots_dir, "hist_r2_rating.png"),
       plot_histogram(datasets$manipulated, "r2_rating", title ="R2 Value Alignment"),
       width = 6, height = 4)

# ---- attitude change histograms ----

ggsave(file.path(manipulated_plots_dir, "hist_attitude_change.png"),
       plot_histogram(datasets$manipulated, "attitude_change", title ="Attitude Change"),
       width = 6, height = 4)

ggsave(file.path(manipulated_plots_dir, "hist_attitude_change_signed.png"),
       plot_histogram(datasets$manipulated, "attitude_change_signed", title ="Attitude Change Signed"),
       width = 6, height = 4)

# ---- magnitude x attitude_change scatter plots ----

ggsave(file.path(manipulated_plots_dir, "scatter_magnitude_x_attitude_change.png"),
       plot_scatter(datasets$manipulated, "manipulation_magnitude", "attitude_change",
                    title = "Manipulation Magnitude x Attitude Change"),
       width = 6, height = 4)

ggsave(file.path(manipulated_plots_dir, "scatter_magnitude_x_attitude_change_signed.png"),
       plot_scatter(datasets$manipulated, "manipulation_magnitude", "attitude_change_signed",
                    title = "Manipulation Magnitude x Attitude Change Signed"),
       width = 6, height = 4)

# ---- r1 confidence x rating/attitude_change scatter plots ----

ggsave(file.path(manipulated_plots_dir, "scatter_r1_confidence_x_rating.png"),
       plot_scatter(datasets$manipulated, "r1_confidence", "r1_rating",
                    title = "R1 Confidence x R1 Value Alignment"),
       width = 6, height = 4)

ggsave(file.path(manipulated_plots_dir, "scatter_r1_confidence_x_attitude_change.png"),
       plot_scatter(datasets$manipulated, "r1_confidence", "attitude_change",
                    title = "R1 Confidence x Attitude Change"),
       width = 6, height = 4)

ggsave(file.path(manipulated_plots_dir, "scatter_r1_confidence_x_attitude_change_signed.png"),
       plot_scatter(datasets$manipulated, "r1_confidence", "attitude_change_signed",
                    title = "R1 Confidence x Attitude Change Signed"),
       width = 6, height = 4)