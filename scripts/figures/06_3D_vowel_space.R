# 06_3D_vowel_space.R
# Lexical Prominence QP1
# Interactive 3D vowel-space visualizations
# x = F2, y = F1, z = centered F0 (semitones)

project_root <- "C:/Users/emrek/OneDrive/Masaüstü/Lexical_Prominence_QP1"

library(dplyr)
library(plotly)
library(htmlwidgets)

dat <- read.csv(
  file.path(
    project_root,
    "03_analysis",
    "analysis_model_ready.csv"
  )
)

# ============================================================
# Prepare jointly usable observations
# ============================================================

vowel3d <- dat %>%
  filter(
    joint_formant_analysis_usable == TRUE,
    !is.na(f1),
    !is.na(f2),
    !is.na(f0_st_centered)
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
    vowel_ipa = case_when(
      language == "EN" & target_vowel_for_F1F2 == "AA" ~ "ɑ",
      language == "EN" & target_vowel_for_F1F2 == "AE" ~ "æ",
      language == "EN" & target_vowel_for_F1F2 == "AO" ~ "ɔ",
      language == "EN" & target_vowel_for_F1F2 == "EH" ~ "ɛ",
      language == "EN" & target_vowel_for_F1F2 == "EY" ~ "eɪ",
      language == "EN" & target_vowel_for_F1F2 == "IH" ~ "ɪ",
      language == "EN" & target_vowel_for_F1F2 == "IY" ~ "i",
      language == "EN" & target_vowel_for_F1F2 == "UW" ~ "u",
      
      language == "TR" & target_vowel_for_F1F2 == "a" ~ "a",
      language == "TR" & target_vowel_for_F1F2 == "e" ~ "e",
      language == "TR" & target_vowel_for_F1F2 == "i" ~ "i",
      language == "TR" & target_vowel_for_F1F2 == "ı" ~ "ɯ",
      language == "TR" & target_vowel_for_F1F2 == "o" ~ "o",
      language == "TR" & target_vowel_for_F1F2 == "u" ~ "u",
      
      TRUE ~ target_vowel_for_F1F2
    )
  )

# ============================================================
# Mean vowel centroids
# ============================================================

centroids3d <- vowel3d %>%
  group_by(
    language_label,
    sex_label,
    source,
    target_vowel_for_F1F2,
    vowel_ipa
  ) %>%
  summarise(
    n = n(),
    mean_f1 = mean(f1, na.rm = TRUE),
    mean_f2 = mean(f2, na.rm = TRUE),
    mean_f0_st = mean(f0_st_centered, na.rm = TRUE),
    .groups = "drop"
  )

# ============================================================
# Helper: make one interactive 3D plot
# ============================================================

make_3d_plot <- function(language_name, sex_name) {
  
  d <- centroids3d %>%
    filter(
      language_label == language_name,
      sex_label == sex_name
    )
  
  human <- d %>%
    filter(source == "Human") %>%
    select(
      target_vowel_for_F1F2,
      vowel_ipa,
      human_f1 = mean_f1,
      human_f2 = mean_f2,
      human_f0 = mean_f0_st
    )
  
  tts <- d %>%
    filter(source == "TTS") %>%
    select(
      target_vowel_for_F1F2,
      tts_f1 = mean_f1,
      tts_f2 = mean_f2,
      tts_f0 = mean_f0_st
    )
  
  vectors <- left_join(
    human,
    tts,
    by = "target_vowel_for_F1F2"
  )
  
  p <- plot_ly()
  
  # Human points
  human_pts <- d %>% filter(source == "Human")
  
  p <- add_trace(
    p,
    data = human_pts,
    x = ~mean_f2,
    y = ~mean_f1,
    z = ~mean_f0_st,
    type = "scatter3d",
    mode = "markers+text",
    text = ~vowel_ipa,
    textposition = "top center",
    name = "Human",
    marker = list(
      size = 6,
      symbol = "circle"
    ),
    hovertemplate = paste0(
      "<b>%{text}</b><br>",
      "F2: %{x:.1f} Hz<br>",
      "F1: %{y:.1f} Hz<br>",
      "Centered F0: %{z:.2f} ST",
      "<extra>Human</extra>"
    )
  )
  
  # TTS points
  tts_pts <- d %>% filter(source == "TTS")
  
  p <- add_trace(
    p,
    data = tts_pts,
    x = ~mean_f2,
    y = ~mean_f1,
    z = ~mean_f0_st,
    type = "scatter3d",
    mode = "markers+text",
    text = ~vowel_ipa,
    textposition = "bottom center",
    name = "TTS",
    marker = list(
      size = 6,
      symbol = "diamond"
    ),
    hovertemplate = paste0(
      "<b>%{text}</b><br>",
      "F2: %{x:.1f} Hz<br>",
      "F1: %{y:.1f} Hz<br>",
      "Centered F0: %{z:.2f} ST",
      "<extra>TTS</extra>"
    )
  )
  
  # Human -> TTS displacement vectors
  for (i in seq_len(nrow(vectors))) {
    
    p <- add_trace(
      p,
      x = c(
        vectors$human_f2[i],
        vectors$tts_f2[i]
      ),
      y = c(
        vectors$human_f1[i],
        vectors$tts_f1[i]
      ),
      z = c(
        vectors$human_f0[i],
        vectors$tts_f0[i]
      ),
      type = "scatter3d",
      mode = "lines",
      line = list(
        width = 4
      ),
      showlegend = FALSE,
      hoverinfo = "skip"
    )
  }
  
  p <- layout(
    p,
    title = paste(
      language_name,
      sex_name,
      "Human–TTS vowel space"
    ),
    scene = list(
      xaxis = list(
        title = "F2 (Hz)",
        autorange = "reversed"
      ),
      yaxis = list(
        title = "F1 (Hz)",
        autorange = "reversed"
      ),
      zaxis = list(
        title = "Centered F0 (semitones)"
      ),
      camera = list(
        eye = list(
          x = 1.45,
          y = 1.45,
          z = 1.15
        )
      )
    ),
    legend = list(
      orientation = "h",
      x = 0.35,
      y = 1.05
    )
  )
  
  p
}

# ============================================================
# Generate four plots
# ============================================================

plots <- list(
  EN_F = make_3d_plot("English", "Female"),
  EN_M = make_3d_plot("English", "Male"),
  TR_F = make_3d_plot("Turkish", "Female"),
  TR_M = make_3d_plot("Turkish", "Male")
)

# ============================================================
# Save interactive HTML files
# ============================================================

saveWidget(
  plots$EN_F,
  file.path(
    project_root,
    "05_figures",
    "Figure_3D_01_EN_Female_vowel_space.html"
  ),
  selfcontained = TRUE
)

saveWidget(
  plots$EN_M,
  file.path(
    project_root,
    "05_figures",
    "Figure_3D_02_EN_Male_vowel_space.html"
  ),
  selfcontained = TRUE
)

saveWidget(
  plots$TR_F,
  file.path(
    project_root,
    "05_figures",
    "Figure_3D_03_TR_Female_vowel_space.html"
  ),
  selfcontained = TRUE
)

saveWidget(
  plots$TR_M,
  file.path(
    project_root,
    "05_figures",
    "Figure_3D_04_TR_Male_vowel_space.html"
  ),
  selfcontained = TRUE
)

cat("\nFour interactive 3D vowel-space plots created successfully.\n")