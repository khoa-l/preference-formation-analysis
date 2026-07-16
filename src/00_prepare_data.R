#src/00_prepare_data.R

source(here("src", "functions", "rename_survey_columns.R"))
source(here("src", "functions", "rename_metadata_columns.R"))
source(here("src", "functions", "reshape_to_long.R"))
source(here("src", "functions", "recode_yes_no.R"))


# ---- load data ----
filtered_preferences <- read_csv(here("data", "processed", "filtered_preferences.csv"))

# ---- rename columns ----
renamed_filtered_preferences <- filtered_preferences %>%
  rename_survey_columns() %>%
  rename_metadata_columns()

# ---- reshape to long ----
long_preferences <- reshape_to_long(renamed_filtered_preferences)

# ---- create columns ----
long_preferences <- mutate(long_preferences,
  # rating_final = r2_rating,
  r1_rating_deviation = abs(r1_rating - 50),
  r1_confidence_deviation = abs(r1_confidence - 50),
  manipulated = r1_rating != rating_shown,
  manipulation_magnitude = abs(rating_shown - r1_rating),
  attitude_change = abs(r2_rating - r1_rating)
)

# ---- recode yes no ----
long_preferences <- long_preferences |>
  recode_yes_no()

# ---- save ----
dir.create(here("data", "processed"), recursive = TRUE, showWarnings = FALSE)
saveRDS(long_preferences, here("data", "processed", "long_preferences.rds"))
saveRDS(renamed_filtered_preferences, here("data", "processed", "renamed_filtered_preferences.rds"))