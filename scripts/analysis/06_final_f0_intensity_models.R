# 06_final_f0_intensity_models.R
# Lexical Prominence QP1
# Final primary mixed-effects models for centered F0 and intensity.

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

library(lme4)
library(lmerTest)
library(emmeans)

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

dat$source_c <- ifelse(dat$source == "HUMAN", -0.5, 0.5)
dat$category_c <- ifelse(dat$lexical_category == "Noun", -0.5, 0.5)

# ============================================================
# FINAL F0 MODEL
# ============================================================

f0_dat <- dat[!is.na(dat$f0_st_centered), ]

m_f0_final <- lmer(
  f0_st_centered ~
    source * language * lexical_category +
    sex +
    (1 | session_id) +
    (1 | stimulus_id),
  data = f0_dat,
  REML = FALSE
)

cat("\n================ FINAL F0 MODEL ================\n")
print(summary(m_f0_final))

cat("\n--- F0 TYPE III TESTS ---\n")
print(anova(m_f0_final, type = 3))

cat("\n--- F0 HUMAN-TTS CONTRASTS WITHIN LANGUAGE x CATEGORY ---\n")

f0_emm <- emmeans(
  m_f0_final,
  ~ source | language * lexical_category
)

print(
  contrast(
    f0_emm,
    method = "pairwise",
    adjust = "holm"
  )
)

# ============================================================
# FINAL INTENSITY MODEL
# ============================================================

int_dat <- dat[!is.na(dat$intensity_centered), ]

m_int_final <- lmer(
  intensity_centered ~
    source * language * lexical_category +
    sex +
    (1 + category_c || session_id) +
    (1 + source_c || stimulus_id),
  data = int_dat,
  REML = FALSE
)

cat("\n================ FINAL INTENSITY MODEL ================\n")
print(summary(m_int_final))

cat("\n--- INTENSITY TYPE III TESTS ---\n")
print(anova(m_int_final, type = 3))

cat("\n--- INTENSITY HUMAN-TTS CONTRASTS WITHIN LANGUAGE x CATEGORY ---\n")

int_emm <- emmeans(
  m_int_final,
  ~ source | language * lexical_category
)

print(
  contrast(
    int_emm,
    method = "pairwise",
    adjust = "holm"
  )
)

cat("\n--- FINAL MODEL CHECKS ---\n")
print(
  c(
    F0_singular = isSingular(m_f0_final),
    Intensity_singular = isSingular(m_int_final)
  )
)