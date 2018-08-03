
# load system cow codes
cow_df <- read_csv("data/raw/system2016.csv") %>%
  select(ccode, year) %>%
  filter(year %in% 1990:2004) %>%
  glimpse() %>%
  write_csv("data/empty-country-years-to-fill.csv")

