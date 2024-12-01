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
library(MLmetrics)
library(tidymodels)
library(broom)


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

#formula = percentile_rank ~  subregion + log(years_since_birth) * time_period + gender + occupation,


### Training and Test Split ###
split <- initial_split(analysis_data, prop = 0.7)

training_data <- training(split)
testing_data <- testing(split)

### Model data ####
relevance_model <- stan_glm(
  percentile_rank ~  occupation + subregion + years_since_birth + 
    gender + occupation:gender,  # Interaction as fixed effect
  data = training_data,
  family = gaussian(),
  prior = normal(0, 1),
  prior_intercept = normal(0.5, 1),
  cores = 4
)


### Model informed by BIC ###

relevance_model <- lm(data = training_data, percentile_rank ~  occupation + subregion + time_period + log(years_since_birth) + 
                        gender + time_period:log(years_since_birth) + occupation:gender)

stepfit = stats::step(relevance_model,
               direction="backward", 
               k = log(2))


orig_model <-  lm(data = training_data, percentile_rank ~ occupation + log(years_since_birth))

BIC_model <-lm(data = training_data, percentile_rank ~  occupation + subregion + time_period + log(years_since_birth) + 
                 gender + time_period:log(years_since_birth) + occupation:gender)

plot(BIC_model, which = 1)
plot(BIC_model, which = 2)
plot(BIC_model, which = 3)

### Model Evaluation ###


pog <- posterior_predict(relevance_model, newdata = testing_data)

testing_data <- testing_data |>
  mutate(pred3 = colMeans(pog))

testing_data  <- testing_data |>
  mutate(pred1 = predict(orig_model, testing_data),
         pred2 = predict(BIC_model, testing_data))

RMSE(testing_data$pred1, testing_data$percentile_rank)
RMSE(testing_data$pred2, testing_data$percentile_rank)
RMSE(testing_data$pred3, testing_data$percentile_rank)


R2_Score(testing_data$pred1, testing_data$percentile_rank)
R2_Score(testing_data$pred2, testing_data$percentile_rank)
R2_Score(testing_data$pred3, testing_data$percentile_rank)



time_stats <- training_data %>%
  group_by(gender) %>%
  summarize(
    mean = mean(percentile_rank, na.rm = TRUE),
    variance = var(percentile_rank, na.rm = TRUE)
  )




#### Save model ####
saveRDS(
  BIC_model,
  file = "models/relevance_model.rds"
)

write_parquet(training_data, "data/analysis_data/training_data.parquet")
write_parquet(testing_data, "data/analysis_data/testing_data.parquet")



