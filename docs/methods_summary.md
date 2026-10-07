# Methods Summary

This document provides a concise methodological overview of the public materials accompanying the qualifying-paper study:

**Acoustic Implementation of Lexical Prominence in Human and Synthetic Speech: A Cross-Linguistic Comparison of English and Turkish**

## Study Design

The study compares the acoustic realization of prominence-bearing vowels in American English and Turkish Human and synthetic speech.

The complete design contains 2,880 citation-form observations:

- 32 Human speakers
  - 16 American English speakers
  - 16 Turkish speakers
- 16 synthetic voice conditions
  - four multilingual TTS systems
  - two languages
  - one female and one male voice per system and language
- 60 lexical stimuli per language
  - 30 nouns
  - 30 adjectives

Human and TTS sources produced the same lexical materials within each language. The English and Turkish inventories were selected independently and are not translation-equivalent item pairs.

## Human Speech

Human recordings were collected individually in quiet personal environments using a Sony ICD-UX570 Stereo Digital Voice Recorder positioned approximately 20–25 cm from the speaker.

The original Human recordings were 44.1-kHz MP3 files. Each recording session contained all 60 lexical items for the relevant language.

Both citation and prompted productions were elicited and preserved. The present QP analysis uses the citation-form productions only.

## Synthetic Speech

Synthetic productions were generated using four multilingual TTS platforms:

- Microsoft Azure Speech
- Google Cloud Text-to-Speech
- ElevenLabs
- PlayHT

One young-adult female and one young-adult male voice were selected for each platform and language after auditory evaluation by the researcher.

Synthesis parameters were otherwise left at platform-default settings. The original TTS outputs were 44.1-kHz WAV files.

## Stimuli

The finalized stimulus inventory contains 120 trisyllabic lexical items:

- 60 English
- 60 Turkish
- 30 nouns and 30 adjectives per language

Candidate selection was corpus informed, using SUBTLEX-US for English and TS Corpus for Turkish, together with linguistic and phonetic suitability criteria.

The complete public stimulus inventory is available at:

`data/stimulus_metadata.csv`

## Acoustic Processing

Acoustic localization and extraction were conducted using **Savlaq**, an automated acoustic-analysis pipeline maintained separately at:

https://github.com/aekeser/Savlaq

For the present QP, the citation-production interval was selected before target-vowel localization.

Acoustic measurements were obtained from an approximately 60-ms region centered on the localized prominence-bearing target-vowel nucleus.

The primary acoustic measures are:

- fundamental frequency (F0);
- intensity;
- first formant frequency (F1); and
- second formant frequency (F2).

Duration is not analyzed because the current approximately 60-ms measurement region is an analysis window rather than an independently estimated vowel-duration interval.

## Quality Control

Quality control was measure specific.

F0 required usable voiced-frame information within the localized measurement region. The primary analysis retained accepted and sparse-frame observations, while a stricter sensitivity analysis retained only fully accepted observations.

Intensity was retained for successfully localized target regions.

F1 and F2 underwent additional robust post-extraction quality control because occasional automated formant-tracking failures produced implausible estimates. The primary formant analysis used a 3.5-MAD robust criterion together with broad acoustic sanity checks. A stricter 3.0-MAD criterion was used for sensitivity analysis.

No missing or implausible formant measurements were manually reconstructed or replaced.

Measure-specific retention and sensitivity summaries are available in:

- `data/derived/table_analysis_retention.csv`
- `data/derived/table_sensitivity_summary.csv`

## Statistical Analysis

Statistical analyses were conducted in R using linear mixed-effects models.

F0 was converted to semitones and centered within recording session. Intensity was likewise centered within session. F1 and F2 were log transformed before modeling.

F0 and intensity models evaluated speech source, language, lexical category, and their interactions, with voice sex included as an additional predictor.

Formants were modeled separately within English and Turkish because the languages have different vowel inventories. These models additionally controlled for target-vowel identity.

Random effects accounted for repeated recording sessions and lexical stimuli.

Planned Human–TTS contrasts were estimated within the relevant language and lexical-category conditions. Formant contrasts were back-transformed for interpretation as percentage Human–TTS differences.

## Sensitivity Analyses

The principal F0 analysis was repeated using the stricter F0 acceptance criterion.

F1 and F2 analyses were repeated using the stricter 3.0-MAD formant QC criterion.

These analyses evaluate whether the principal findings depend materially on the primary quality-control specifications.

## Public Data Scope

This repository does **not** contain:

- raw Human recordings;
- raw TTS recordings;
- participant-level metadata;
- consent or institutional review documents; or
- other potentially identifying research materials.

The public repository contains only non-sensitive stimulus metadata, derived summary results, figures, interactive visualizations, analysis scripts, and supporting documentation.