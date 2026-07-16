# Converts any column containing only "Yes"/"No"/NA into logical TRUE/FALSE
recode_yes_no <- function(data) {
  data |>
    mutate(across(
      where(~ all(unique(na.omit(.x)) %in% c("Yes", "No"))),
      ~ .x == "Yes"
    ))
}