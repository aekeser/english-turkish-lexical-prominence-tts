# 01_qc_descriptive_figures.R
# Lexical Prominence QP1
# Neutral QC and descriptive figures.
# No inferential statistics are performed here.

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

# -------------------------------------------------------------------------
# Packages
# -------------------------------------------------------------------------

library(ggplot2)
library(dplyr)
library(tidyr)

dat <- read.csv(
  file.path(
    project_root,
    "01_preprocessing",
    "analysis_qc_ready.csv"
  )
)

figure_dir <- file.path(project_root, "05_figures")

# Common theme
qp_theme <- theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold"),
    plot.subtitle = element_text(size = 11),
    panel.grid.minor = element_blank(),
    legend.position = "top"
  )

# =========================================================================
# FIGURE 1: Measure-specific data retention
# =========================================================================

retention <- data.frame(
  measure = c(
    "Localization",
    "F0",
    "F0 strict",
    "Intensity",
    "F1",
    "F2",
    "F1 + F2"
  ),
  retained = c(
    sum(dat$localization_usable == 1),
    sum(dat$f0_usable == 1),
    sum(dat$f0_strict_accepted == 1),
    sum(dat$intensity_usable == 1),
    sum(dat$f1_analysis_usable == 1),
    sum(dat$f2_analysis_usable == 1),
    sum(dat$joint_formant_analysis_usable == 1)
  )
)

retention$total <- nrow(dat)
retention$pct <- 100 * retention$retained / retention$total

retention$measure <- factor(
  retention$measure,
  levels = rev(retention$measure)
)

p1 <- ggplot(
  retention,
  aes(
    x = measure,
    y = pct
  )
) +
  geom_col(width = 0.7) +
  geom_text(
    aes(
      label = sprintf(
        "%d / %d\n(%.1f%%)",
        retained,
        total,
        pct
      )
    ),
    hjust = -0.05,
    size = 4
  ) +
  coord_flip() +
  scale_y_continuous(
    limits = c(0, 108),
    breaks = seq(0, 100, 20),
    expand = c(0, 0)
  ) +
  labs(
    title = "Measure-specific data retention",
    subtitle = "Retention after localization and QP1 measure-specific quality control",
    x = NULL,
    y = "Retained observations (%)"
  ) +
  qp_theme

ggsave(
  file.path(
    figure_dir,
    "Figure_QC_01_measure_retention.png"
  ),
  p1,
  width = 9,
  height = 5.5,
  dpi = 400
)

# =========================================================================
# FIGURE 2: F0 usability heatmap
# =========================================================================

f0_heat <- dat %>%
  group_by(
    source,
    language,
    sex
  ) %>%
  summarise(
    n_total = n(),
    n_usable = sum(f0_usable == 1),
    pct_usable = 100 * mean(f0_usable == 1),
    .groups = "drop"
  ) %>%
  mutate(
    group = paste(
      language,
      sex,
      sep = " / "
    )
  )

p2 <- ggplot(
  f0_heat,
  aes(
    x = source,
    y = group,
    fill = pct_usable
  )
) +
  geom_tile() +
  geom_text(
    aes(
      label = sprintf(
        "%.1f%%\n%d/%d",
        pct_usable,
        n_usable,
        n_total
      )
    ),
    size = 4
  ) +
  scale_fill_viridis_c(
    limits = c(0, 100),
    name = "Usable (%)"
  ) +
  labs(
    title = "F0 usability by source, language, and sex",
    subtitle = "Measure-specific retention prior to inferential analysis",
    x = NULL,
    y = NULL
  ) +
  qp_theme

ggsave(
  file.path(
    figure_dir,
    "Figure_QC_02_f0_usability_heatmap.png"
  ),
  p2,
  width = 7.5,
  height = 5.5,
  dpi = 400
)

# =========================================================================
# FIGURE 3: Formant retention heatmap
# =========================================================================

formant_heat <- dat %>%
  group_by(
    source,
    language,
    sex
  ) %>%
  summarise(
    total = n(),
    f1_pct = 100 * mean(f1_analysis_usable),
    f2_pct = 100 * mean(f2_analysis_usable),
    joint_pct = 100 * mean(joint_formant_analysis_usable),
    .groups = "drop"
  ) %>%
  pivot_longer(
    cols = c(
      f1_pct,
      f2_pct,
      joint_pct
    ),
    names_to = "measure",
    values_to = "pct"
  ) %>%
  mutate(
    measure = recode(
      measure,
      f1_pct = "F1",
      f2_pct = "F2",
      joint_pct = "F1 + F2"
    ),
    group = paste(
      source,
      language,
      sex,
      sep = " / "
    )
  )

p3 <- ggplot(
  formant_heat,
  aes(
    x = measure,
    y = group,
    fill = pct
  )
) +
  geom_tile() +
  geom_text(
    aes(
      label = sprintf("%.1f%%", pct)
    ),
    size = 4
  ) +
  scale_fill_viridis_c(
    limits = c(0, 100),
    name = "Retained (%)"
  ) +
  labs(
    title = "Formant retention after QP1 post-extraction QC",
    subtitle = "F1 and F2 are retained independently; joint retention requires both",
    x = NULL,
    y = NULL
  ) +
  qp_theme

ggsave(
  file.path(
    figure_dir,
    "Figure_QC_03_formant_retention_heatmap.png"
  ),
  p3,
  width = 8.5,
  height = 6,
  dpi = 400
)

# =========================================================================
# FIGURE 4: F0 distributions
# =========================================================================

f0_plot_dat <- dat %>%
  filter(f0_usable == 1) %>%
  mutate(
    source = factor(
      source,
      levels = c("HUMAN", "TTS")
    )
  )

p4 <- ggplot(
  f0_plot_dat,
  aes(
    x = source,
    y = mean_f0,
    fill = source
  )
) +
  geom_violin(
    trim = FALSE,
    alpha = 0.65
  ) +
  geom_boxplot(
    width = 0.16,
    outlier.shape = NA,
    alpha = 0.8
  ) +
  facet_grid(
    language ~ sex
  ) +
  labs(
    title = "Distribution of mean F0",
    subtitle = "Usable F0 observations only",
    x = NULL,
    y = "Mean F0 (Hz)",
    fill = "Source"
  ) +
  qp_theme

ggsave(
  file.path(
    figure_dir,
    "Figure_DESC_01_f0_distribution.png"
  ),
  p4,
  width = 9,
  height = 7,
  dpi = 400
)

# =========================================================================
# FIGURE 5: Intensity distributions
# =========================================================================

int_plot_dat <- dat %>%
  filter(intensity_usable == 1) %>%
  mutate(
    source = factor(
      source,
      levels = c("HUMAN", "TTS")
    )
  )

p5 <- ggplot(
  int_plot_dat,
  aes(
    x = source,
    y = mean_intensity,
    fill = source
  )
) +
  geom_violin(
    trim = FALSE,
    alpha = 0.65
  ) +
  geom_boxplot(
    width = 0.16,
    outlier.shape = NA,
    alpha = 0.8
  ) +
  facet_grid(
    language ~ sex
  ) +
  labs(
    title = "Distribution of mean intensity",
    subtitle = "Usable intensity observations only",
    x = NULL,
    y = "Mean intensity (dB)",
    fill = "Source"
  ) +
  qp_theme

ggsave(
  file.path(
    figure_dir,
    "Figure_DESC_02_intensity_distribution.png"
  ),
  p5,
  width = 9,
  height = 7,
  dpi = 400
)

cat("\nFive QC/descriptive figures generated successfully.\n")
cat("Output directory:", figure_dir, "\n")