#### Preamble ####
# Purpose: Models Prominence of Notable People and Performs Statistical Tests
# Author: Parth Samant
# Date: 25 November 2024
# Contact: parth.samant@mail.utoronto.ca
# License: MIT
# Pre-requisites: Make sure tidyverse, MLmetrics, broom, and tidymodels packages have all been installed


#### Workspace setup ####
library(tidyverse)
library(MLmetrics)
library(broom)
library(tidymodels)


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


### Training and Test Split ###
split <- initial_split(analysis_data, prop = 0.7)

training_data <- training(split)
testing_data <- testing(split)

### Model informed by BIC ###

relevance_model <- lm(data = training_data, percentile_rank ~ occupation + subregion + time_period + log(years_since_birth) +
  gender + time_period:log(years_since_birth) + gender:occupation)

n <- nrow(training_data)
stepfit <- stats::step(relevance_model,
  direction = "backward",
  k = log(n)
)


BIC_model <- lm(data = training_data, percentile_rank ~ occupation + subregion + time_period +
  gender)

plot(BIC_model, which = 1)
plot(BIC_model, which = 2)
plot(BIC_model, which = 3)

### Model Evaluation ###



pred1 <- predict(relevance_model, testing_data)
pred2 <- predict(BIC_model, testing_data)

RMSE(pred1, testing_data$percentile_rank)
RMSE(pred2, testing_data$percentile_rank)


R2_Score(testing_data2$pred1, testing_data$percentile_rank)
R2_Score(testing_data2$pred2, testing_data$percentile_rank)




#### Save model ####
saveRDS(
  BIC_model,
  file = "models/relevance_model.rds"
)

write_parquet(training_data, "data/analysis_data/training_data.parquet")
write_parquet(testing_data, "data/analysis_data/testing_data.parquet")
