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