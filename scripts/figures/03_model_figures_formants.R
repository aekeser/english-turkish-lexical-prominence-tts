# 03_model_figures_formants.R
# Lexical Prominence QP1
# Model-derived F1/F2 figures for English and Turkish.

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

library(lme4)
library(lmerTest)
library(emmeans)
library(ggplot2)

dat <- read.csv(
  file.path(
    project_root,
    "03_analysis",
    "analysis_formant_model_ready.csv"
  )
)

dat$source <- factor(dat$source, levels = c("HUMAN", "TTS"))
dat$sex <- factor(dat$sex, levels = c("F", "M"))
dat$lexical_category <- factor(
  dat$lexical_category,
  levels = c("Noun", "Adjective")
)

contrasts(dat$source) <- contr.sum(2)
contrasts(dat$sex) <- contr.sum(2)
contrasts(dat$lexical_category) <- contr.sum(2)

plot_formant <- function(data, outcome, language_code, language_label, formant_label) {
  
  d <- data[
    data$language == language_code &
      !is.na(data[[outcome]]),
  ]
  
  d$target_vowel_for_F1F2 <- factor(d$target_vowel_for_F1F2)
  
  model <- lmer(
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
  
  emm <- as.data.frame(
    emmeans(
      model,
      ~ source * lexical_category
    )
  )
  
  # Back-transform log-Hz estimates
  emm$estimate_hz <- exp(emm$emmean)
  emm$lower_hz <- exp(emm$lower.CL)
  emm$upper_hz <- exp(emm$upper.CL)
  
  p <- ggplot(
    emm,
    aes(
      x = lexical_category,
      y = estimate_hz,
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
        ymin = lower_hz,
        ymax = upper_hz
      ),
      position = position_dodge(width = 0.15),
      width = 0.08
    ) +
    labs(
      title = paste0(
        language_label,
        ": Human and synthetic ",
        formant_label
      ),
      subtitle = "Model-estimated marginal means with 95% confidence intervals",
      x = NULL,
      y = paste0(formant_label, " (Hz)"),
      shape = "Speech source",
      linetype = "Speech source"
    ) +
    theme_minimal(base_size = 13) +
    theme(
      plot.title = element_text(face = "bold"),
      panel.grid.minor = element_blank(),
      legend.position = "top"
    )
  
  list(
    model = model,
    emm = emm,
    plot = p
  )
}

# English F1
en_f1_fig <- plot_formant(
  dat,
  "log_f1",
  "EN",
  "English",
  "F1"
)

ggsave(
  file.path(
    project_root,
    "05_figures",
    "Figure_MODEL_03_EN_F1_emmeans.png"
  ),
  en_f1_fig$plot,
  width = 7.5,
  height = 5.5,
  dpi = 400
)

# English F2
en_f2_fig <- plot_formant(
  dat,
  "log_f2",
  "EN",
  "English",
  "F2"
)

ggsave(
  file.path(
    project_root,
    "05_figures",
    "Figure_MODEL_04_EN_F2_emmeans.png"
  ),
  en_f2_fig$plot,
  width = 7.5,
  height = 5.5,
  dpi = 400
)

# Turkish F1
tr_f1_fig <- plot_formant(
  dat,
  "log_f1",
  "TR",
  "Turkish",
  "F1"
)

ggsave(
  file.path(
    project_root,
    "05_figures",
    "Figure_MODEL_05_TR_F1_emmeans.png"
  ),
  tr_f1_fig$plot,
  width = 7.5,
  height = 5.5,
  dpi = 400
)

# Turkish F2
tr_f2_fig <- plot_formant(
  dat,
  "log_f2",
  "TR",
  "Turkish",
  "F2"
)

ggsave(
  file.path(
    project_root,
    "05_figures",
    "Figure_MODEL_06_TR_F2_emmeans.png"
  ),
  tr_f2_fig$plot,
  width = 7.5,
  height = 5.5,
  dpi = 400
)

cat("\nFour formant model-derived figures created successfully.\n")