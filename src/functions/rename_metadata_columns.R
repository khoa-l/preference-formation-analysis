#src/functions/rename_metadata_columns.R

metadata_rename_map <- c(
  # Qualtrics survey metadata
  "StartDate"                       = "start_date",
  "EndDate"                         = "end_date",
  "Status"                          = "status",
  "IPAddress"                       = "ip_address",
  "Progress"                        = "progress",
  "Duration (in seconds)"           = "duration_sec",
  "Finished"                        = "finished",
  "RecordedDate"                    = "recorded_date",
  "ResponseId"                      = "response_id",
  "RecipientLastName"               = "recipient_last_name",
  "RecipientFirstName"              = "recipient_first_name",
  "RecipientEmail"                  = "recipient_email",
  "ExternalReference"               = "external_reference",
  "LocationLatitude"                = "location_latitude",
  "LocationLongitude"               = "location_longitude",
  "DistributionChannel"             = "distribution_channel",
  "UserLanguage"                    = "user_language",
  "Q_RecaptchaScore"                = "recaptcha_score",
  "Q_RecaptchaStatus"               = "recaptcha_status",
  "Q_RecaptchaError"                = "recaptcha_error",
  
  # Consent and choosing posts for Round 2
  "Consent Agreement"               = "consent",
  "R2 Random Questions"             = "r2_post_selection",
  
  # Debrief / manipulation-check questions
  "Issues"                          = "detection_issue_flag",
  "Issue Description"               = "detection_issue_text",
  "Awareness"                       = "detection_hypothetical",
  "Recall"                          = "detection_confirmed", # After we reveal the manipulation
  "Attention Check"                 = "attn_check_breath",
  "AI Usage"                        = "ai_usage",
  # Demographics
  "Birth Year"                      = "birth_year",
  "Gender"                          = "gender",
  "Gender_3_TEXT"                   = "gender_text",
  "Ethnicity"                       = "ethnicity",
  "Ethnicity_11_TEXT"               = "ethnicity_text",
  
  # Prolific identifiers
  "PROLIFIC_PID"                    = "prolific_id",
  "STUDY_ID"                        = "study_id",
  "SESSION_ID"                      = "session_id",
  
  # Embedded data for choice blindness paradigm bookkeeping
  "__js_FlippedChoice"              = "js_flipped_choice",
  "__js_Alter0"                     = "js_alter0",
  "__js_Alter1"                     = "js_alter1",
  "__js_Normal0"                    = "js_normal0",
  "__js_Normal1"                    = "js_normal1",
  "__js_hasRun"                     = "js_has_run",
  "__js_Altered"                    = "js_altered",
  "__js_Normal"                     = "js_normal",
  
  # Derived columns
  "Average _R1 Timer_Page Submit"   = "avg_r1_time_submit",
  "Explanation Questions Answered"  = "n_explanations_answered"
)

rename_metadata_columns <- function(data) {
  current_names <- names(data)
  matched <- current_names %in% names(metadata_rename_map)
  
  new_names <- current_names
  new_names[matched] <- metadata_rename_map[current_names[matched]]
  
  unmatched <- current_names[!matched & !current_names %in% new_names]
  # unmatched here just means "not in map" - could still be post##_* etc,
  
  names(data) <- new_names
  data
}