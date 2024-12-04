#### Preamble ####
# Purpose: Tests the structure and validity of the Notable People Dataset
# Author: Parth Samant
# Date: 01 December 2024
# Contact: parth.samant@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(testthat)

data <- read_parquet("data/analysis_data/analysis_data.parquet")


#### Test Data ####
if (exists("data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

# Check if any column contains NA values
test_that("No NA values in the dataset", {
  expect_false(any(is.na(data)), info = "Dataset contains NA values")
})

# Check if no negative values of years since birth
test_that("Years Since Birth are all positive", {
  expect_true(all(data$years_since_birth > 0), info = "Dataset contains negative years_since_birth entries")
})

# Tests if years_since_birth correctly corresponds to the time period of birth
test_that("Time Period and Years since birth variable in agreement", {
  get_time_period <- function(year_of_birth) {
    if (year_of_birth >= 1901) return("5. 1901-2020AD")
    if (year_of_birth >= 1751) return("4. 1751-1900AD")
    if (year_of_birth >= 1501) return("3. 1501-1750AD")
    if (year_of_birth >= 501)  return("2. 501-1500AD")
    return("1. Before 500AD")
  }
  
  data <- data |>
    mutate(
      year_of_birth = 2020 - years_since_birth,  # Calculate year_of_birth
      expected_time_period = sapply(year_of_birth, get_time_period)  # Determine expected time_period
    )
  expect_true(all(data$time_period == data$expected_time_period), 
              info = "Some rows have mismatched time_period and years_since_birth.")
})
# Check if occupation variable contains valid categories
test_that("All values of occupation are valid categories", {
  expect_true(all(data$occupation %in% occupation_names),
              info = "Some values in the occupation column are not valid categories.")
})

# Check if subregion variable contains valid categories
test_that("All values of subregion are valid categories", {
  expect_true(all(data$subregion %in% subregion_names),
              info = "Some values in the subregion column are not valid categories.")
})

# Check if time_period variable contains valid categories
test_that("All values of time_period are valid categories", {
  expect_true(all(data$time_period %in% time_period_names),
              info = "Some values in the time_period column are not valid categories.")
})