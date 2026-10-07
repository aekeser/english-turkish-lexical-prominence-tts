# Supplementary Materials Guide

This document provides a guide to the supplementary figures, interactive visualizations, derived results, and analysis resources accompanying the qualifying-paper study:

**Acoustic Implementation of Lexical Prominence in Human and Synthetic Speech: A Cross-Linguistic Comparison of English and Turkish**

The supplementary materials are intended to support transparency and interpretation without requiring the public release of raw Human recordings or participant-level data.

## Main Figures

The `figures/main/` directory contains the three principal visualizations used in the qualifying paper.

### F0 Model Estimates

`Figure_MODEL_01_F0_emmeans.png`

Model-estimated Human–TTS F0 patterns across English and Turkish nouns and adjectives.

### Intensity Model Estimates

`Figure_MODEL_02_intensity_emmeans.png`

Model-estimated Human–TTS intensity patterns across English and Turkish nouns and adjectives.

### Human–TTS Vowel Spaces

`Figure_DESC_03_Human_TTS_vowel_space.png`

Two-dimensional F1–F2 representations of Human and TTS target-vowel realizations. These plots provide a descriptive view of vowel-space organization and source-related spectral displacement.

## Supplementary Static Figures

The `figures/supplementary/` directory contains additional descriptive, inferential, and quality-control visualizations.

### Acoustic Distributions

- `Figure_DESC_01_f0_distribution.png`
- `Figure_DESC_02_intensity_distribution.png`

These figures show descriptive distributions of the primary suprasegmental acoustic measures.

### Formant Model Estimates

- `Figure_MODEL_03_EN_F1_emmeans.png`
- `Figure_MODEL_04_EN_F2_emmeans.png`
- `Figure_MODEL_05_TR_F1_emmeans.png`
- `Figure_MODEL_06_TR_F2_emmeans.png`

These figures display model-estimated Human–TTS differences in F1 and F2 separately for English and Turkish.

### Cross-Cue Summary

`Figure_MODEL_07_cross_cue_human_tts_summary.png`

This figure provides a comparative summary of Human–TTS effects across the analyzed acoustic dimensions.

### Quality-Control Figures

- `Figure_QC_01_measure_retention.png`
- `Figure_QC_02_f0_usability_heatmap.png`
- `Figure_QC_03_formant_retention_heatmap.png`

These figures document measure-specific retention and the distribution of usable acoustic observations following quality control.

## Interactive Three-Dimensional Visualizations

The `interactive/` directory contains interactive Plotly visualizations that can be opened in a web browser.

The visualizations are stratified by language and voice-sex category because F0 and formant distributions differ substantially across these dimensions.

### English — Female

Directory: `interactive/english_female/`

- `Figure_3D_01_EN_Female_vowel_space.html`
- `Figure_3D_05_EN_Female_F1F2_Intensity.html`

### English — Male

Directory: `interactive/english_male/`

- `Figure_3D_02_EN_Male_vowel_space.html`
- `Figure_3D_06_EN_Male_F1F2_Intensity.html`

### Turkish — Female

Directory: `interactive/turkish_female/`

- `Figure_3D_03_TR_Female_vowel_space.html`
- `Figure_3D_07_TR_Female_F1F2_Intensity.html`

### Turkish — Male

Directory: `interactive/turkish_male/`

- `Figure_3D_04_TR_Male_vowel_space.html`
- `Figure_3D_08_TR_Male_F1F2_Intensity.html`

The vowel-space visualizations provide interactive multidimensional representations of the acoustic organization of the target vowels. The F1–F2–intensity visualizations add intensity as a third acoustic dimension.

These figures are exploratory and descriptive. They should not be interpreted as independent inferential tests or as direct representations of articulatory tongue position.

## Exploratory Acoustic PCA

Directory: `interactive/exploratory/`

`Figure_3D_09_exploratory_acoustic_PCA.html`

This visualization represents an exploratory principal component analysis combining:

- session-centered F0;
- session-centered intensity;
- log-transformed F1; and
- log-transformed F2.

The PCA is provided as a supplementary multidimensional visualization and is not part of the primary inferential analysis.

## Derived Results

The `data/derived/` directory contains public summary outputs used to document the principal analyses.

- `table_descriptive_acoustics.csv` — descriptive acoustic summaries by source, language, and voice-sex category.
- `table_planned_contrasts.csv` — planned model-based Human–TTS contrasts.
- `table_analysis_retention.csv` — measure-specific analysis retention.
- `table_sensitivity_summary.csv` — primary and stricter QC analysis sample summaries.

See `docs/data_dictionary.md` for variable definitions.

## Stimulus Materials

`data/stimulus_metadata.csv`

This file contains the finalized 120-item lexical stimulus inventory and selected non-sensitive linguistic metadata used in the study.

The English and Turkish stimulus sets were selected independently and should not be interpreted as translation-equivalent item pairs.

## Analysis Scripts

The `scripts/analysis/` directory contains the finalized R scripts used for descriptive summaries, preparation of model variables, primary F0/intensity models, formant models, and cross-cue summaries.

The `scripts/sensitivity/` directory contains the primary sensitivity-analysis script.

The `scripts/figures/` directory contains the scripts used to generate the static and interactive visualizations included in this repository.

## Acoustic Processing

Acoustic localization and extraction were conducted using **Savlaq**, maintained separately at:

https://github.com/aekeser/Savlaq

This repository focuses on the QP-specific analysis and visualization layer rather than duplicating the Savlaq processing codebase.

## Important Interpretive Notes

The interactive and descriptive visualizations supplement, but do not replace, the mixed-effects analyses reported in the qualifying paper.

In particular:

- F1 and F2 are acoustic measures and should not be interpreted as direct measurements of articulatory position.
- Human–TTS formant differences should not automatically be interpreted as vowel-space compression or expansion without dedicated vowel-space metrics.
- Nonsignificant Human–TTS contrasts should not be interpreted as statistical evidence of equivalence.
- The exploratory PCA is not a confirmatory analysis.
- Human and TTS speech should be understood as different speech-production sources rather than as intrinsically "correct" and "incorrect" realizations.

## Data Availability

Raw Human audio, participant-level metadata, and other potentially identifying research materials are not publicly distributed.

Raw TTS audio is also not included in this repository.

The public repository is limited to non-sensitive stimulus metadata, derived results, visualizations, analysis code, and supporting documentation.