#src/01_make_subsets.R

source(here("src", "functions", "filter_subsets.R"))

save_subset <- function(data, name) {
  dir.create(here("data", "processed", "subsets"), recursive = TRUE, showWarnings = FALSE)
  write_rds(data, here("data", "processed", "subsets", paste0(name, ".rds")))
}

subsets <- list(
  manipulated             = filter_manipulated(r2_posts, TRUE), # Only observations where the rating was manipulated
  not_manipulated         = filter_manipulated(r2_posts, FALSE),
  
  r2_gt_shown             = filter_r2_vs_shown(r2_posts, "up"),
  r2_lt_shown             = filter_r2_vs_shown(r2_posts, "down"),
  r2_eq_shown             = filter_r2_vs_shown(r2_posts, "same"), # People who accepted the manipulation
  
  r1_gt_r2                = filter_r1_vs_r2(r2_posts, "up"),
  r1_lt_r2                = filter_r1_vs_r2(r2_posts, "down"),
  r1_eq_r2                = filter_r1_vs_r2(r2_posts, "same"), # People who were unmanipulated and/or changed it back to exactly what they had
  
  manip_up                = filter_manipulation_direction(r2_posts, "up"),
  manip_down              = filter_manipulation_direction(r2_posts, "down"),
  
  # "Did you notice anything odd, or experienced issues/bugs with the questions in this study?" 
  issues                  = filter_issues(r2_posts, TRUE),
  no_issues               = filter_issues(r2_posts, FALSE),
  
  # "During the phase where you explained your ratings of posts,
  # do you think you would have noticed if some of the displayed ratings were different than those you selected originally?"
  hypothetical_aware       = filter_hypothetical_awareness(r2_posts, "Yes"),
  hypothetical_not_aware   = filter_hypothetical_awareness(r2_posts, "No"),
  hypothetical_unsure      = filter_hypothetical_awareness(r2_posts, "Unsure"),
  
  # "Did you recall noticing that some of the ratings that we showed you were different than those you had selected originally?"
  detected                = filter_detected(r2_posts, "Yes"),
  not_detected            = filter_detected(r2_posts, "No"),
  detected_unsure         = filter_detected(r2_posts, "Unsure"),
  
  explanation_given       = filter_by_explanation_given(r2_posts, TRUE),
  explanation_missing     = filter_by_explanation_given(r2_posts, FALSE)
)

iwalk(subsets, save_subset)
