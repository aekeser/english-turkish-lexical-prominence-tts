# 08_primary_formant_models.R
# Lexical Prominence QP1
# Language-specific mixed-effects models for QC-screened F1 and F2.

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

library(lme4)
library(lmerTest)
library(emmeans)

dat <- read.csv(
  file.path(
    project_root,
    "03_analysis",
    "analysis_formant_model_ready.csv"
  )
)

# -------------------------------------------------------------------------
# Factor setup
# -------------------------------------------------------------------------

dat$source <- factor(dat$source, levels = c("HUMAN", "TTS"))
dat$sex <- factor(dat$sex, levels = c("F", "M"))
dat$lexical_category <- factor(
  dat$lexical_category,
  levels = c("Noun", "Adjective")
)

contrasts(dat$source) <- contr.sum(2)
contrasts(dat$sex) <- contr.sum(2)
contrasts(dat$lexical_category) <- contr.sum(2)

# =========================================================================
# ENGLISH F1
# =========================================================================

en_f1 <- dat[
  dat$language == "EN" &
    !is.na(dat$log_f1),
]

en_f1$target_vowel_for_F1F2 <-
  factor(en_f1$target_vowel_for_F1F2)

m_en_f1 <- lmer(
  log_f1 ~
    source * lexical_category +
    sex +
    target_vowel_for_F1F2 +
    (1 | session_id) +
    (1 | stimulus_id),
  data = en_f1,
  REML = FALSE
)

cat("\n================ ENGLISH F1 ================\n")
print(summary(m_en_f1))

cat("\n--- ENGLISH F1 TYPE III TESTS ---\n")
print(anova(m_en_f1, type = 3))

cat("\n--- ENGLISH F1 HUMAN-TTS CONTRASTS BY CATEGORY ---\n")

print(
  contrast(
    emmeans(
      m_en_f1,
      ~ source | lexical_category
    ),
    method = "pairwise",
    adjust = "holm"
  )
)

cat("\n--- ENGLISH F1 SINGULARITY ---\n")
print(isSingular(m_en_f1))

# =========================================================================
# ENGLISH F2
# =========================================================================

en_f2 <- dat[
  dat$language == "EN" &
    !is.na(dat$log_f2),
]

en_f2$target_vowel_for_F1F2 <-
  factor(en_f2$target_vowel_for_F1F2)

m_en_f2 <- lmer(
  log_f2 ~
    source * lexical_category +
    sex +
    target_vowel_for_F1F2 +
    (1 | session_id) +
    (1 | stimulus_id),
  data = en_f2,
  REML = FALSE
)

cat("\n================ ENGLISH F2 ================\n")
print(summary(m_en_f2))

cat("\n--- ENGLISH F2 TYPE III TESTS ---\n")
print(anova(m_en_f2, type = 3))

cat("\n--- ENGLISH F2 HUMAN-TTS CONTRASTS BY CATEGORY ---\n")

print(
  contrast(
    emmeans(
      m_en_f2,
      ~ source | lexical_category
    ),
    method = "pairwise",
    adjust = "holm"
  )
)

cat("\n--- ENGLISH F2 SINGULARITY ---\n")
print(isSingular(m_en_f2))

# =========================================================================
# TURKISH F1
# =========================================================================

tr_f1 <- dat[
  dat$language == "TR" &
    !is.na(dat$log_f1),
]

tr_f1$target_vowel_for_F1F2 <-
  factor(tr_f1$target_vowel_for_F1F2)

m_tr_f1 <- lmer(
  log_f1 ~
    source * lexical_category +
    sex +
    target_vowel_for_F1F2 +
    (1 | session_id) +
    (1 | stimulus_id),
  data = tr_f1,
  REML = FALSE
)

cat("\n================ TURKISH F1 ================\n")
print(summary(m_tr_f1))

cat("\n--- TURKISH F1 TYPE III TESTS ---\n")
print(anova(m_tr_f1, type = 3))

cat("\n--- TURKISH F1 HUMAN-TTS CONTRASTS BY CATEGORY ---\n")

print(
  contrast(
    emmeans(
      m_tr_f1,
      ~ source | lexical_category
    ),
    method = "pairwise",
    adjust = "holm"
  )
)

cat("\n--- TURKISH F1 SINGULARITY ---\n")
print(isSingular(m_tr_f1))

# =========================================================================
# TURKISH F2
# =========================================================================

tr_f2 <- dat[
  dat$language == "TR" &
    !is.na(dat$log_f2),
]

tr_f2$target_vowel_for_F1F2 <-
  factor(tr_f2$target_vowel_for_F1F2)

m_tr_f2 <- lmer(
  log_f2 ~
    source * lexical_category +
    sex +
    target_vowel_for_F1F2 +
    (1 | session_id) +
    (1 | stimulus_id),
  data = tr_f2,
  REML = FALSE
)

cat("\n================ TURKISH F2 ================\n")
print(summary(m_tr_f2))

cat("\n--- TURKISH F2 TYPE III TESTS ---\n")
print(anova(m_tr_f2, type = 3))

cat("\n--- TURKISH F2 HUMAN-TTS CONTRASTS BY CATEGORY ---\n")

print(
  contrast(
    emmeans(
      m_tr_f2,
      ~ source | lexical_category
    ),
    method = "pairwise",
    adjust = "holm"
  )
)

cat("\n--- TURKISH F2 SINGULARITY ---\n")
print(isSingular(m_tr_f2))