# Data Dictionary

This document describes the public, non-sensitive data files included in this repository.

## `data/stimulus_metadata.csv`

Contains one row per finalized lexical stimulus.

| Variable | Description |
|---|---|
| `stimulus_id` | Unique stimulus identifier. |
| `language` | Language code (`EN` = English, `TR` = Turkish). |
| `lexical_category` | Lexical category of the item (`Noun` or `Adjective`). |
| `orthographic_form` | Written form of the lexical item. |
| `ipa_transcription` | IPA transcription associated with the finalized stimulus metadata. |
| `syllabification` | Syllabified representation of the lexical item. |
| `stress_pattern` | Encoded prominence/stress pattern from the finalized stimulus metadata. |
| `stressed_syllable_number_metadata` | Ordinal position of the designated prominence-bearing syllable. |
| `target_vowel_for_F1F2` | Target vowel category used in the F1/F2 analyses. |

The file contains 120 stimuli: 60 English and 60 Turkish items, with 30 nouns and 30 adjectives per language.

## `data/derived/table_descriptive_acoustics.csv`

Contains descriptive acoustic summaries grouped by speech source, language, and voice-sex category.

| Variable | Description |
|---|---|
| `source` | Speech source (`HUMAN` or `TTS`). |
| `language` | Language code (`EN` or `TR`). |
| `sex` | Human sex or TTS voice-sex category (`F` or `M`). |
| `f0_n` | Number of observations retained for F0. |
| `f0_mean_hz` | Mean retained F0 in Hz. |
| `f0_sd_hz` | Standard deviation of retained F0 in Hz. |
| `intensity_n` | Number of observations retained for intensity. |
| `intensity_mean_db` | Mean retained intensity in dB. |
| `intensity_sd_db` | Standard deviation of retained intensity in dB. |
| `f1_n` | Number of observations retained for F1. |
| `f1_mean_hz` | Mean retained F1 in Hz. |
| `f1_sd_hz` | Standard deviation of retained F1 in Hz. |
| `f2_n` | Number of observations retained for F2. |
| `f2_mean_hz` | Mean retained F2 in Hz. |
| `f2_sd_hz` | Standard deviation of retained F2 in Hz. |

Formant summaries are pooled across vowel categories and are intended only as broad descriptive summaries. Inferential formant models control explicitly for target-vowel identity.

## `data/derived/table_planned_contrasts.csv`

Contains model-based planned Human–TTS contrasts for the primary acoustic measures.

| Variable | Description |
|---|---|
| `Measure` | Acoustic measure (`F0`, `Intensity`, `F1`, or `F2`). |
| `Language` | Language condition. |
| `Lexical.category` | Lexical category condition. |
| `Human...TTS.effect` | Estimated Human minus TTS effect. |
| `df` | Degrees of freedom associated with the planned contrast. |
| `X95..CI` | 95% confidence interval for the estimated contrast. |
| `p` | p value for the planned contrast. |

F0 effects are reported in semitones, intensity effects in dB, and F1/F2 effects as back-transformed percentage differences.

## `data/derived/table_analysis_retention.csv`

Summarizes measure-specific data retention after quality control.

| Variable | Description |
|---|---|
| `Measure` | Acoustic measure or retention category. |
| `Retained` | Number of observations retained. |
| `Total` | Total number of observations in the full design. |
| `Percent` | Percentage retained. |

## `data/derived/table_sensitivity_summary.csv`

Summarizes primary and stricter quality-control analysis samples.

| Variable | Description |
|---|---|
| `Analysis` | Analysis specification. |
| `N` | Number of observations retained under that specification. |
| `Interpretation` | Short description of the specification or QC criterion. |

## Privacy and Data Scope

This repository does not contain raw Human recordings, participant-level metadata, consent or exemption documents, or other potentially identifying research materials.

The public data files are restricted to non-sensitive stimulus metadata and derived summary results.