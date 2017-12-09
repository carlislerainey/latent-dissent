
# clear workspace
rm(list = ls())

dates_df <- data.frame(date = seq(ymd("1990-01-01"), ymd("2004-12-31"), by = "1 day")) %>%
  mutate(year = year(date)) %>%
  glimpse()

# load system cow codes
cow_df <- read_csv("data/raw/system2016.csv") %>%
  select(ccode, year) %>%
  filter(year %in% 1990:2004) %>%
  left_join(dates_df) %>%
  glimpse() %>%
  write_csv("data/empty-country-days-to-fill.csv")

