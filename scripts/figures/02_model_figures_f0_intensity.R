# 02_model_figures_f0_intensity.R
# Lexical Prominence QP1
# Model-derived F0 and intensity figures

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

library(lme4)
library(lmerTest)
library(emmeans)
library(ggplot2)
library(dplyr)

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

f0_emm <- as.data.frame(
  emmeans(
    m_f0_final,
    ~ source * language * lexical_category
  )
)

f0_emm$language <- factor(
  f0_emm$language,
  levels = c("EN", "TR"),
  labels = c("English", "Turkish")
)

p_f0 <- ggplot(
  f0_emm,
  aes(
    x = lexical_category,
    y = emmean,
    group = source,
    shape = source,
    linetype = source
  )
) +
  geom_line(
    position = position_dodge(width = 0.15),
    linewidth = 0.8
  ) +
  geom_point(
    position = position_dodge(width = 0.15),
    size = 3
  ) +
  geom_errorbar(
    aes(
      ymin = lower.CL,
      ymax = upper.CL
    ),
    position = position_dodge(width = 0.15),
    width = 0.08
  ) +
  facet_wrap(~ language) +
  geom_hline(
    yintercept = 0,
    linetype = "dotted"
  ) +
  labs(
    title = "Human and synthetic realization of relative F0",
    subtitle = "Model-estimated means with 95% confidence intervals",
    x = NULL,
    y = "Centered F0 (semitones)",
    shape = "Speech source",
    linetype = "Speech source"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    legend.position = "top"
  )

ggsave(
  file.path(
    project_root,
    "05_figures",
    "Figure_MODEL_01_F0_emmeans.png"
  ),
  p_f0,
  width = 9,
  height = 5.5,
  dpi = 400
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

int_emm <- as.data.frame(
  emmeans(
    m_int_final,
    ~ source * language * lexical_category
  )
)

int_emm$language <- factor(
  int_emm$language,
  levels = c("EN", "TR"),
  labels = c("English", "Turkish")
)

p_int <- ggplot(
  int_emm,
  aes(
    x = lexical_category,
    y = emmean,
    group = source,
    shape = source,
    linetype = source
  )
) +
  geom_line(
    position = position_dodge(width = 0.15),
    linewidth = 0.8
  ) +
  geom_point(
    position = position_dodge(width = 0.15),
    size = 3
  ) +
  geom_errorbar(
    aes(
      ymin = lower.CL,
      ymax = upper.CL
    ),
    position = position_dodge(width = 0.15),
    width = 0.08
  ) +
  facet_wrap(~ language) +
  geom_hline(
    yintercept = 0,
    linetype = "dotted"
  ) +
  labs(
    title = "Human and synthetic realization of relative intensity",
    subtitle = "Model-estimated means with 95% confidence intervals",
    x = NULL,
    y = "Centered intensity (dB)",
    shape = "Speech source",
    linetype = "Speech source"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    legend.position = "top"
  )

ggsave(
  file.path(
    project_root,
    "05_figures",
    "Figure_MODEL_02_intensity_emmeans.png"
  ),
  p_int,
  width = 9,
  height = 5.5,
  dpi = 400
)

cat("\nF0 and intensity model-derived figures created successfully.\n")