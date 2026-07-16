#src/functions/create_manipulated_flag_columns.R

# created for the wide data, but not necessary on long data

create_manipulated_flag_columns <- function(data) {
  # Flag whether each post's rating was manipulated (rating_shown != rating_original)
  post_nums <- sprintf("%02d", 1:12)
  
  for (n in post_nums) {
    chosen_col <- paste0("post", n, "_rating_original")
    shown_col  <- paste0("post", n, "_rating_shown")
    flag_col   <- paste0("post", n, "_manipulated")
    
    if (all(c(chosen_col, shown_col) %in% names(data))) {
      data[[flag_col]] <- 
        data[[chosen_col]] != data[[shown_col]]
    }
  }
  data
}