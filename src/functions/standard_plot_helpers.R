# src/functions/plot_helpers.R

plot_histogram <- function(data, column, binwidth = 10, title = NULL, x_label = column) {
  ggplot(data, aes(x = .data[[column]])) +
    geom_histogram(binwidth = binwidth, color = "white") +
    labs(title = title %||% column, x = x_label, y = "Count") +
    theme_minimal()
}

plot_bar <- function(data, column, title = NULL) {
  ggplot(data, aes(x = .data[[column]])) +
    geom_bar(fill = "steelblue") +
    labs(title = title %||% column, x = column, y = "Count") +
    theme_minimal()
}

plot_bar_stack <- function(data, percent = FALSE, x_col, y_col, title = NULL, fill_label = NULL, y_label = NULL) {
  ggplot(data, aes(x = .data[[x_col]], fill = .data[[y_col]])) +
    geom_bar(position = if_else(percent, "fill", "stack")) +
    labs(title = title, x = NULL, y = y_label, fill = fill_label) +
    theme_minimal()
}

plot_scatter <- function(data, x_col, y_col, title = NULL) {
  ggplot(data, aes(x = .data[[x_col]], y = .data[[y_col]])) +
    geom_point(alpha = 0.4) +
    labs(title = title %||% paste(y_col, "vs", x_col), x = x_col, y = y_col) +
    theme_minimal()
}

# Run standard set of plots
plot_standard <- function(data, out_dir) {
  
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  
  .p1 <- plot_histogram(data, "r1_rating", title = "R1 Value Alignment", x_label = "Value rating")
  .p2 <- plot_histogram(data, "r2_rating", title = "R2 Value Alignment", x_label = "Value rating")
  y_max <- max(layer_data(.p1)$count, layer_data(.p2)$count)
  y_max_rounded <- ceiling(y_max / 20) * 20 + 20
  combined_plot <- (.p1 + coord_cartesian(ylim = c(0, y_max)) + scale_y_continuous(breaks = seq(0, y_max_rounded, by = 20))) +
    (.p2 + coord_cartesian(ylim = c(0, y_max)) + scale_y_continuous(breaks = seq(0, y_max_rounded, by = 20)))
  ggsave(file.path(out_dir, "hist_r1r2_rating.png"), combined_plot, width = 10, height = 4)
  
  ggsave(file.path(out_dir, "hist_r1_rating.png"),
         plot_histogram(data, "r1_rating", title = "R1 Value Alignment"),
         width = 6, height = 4)
  
  ggsave(file.path(out_dir, "hist_r1_confidence.png"),
         plot_histogram(data, "r1_confidence", title = "R1 Confidence"),
         width = 6, height = 4)
  
  ggsave(file.path(out_dir, "hist_r2_rating.png"),
         plot_histogram(data, "r2_rating", title = "R2 Value Alignment"),
         width = 6, height = 4)
  
  # ---- attitude change histograms ----
  
  ggsave(file.path(out_dir, "hist_attitude_change.png"),
         plot_histogram(data, "attitude_change", title = "Attitude Change"),
         width = 6, height = 4)
  
  ggsave(file.path(out_dir, "hist_attitude_change_signed.png"),
         plot_histogram(data, "attitude_change_signed", title = "Attitude Change Signed"),
         width = 6, height = 4)
  
  # ---- magnitude x attitude_change scatter plots ----
  
  ggsave(file.path(out_dir, "scatter_magnitude_x_attitude_change.png"),
         plot_scatter(data, "manipulation_magnitude", "attitude_change",
                      title = "Manipulation Magnitude x Attitude Change"),
         width = 6, height = 4)
  
  ggsave(file.path(out_dir, "scatter_magnitude_x_attitude_change_signed.png"),
         plot_scatter(data, "manipulation_magnitude", "attitude_change_signed",
                      title = "Manipulation Magnitude x Attitude Change Signed"),
         width = 6, height = 4)
  
  # ---- r1 confidence x rating/attitude_change scatter plots ----
  
  ggsave(file.path(out_dir, "scatter_r1_confidence_x_rating.png"),
         plot_scatter(data, "r1_confidence", "r1_rating",
                      title = "R1 Confidence x R1 Value Alignment"),
         width = 6, height = 4)
  ggsave(file.path(out_dir, "scatter_r1_confidence_x_attitude_change.png"),
         plot_scatter(data, "r1_confidence", "attitude_change",
                      title = "R1 Confidence x Attitude Change"),
         width = 6, height = 4)
  ggsave(file.path(out_dir, "scatter_r1_confidence_x_attitude_change_signed.png"),
         plot_scatter(data, "r1_confidence", "attitude_change_signed",
                      title = "R1 Confidence x Attitude Change Signed"),
         width = 6, height = 4)
}