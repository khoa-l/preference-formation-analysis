#src/01_make_subsets.R

library(tidyverse)
library(here)

source(here("src", "functions", "filter_subsets.R"))

save_subset <- function(data, name) {
  write_rds(data, here("data", "processed", paste0(name, ".rds")))
}

subsets <- list(
  manipulated             = filter_manipulated(long_preferences, TRUE),
  not_manipulated         = filter_manipulated(long_preferences, FALSE),
  
  r2_gt_shown             = filter_r2_vs_shown(long_preferences, "up"),
  r2_lt_shown             = filter_r2_vs_shown(long_preferences, "down"),
  r2_eq_shown             = filter_r2_vs_shown(long_preferences, "same"), # People who accepted the manipulation
  
  r1_gt_r2                = filter_r1_vs_r2(long_preferences, "up"),
  r1_lt_r2                = filter_r1_vs_r2(long_preferences, "down"),
  r1_eq_r2                = filter_r1_vs_r2(long_preferences, "same"),
  
  manip_up                = filter_manipulation_direction(long_preferences, "up"),
  manip_down              = filter_manipulation_direction(long_preferences, "down"),
  
  issues                  = filter_issues(long_preferences, TRUE),
  no_issues               = filter_issues(long_preferences, FALSE),
  
  detected                = filter_detected(long_preferences, "Yes"),
  not_detected             = filter_detected(long_preferences, "No"),
  detected_unsure          = filter_detected(long_preferences, "Unsure"),
  
  hypothetical_aware       = filter_hypothetical_awareness(long_preferences, "Yes"),
  hypothetical_not_aware   = filter_hypothetical_awareness(long_preferences, "No"),
  hypothetical_unsure      = filter_hypothetical_awareness(long_preferences, "Unsure"),
  
  explanation_given       = filter_by_explanation_given(long_preferences, TRUE),
  explanation_missing     = filter_by_explanation_given(long_preferences, FALSE)
)

iwalk(subsets, save_subset)
