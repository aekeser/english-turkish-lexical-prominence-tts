# 01_primary_sensitivity_checks.R
# Lexical Prominence QP1
# Sensitivity analyses for F0 and formant QC decisions.

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

library(lme4)
library(lmerTest)
library(emmeans)
library(dplyr)

# ============================================================
# F0 SENSITIVITY: USABLE vs STRICT-ACCEPTED
# ============================================================

dat <- read.csv(
  file.path(
    project_root,
    "03_analysis",
    "analysis_model_ready.csv"
  )
)

dat$source <- factor(dat$source, levels = c("HUMAN", "TTS"))
dat$language <- factor(dat$language, levels = c("EN", "TR"))
dat$sex <- factor(dat$sex, levels = c("F", "M"))
dat$lexical_category <- factor(
  dat$lexical_category,
  levels = c("Noun", "Adjective")
)

contrasts(dat$source) <- contr.sum(2)
contrasts(dat$language) <- contr.sum(2)
contrasts(dat$sex) <- contr.sum(2)
contrasts(dat$lexical_category) <- contr.sum(2)

# Primary
f0_primary <- dat[!is.na(dat$f0_st_centered), ]

m_f0_primary <- lmer(
  f0_st_centered ~
    source * language * lexical_category +
    sex +
    (1 | session_id) +
    (1 | stimulus_id),
  data = f0_primary,
  REML = FALSE
)

# Strict
f0_strict <- dat[
  dat$f0_strict_accepted == 1 &
    !is.na(dat$f0_st_centered),
]

m_f0_strict <- lmer(
  f0_st_centered ~
    source * language * lexical_category +
    sex +
    (1 | session_id) +
    (1 | stimulus_id),
  data = f0_strict,
  REML = FALSE
)

cat("\n================ F0 SENSITIVITY ================\n")

cat("\nPrimary N:", nrow(f0_primary), "\n")
cat("Strict N:", nrow(f0_strict), "\n")

cat("\n--- PRIMARY F0 TYPE III ---\n")
print(anova(m_f0_primary, type = 3))

cat("\n--- STRICT F0 TYPE III ---\n")
print(anova(m_f0_strict, type = 3))

cat("\n--- PRIMARY F0 HUMAN-TTS CONTRASTS ---\n")
print(
  contrast(
    emmeans(
      m_f0_primary,
      ~ source | language * lexical_category
    ),
    "pairwise"
  )
)

cat("\n--- STRICT F0 HUMAN-TTS CONTRASTS ---\n")
print(
  contrast(
    emmeans(
      m_f0_strict,
      ~ source | language * lexical_category
    ),
    "pairwise"
  )
)

# ============================================================
# FORMANT SENSITIVITY: 3.5 MAD vs 3.0 MAD
# ============================================================

form <- read.csv(
  file.path(
    project_root,
    "02_data_audit",
    "formant_qc_diagnostic.csv"
  )
)

# Reconstruct stricter robust flags using existing robust-z columns
form$f1_qc_strict <-
  form$f1_hard_flag |
  form$formant_order_flag |
  (
    !is.na(form$f1_robust_z) &
      abs(form$f1_robust_z) > 3.0
  )

form$f2_qc_strict <-
  form$f2_hard_flag |
  form$formant_order_flag |
  (
    !is.na(form$f2_robust_z) &
      abs(form$f2_robust_z) > 3.0
  )

cat("\n================ FORMANT QC SENSITIVITY ================\n")

print(
  c(
    primary_f1_retained = sum(!form$f1_qc_flag),
    strict_f1_retained = sum(!form$f1_qc_strict),
    primary_f2_retained = sum(!form$f2_qc_flag),
    strict_f2_retained = sum(!form$f2_qc_strict)
  )
)

# ============================================================
# Helper for strict formant models
# ============================================================

fit_formant_strict <- function(language_code, measure, qc_var) {
  
  d <- form[
    form$language == language_code &
      !form[[qc_var]],
  ]
  
  d$source <- factor(d$source, levels = c("HUMAN", "TTS"))
  d$sex <- factor(d$sex, levels = c("F", "M"))
  d$lexical_category <- factor(
    d$lexical_category,
    levels = c("Noun", "Adjective")
  )
  d$target_vowel_for_F1F2 <- factor(d$target_vowel_for_F1F2)
  
  contrasts(d$source) <- contr.sum(2)
  contrasts(d$sex) <- contr.sum(2)
  contrasts(d$lexical_category) <- contr.sum(2)
  
  d$log_measure <- log(d[[measure]])
  
  lmer(
    log_measure ~
      source * lexical_category +
      sex +
      target_vowel_for_F1F2 +
      (1 | session_id) +
      (1 | stimulus_id),
    data = d,
    REML = FALSE
  )
}

models_strict <- list(
  EN_F1 = fit_formant_strict("EN", "f1", "f1_qc_strict"),
  EN_F2 = fit_formant_strict("EN", "f2", "f2_qc_strict"),
  TR_F1 = fit_formant_strict("TR", "f1", "f1_qc_strict"),
  TR_F2 = fit_formant_strict("TR", "f2", "f2_qc_strict")
)

for (nm in names(models_strict)) {
  
  cat("\n---", nm, "STRICT QC ---\n")
  
  print(
    anova(
      models_strict[[nm]],
      type = 3
    )
  )
  
  print(
    contrast(
      emmeans(
        models_strict[[nm]],
        ~ source | lexical_category
      ),
      "pairwise"
    )
  )
}

cat("\nSensitivity analyses completed.\n")