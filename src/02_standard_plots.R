#src/02_standard_plots.R

source(here("src", "functions", "filter_subsets.R"))
source(here("src", "functions", "plot_helpers.R"))

# --- set plot root ----

plot_root <- here("outputs", "plots")

# ---- bar chart: manipulated/not_manipulated x accepted/up/down ----

response_categories <- long_preferences |>
  filter(!is.na(manipulated)) |>
  mutate(
    change_direction = case_when(
      r2_rating == rating_shown ~ "accepted",
      r2_rating > rating_shown  ~ "up",
      r2_rating < rating_shown  ~ "down",
    ),
    manipulated_label = if_else(manipulated, "manipulated", "not_manipulated")
  )

ggsave(file.path(plot_root, "bar_response_category_counts.png"), 
       plot_bar_stack(response_categories, FALSE, "manipulated_label", "change_direction", "Response Categories", "Change", "Count"), 
       width = 7, height = 4)

ggsave(file.path(plot_root, "bar_response_category_counts_percent.png"), 
       plot_bar_stack(response_categories, TRUE, "manipulated_label", "change_direction", "Response Categories", "Change", "Count"), 
       width = 7, height = 4)

# ---- r1/r2 ratings + confidence histograms
.p1 <- plot_histogram(r2_posts, "r1_rating", title = "R1 Value Alignment", x_label = "Value rating")
.p2 <- plot_histogram(r2_posts, "r2_rating", title = "R2 Value Alignment", x_label = "Value rating")

y_max <- max(layer_data(.p1)$count, layer_data(.p2)$count)
y_max_rounded <- ceiling(y_max / 20) * 20 + 20

combined_plot <- (.p1 + coord_cartesian(ylim = c(0, y_max)) + scale_y_continuous(breaks = seq(0, y_max_rounded, by = 20))) +
  (.p2 + coord_cartesian(ylim = c(0, y_max)) + scale_y_continuous(breaks = seq(0, y_max_rounded, by = 20)))

ggsave(file.path(plot_root, "hist_r1r2_rating.png"),
       combined_plot,
       width = 10, height = 4)

ggsave(file.path(plot_root, "hist_r1_rating.png"),
       plot_histogram(r2_posts, "r1_rating", title ="R1 Value Alignment"),
       width = 6, height = 4)

ggsave(file.path(plot_root, "hist_r1_confidence.png"),
       plot_histogram(r2_posts, "r1_confidence", title ="R1 Confidence"),
       width = 6, height = 4)

ggsave(file.path(plot_root, "hist_r2_rating.png"),
       plot_histogram(r2_posts, "r2_rating", title ="R2 Value Alignment"),
       width = 6, height = 4)

# ---- attitude change histograms ----

ggsave(file.path(plot_root, "hist_attitude_change.png"),
       plot_histogram(r2_posts, "attitude_change", title ="Attitude Change"),
       width = 6, height = 4)

ggsave(file.path(plot_root, "hist_attitude_change_signed.png"),
       plot_histogram(r2_posts, "attitude_change_signed", title ="Attitude Change Signed"),
       width = 6, height = 4)

# ---- magnitude x attitude_change scatter plots ----

ggsave(file.path(plot_root, "scatter_magnitude_x_attitude_change.png"),
       plot_scatter(r2_posts, "manipulation_magnitude", "attitude_change",
                    title = "Manipulation Magnitude x Attitude Change"),
       width = 6, height = 4)

ggsave(file.path(plot_root, "scatter_magnitude_x_attitude_change_signed.png"),
       plot_scatter(r2_posts, "manipulation_magnitude", "attitude_change_signed",
                    title = "Manipulation Magnitude x Attitude Change Signed"),
       width = 6, height = 4)

# ---- r1 confidence x rating/attitude_change scatter plots ----

ggsave(file.path(plot_root, "scatter_r1_confidence_x_rating.png"),
       plot_scatter(r2_posts, "r1_confidence", "r1_rating",
                    title = "R1 Confidence x R1 Value Alignment"),
       width = 6, height = 4)

ggsave(file.path(plot_root, "scatter_r1_confidence_x_attitude_change.png"),
       plot_scatter(r2_posts, "r1_confidence", "attitude_change",
                    title = "R1 Confidence x Attitude Change"),
       width = 6, height = 4)

ggsave(file.path(plot_root, "scatter_r1_confidence_x_attitude_change_signed.png"),
       plot_scatter(r2_posts, "r1_confidence", "attitude_change_signed",
                    title = "R1 Confidence x Attitude Change Signed"),
       width = 6, height = 4)