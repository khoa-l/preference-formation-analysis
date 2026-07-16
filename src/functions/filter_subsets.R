# src/functions/filter_subsets.R

# ---- Direction-of-change filters ----

filter_direction <- function(data, from, to, direction = c("up", "down", "same"), tolerance = 0) {
  direction <- match.arg(direction)
  if (direction == "up") {
    data |> filter(.data[[to]] > .data[[from]] + tolerance)
  } else if (direction == "down") {
    data |> filter(.data[[to]] < .data[[from]] - tolerance)
  } else {
    data |> filter(abs(.data[[to]] - .data[[from]]) <= tolerance)
  }
}

filter_r1_vs_r2        <- function(data, direction, tolerance = 0) filter_direction(data, "r1_rating", "r2_rating", direction, tolerance)
filter_r2_vs_shown     <- function(data, direction, tolerance = 0) filter_direction(data, "rating_shown", "r2_rating", direction, tolerance)
filter_manipulation_direction <- function(data, direction, tolerance = 0) filter_direction(data, "r1_rating", "rating_shown", direction, tolerance)

# ---- Manipulation status & magnitude ----

filter_manipulated <- function(data, manipulated = TRUE) {
  data |> filter(.data$manipulated == manipulated)
}

filter_manipulation_magnitude <- function(data, min = 0, max = Inf) {
  data |> filter(abs(rating_shown - rating_original) >= min,
                 abs(rating_shown - rating_original) <= max)
}

filter_manipulation_magnitude_signed <- function(data, min = -Inf, max = Inf) {
  data |> filter(rating_shown - rating_original >= min,
                 rating_shown - rating_original <= max)
}

# ---- Post selection ----

filter_by_posts <- function(data, posts) {
  data |> filter(post_num %in% posts)
}

# ---- Detection (debrief measures) ----

filter_issues <- function(data, issue = TRUE) {
  data |> filter(detection_issue_flag == issue)
}

filter_detected <- function(data, detected = "Yes") {
  data |> filter(detection_confirmed == detected)
}

filter_hypothetical_awareness <- function(data, aware = "Yes") {
  data |> filter(detection_hypothetical == aware)
}

# ---- Explanation given ------------------------------------------------

filter_by_explanation_given <- function(data, given = TRUE) {
  if (given) {
    data |> filter(!is.na(r2_explanation), r2_explanation != "")
  } else {
    data |> filter(is.na(r2_explanation) | r2_explanation == "")
  }
}