# src/functions/extract_item_numbers.R

extract_selected_items <- function(x) {
  matches <- regmatches(x, gregexpr("\\d+", x))
  sapply(matches, function(m) paste(unique(m), collapse = ","))
}