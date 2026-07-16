#src/functions/rename_survey_columns.R

rename_survey_column <- function(col) {
  
  # Round 1 (R1) post 13 is an attention check special case
  if (str_detect(col, "^13_R1")) {
    measure <- case_when(
      str_detect(col, "Value Alignment")   ~ "rating",
      str_detect(col, "Confidence")        ~ "confidence",
      str_detect(col, "Timer_First Click") ~ "time_first_click",
      str_detect(col, "Timer_Last Click")  ~ "time_last_click",
      str_detect(col, "Timer_Page Submit") ~ "time_submit",
      str_detect(col, "Timer_Click Count") ~ "click_count",
      TRUE ~ NA_character_
    )
    if (is.na(measure)) return(col)
    return(sprintf("attn_check_r1_%s", measure))
  }
  
  # R1/R2 item columns -> r1_post##_value, r2_post##_confidence, etc.
  if (str_detect(col, "^\\d+_R[12]")) {
    round <- ifelse(str_detect(col, "_R1"), "r1", "r2")
    n     <- as.integer(str_extract(col, "^\\d+"))
    if (round == "r2") n <- n - 84
    
    measure <- case_when(
      str_detect(col, "Value Alignment")   ~ "rating",
      str_detect(col, "Explanation")       ~ "explanation",
      str_detect(col, "Confidence")        ~ "confidence",
      str_detect(col, "Timer_First Click") ~ "time_first_click",
      str_detect(col, "Timer_Last Click")  ~ "time_last_click",
      str_detect(col, "Timer_Page Submit") ~ "time_submit",
      str_detect(col, "Timer_Click Count") ~ "click_count",
      TRUE ~ NA_character_
    )
    if (is.na(measure)) return(col)
    
    return(sprintf("%s_post%02d_%s", round, n, measure))
  }
  
  # Post metadata columns -> post##_id, post##_choice, post##_shown_choice
  post_type <- case_when(
    str_detect(col, "^PostID\\d+$")              ~ "id",
    str_detect(col, "^__js_Post\\d+ShownChoice") ~ "rating_shown", # The value that is shown to the participant in Round 2, may be manipulated
    str_detect(col, "^__js_Post\\d+Choice$")      ~ "rating_original", # The value that the participant originally rated in Round 1
    TRUE ~ NA_character_
  )
  if (!is.na(post_type)) {
    n <- as.integer(str_extract(col, "\\d+"))
    return(sprintf("post%02d_%s", n, post_type))
  }
  
  col  # unchanged if no pattern matches
}

rename_survey_columns <- function(data) {
  names(data) <- sapply(names(data), rename_survey_column, USE.NAMES = FALSE)
  data
}