# --------------------------------------------------------
# Project: Interaction Effects in Regression
# Goal: Examine whether the effect of age on insurance charges
#       differs between smokers and non-smokers
#
# Variables:
#   - Outcome (Y): Charges (USD) — Continuous
#   - Predictors (X): 
#       * Age (Years) — Continuous
#       * Smoker (yes/no) — Categorical (Binary)
#       * Age × Smoker — Interaction term
#
# Key Concepts:
#   1. Additive vs Interaction models
#   2. Interpreting interaction coefficients
#   3. Testing interaction significance
#   4. Visualizing interactions
#
# Author: Osman Omer Mustafa (Medical Student & Data Analyst Trainee)
# Date: February 2026
# --------------------------------------------------------

# 0) Load required libraries
library(tidyverse)
library(broom)

# 1) Read data
data <- read_csv("insurance.csv")

# 2) Basic checks
glimpse(data)
summary(data)
sum(is.na(data))

# 3) Ensure categorical variables are factors
data <- data %>% 
  mutate(
    sex = as.factor(sex),
    smoker = as.factor(smoker),
    region = as.factor(region)
  )

glimpse(data)

# --------------------------------------------------------
# EXPLORATORY DATA ANALYSIS
# --------------------------------------------------------

# 4) Summary statistics by smoker
summary_smoker <- data %>% 
  group_by(smoker) %>% 
  summarise(
    n = n(),
    mean_age = mean(age),
    mean_charges = mean(charges),
    sd_charges = sd(charges)
  )
summary_smoker

# 5) Scatter plot: Age vs Charges by smoker
scatter_age_smoker <- ggplot(data, aes(x = age, y = charges, color = smoker)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    x = "Age (Years)",
    y = "Insurance Charges (USD)",
    title = "Age vs Charges by Smoker Status",
    color = "Smoker"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))
scatter_age_smoker

# --------------------------------------------------------
# MODEL 1: ADDITIVE MODEL (NO INTERACTION)
# --------------------------------------------------------

# 6) Fit additive model
model_additive <- lm(charges ~ age + smoker, data = data)

# 7) Tidy results
tidy_additive <- tidy(model_additive, conf.int = TRUE)
tidy_additive

# 8) Model performance
glance_additive <- glance(model_additive)
glance_additive

# --------------------------------------------------------
# MODEL 2: INTERACTION MODEL
# --------------------------------------------------------

# 9) Fit interaction model
model_interaction <- lm(charges ~ age * smoker, data = data)

# 10) Tidy results
tidy_interaction <- tidy(model_interaction, conf.int = TRUE)
tidy_interaction

# 11) Model performance
glance_interaction <- glance(model_interaction)
glance_interaction

# --------------------------------------------------------
# MODEL COMPARISON
# --------------------------------------------------------

# 12) ANOVA comparison
anova_compare <- anova(model_additive, model_interaction)
anova_compare

# 13) AIC comparison
aic_compare <- AIC(model_additive, model_interaction)
aic_compare

# 14) BIC comparison
bic_compare <- BIC(model_additive, model_interaction)
bic_compare

# 15) R-squared comparison
r2_comparison <- data.frame(
  model = c("Additive", "Interaction"),
  r_squared = c(glance_additive$r.squared, glance_interaction$r.squared),
  adj_r_squared = c(glance_additive$adj.r.squared, glance_interaction$adj.r.squared)
)
r2_comparison

# --------------------------------------------------------
# UNDERSTANDING THE INTERACTION
# --------------------------------------------------------

# 16) Extract coefficients
coefs <- coef(model_interaction)

# 17) Calculate slopes for each group
slope_no <- coefs[2]
slope_yes <- coefs[2] + coefs[4]

# 18) Calculate predicted charges at different ages
predictions <- data.frame(
  age = c(20, 40, 60)
) %>%
  mutate(
    non_smoker = coefs[1] + slope_no * age,
    smoker = (coefs[1] + coefs[3]) + slope_yes * age,
    difference = smoker - non_smoker
  )

predictions

# --------------------------------------------------------
# VISUALIZATION: INTERACTION PLOT
# --------------------------------------------------------

# Create plots directory if it doesn't exist
if (!dir.exists("plots")) dir.create("plots")

# 20) Enhanced scatter plot with regression lines
interaction_plot <- ggplot(data, aes(x = age, y = charges, color = smoker)) +
  geom_point(alpha = 0.4, size = 1.5) +
  geom_smooth(method = "lm", se = TRUE, linewidth = 1.2) +
  labs(
    x = "Age (Years)",
    y = "Insurance Charges (USD)",
    title = "Interaction Effect: Age × Smoker on Charges",
    subtitle = "Different slopes indicate interaction between age and smoking status",
    color = "Smoker"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 10),
    legend.position = "right"
  )

ggsave("plots/interaction_plot.png", interaction_plot, width = 8, height = 5)
interaction_plot

# 21) Coefficient comparison plot
coef_comparison <- bind_rows(
  tidy_additive %>% mutate(model = "Additive"),
  tidy_interaction %>% mutate(model = "Interaction")
) %>%
  filter(term != "(Intercept)") %>%
  ggplot(aes(x = term, y = estimate, fill = model)) +
  geom_col(position = "dodge") +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), 
                position = position_dodge(width = 0.9), width = 0.2) +
  coord_flip() +
  labs(
    x = "Term",
    y = "Coefficient Estimate",
    title = "Model Comparison: Additive vs Interaction",
    fill = "Model"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

ggsave("plots/coefficient_comparison.png", coef_comparison, width = 8, height = 5)
coef_comparison

# 22) Predicted values plot
pred_data <- expand.grid(
  age = seq(18, 64, by = 1),
  smoker = c("no", "yes")
)

pred_data$charges_additive <- predict(model_additive, newdata = pred_data)
pred_data$charges_interaction <- predict(model_interaction, newdata = pred_data)

prediction_plot <- ggplot(pred_data, aes(x = age, y = charges_interaction, 
                                          color = smoker)) +
  geom_line(linewidth = 1.2) +
  labs(
    x = "Age (Years)",
    y = "Predicted Insurance Charges (USD)",
    title = "Predicted Charges by Age and Smoker Status",
    subtitle = "Based on interaction model",
    color = "Smoker"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 10)
  )

ggsave("plots/prediction_plot.png", prediction_plot, width = 8, height = 5)
prediction_plot

# --------------------------------------------------------
# HYPOTHESIS TESTING
# --------------------------------------------------------

# 19) Test interaction significance
interaction_term <- tidy_interaction %>% 
  filter(term == "age:smokeryes")

interaction_term

# --------------------------------------------------------
# END OF SCRIPT
# --------------------------------------------------------
