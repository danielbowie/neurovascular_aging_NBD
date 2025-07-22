#############################################
# merge_data.R
#############################################

# Outlier function — vectorized
outlier <- function(x, threshold = 3) {
  mu <- mean(x, na.rm = TRUE)
  sigma <- sd(x, na.rm = TRUE)
  ifelse(abs(x - mu) > threshold * sigma, NA, x)
}

## ------------------------------------------------------------------------------------------------------------------------------------------------------------------
pulse <- read_csv(here("data", "optical_prefx_data.csv")) # read prefx data
bp <- read_csv(here("data", "BP_medication_data.csv")) # read blood pressure and medication data
wmh <- read_csv(here("data", "white_matter_hypointensity_data.csv")) # read white matter hypointensity data
cog <- read_csv(here("data", "harmonized_cognition.csv")) %>% dplyr::select(!age) # read harmonized neuropsych data


## ------------------------------------------------------------------------------------------------------------------------------------------------------------------
all_dat <- pulse %>% 
  left_join(bp, by = c("Subj_ID")) %>% 
  left_join(wmh, by = c("Subj_ID")) %>% 
  left_join(cog, by = c("Subj_ID")) %>%
  distinct(Subj_ID, .keep_all=TRUE)

# Take the raw dataframe `all_dat` and clean it step by step
all_dat_clean <- all_dat %>%
  
  # 1. Drop rows with missing PReFx values
  drop_na(prefx) %>% 
  
  # 3.  Flag outliers in `prefx` by setting them to NA, then standardize
  mutate(prefx_std = as.vector(scale(outlier(prefx)))) %>%
  
  # 4. Flag outliers in `pulse_pressure` by setting them to NA, then standardize
  mutate(pulse_pressure_clean = as.vector(outlier(pulse_pressure))) %>% 
  
  # 5. Remove duplicate Study columns and rename
  dplyr::select(!c("Study.y", "Study.x.x", "Study.y.y")) %>% 
  rename(Study = Study.x)

## ------------------------------------------------------------------------------------------------------------------------------------------------------------------
write_csv(all_dat_clean, here("data", "merged_data_final.csv"))
