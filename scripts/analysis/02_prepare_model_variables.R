# 02_prepare_model_variables.R
# Lexical Prominence QP1
# Prepare normalized acoustic variables for inferential modeling.
#
# Raw measurements are retained unchanged.
# F0: convert to semitones and center within session/voice.
# Intensity: center within session/voice.
# F1/F2: retain raw Hz for now; vowel-conditioned modeling will be
# specified separately because vowel identity strongly determines formants.

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

library(dplyr)

dat <- read.csv(
  file.path(
    project_root,
    "01_preprocessing",
    "analysis_qc_ready.csv"
  )
)

# -------------------------------------------------------------------------
# F0
# -------------------------------------------------------------------------

# Semitone transformation.
# Absolute reference cancels after within-session centering.
dat$f0_semitone <- 12 * log2(dat$mean_f0)

dat <- dat %>%
  group_by(session_id) %>%
  mutate(
    f0_st_centered =
      f0_semitone -
      median(
        f0_semitone[f0_usable == 1],
        na.rm = TRUE
      )
  ) %>%
  ungroup()

# Unusable F0 must not contribute an analyzable centered value
dat$f0_st_centered[dat$f0_usable != 1] <- NA_real_

# -------------------------------------------------------------------------
# Intensity
# -------------------------------------------------------------------------

dat <- dat %>%
  group_by(session_id) %>%
  mutate(
    intensity_centered =
      mean_intensity -
      median(
        mean_intensity[intensity_usable == 1],
        na.rm = TRUE
      )
  ) %>%
  ungroup()

dat$intensity_centered[
  dat$intensity_usable != 1
] <- NA_real_

# -------------------------------------------------------------------------
# Validation
# -------------------------------------------------------------------------

cat("\n--- MODEL VARIABLE VALIDATION ---\n")

cat(
  "Usable centered F0:",
  sum(!is.na(dat$f0_st_centered)),
  "\n"
)

cat(
  "Usable centered intensity:",
  sum(!is.na(dat$intensity_centered)),
  "\n"
)

cat("\n--- WITHIN-SESSION MEDIANS: F0 ---\n")

print(
  summary(
    tapply(
      dat$f0_st_centered,
      dat$session_id,
      median,
      na.rm = TRUE
    )
  )
)

cat("\n--- WITHIN-SESSION MEDIANS: INTENSITY ---\n")

print(
  summary(
    tapply(
      dat$intensity_centered,
      dat$session_id,
      median,
      na.rm = TRUE
    )
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
    "analysis_model_ready.csv"
  ),
  row.names = FALSE
)

cat("\nanalysis_model_ready.csv created successfully.\n")