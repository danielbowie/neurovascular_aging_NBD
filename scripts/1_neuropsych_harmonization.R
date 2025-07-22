#############################################
# 1_neuropsych_harmonization.R
#############################################

# Load data
dat <- read_csv(here("data", "neuropsych_uncorrected.csv"))

# Split by study
arr_final <- dat %>% filter(Study == "arr")
opa_final <- dat %>% filter(Study == "opa")
pcc_final <- dat %>% filter(Study == "pcc")
pea_final <- dat %>% filter(Study == "pea")

# Compute means and SDs for 50-70 subsamples
sub <- dat %>%
  filter(age >= 50 & age <= 70) %>%
  group_by(Study) %>%
  summarise(
    age_mean = mean(age),
    age_sd = sd(age),
    fluid_mean = mean(fluid, na.rm = TRUE),
    fluid_sd = sd(fluid, na.rm = TRUE),
    verbal_mean = mean(verbal, na.rm = TRUE),
    verbal_sd = sd(verbal, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  )

print(sub)

# Re-standardize by study
standardize_var <- function(df, var, means, sds, index) {
  ((df[[var]] - means[index]) / sds[index])
}

arr_final <- arr_final %>%
  mutate(
    fluid_std = standardize_var(., "fluid", sub$fluid_mean, sub$fluid_sd, 1),
    verbal_std = standardize_var(., "verbal", sub$verbal_mean, sub$verbal_sd, 1)
  )

opa_final <- opa_final %>%
  mutate(
    fluid_std = standardize_var(., "fluid", sub$fluid_mean, sub$fluid_sd, 2),
    verbal_std = standardize_var(., "verbal", sub$verbal_mean, sub$verbal_sd, 2)
  )

pcc_final <- pcc_final %>%
  mutate(
    fluid_std = standardize_var(., "fluid", sub$fluid_mean, sub$fluid_sd, 3),
    verbal_std = standardize_var(., "verbal", sub$verbal_mean, sub$verbal_sd, 3)
  )

pea_final <- pea_final %>%
  mutate(
    fluid_std = standardize_var(., "fluid", sub$fluid_mean, sub$fluid_sd, 4),
    verbal_std = standardize_var(., "verbal", sub$verbal_mean, sub$verbal_sd, 4)
  )

# Combine studies
all_study <- bind_rows(arr_final, opa_final, pcc_final, pea_final)

# Outlier function — vectorized
remove_outliers <- function(x, threshold = 3) {
  mu <- mean(x, na.rm = TRUE)
  sigma <- sd(x, na.rm = TRUE)
  ifelse(abs(x - mu) > threshold * sigma, NA, x)
}

# Standardize again & remove outliers
all_study <- all_study %>%
  mutate(
    fluid_std = scale(fluid_std) %>% as.vector() %>% remove_outliers(),
    verbal_std = scale(verbal_std) %>% as.vector() %>% remove_outliers(),
    verbalpair_immed = scale(verbalpair_immed) %>% as.vector() %>% remove_outliers(),
    verbalpair_delay = scale(verbalpair_delay) %>% as.vector() %>% remove_outliers()
  ) %>%
  dplyr::select(-c(fluid, verbal))  # Remove originals

# Correlation heatmap
drop_mat <- all_study %>% drop_na()
cormat <- round(cor(drop_mat %>% dplyr::select(-c(Study, Subj_ID)), use = "pairwise.complete.obs"), 2)

# Reorder and get lower triangle
reorder_cormat <- function(cormat) {
  dd <- as.dist((1 - cormat) / 2)
  hc <- hclust(dd)
  cormat[hc$order, hc$order]
}

get_lower_tri <- function(cormat) {
  cormat[lower.tri(cormat)] <- NA
  cormat
}

cormat <- reorder_cormat(cormat)
lower_tri <- get_lower_tri(cormat)

# Plot heatmap
melted_cormat <- melt(lower_tri, na.rm = TRUE)

ggplot(melted_cormat, aes(Var2, Var1, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(
    low = "blue", high = "red", mid = "white",
    midpoint = 0, limit = c(-1, 1), space = "Lab",
    name = "Pearson\nCorrelation"
  ) +
  geom_text(aes(label = value), color = "black", size = 5) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, vjust = 1, size = 12, hjust = 1),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    legend.justification = c(1, 0),
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal"
  ) +
  coord_fixed() +
  guides(fill = guide_colorbar(barwidth = 7, barheight = 1, title.position = "top", title.hjust = 0.5))

# Quick scatterplot
ggplot(all_study, aes(age, fluid_std, color = Study)) +
  geom_point() +
  geom_smooth(method = "lm") +
  stat_cor(method = "pearson")

# Write out
write_csv(all_study, here("data", "harmonized_cognition.csv"))
    