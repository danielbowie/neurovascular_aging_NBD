#############################################
# master_pipeline.R
# Purpose: Reproduce the full workflow in order
#############################################

# ---- 0. Setup ----

# Load necessary packages
library(here)
library(rmarkdown)
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(tibble)
library(stringr)
library(forcats)
library(purrr)
library(ggpubr)
library(rstatix)
library(reshape2)
library(lavaan)
library(segmented)
library(ggtext)

# ---- 1. Run scripts in order ----

# Statistically harmonize neuropsych data
source(here("scripts/1_neuropsych_harmonization.R"))

# Merge optical pulse, white matter, harmonized neuropsych, blood pressure/medication data
source(here("scripts/2_merge_data.R"))

# Reads merged data, runs models, creats a notebook and figures for primary analyses
# This may take a few minutes, given that multiple mediation analyses are run with 5000 bootstrap samples each
rmarkdown::render("reports/1_primary_analyses.Rmd", output_dir = "reports")

# Runs supplementary analyses, creates a notebook and figures
# This may take a few minutes, given that multiple mediation analyses are run with 5000 bootstrap samples each
rmarkdown::render("reports/2_supplementary_analyses.Rmd", output_dir = "reports")

# ---- 3. Done ----
message("Pipeline complete! Check output in figures/ folder.")
