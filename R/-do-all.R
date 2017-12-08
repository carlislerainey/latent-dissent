
# load packages
library(tidyverse)
library(magrittr)
library(lubridate)
library(rstan); options(mc.cores = parallel::detectCores())
library(countrycode)
library(haven)

# clear workspace
rm(list = ls())

# set working directory
setwd("~/Dropbox/projects/latent-dissent")

# create the new data set
source("R/01-create-murdie-bhasin-events-df.R")
source("R/02-create-empty-country-years.R")
source("R/03-clean-idea-data.R")
source("R/04-create-variables-to-merge-ccode-idea3.R")
source("R/05-fill-country-years-with-counts.R")
source("R/06-add-model-estimates.R")
source("R/07-plot-eta.R")
source("R/08-plot-cors.R")

# evaluate new data set
source("R/test-fariss.R")
source("R/test-hill-jones.R")
source("R/test-nordas-davenport.R")
