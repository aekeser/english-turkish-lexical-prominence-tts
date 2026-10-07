# 07_3D_intensity_and_PCA.R
# Lexical Prominence QP1
#
# Supplementary interactive visualizations:
# A. F2 x F1 x centered intensity
# B. PCA of multidimensional acoustic cue space
#
# DESCRIPTIVE / EXPLORATORY ONLY

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
# Shared preparation
# ============================================================

dat <- dat %>%
  mutate(
    source_label = factor(
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
# PART A
# 3D VOWEL SPACE WITH INTENSITY
# ============================================================

int3d <- dat %>%
  filter(
    joint_formant_analysis_usable == TRUE,
    intensity_usable == 1,
    !is.na(f1),
    !is.na(f2),
    !is.na(intensity_centered)
  )

int_centroids <- int3d %>%
  group_by(
    language_label,
    sex_label,
    source_label,
    target_vowel_for_F1F2,
    vowel_ipa
  ) %>%
  summarise(
    n = n(),
    mean_f1 = mean(f1),
    mean_f2 = mean(f2),
    mean_intensity = mean(intensity_centered),
    .groups = "drop"
  )

make_intensity_3d <- function(language_name, sex_name) {
  
  d <- int_centroids %>%
    filter(
      language_label == language_name,
      sex_label == sex_name
    )
  
  human <- d %>%
    filter(source_label == "Human") %>%
    select(
      target_vowel_for_F1F2,
      human_f1 = mean_f1,
      human_f2 = mean_f2,
      human_int = mean_intensity
    )
  
  tts <- d %>%
    filter(source_label == "TTS") %>%
    select(
      target_vowel_for_F1F2,
      tts_f1 = mean_f1,
      tts_f2 = mean_f2,
      tts_int = mean_intensity
    )
  
  vectors <- left_join(
    human,
    tts,
    by = "target_vowel_for_F1F2"
  )
  
  human_pts <- d %>%
    filter(source_label == "Human")
  
  tts_pts <- d %>%
    filter(source_label == "TTS")
  
  p <- plot_ly()
  
  p <- add_trace(
    p,
    data = human_pts,
    x = ~mean_f2,
    y = ~mean_f1,
    z = ~mean_intensity,
    type = "scatter3d",
    mode = "markers+text",
    text = ~vowel_ipa,
    textposition = "top center",
    name = "Human",
    marker = list(
      size = 6,
      symbol = "circle",
      color = "#2166AC"
    ),
    hovertemplate = paste0(
      "<b>%{text}</b><br>",
      "F2: %{x:.1f} Hz<br>",
      "F1: %{y:.1f} Hz<br>",
      "Centered intensity: %{z:.2f} dB",
      "<extra>Human</extra>"
    )
  )
  
  p <- add_trace(
    p,
    data = tts_pts,
    x = ~mean_f2,
    y = ~mean_f1,
    z = ~mean_intensity,
    type = "scatter3d",
    mode = "markers+text",
    text = ~vowel_ipa,
    textposition = "bottom center",
    name = "TTS",
    marker = list(
      size = 6,
      symbol = "diamond",
      color = "#D6604D"
    ),
    hovertemplate = paste0(
      "<b>%{text}</b><br>",
      "F2: %{x:.1f} Hz<br>",
      "F1: %{y:.1f} Hz<br>",
      "Centered intensity: %{z:.2f} dB",
      "<extra>TTS</extra>"
    )
  )
  
  for (i in seq_len(nrow(vectors))) {
    
    p <- add_trace(
      p,
      x = c(vectors$human_f2[i], vectors$tts_f2[i]),
      y = c(vectors$human_f1[i], vectors$tts_f1[i]),
      z = c(vectors$human_int[i], vectors$tts_int[i]),
      type = "scatter3d",
      mode = "lines",
      line = list(
        width = 4,
        color = "rgba(90,90,90,0.55)"
      ),
      showlegend = FALSE,
      hoverinfo = "skip"
    )
  }
  
  layout(
    p,
    title = paste(
      language_name,
      sex_name,
      "F1-F2-intensity space"
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
        title = "Centered intensity (dB)"
      ),
      camera = list(
        eye = list(
          x = 1.45,
          y = 1.45,
          z = 1.15
        )
      )
    )
  )
}

intensity_plots <- list(
  EN_F = make_intensity_3d("English", "Female"),
  EN_M = make_intensity_3d("English", "Male"),
  TR_F = make_intensity_3d("Turkish", "Female"),
  TR_M = make_intensity_3d("Turkish", "Male")
)

saveWidget(
  intensity_plots$EN_F,
  file.path(
    project_root,
    "05_figures",
    "Figure_3D_05_EN_Female_F1F2_Intensity.html"
  ),
  selfcontained = TRUE
)

saveWidget(
  intensity_plots$EN_M,
  file.path(
    project_root,
    "05_figures",
    "Figure_3D_06_EN_Male_F1F2_Intensity.html"
  ),
  selfcontained = TRUE
)

saveWidget(
  intensity_plots$TR_F,
  file.path(
    project_root,
    "05_figures",
    "Figure_3D_07_TR_Female_F1F2_Intensity.html"
  ),
  selfcontained = TRUE
)

saveWidget(
  intensity_plots$TR_M,
  file.path(
    project_root,
    "05_figures",
    "Figure_3D_08_TR_Male_F1F2_Intensity.html"
  ),
  selfcontained = TRUE
)

# ============================================================
# PART B
# PCA OF MULTIDIMENSIONAL ACOUSTIC SPACE
# ============================================================
#
# Use complete cases only:
# centered F0
# centered intensity
# log F1
# log F2
#
# F1/F2 must both pass QC.

pca_dat <- dat %>%
  filter(
    joint_formant_analysis_usable == TRUE,
    f0_usable == 1,
    intensity_usable == 1,
    !is.na(f0_st_centered),
    !is.na(intensity_centered),
    !is.na(f1),
    !is.na(f2)
  ) %>%
  mutate(
    log_f1 = log(f1),
    log_f2 = log(f2)
  )

# PCA variables
pca_matrix <- pca_dat %>%
  select(
    f0_st_centered,
    intensity_centered,
    log_f1,
    log_f2
  )

pca_fit <- prcomp(
  pca_matrix,
  center = TRUE,
  scale. = TRUE
)

pca_scores <- as.data.frame(pca_fit$x)

pca_plot_dat <- bind_cols(
  pca_dat %>%
    select(
      source_label,
      language_label,
      sex_label,
      lexical_category,
      stimulus_id,
      word,
      vowel_ipa
    ),
  pca_scores
)

# Variance explained
variance_explained <-
  100 *
  pca_fit$sdev^2 /
  sum(pca_fit$sdev^2)

cat("\n--- PCA VARIANCE EXPLAINED ---\n")
print(
  round(
    variance_explained,
    2
  )
)

cat("\n--- PCA LOADINGS ---\n")
print(
  round(
    pca_fit$rotation,
    3
  )
)

# ============================================================
# Interactive 3D PCA plot
# ============================================================

p_pca <- plot_ly(
  data = pca_plot_dat,
  x = ~PC1,
  y = ~PC2,
  z = ~PC3,
  color = ~source_label,
  colors = c(
    "Human" = "#2166AC",
    "TTS" = "#D6604D"
  ),
  symbol = ~language_label,
  symbols = c(
    "English" = "circle",
    "Turkish" = "diamond"
  ),
  type = "scatter3d",
  mode = "markers",
  marker = list(
    size = 3.5,
    opacity = 0.65
  ),
  text = ~paste0(
    "<b>", word, "</b>",
    "<br>Language: ", language_label,
    "<br>Source: ", source_label,
    "<br>Sex: ", sex_label,
    "<br>Category: ", lexical_category,
    "<br>Vowel: /", vowel_ipa, "/"
  ),
  hoverinfo = "text"
)

p_pca <- layout(
  p_pca,
  title = "Exploratory multidimensional acoustic space",
  scene = list(
    xaxis = list(
      title = paste0(
        "PC1 (",
        round(variance_explained[1], 1),
        "%)"
      )
    ),
    yaxis = list(
      title = paste0(
        "PC2 (",
        round(variance_explained[2], 1),
        "%)"
      )
    ),
    zaxis = list(
      title = paste0(
        "PC3 (",
        round(variance_explained[3], 1),
        "%)"
      )
    )
  )
)

saveWidget(
  p_pca,
  file.path(
    project_root,
    "05_figures",
    "Figure_3D_09_exploratory_acoustic_PCA.html"
  ),
  selfcontained = TRUE
)

# ============================================================
# Save PCA loadings and variance tables
# ============================================================

loadings_table <- data.frame(
  acoustic_measure = rownames(pca_fit$rotation),
  pca_fit$rotation,
  row.names = NULL
)

write.csv(
  loadings_table,
  file.path(
    project_root,
    "06_tables",
    "Table_EXPLORATORY_PCA_loadings.csv"
  ),
  row.names = FALSE
)

variance_table <- data.frame(
  component = paste0(
    "PC",
    seq_along(variance_explained)
  ),
  variance_percent = variance_explained,
  cumulative_percent = cumsum(variance_explained)
)

write.csv(
  variance_table,
  file.path(
    project_root,
    "06_tables",
    "Table_EXPLORATORY_PCA_variance.csv"
  ),
  row.names = FALSE
)

cat("\n3D intensity vowel spaces created successfully.\n")
cat("Exploratory 3D acoustic PCA created successfully.\n")
cat("PCA complete-case N:", nrow(pca_dat), "\n")