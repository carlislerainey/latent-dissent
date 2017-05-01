
# be sure to set working directory, e.g., 
# setwd("~/Dropbox/projects/latent-dissent")

# load packages
library(tidyverse)
library(magrittr)
library(mice)

# load ritter's 2014 replication data. 
# from https://www.emilyhenckenritter.com/s/RitterJCR2014Replication.zip
ritter <- haven::read_dta("data/ritter-2014-replication.dta") %>%
  # extract need variables
  dplyr::select(n_dissent_events = dissct, 
         n_events = alleventcount,
         year, ccode)

# create a data set that exhaust country-year combinations
full_country_year <- crossing(year = seq(min(ritter$year), max(ritter$year), 1),
                              ccode = unique(ritter$ccode))
# join with ritter's data
ritter <- left_join(full_country_year, ritter)

# create data frame with country names and country indices (which are later useful in stan)
country_index <- data.frame(ccode = unique(ritter$ccode)) %>%
  mutate(country_index = 1:n(), 
         country_name = countrycode::countrycode(ccode, "cown", "country.name")) 

# create data frame with year indices (which are later useful in stan)
year_index <- data.frame(year = unique(ritter$year)) %>%
  mutate(year_index = 1:n()) 

# join the country and year indices to ritter's data
ritter <- left_join(ritter, country_index) %>% left_join(year_index)

# singly impute missing values
si <- complete(mice(ritter, m = 1, method = "mean"))
# round so that data look like counts
si$n_events <- round(si$n_events)
si$n_dissent_events <- round(si$n_dissent_events)

# write data to file 
write_csv(si, "data/events.csv")



