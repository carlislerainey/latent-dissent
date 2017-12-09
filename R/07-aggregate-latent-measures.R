

# write latent measures to file
latent_df <- read_csv("latent-dissent.csv") %>%
  mutate(year = year(date),
         quarter = quarter(date),
         month = month(date),
         day = day(date)) %>%
  glimpse()

group_by(latent_df, year, month) %>%
  summarize(n_events = sum(n_events),
            n_dissent_events = sum(n_dissent_events),
            frac_dissent_events = n_dissent_events/n_events,
            pi = mean(pi),
            eta = mean(eta)) %>%
  glimpse() %>%
  write_csv("monthly-latent-dissent.csv") %>%
  write_dta("monthly-latent-dissent.dta")

group_by(latent_df, year, quarter) %>%
  summarize(n_events = sum(n_events),
            n_dissent_events = sum(n_dissent_events),
            frac_dissent_events = n_dissent_events/n_events,
            pi = mean(pi),
            eta = mean(eta)) %>%
  glimpse() %>%
  write_csv("quarterly-latent-dissent.csv") %>%
  write_dta("quarterly-latent-dissent.dta")
