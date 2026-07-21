#src/functions/reshape_to_long.R

reshape_to_long<- function(data) {
  # Identify participant-level (non-item) columns to put on each row
  participant_cols <- names(data)[!str_detect(names(data), "^item\\d{2}_") & !str_detect(names(data), "^r[12]_item\\d{2}_")]
  
  #  Item metadata
  item_meta_long <- data %>%
    select(participant_id, matches("^item\\d{2}_")) %>%
    pivot_longer(
      cols = matches("^item\\d{2}_"),
      names_to = c("item_num", ".value"),
      names_pattern = "item(\\d{2})_(.*)"
    )
  
  # Round 1 measurements
  r1_long <- data %>%
    select(participant_id, matches("^r1_item\\d{2}_")) %>%
    pivot_longer(
      cols = matches("^r1_item\\d{2}_"),
      names_to = c("item_num", ".value"),
      names_pattern = "r1_item(\\d{2})_(.*)",
      names_prefix = "",
    ) %>%
    rename_with(~ paste0("r1_", .), -c(participant_id, item_num))
  
  # Round 2 measurements
  r2_long <- data %>%
    select(participant_id, matches("^r2_item\\d{2}_")) %>%
    pivot_longer(
      cols = matches("^r2_item\\d{2}_"),
      names_to = c("item_num", ".value"),
      names_pattern = "r2_item(\\d{2})_(.*)"
    ) %>%
    rename_with(~ paste0("r2_", .), -c(participant_id, item_num))
  
  # Combine
  long_data <- item_meta_long %>%
    left_join(r1_long, by = c("participant_id", "item_num")) %>%
    left_join(r2_long, by = c("participant_id", "item_num")) %>%
    left_join(
      data %>% select(all_of(participant_cols)),
      by = "participant_id"
    )
  long_data
}
