
# load events data (created by clean-data.R)
counts_df <- read.csv("data/idea-counts.csv") %>%
  glimpse()

# drop cases that don't cover the entire 1990-2004 period.
# this is an assumption to make the Stan model easier to write (eta can be a matrix)
incomplete_cases_df <- counts_df %>%
  group_by(where, ccode) %>%
  summarize(n = n()) %>%
  filter(n < 15) %>%
  glimpse() 
counts_df <- counts_df %>%
  filter(!ccode %in% incomplete_cases_df$ccode)

# drop ccodes that never appear in the idea (no events, ever)
counts_df <- counts_df %>%
  filter(!is.na(where))

# add country and year indices
counts_df <- counts_df %>%
  mutate(year_index = match(year, sort(unique(year)))) %>%
  mutate(country_index = match(ccode, sort(unique(ccode))))

# setup data for stan
T <- length(unique(counts_df$year_index))
J <- length(unique(counts_df$country_index))
stan_data <- list(T = T, J = J, N = J*T,
                  n_dissent_events = counts_df$n_dissent_events, 
                  n_events = counts_df$n_events, 
                  year_index = counts_df$year_index,
                  country_index = counts_df$country_index)

# fit model
model1 <- stan_model("src/binomial.stan")
fit1 <- vb(model1, data = stan_data, seed = 97854)
#fit1 <- stan("src/binomial.stan", data = stan_data, seed = 97854)

# post-process simulations
latent_df <- as.data.frame(rstan::extract(fit1, par = "eta")) %>%
  gather(par, eta) %>%
  separate(par, into = c("par", "country_index", "year_index")) %>%
  mutate(country_index = as.numeric(country_index),
         year_index = as.numeric(year_index)) %>%
  select(-par) %>%
  group_by(country_index, year_index) %>%
  summarize(pi = mean(plogis(eta)),
            eta = mean(eta)) %>%
  left_join(counts_df) %>%
  mutate(frac_dissent_events = ifelse(n_events == 0, 0, n_dissent_events/n_events)) %>%
  ungroup() %>%
  mutate(stateabb = countrycode(ccode, "cown", "cowc"),
         country_name = countrycode(ccode, "cown", "country.name.en")) %>%
  select(country_name, ccode, stateabb, year, n_dissent_events, frac_dissent_events, pi, eta) %>%
  glimpse()

# write latent measures to file
write_csv(latent_df, "latent-dissent.csv")
write_dta(latent_df, "latent-dissent.dta")


