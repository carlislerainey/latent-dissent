
# clear workspace
rm(list = ls())

# create desired dates
## I want monthly data. The original data are daily, so I just use floor_date() to push all the 
## data to the 1st of the month.
## helpful: https://stackoverflow.com/questions/6052631/aggregate-daily-data-to-month-year-intervals
dates_df <- data.frame(date = seq(ymd("1990-01-01"), ymd("2004-12-31"), by = "1 month")) %>%
  mutate(year = year(date)) %>%
  glimpse()


# load system cow codes
cow_df <- read_csv("data/raw/system2016.csv") %>%
  select(ccode, year) %>%
  filter(year %in% 1990:2004) %>%
  left_join(dates_df) %>%
  glimpse() %>%
  write_rds("data/empty-country-months-to-fill.rds")

