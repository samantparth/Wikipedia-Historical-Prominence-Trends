#### Preamble ####
# Purpose: Cleans Raw Dataset, Selects for Notable Variables, Adds Standardized Popularity Variable
# Author: Parth Samant
# Date: 25 November 2024
# Contact: parth.samant@mail.utoronto.ca
# License: MIT
# Pre-requisites: Make sure tidyverse, readr, and arrow libraries have been downloaded
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(readr)
library(arrow)

#### Clean data ####
raw_data <- read_csv("data/raw_data/raw_data.csv")

# To make data reproducible
set.seed(201)

# raw_data$ranked_visib <- rank(raw_data$ranking_visib_5criteria, ties.method = "average")
# 
# # Step 2: Scale ranks to [0, 1]
# n <- nrow(raw_data)  # Number of observations
# raw_data$scaled_ranks <- (raw_data$ranked_visib - 0.5) / n
# 
# # Step 3: Apply the inverse normal transformation
# # This maps scaled ranks to the quantiles of a standard normal distribution
# raw_data$normal_transformed <- qnorm(raw_data$scaled_ranks)
# 
# # Step 4: (Optional) Center and scale to ensure standard normal
# # Not usually needed since qnorm already produces standard normal values
# raw_data$standard_normal <- scale(raw_data$normal_transformed)


#Selecting for relevant columns, as well as making a couple new ones
cleaned_data <- raw_data |>
  mutate(
    percentile_rank = percent_rank(-ranking_visib_5criteria),
    years_since_birth = 2024-birth
  ) |>
  select(years_since_birth, gender, level2_main_occ, bigperiod_birth_graph_b, un_subregion, percentile_rank) |> 
  filter(!is.na(years_since_birth) &
           !is.na(gender) &
           !is.na(level2_main_occ) &
           !is.na(bigperiod_birth_graph_b) &
           !is.na(un_subregion),
         gender %in% c("Male", "Female"),
         ) |>
  sample_n(20000, replace = FALSE) |>
  rename(
    occupation = level2_main_occ,
    time_period = bigperiod_birth_graph_b,
    subregion = un_subregion
  ) |>
  mutate(
    time_period = 
      case_match(
        time_period,
        "5.Contemporary period 1901-2020AD" ~ "5. 1901-2020AD",
        "4.Mid Modern Period 1751-1900AD" ~ "4. 1751-1900AD",
        "3.Early Modern Period 1501-1750AD" ~ "3. 1501-1750AD",
        "2.Post-Classical History 501-1500AD" ~ "2. 501-1500AD",
        "1.Ancient History Before 500AD" ~ "1. Before 500AD" 
        
      )
  )

#### Removing incorrectly labeled time periods ####

get_time_period <- function(years_since_birth) {
  year_of_birth <- 2020 - years_since_birth
  if (year_of_birth >= 1901) return("5. 1901-2020AD")
  if (year_of_birth >= 1751) return("4. 1751-1900AD")
  if (year_of_birth >= 1501) return("3. 1501-1750AD")
  if (year_of_birth >= 501)  return("2. 501-1500AD")
  return("1. Before 500AD")
}

cleaned_data$expected_time_period <- sapply(cleaned_data$years_since_birth, get_time_period)
cleaned_data <- cleaned_data[cleaned_data$time_period == cleaned_data$expected_time_period, ]
cleaned_data <- cleaned_data |>
  select(-expected_time_period)


#### Save data ####
write_parquet(cleaned_data, "data/analysis_data/analysis_data.parquet")

