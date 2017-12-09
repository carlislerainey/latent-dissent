

# load and clean the raw monthly estimates
latent_df <- read_rds("data/raw-monthly-latent-dissent.rds") %>%
  mutate(year = year(date),
         quarter = quarter(date), 
         month = month(date)) %>%
  select(country_name, ccode, stateabb, 
         date, year, quarter, month, 
         n_events, n_dissent_events, frac_dissent_events, pi, eta) %>%
  glimpse()

# monthly
latent_df %>%
  write_rds("measures/monthly-latent-dissent.rds") %>%
  write_csv("measures/monthly-latent-dissent.csv") %>%
  write_dta("measures/monthly-latent-dissent.dta")

# quarterly
group_by(latent_df, country_name, ccode, stateabb, 
         year, quarter) %>%
  summarize(n_events = sum(n_events),
            n_dissent_events = sum(n_dissent_events),
            frac_dissent_events = n_dissent_events/n_events,
            pi = mean(pi),
            eta = mean(eta)) %>%
  glimpse() %>%
  write_rds("measures/quarterly-latent-dissent.rds") %>%
  write_csv("measures/quarterly-latent-dissent.csv") %>%
  write_dta("measures/quarterly-latent-dissent.dta")

# yearly
group_by(latent_df, country_name, ccode, stateabb, 
         year) %>%
  summarize(n_events = sum(n_events),
            n_dissent_events = sum(n_dissent_events),
            frac_dissent_events = n_dissent_events/n_events,
            pi = mean(pi),
            eta = mean(eta)) %>%
  glimpse() %>%
  write_rds("measures/yearly-latent-dissent.rds") %>%
  write_csv("measures/yearly-latent-dissent.csv") %>%
  write_dta("measures/yearly-latent-dissent.dta")

