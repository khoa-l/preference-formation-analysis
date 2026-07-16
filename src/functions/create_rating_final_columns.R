#src/functions/create_rating_final_columns.R

# created for the wide data, but not necessary on long data

create_value_final_columns <- function(data) {
  # create post##_rating_final by copying r2_post##_rating
  post_nums <- sprintf("%02d", 1:12)
  
  for (n in post_nums) {
    r2_col    <- paste0("r2_post", n, "_rating")
    final_col <- paste0("post", n, "_rating_final") # The value rating submitted in Round 2. This could be a revised or accepted from the value_shown.
    if (r2_col %in% names(data)) {
      data[[final_col]] <- data[[r2_col]]
    }
  }
  data
}