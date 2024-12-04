#### Preamble ####
# Purpose: Simulates a fictitious dataset of 50 Notable People
# Author: Parth Samant
# Date: 01 December 2024
# Contact: parth.samant@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and `arrow` package must be installed


#### Workspace setup ####
library(tidyverse)
library(arrow)
set.seed(853)


#### Simulates data ####
n <- 50

occupation_names <- c(
  "Culture-core", "Academia", "Sports/Games", "Politics", "Military",
  "Administration/Law", "Corporate/Executive/Business (large)",
  "Culture-periphery", "Religious", "Explorer/Inventor/Developer",
  "Worker/Business (small)", "Family", "Nobility", "Other", "Missing"
)

subregion_names <- c(
  "Western Europe", "Northern America", "Southern Europe", "Eastern Europe",
  "Oceania Western World", "Eastern Asia", "Central America", "West Africa",
  "South Asia incl. Indian Peninsula", "South America", "North Africa",
  "Caribbean", "Northern Europe", "Central Africa",
  "Western Asia (Middle East Caucasus)", "East Africa", "Southern Africa",
  "SouthEast Asia", "Central Asia", "Oceania not Aus Nze"
)

simulated_data <- data.frame(
  years_since_birth = rexp(n, rate = 1 / 125.8), # exponential distribution for years_since_birth, with mean = 125.8
  gender = sample(c("Male", "Female"), n, replace = TRUE), # either male or female
  occupation = sample(occupation_names, n, replace = TRUE),
  subregion = sample(subregion_names, n, replace = TRUE),
  percentile_rank = runif(n, 0, 1) # percentile follows uniform distribution from 0 to 1
)


get_time_period <- function(years_since_birth) {
  year_of_birth <- 2020 - years_since_birth
  if (year_of_birth >= 1901) {
    return("5. 1901-2020AD")
  }
  if (year_of_birth >= 1751) {
    return("4. 1751-1900AD")
  }
  if (year_of_birth >= 1501) {
    return("3. 1501-1750AD")
  }
  if (year_of_birth >= 501) {
    return("2. 501-1500AD")
  }
  return("1. Before 500AD")
}

simulated_data$time_period <- sapply(simulated_data$years_since_birth, get_time_period)


#### Save data ####
write_parquet(simulated_data, "data/simulated_data/simulated_data.parquet")
