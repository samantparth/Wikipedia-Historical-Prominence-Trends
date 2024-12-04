## Overview

This repository aims to dataset of notable people on Wikipedia from 3500 BCE to 2018 AD to identify whether certain characteristics (such as age and gender) were correlated with prominence. The analysis found that occupation and time period were most strongly associated with prominence, with subregion and gender being less significant. This highlights how prominence between already notable people selects for different characteristics.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from *A cross-verified database of notable people, 3500BC-2018AD*.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, a datasheet, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download, model and clean data.


## Statement on LLM usage

Aspects of the code were written with the help of the the LLM model Chat-GPT. Chat-GPT aided with visualizations relevant to the results, as well as scripts used to clean the data.  The details of these prompts are included in inputs/llms/usage.txt.
