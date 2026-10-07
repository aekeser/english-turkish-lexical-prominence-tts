# 05_vowel_space_human_tts.R
# Lexical Prominence QP1
# Publication-quality descriptive Human-TTS vowel-space comparison

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

library(ggplot2)
library(dplyr)
library(ggrepel)

dat <- read.csv(
  file.path(
    project_root,
    "01_preprocessing",
    "analysis_qc_ready.csv"
  )
)

# ============================================================
# Jointly QC-passing observations
# ============================================================

vowel_dat <- dat %>%
  filter(
    joint_formant_analysis_usable == TRUE,
    !is.na(f1),
    !is.na(f2)
  ) %>%
  mutate(
    source = factor(
      source,
      levels = c("HUMAN", "TTS"),
      labels = c("Human", "TTS")
    ),
    language_label = factor(
      language,
      levels = c("EN", "TR"),
      labels = c("English", "Turkish")
    ),
    sex_label = factor(
      sex,
      levels = c("F", "M"),
      labels = c("Female", "Male")
    ),
    
    # IPA labels
    vowel_ipa = case_when(
      
      # English
      language == "EN" &
        target_vowel_for_F1F2 == "AA" ~ "ɑ",
      
      language == "EN" &
        target_vowel_for_F1F2 == "AE" ~ "æ",
      
      language == "EN" &
        target_vowel_for_F1F2 == "AO" ~ "ɔ",
      
      language == "EN" &
        target_vowel_for_F1F2 == "EH" ~ "ɛ",
      
      language == "EN" &
        target_vowel_for_F1F2 == "EY" ~ "eɪ",
      
      language == "EN" &
        target_vowel_for_F1F2 == "IH" ~ "ɪ",
      
      language == "EN" &
        target_vowel_for_F1F2 == "IY" ~ "i",
      
      language == "EN" &
        target_vowel_for_F1F2 == "UW" ~ "u",
      
      # Turkish
      language == "TR" &
        target_vowel_for_F1F2 == "a" ~ "a",
      
      language == "TR" &
        target_vowel_for_F1F2 == "e" ~ "e",
      
      language == "TR" &
        target_vowel_for_F1F2 == "i" ~ "i",
      
      language == "TR" &
        target_vowel_for_F1F2 == "ı" ~ "ɯ",
      
      language == "TR" &
        target_vowel_for_F1F2 == "o" ~ "o",
      
      language == "TR" &
        target_vowel_for_F1F2 == "u" ~ "u",
      
      TRUE ~ target_vowel_for_F1F2
    )
  )

# ============================================================
# Vowel centroids
# ============================================================

vowel_means <- vowel_dat %>%
  group_by(
    language_label,
    sex_label,
    source,
    target_vowel_for_F1F2,
    vowel_ipa
  ) %>%
  summarise(
    n = n(),
    mean_f1 = mean(f1),
    mean_f2 = mean(f2),
    .groups = "drop"
  )

# ============================================================
# Human -> TTS displacement vectors
# ============================================================

human_centroids <- vowel_means %>%
  filter(source == "Human") %>%
  select(
    language_label,
    sex_label,
    target_vowel_for_F1F2,
    vowel_ipa,
    human_f1 = mean_f1,
    human_f2 = mean_f2
  )

tts_centroids <- vowel_means %>%
  filter(source == "TTS") %>%
  select(
    language_label,
    sex_label,
    target_vowel_for_F1F2,
    tts_f1 = mean_f1,
    tts_f2 = mean_f2
  )

vectors <- left_join(
  human_centroids,
  tts_centroids,
  by = c(
    "language_label",
    "sex_label",
    "target_vowel_for_F1F2"
  )
) %>%
  mutate(
    label_f1 = (human_f1 + tts_f1) / 2,
    label_f2 = (human_f2 + tts_f2) / 2
  )

# ============================================================
# Plot
# ============================================================

p <- ggplot() +
  
  # Human -> TTS displacement
  geom_segment(
    data = vectors,
    aes(
      x = human_f2,
      y = human_f1,
      xend = tts_f2,
      yend = tts_f1
    ),
    linewidth = 0.85,
    alpha = 0.55,
    color = "grey40",
    arrow = arrow(
      length = unit(0.12, "inches"),
      type = "closed"
    )
  ) +
  
  # Centroids
  geom_point(
    data = vowel_means,
    aes(
      x = mean_f2,
      y = mean_f1,
      color = source,
      shape = source
    ),
    size = 4.3,
    stroke = 1.2
  ) +
  
  # IPA vowel labels
  geom_label_repel(
    data = vectors,
    aes(
      x = label_f2,
      y = label_f1,
      label = vowel_ipa
    ),
    size = 5,
    fontface = "bold",
    label.size = 0,
    fill = alpha("white", 0.75),
    box.padding = 0.35,
    point.padding = 0.25,
    min.segment.length = 0,
    max.overlaps = Inf,
    seed = 42
  ) +
  
  # Conventional acoustic vowel-space orientation
  scale_x_reverse() +
  scale_y_reverse() +
  
  # Explicit color + shape coding
  scale_color_manual(
    values = c(
      "Human" = "#2166AC",
      "TTS" = "#D6604D"
    )
  ) +
  
  scale_shape_manual(
    values = c(
      "Human" = 16,
      "TTS" = 17
    )
  ) +
  
  facet_grid(
    language_label ~ sex_label
  ) +
  
  coord_equal() +
  
  labs(
    title = "Human and synthetic vowel spaces in English and Turkish",
    subtitle =
      "QC-passing vowel centroids; arrows indicate displacement from Human to TTS realizations",
    x = "F2 (Hz)  ←  fronter",
    y = "F1 (Hz)  ←  higher",
    color = "Speech source",
    shape = "Speech source"
  ) +
  
  theme_minimal(base_size = 14) +
  
  theme(
    plot.title = element_text(
      face = "bold",
      size = 17
    ),
    plot.subtitle = element_text(
      size = 11,
      margin = margin(b = 12)
    ),
    strip.text = element_text(
      face = "bold",
      size = 13
    ),
    strip.background = element_rect(
      fill = "grey95",
      color = NA
    ),
    legend.position = "top",
    legend.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(
      linewidth = 0.35,
      color = "grey88"
    ),
    panel.border = element_rect(
      fill = NA,
      linewidth = 0.6,
      color = "grey45"
    ),
    axis.title = element_text(
      face = "bold"
    )
  )

ggsave(
  file.path(
    project_root,
    "05_figures",
    "Figure_DESC_03_Human_TTS_vowel_space.png"
  ),
  p,
  width = 12,
  height = 8.5,
  dpi = 500
)

# ============================================================
# Save centroid data
# ============================================================

write.csv(
  vowel_means,
  file.path(
    project_root,
    "06_tables",
    "Table_DESCRIPTIVE_vowel_centroids.csv"
  ),
  row.names = FALSE
)

cat("\nEnhanced IPA vowel-space figure created successfully.\n")
cat("Joint-QC observations used:", nrow(vowel_dat), "\n")