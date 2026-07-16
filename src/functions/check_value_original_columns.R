#src/functions/check_value_original_columns.R

library(dplyr)
library(tidyr)

post_nums <- sprintf("%02d", 1:12)

agreement_check <- purrr::map_dfr(post_nums, function(n) {
  chosen_col <- paste0("post", n, "_value_original")
  r1_col     <- paste0("r1_post", n, "_value")
  
  if (!all(c(chosen_col, r1_col) %in% names(renamed_filtered_preferences))) {
    return(tibble(post = n, n_total = NA, n_match = NA, n_mismatch = NA, n_na = NA))
  }
  
  df <- renamed_filtered_preferences %>%
    select(all_of(c(chosen_col, r1_col))) %>%
    rename(chosen = 1, r1_value = 2)
  
  tibble(
    post       = n,
    n_total    = nrow(df),
    n_match    = sum(df$chosen == df$r1_value, na.rm = TRUE),
    n_mismatch = sum(df$chosen != df$r1_value, na.rm = TRUE),
    n_na       = sum(is.na(df$chosen) | is.na(df$r1_value))
  )
})

agreement_check

# n <- "01"  # for inspecting mismatches
# renamed_filtered_preferences %>%
#   filter(.data[[paste0("post", n, "_value_chosen")]] != .data[[paste0("r1_post", n, "_value")]]) %>%
#   select(ResponseId, starts_with(paste0("post", n, "_")), starts_with(paste0("r1_post", n, "_")))