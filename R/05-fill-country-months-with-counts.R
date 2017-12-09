
# clear workspace
rm(list = ls())

# load data set of country-years to fill
country_month_df <-  read_rds("data/empty-country-months-to-fill.rds") %>%
  glimpse()

# load data set of ccodes to merge with idea's 3-letter labels
merge_df <- read_csv("data/variables-to-merge-ccode-idea3.csv") %>%
  glimpse()

# load the dissent events
dissent_events_df <- read_csv("data/idea-dissent-events.csv") %>%
  mutate(date = floor_date(ymd(date), unit = "month")) %>%
  mutate(year = year(date)) %>%
  select(where_idea, date) %>%
  group_by(where_idea, date) %>%
  summarize(n_dissent_events = n()) %>%
  glimpse()

# load all events
all_events_df <- read_csv("data/idea-all-events.csv") %>%
  separate(EVENTDAT, c("date", "time"), sep = " ", fill = "right") %>%
  mutate(date = floor_date(mdy(date), unit = "month")) %>%
  mutate(year = year(date)) %>%
  mutate(where_idea = SRCNAME) %>%
  select(where_idea, date) %>%
  group_by(where_idea, date) %>%
  summarize(n_events = n()) %>%
  glimpse()

# fill the country-day data with the counts
counts_df <- country_month_df %>%
  left_join(merge_df) %>%
  filter(!is.na(where)) %>%  # drop countries that never appear in the idea data
  left_join(dissent_events_df) %>%
  left_join(all_events_df) %>%
  # some countries never appear in the idea data and thus to not get a 3-letter
  # where_idea code these countries get zero.
  mutate(n_events = ifelse(is.na(n_events), 0, n_events)) %>%
  mutate(n_dissent_events = ifelse(is.na(n_dissent_events), 0, n_dissent_events)) %>%
  glimpse()

# write filled data set to file
write_rds(counts_df, "data/idea-counts.rds")
