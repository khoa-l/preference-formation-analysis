#src/functions/reshape_to_long.R

reshape_to_long<- function(data) {
  # Identify participant-level (non-post) columns to put on each row
  participant_cols <- names(data)[!str_detect(names(data), "^post\\d{2}_") & !str_detect(names(data), "^r[12]_post\\d{2}_")]
  
  #  Post metadata
  post_meta_long <- data %>%
    select(response_id, matches("^post\\d{2}_")) %>%
    pivot_longer(
      cols = matches("^post\\d{2}_"),
      names_to = c("post_num", ".value"),
      names_pattern = "post(\\d{2})_(.*)"
    )
  
  # Round 1 measurements
  r1_long <- data %>%
    select(response_id, matches("^r1_post\\d{2}_")) %>%
    pivot_longer(
      cols = matches("^r1_post\\d{2}_"),
      names_to = c("post_num", ".value"),
      names_pattern = "r1_post(\\d{2})_(.*)",
      names_prefix = "",
    ) %>%
    rename_with(~ paste0("r1_", .), -c(response_id, post_num))
  
  # Round 2 measurements
  r2_long <- data %>%
    select(response_id, matches("^r2_post\\d{2}_")) %>%
    pivot_longer(
      cols = matches("^r2_post\\d{2}_"),
      names_to = c("post_num", ".value"),
      names_pattern = "r2_post(\\d{2})_(.*)"
    ) %>%
    rename_with(~ paste0("r2_", .), -c(response_id, post_num))
  
  # Combine
  long_data <- post_meta_long %>%
    left_join(r1_long, by = c("response_id", "post_num")) %>%
    left_join(r2_long, by = c("response_id", "post_num")) %>%
    left_join(
      data %>% select(all_of(participant_cols)),
      by = "response_id"
    )
  long_data
}
