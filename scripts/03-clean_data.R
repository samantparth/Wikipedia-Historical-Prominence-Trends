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


#Selecting for relevant columns, as well as making a couple new ones
cleaned_data <- raw_data |>
  mutate(
    percentile_rank = percent_rank(-ranking_visib_5criteria),
    years_since_birth = 2024-birth
    ) |>
  select(years_since_birth, gender, level2_main_occ, bigperiod_birth_graph_b, un_subregion, percentile_rank) |> 
  filter(gender %in% c("Male", "Female"),
    if_all(c(years_since_birth, gender, level2_main_occ, bigperiod_birth_graph_b, un_subregion, percentile_rank), ~ !is.na(.))) |>
  # sample_n(20000, replace = FALSE) |>
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


# Filter and sample 1000 entries for each time period
# sampled_data <- cleaned_data |>
#   filter(time_period %in% c("1. Before 500AD", "2. 501-1500AD", "3. 1501-1750AD", "4. 1751-1900AD", "5. 1901-2020AD")) |> # Filter for the desired time periods
#   group_by(time_period) |> # Group by time period
#   sample_n(1000, replace = FALSE) |> # Sample 1000 from each group without replacement
#   ungroup() # Remove the grouping


#### Save data ####
write_parquet(cleaned_data, "data/analysis_data/analysis_data.parquet")

