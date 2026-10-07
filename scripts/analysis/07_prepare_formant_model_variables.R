# 07_prepare_formant_model_variables.R
# Lexical Prominence QP1
# Prepare QC-screened F1/F2 variables for language-specific modeling.

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

dat <- read.csv(
  file.path(
    project_root,
    "03_analysis",
    "analysis_model_ready.csv"
  )
)

# -------------------------------------------------------------------------
# QC-screened log formants
# -------------------------------------------------------------------------

dat$log_f1 <- NA_real_
dat$log_f2 <- NA_real_

dat$log_f1[dat$f1_analysis_usable == 1] <-
  log(dat$f1[dat$f1_analysis_usable == 1])

dat$log_f2[dat$f2_analysis_usable == 1] <-
  log(dat$f2[dat$f2_analysis_usable == 1])

# -------------------------------------------------------------------------
# Validation
# -------------------------------------------------------------------------

cat("\n--- FORMANT MODEL VARIABLE COUNTS ---\n")

print(
  c(
    F1 = sum(!is.na(dat$log_f1)),
    F2 = sum(!is.na(dat$log_f2))
  )
)

cat("\n--- ENGLISH VOWELS: F1 ---\n")
print(
  table(
    dat$target_vowel_for_F1F2[
      dat$language == "EN" &
        !is.na(dat$log_f1)
    ]
  )
)

cat("\n--- TURKISH VOWELS: F1 ---\n")
print(
  table(
    dat$target_vowel_for_F1F2[
      dat$language == "TR" &
        !is.na(dat$log_f1)
    ]
  )
)

cat("\n--- ENGLISH VOWELS: F2 ---\n")
print(
  table(
    dat$target_vowel_for_F1F2[
      dat$language == "EN" &
        !is.na(dat$log_f2)
    ]
  )
)

cat("\n--- TURKISH VOWELS: F2 ---\n")
print(
  table(
    dat$target_vowel_for_F1F2[
      dat$language == "TR" &
        !is.na(dat$log_f2)
    ]
  )
)

# -------------------------------------------------------------------------
# Export
# -------------------------------------------------------------------------

write.csv(
  dat,
  file.path(
    project_root,
    "03_analysis",
    "analysis_formant_model_ready.csv"
  ),
  row.names = FALSE
)

cat("\nanalysis_formant_model_ready.csv created successfully.\n")