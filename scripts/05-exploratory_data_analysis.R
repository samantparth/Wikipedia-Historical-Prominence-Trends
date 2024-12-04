#### Preamble ####
# Purpose: Conducts Exploratory Data Analysis on Notable People Dataset
# Author: Parth Samant
# Date: 01 December 2024
# Contact: parth.samant@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - The `tidyverse` and `arrow` package must be installed


#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Read data ####
cleaned_data <- read_parquet("data/analysis_data/analysis_data.parquet")


# Summary statistics on cleaned data
summary(cleaned_data)

# Plotting histograms of characteristics
ggplot(cleaned_data, aes(x = occupation)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(x = "Occupation", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(cleaned_data, aes(x = time_period)) +
  geom_bar(fill = "darkred", color = "black") +
  labs(x = "Time Period", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(cleaned_data, aes(x = subregion)) +
  geom_bar(fill = "purple", color = "black") +
  labs(x = "Subregion", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(cleaned_data, aes(x = years_since_birth)) +
  geom_histogram(fill = "gold", color = "black") +
  labs(x = "Years Since Birth", y = "Count")

ggplot(cleaned_data, aes(x = gender)) +
  geom_bar(fill = "darkblue", color = "black") +
  labs(x = "Gender", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Plotting Barplot of prominence_rank based on characteristics


ggplot(cleaned_data, aes(x = reorder(occupation, percentile_rank, FUN = mean), y = percentile_rank)) +
  geom_bar(stat = "summary", fun = "mean", fill = "skyblue", color = "black") +
  labs(x = "Occupation", y = "Mean Percentile Rank") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(cleaned_data, aes(x = reorder(time_period, percentile_rank, FUN = mean), y = percentile_rank)) +
  geom_bar(stat = "summary", fun = "mean", fill = "darkred", color = "black") +
  labs(x = "Time Period", y = "Mean Percentile Rank") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(cleaned_data, aes(x = reorder(subregion, percentile_rank, FUN = mean), y = percentile_rank)) +
  geom_bar(stat = "summary", fun = "mean", fill = "purple", color = "black") +
  labs(x = "subregion", y = "Mean Percentile Rank") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(cleaned_data, aes(x = log(years_since_birth), y = percentile_rank)) +
  geom_point(color = "gold")
labs(x = "Years Since Birth", y = "Percentile Rank") +
  theme_minimal()

ggplot(cleaned_data, aes(x = reorder(gender, percentile_rank, FUN = mean), y = percentile_rank)) +
  geom_bar(stat = "summary", fun = "mean", fill = "darkblue", color = "black") +
  labs(x = "gender", y = "Mean Percentile Rank") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
