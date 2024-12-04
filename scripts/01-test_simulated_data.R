#### Preamble ####
# Purpose: Tests the structure and validity of the simulated Notable People Dataset
# Author: Parth Samant
# Date: 01 December 2024
# Contact: parth.samant@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - The `tidyverse`, `arrow`, and `testthat` package must be installed
# - 00-simulate_data.R must have been run


#### Workspace setup ####
library(testthat)
library(tidyverse)
library(arrow)

simulated_data <- read_csv("data/simulated_data/simulated_data.csv")


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

time_period_names <- c("5. 1901-2020AD", "4. 1751-1900AD", "3. 1501-1750AD", "2. 501-1500AD", "1. Before 500AD")

#### Test Data ####
# Test if the data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

# Check if any column contains NA values
test_that("No NA values in the dataset", {
  expect_false(any(is.na(simulated_data)), info = "Dataset contains NA values")
})


# Check if no negative values of years since birth
test_that("Years Since Birth are all positive", {
  expect_true(all(simulated_data$years_since_birth > 0), info = "dataset contains negative years_of_birth entries")
})


# Tests if years_since_birth correctly corresponds to the time period of birth
test_that("Time Period and Years since birth variable in agreement", {
  get_time_period <- function(year_of_birth) {
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

  simulated_data <- simulated_data |>
    mutate(
      year_of_birth = 2020 - years_since_birth, # Calculate year_of_birth
      expected_time_period = sapply(year_of_birth, get_time_period) # Determine expected time_period
    )
  expect_true(all(simulated_data$time_period == simulated_data$expected_time_period),
    info = "Some rows have mismatched time_period and years_since_birth."
  )
})
# Tests that the prominence percentile is strictly between 0 and 1

test_that("prominence percentile is betwen 0 and 1", {
  expect_true(all(simulated_data$percentile_rank >= 0 & simulated_data$percentile_rank <= 100), info = "Percentile of prominence includes values out of range (0 to 1)")
})

# Check if occupation variable contains valid categories

test_that("All values of occupation are valid categories", {
  expect_true(all(simulated_data$occupation %in% occupation_names),
    info = "Some values in the occupation column are not valid categories."
  )
})


# Check if subregion variable contains valid categories

test_that("All values of subregion are valid categories", {
  expect_true(all(simulated_data$subregion %in% subregion_names),
    info = "Some values in the subregion column are not valid categories."
  )
})

# Check if time_period variable contains valid categories

test_that("All values of time_period are valid categories", {
  expect_true(all(simulated_data$time_period %in% time_period_names),
    info = "Some values in the time_period column are not valid categories."
  )
})
