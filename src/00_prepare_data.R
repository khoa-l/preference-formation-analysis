#src/00_prepare_data.R

source(here("src", "functions", "rename_survey_columns.R"))
source(here("src", "functions", "rename_metadata_columns.R"))
source(here("src", "functions", "extract_selected_items.R"))
source(here("src", "functions", "reshape_to_long.R"))
source(here("src", "functions", "recode_yes_no.R"))


# ---- load data ----
raw_preferences <- read_csv(here("data", "raw", "raw_data_preferences.csv"))

# ---- drop first two columns ----
filtered_preferences <- raw_preferences %>%
  slice(-1, -2)

# ---- rename columns ----
renamed_filtered_preferences <- filtered_preferences %>%
  rename_survey_columns() %>%
  rename_metadata_columns()

# ---- filter on date, participants, duration ----
renamed_filtered_preferences <- renamed_filtered_preferences %>%
  filter(
    as.Date(start_date) >= as.Date("2026-06-04"),
    !is.na(prolific_id),
    as.numeric(duration_sec) > 100
  )

# ---- extract selected items ----
renamed_filtered_preferences <- renamed_filtered_preferences %>%
  mutate(r2_item_selection = extract_selected_items(r2_item_selection))

# ---- reshape to long ----
long_preferences <- reshape_to_long(renamed_filtered_preferences)

# ---- correct typing on columns ----
long_preferences <- long_preferences %>%
  mutate(across(c(r1_rating, r2_rating, rating_shown, rating_original, r1_confidence), as.numeric))

# ---- fill in missing 0s ----
# When the rating slider is not used, Qualtrics labels the result as NA
# Fixes the case where the rating is not manipulated and the slider is not used
long_preferences <- long_preferences %>%
  mutate(
    r2_rating = if_else(r1_rating == 0 & rating_shown == 0 & is.na(r2_rating), 0, r2_rating)
  )

# ---- create columns ----
long_preferences <- mutate(long_preferences,
  r1_rating_deviation = abs(r1_rating - 50),
  r1_confidence_deviation = abs(r1_confidence - 50),
  manipulated = r1_rating != rating_shown,
  manipulation_magnitude = abs(rating_shown - r1_rating),
  attitude_change = abs(r2_rating - r1_rating),
  attitude_change_signed = r2_rating - r1_rating
)

# ---- recode yes no ----
long_preferences <- long_preferences %>%
  recode_yes_no()

# ---- only r2 selected posts ----
r2_posts <- long_preferences %>%
  filter(
    !is.na(r2_rating)
  )

# ---- save ----
dir.create(here("data", "processed"), recursive = TRUE, showWarnings = FALSE)
saveRDS(long_preferences, here("data", "processed", "long_preferences.rds"))
saveRDS(renamed_filtered_preferences, here("data", "processed", "renamed_filtered_preferences.rds"))
saveRDS(renamed_filtered_preferences, here("data", "processed", "r2_posts.rds"))