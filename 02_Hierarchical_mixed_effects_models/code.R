# Load libraries 
library(tidyverse)    
library(lme4)       
library(lmerTest)
library(dplyr)

# Set seed for reproducibility
set.seed(2024)

# Create required parameters
n_schools <- 5
n_class_per_school <- 8
n_students_per_class <- 15  

# Create multi-level structure
sim_multilevel <- expand.grid(
  school_id = 1:n_schools,
  classroom_id_in_school = 1:n_class_per_school,
  student_in_class = 1:n_students_per_class
)

# Unique classroom id across all schools
sim_multilevel$classroom_id <- with(sim_multilevel, (school_id - 1) * n_class_per_school + classroom_id_in_school)
sim_multilevel$student_id <- 1:nrow(sim_multilevel)

# Simulate student variables
n_total <- nrow(sim_multilevel)
sim_multilevel$sex <- sample(0:1, n_total, replace = TRUE)  # 0: female, 1: male
sim_multilevel$ses <- rnorm(n_total, mean = 0, sd = 1) # Socioeconomic status
sim_multilevel$mathknow <- rnorm(n_total, mean = 0, sd = 1) # Prior math knowledge
sim_multilevel$mathprep <- rnorm(n_total, mean = 2.5, sd = 0.8) # Math preparation

# Assign intervention: about half in each class 
sim_multilevel <- sim_multilevel %>%
  group_by(classroom_id) %>%
  mutate(
    intervention = sample(
      c(rep(0, floor(n()/2)), rep(1, ceiling(n()/2)))
    )
  ) %>%
  ungroup()

# Random effects
school_effect <- rnorm(n_schools, 0, 4)
classroom_effect <- rnorm(n_schools * n_class_per_school, 0, 2)

# Math-gain outcome
sim_multilevel$mathgain <- 10 +
  4 * sim_multilevel$mathknow +
  3 * sim_multilevel$intervention +
  1.5 * sim_multilevel$sex +
  1.2 * sim_multilevel$ses +
  0.8 * sim_multilevel$mathprep +
  school_effect[sim_multilevel$school_id] +
  classroom_effect[sim_multilevel$classroom_id] +
  rnorm(n_total, 0, 5)

# Tidy up vars
# as.factor ensure that the models treat schools/classes as categorical, not numerical.
sim_multilevel$school_id <- as.factor(sim_multilevel$school_id)
sim_multilevel$classroom_id <- as.factor(sim_multilevel$classroom_id)
sim_multilevel$intervention <- as.factor(sim_multilevel$intervention)

# Check that each classroom has nearly equal split
table(sim_multilevel$classroom_id, sim_multilevel$intervention)

# Glimpse data
glimpse(sim_multilevel)
head(sim_multilevel)

# Exploring the data 
# Plot the data
library(ggplot2)

ggplot(sim_multilevel, aes(x = mathknow, y = mathgain)) +
  geom_point(alpha = 0.6, aes(color = intervention)) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Math Gain vs. Prior Math Knowledge",
    x = "Prior Math Knowledge (mathknow)",
    y = "Math Gain",
    color = "Intervention"
  ) +
  theme_minimal()

# Simple linear model 
# Build a simple multi-linear model 
lm_simple <- lm(mathgain ~ mathknow + intervention + sex + ses + mathprep, data = sim_multilevel)
summary(lm_simple)

# Aggregate data at classroom level and run a linear model
# Aggregated classroom level data 
class_data <- sim_multilevel %>%
  group_by(classroom_id) %>%
  summarise(
    mean_gain = mean(mathgain),
    mean_know = mean(mathknow),
    mean_intervention = mean(as.numeric(as.character(intervention))),
    mean_sex = mean(sex),
    mean_ses = mean(ses),
    mean_prep = mean(mathprep)
  )
  
  # Run regression
lm_class <- lm(mean_gain ~ mean_know + mean_intervention + mean_sex + mean_ses + mean_prep, data = class_data)
summary(lm_class)

# Fixed-effects model
# Fixed effects model (classroom as a factor)
lm_fixed <- lm(mathgain ~ mathknow + intervention + sex + ses + mathprep + as.factor(classroom_id), data = sim_multilevel)
summary(lm_fixed)

# Hierarchical model- random intercepts
lmer_class <- lmer(mathgain ~ mathknow + intervention + sex + ses + mathprep + (1 | classroom_id), data = sim_multilevel) #classroom as random intercept
summary(lmer_class)

# Classroom nested in schools
lmer_school_class <- lmer(mathgain ~ mathknow + intervention + sex + ses + mathprep + (1 | school_id/classroom_id), data = sim_multilevel)
summary(lmer_school_class)

# Plot model predictions
# Add model predictions for plotting
sim_multilevel <- sim_multilevel %>%
  mutate(
    pred_lm_simple = predict(lm_simple, newdata = .),
    pred_lmer_class = predict(lmer_class, newdata = .),
    pred_lmer_school_class = predict(lmer_school_class, newdata = .)
  )

# Plot observed vs predicted (Random intercept model)
ggplot(sim_multilevel, aes(x = mathgain, y = pred_lmer_school_class, color = school_id)) +
  geom_point(alpha = 0.5) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(
    title = "Observed vs. Predicted Math Gains (Random intercepts for school/class)",
    x = "Observed math gains",
    y = "Predicted math gains"
  ) +
  theme_minimal()

# Comparing model estimates
# Compare model coeffs
library(broom)
# install.packages("broom.mixed") #install once if not already
library(broom.mixed)

#tidy will extract coefficients from all the models we ran earlier!
tidy(lm_simple,conf.int = TRUE)
tidy(lm_fixed, conf.int = TRUE)
tidy(lmer_class, conf.int = TRUE)
tidy(lmer_school_class,conf.int = TRUE)


