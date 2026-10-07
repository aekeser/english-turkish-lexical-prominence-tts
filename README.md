# Acoustic Implementation of Lexical Prominence in Human and Synthetic Speech

## A Cross-Linguistic Comparison of English and Turkish

This repository contains public supplementary materials for a study examining the acoustic realization of lexical prominence in Human and text-to-speech (TTS) productions of American English and Turkish.

The study compares Human speech with output from four multilingual TTS platforms across multiple acoustic dimensions, including fundamental frequency (F0), intensity, and vowel formants (F1 and F2). The public materials are intended to support transparency, visualization, and documentation of the computational analysis workflow while protecting participant data and respecting restrictions on redistribution of audio materials.

## Study Overview

The study includes:

- 32 Human speakers
  - 16 American English speakers
  - 16 Turkish speakers
- 16 synthetic voice conditions
- 4 multilingual TTS platforms
- 120 lexical stimuli
  - 60 English items
  - 60 Turkish items
  - 30 nouns and 30 adjectives per language
- 2,880 citation-form observations in the complete study design

The primary analyses compare Human and synthetic productions of prominence-bearing vowels using F0, intensity, F1, and F2.

## Repository Contents

Public materials include:

- finalized lexical stimulus metadata;
- derived descriptive and inferential results;
- main and supplementary figures;
- interactive three-dimensional acoustic visualizations;
- analysis and figure-generation scripts;
- quality-control and sensitivity-analysis documentation; and
- supporting methodological documentation.

## Quick Navigation

- [Methods summary](docs/methods_summary.md)
- [Supplementary materials guide](docs/supplementary_materials.md)
- [Data dictionary](docs/data_dictionary.md)
- [Public stimulus metadata](data/stimulus_metadata.csv)
- [Derived results](data/derived/)
- [Main figures](figures/main/)
- [Supplementary figures](figures/supplementary/)
- [Interactive 3D visualizations](interactive/)
- [Analysis scripts](scripts/analysis/)
- [Sensitivity analysis](scripts/sensitivity/)
- [Figure-generation scripts](scripts/figures/)

## Reproducibility Scope

The analysis and visualization scripts are provided for methodological transparency and to document the computational procedures used in the study.

Full end-to-end numerical reproduction of the Human-speech analyses requires trial-level acoustic data that are not publicly distributed because those data remain linked to restricted participant-level research records.

Publicly available derived tables, stimulus metadata, figures, and interactive visualizations allow the reported results and analytical workflow to be inspected without releasing restricted source data.

The scripts preserve the structure of the finalized research pipeline and may therefore reference internal analysis datasets that are intentionally absent from this public repository.

## Data Availability and Privacy

Raw Human recordings are **not publicly distributed**.

Participant-level metadata and other potentially identifying information are also excluded from this repository. Raw TTS audio is not distributed here.

The repository therefore contains only materials appropriate for public research dissemination, including non-sensitive stimulus information, derived results, visualizations, analysis code, and supporting documentation.

## Stimulus Materials

The finalized stimulus inventory contains 120 trisyllabic lexical items:

- 60 American English items;
- 60 Turkish items;
- 30 nouns and 30 adjectives per language.

The English and Turkish inventories were selected independently and should not be interpreted as translation-equivalent item pairs.

The public stimulus inventory and selected linguistic metadata are available at:

[`data/stimulus_metadata.csv`](data/stimulus_metadata.csv)

## Acoustic Measures

The primary QP analyses examine:

- fundamental frequency (F0);
- intensity;
- first formant frequency (F1); and
- second formant frequency (F2).

The present analyses use citation-form productions and acoustic measurements obtained from localized prominence-bearing target-vowel regions.

Duration is not analyzed in the current study because the approximately 60-ms acoustic measurement region is an analysis window rather than an independently estimated vowel-duration interval.

## Acoustic Processing

Acoustic localization and measurement were conducted using **Savlaq**, an automated acoustic-analysis pipeline for controlled speech research.

Savlaq is maintained separately:

https://github.com/aekeser/Savlaq

This repository contains the QP-specific analysis, visualization, and supplementary materials rather than duplicating the Savlaq processing codebase.

## Derived Results

The [`data/derived/`](data/derived/) directory contains public summary outputs from the finalized analyses, including:

- descriptive acoustic summaries;
- planned Human–TTS contrasts;
- measure-specific analysis retention; and
- sensitivity-analysis summaries.

Variable definitions and interpretive notes are provided in:

[`docs/data_dictionary.md`](docs/data_dictionary.md)

## Figures

The [`figures/main/`](figures/main/) directory contains the principal static figures used in the qualifying paper.

The [`figures/supplementary/`](figures/supplementary/) directory contains additional descriptive, model-based, and quality-control visualizations.

A detailed figure guide is available at:

[`docs/supplementary_materials.md`](docs/supplementary_materials.md)

## Interactive Visualizations

Interactive three-dimensional acoustic visualizations are provided in the [`interactive/`](interactive/) directory.

They are organized by language and voice-sex category:

- [`interactive/english_female/`](interactive/english_female/)
- [`interactive/english_male/`](interactive/english_male/)
- [`interactive/turkish_female/`](interactive/turkish_female/)
- [`interactive/turkish_male/`](interactive/turkish_male/)

An additional exploratory multidimensional visualization is available in:

- [`interactive/exploratory/`](interactive/exploratory/)

The interactive visualizations include three-dimensional vowel-space representations and F1–F2–intensity representations. They can be opened in a web browser and rotated or inspected interactively.

These visualizations are supplementary and exploratory. They do not constitute additional inferential analyses and should not be interpreted as direct representations of articulatory tongue position.

## Analysis Code

Finalized QP analysis scripts are organized into three directories.

### Primary analyses

[`scripts/analysis/`](scripts/analysis/)

Contains scripts documenting:

- descriptive acoustic summaries;
- preparation of model variables;
- final F0 and intensity models;
- preparation of formant-model variables;
- primary F1/F2 models; and
- cross-cue Human–TTS effect summaries.

### Sensitivity analyses

[`scripts/sensitivity/`](scripts/sensitivity/)

Contains the primary robustness analysis using stricter F0 and formant quality-control specifications.

### Figure generation

[`scripts/figures/`](scripts/figures/)

Contains scripts used to generate the static figures and interactive acoustic visualizations included in this repository.

Because restricted trial-level acoustic datasets are not publicly distributed, some scripts reference internal analysis files that are intentionally absent from the public repository.

## Quality Control

Quality control was conducted separately for each acoustic measure.

The public repository includes:

- measure-retention summaries;
- F0 usability visualizations;
- formant-retention visualizations; and
- summaries of stricter sensitivity analyses.

Implausible formant estimates were not manually reconstructed or replaced. Primary formant analyses used robust post-extraction quality control, with stricter criteria evaluated in sensitivity analyses.

Further methodological information is available in:

[`docs/methods_summary.md`](docs/methods_summary.md)

## Important Interpretive Notes

The public visualizations and derived summaries supplement the statistical analyses reported in the qualifying paper.

Several interpretive constraints are particularly important:

- F1 and F2 are acoustic measures of vocal-tract resonance and are not direct measurements of articulatory position.
- Human–TTS formant differences should not automatically be interpreted as vowel-space compression or expansion without dedicated vowel-space metrics.
- Nonsignificant Human–TTS contrasts should not be interpreted as statistical evidence of equivalence.
- Interactive three-dimensional visualizations are descriptive and exploratory rather than independent inferential tests.
- The exploratory PCA is not part of the primary confirmatory analysis.
- Human speech serves as the empirical comparison baseline; deviations from Human acoustic distributions should not automatically be interpreted as linguistically incorrect synthetic productions.

## Public/Restricted Data Boundary

### Included publicly

- non-sensitive stimulus metadata;
- derived descriptive summaries;
- model-based contrast summaries;
- quality-control summaries;
- main and supplementary figures;
- interactive acoustic visualizations;
- finalized analysis scripts;
- sensitivity-analysis scripts;
- figure-generation scripts; and
- methodological documentation.

### Not included publicly

- raw Human audio recordings;
- raw TTS audio recordings;
- participant-level metadata;
- full trial-level acoustic datasets;
- consent documentation;
- institutional review or exemption documentation;
- credentials or API information; and
- other potentially identifying or restricted research materials.

## Qualifying Paper

These materials accompany the qualifying paper:

**Keser, A. E.**  
*Acoustic Implementation of Lexical Prominence in Human and Synthetic Speech: A Cross-Linguistic Comparison of English and Turkish.*

The final citation and manuscript link will be added when the qualifying paper is finalized.

## Citation

If you use materials from this repository before a formal publication citation becomes available, please cite the repository and qualifying paper author.

A complete citation will be added following finalization of the qualifying paper.

## License

A repository-wide license has not yet been assigned.

The repository includes generated interactive HTML visualizations that bundle third-party software dependencies. Licensing and attribution information will be finalized before broader public release.