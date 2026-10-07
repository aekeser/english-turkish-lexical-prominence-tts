# 01_descriptive_acoustic_summary.R
# Lexical Prominence QP1
# First substantive descriptive analysis

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

dat <- read.csv(
  file.path(
    project_root,
    "01_preprocessing",
    "analysis_qc_ready.csv"
  )
)

# -------------------------------------------------------------------------
# Helper
# -------------------------------------------------------------------------

describe_measure <- function(data, measure, usable_var) {
  
  d <- data[data[[usable_var]] == 1, ]
  
  aggregate(
    d[[measure]],
    by = list(
      source = d$source,
      language = d$language,
      sex = d$sex,
      lexical_category = d$lexical_category,
      stress_position = d$stressed_syllable_number_metadata
    ),
    FUN = function(x) c(
      n = length(x),
      mean = mean(x),
      sd = sd(x),
      median = median(x),
      q1 = unname(quantile(x, .25)),
      q3 = unname(quantile(x, .75))
    )
  )
}

# -------------------------------------------------------------------------
# F0
# -------------------------------------------------------------------------

cat("\n================ F0 ================\n")

f0_summary <- describe_measure(
  dat,
  "mean_f0",
  "f0_usable"
)

print(f0_summary)

# -------------------------------------------------------------------------
# Intensity
# -------------------------------------------------------------------------

cat("\n============= INTENSITY =============\n")

intensity_summary <- describe_measure(
  dat,
  "mean_intensity",
  "intensity_usable"
)

print(intensity_summary)

# -------------------------------------------------------------------------
# F1
# -------------------------------------------------------------------------

cat("\n================ F1 ================\n")

f1_summary <- describe_measure(
  dat,
  "f1",
  "f1_analysis_usable"
)

print(f1_summary)

# -------------------------------------------------------------------------
# F2
# -------------------------------------------------------------------------

cat("\n================ F2 ================\n")

f2_summary <- describe_measure(
  dat,
  "f2",
  "f2_analysis_usable"
)

print(f2_summary)

# -------------------------------------------------------------------------
# Save descriptive tables
# -------------------------------------------------------------------------

write.csv(
  f0_summary,
  file.path(project_root, "03_analysis", "descriptive_f0.csv"),
  row.names = FALSE
)

write.csv(
  intensity_summary,
  file.path(project_root, "03_analysis", "descriptive_intensity.csv"),
  row.names = FALSE
)

write.csv(
  f1_summary,
  file.path(project_root, "03_analysis", "descriptive_f1.csv"),
  row.names = FALSE
)

write.csv(
  f2_summary,
  file.path(project_root, "03_analysis", "descriptive_f2.csv"),
  row.names = FALSE
)

cat("\nDescriptive acoustic summaries completed.\n")