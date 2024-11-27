#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(tidybayes)


#### Read data ####
analysis_data <- read_parquet("data/analysis_data/analysis_data.parquet")

analysis_data <- analysis_data |>
  mutate(
    gender = factor(gender),
    occupation = factor(occupation),
    subregion = factor(subregion),
    time_period = factor(time_period)
  )
  
# To make data reproducible
set.seed(200)

### Model data ####
relevance_model <-
  stan_glm(
    formula = percentile_rank ~ subregion + log(years_since_birth) * time_period + gender + occupation,
    data = analysis_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 853,
    cores = 4
  )


#### Save model ####
saveRDS(
  relevance_model,
  file = "models/relevance_model.rds"
)


