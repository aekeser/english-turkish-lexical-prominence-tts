# 09_cross_cue_effect_summary.R
# Lexical Prominence QP1
# Extract Human-TTS contrasts across the four acoustic dimensions.

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

library(lme4)
library(lmerTest)
library(emmeans)
library(dplyr)

# -------------------------------------------------------------------------
# F0 / intensity data
# -------------------------------------------------------------------------

dat <- read.csv(
  file.path(project_root, "03_analysis", "analysis_model_ready.csv")
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

# F0
f0_dat <- dat[!is.na(dat$f0_st_centered), ]

m_f0 <- lmer(
  f0_st_centered ~
    source * language * lexical_category +
    sex +
    (1 | session_id) +
    (1 | stimulus_id),
  data = f0_dat,
  REML = FALSE
)

f0_con <- as.data.frame(
  contrast(
    emmeans(m_f0, ~ source | language * lexical_category),
    "pairwise"
  )
)

f0_con$measure <- "F0"
f0_con$unit <- "Semitones"

# Intensity
int_dat <- dat[!is.na(dat$intensity_centered), ]

m_int <- lmer(
  intensity_centered ~
    source * language * lexical_category +
    sex +
    (1 + category_c || session_id) +
    (1 + source_c || stimulus_id),
  data = int_dat,
  REML = FALSE
)

int_con <- as.data.frame(
  contrast(
    emmeans(m_int, ~ source | language * lexical_category),
    "pairwise"
  )
)

int_con$measure <- "Intensity"
int_con$unit <- "dB"

# -------------------------------------------------------------------------
# Formant data
# -------------------------------------------------------------------------

form <- read.csv(
  file.path(project_root, "03_analysis", "analysis_formant_model_ready.csv")
)

form$source <- factor(form$source, levels = c("HUMAN", "TTS"))
form$sex <- factor(form$sex, levels = c("F", "M"))
form$lexical_category <- factor(
  form$lexical_category,
  levels = c("Noun", "Adjective")
)

contrasts(form$source) <- contr.sum(2)
contrasts(form$sex) <- contr.sum(2)
contrasts(form$lexical_category) <- contr.sum(2)

extract_formant <- function(data, language_code, outcome, measure_name) {
  
  d <- data[
    data$language == language_code &
      !is.na(data[[outcome]]),
  ]
  
  d$target_vowel_for_F1F2 <- factor(d$target_vowel_for_F1F2)
  
  m <- lmer(
    as.formula(
      paste0(
        outcome,
        " ~ source * lexical_category + sex + ",
        "target_vowel_for_F1F2 + ",
        "(1 | session_id) + (1 | stimulus_id)"
      )
    ),
    data = d,
    REML = FALSE
  )
  
  x <- as.data.frame(
    contrast(
      emmeans(m, ~ source | lexical_category),
      "pairwise"
    )
  )
  
  x$language <- language_code
  x$measure <- measure_name
  x$unit <- "Percent"
  
  # HUMAN - TTS on log scale -> percentage difference
  x$estimate_raw <- x$estimate
  x$SE_raw <- x$SE
  
  x$estimate <- 100 * (exp(x$estimate_raw) - 1)
  
  # 95% CI on log scale, then back-transform
  crit <- qt(0.975, df = x$df)
  
  x$lower.CL <- 100 * (
    exp(x$estimate_raw - crit * x$SE_raw) - 1
  )
  
  x$upper.CL <- 100 * (
    exp(x$estimate_raw + crit * x$SE_raw) - 1
  )
  
  x
}

f1_en <- extract_formant(form, "EN", "log_f1", "F1")
f1_tr <- extract_formant(form, "TR", "log_f1", "F1")
f2_en <- extract_formant(form, "EN", "log_f2", "F2")
f2_tr <- extract_formant(form, "TR", "log_f2", "F2")

# -------------------------------------------------------------------------
# Add confidence intervals for F0 and intensity
# -------------------------------------------------------------------------

add_ci <- function(x) {
  
  crit <- qt(0.975, df = x$df)
  
  x$lower.CL <- x$estimate - crit * x$SE
  x$upper.CL <- x$estimate + crit * x$SE
  
  x
}

f0_con <- add_ci(f0_con)
int_con <- add_ci(int_con)

# -------------------------------------------------------------------------
# Combine
# -------------------------------------------------------------------------

keep <- c(
  "measure",
  "unit",
  "language",
  "lexical_category",
  "estimate",
  "SE",
  "df",
  "lower.CL",
  "upper.CL",
  "t.ratio",
  "p.value"
)

effect_summary <- bind_rows(
  f0_con[, keep],
  int_con[, keep],
  f1_en[, keep],
  f1_tr[, keep],
  f2_en[, keep],
  f2_tr[, keep]
)

effect_summary$language <- recode(
  effect_summary$language,
  EN = "English",
  TR = "Turkish"
)

write.csv(
  effect_summary,
  file.path(
    project_root,
    "03_analysis",
    "cross_cue_human_tts_effects.csv"
  ),
  row.names = FALSE
)

cat("\n--- CROSS-CUE HUMAN-TTS EFFECT SUMMARY ---\n")
print(effect_summary)

cat("\nCross-cue effect table created successfully.\n")