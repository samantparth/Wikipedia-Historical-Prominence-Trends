#### Preamble ####
# Purpose: Downloads and saves the data from Notable People Wikipedia Dataset
# Author: Parth Samant
# Date: 25 November 2024
# Contact: parth.samant@mail.utoronto.ca
# License: MIT
# Pre-requisites: Make sure tidyverse, readr, httr, R.utils have been downloaded
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)
library(readr)
library(httr)
library(R.utils)

# Download and Save
url <- "https://data.sciencespo.fr/api/access/datafile/4432?gbrecs=true"
destfile <- "data/raw_data/raw_data.csv.gz"

response <- GET(url, write_disk(destfile, overwrite = TRUE), timeout(300))


# Decompress the .gz file and save .csv file
gunzip("data/raw_data/raw_data.csv.gz", remove = TRUE)  # Set remove = FALSE to keep the original .gz file
