# 04_cross_cue_human_tts_summary.R
# Lexical Prominence QP1
# Cross-cue Human-TTS discrepancy figure for RQ3.

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

library(ggplot2)
library(dplyr)

effects <- read.csv(
  file.path(
    project_root,
    "03_analysis",
    "cross_cue_human_tts_effects.csv"
  )
)

# -------------------------------------------------------------------------
# Display variables
# -------------------------------------------------------------------------

effects <- effects %>%
  mutate(
    condition = paste(language, lexical_category, sep = " — "),
    measure_label = factor(
      measure,
      levels = c("F0", "Intensity", "F1", "F2"),
      labels = c(
        "F0 (semitones)",
        "Intensity (dB)",
        "F1 (% difference)",
        "F2 (% difference)"
      )
    ),
    condition = factor(
      condition,
      levels = c(
        "Turkish — Adjective",
        "Turkish — Noun",
        "English — Adjective",
        "English — Noun"
      )
    )
  )

# -------------------------------------------------------------------------
# Plot
# Positive values mean Human > TTS.
# Each facet has its own x-axis because units differ.
# -------------------------------------------------------------------------

p <- ggplot(
  effects,
  aes(
    x = estimate,
    y = condition,
    shape = lexical_category
  )
) +
  geom_vline(
    xintercept = 0,
    linetype = "dashed",
    linewidth = 0.6
  ) +
  geom_errorbarh(
    aes(
      xmin = lower.CL,
      xmax = upper.CL
    ),
    height = 0.12,
    linewidth = 0.7
  ) +
  geom_point(
    size = 3
  ) +
  facet_wrap(
    ~ measure_label,
    scales = "free_x",
    ncol = 2
  ) +
  labs(
    title = "Human–TTS differences across acoustic dimensions",
    subtitle = "Model-estimated contrasts with 95% confidence intervals; positive values indicate Human > TTS",
    x = "Estimated Human–TTS difference",
    y = NULL,
    shape = "Lexical category"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold"),
    plot.subtitle = element_text(size = 11),
    panel.grid.minor = element_blank(),
    legend.position = "top",
    strip.text = element_text(face = "bold")
  )

ggsave(
  file.path(
    project_root,
    "05_figures",
    "Figure_MODEL_07_cross_cue_human_tts_summary.png"
  ),
  p,
  width = 11,
  height = 7.5,
  dpi = 400
)

cat("\nCross-cue Human-TTS summary figure created successfully.\n")