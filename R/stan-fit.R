
# be sure to set working directory, e.g., 
# setwd("~/Dropbox/projects/latent-dissent")

# load packages
library(tidyverse)
library(magrittr)
library(rstan); options(mc.cores = parallel::detectCores())

# load events data (created by clean-data.R)
events <- read_csv("data/events.csv")

# setup data for stan
T <- length(unique(events$year))
J <- length(unique(events$country_index))
stan_data <- list(T = T, J = J, N = J*T,
                  n_dissent_events = events$n_dissent_events, 
                  n_events = events$n_events, 
                  year_index = events$year_index,
                  country_index = events$country_index)

# fit model
model1 <- stan_model("src/binomial.stan")
fit1 <- vb(model1, data = stan_data)

# post-process simulations
sims <- as.data.frame(rstan::extract(fit1, par = "eta")) %>%
  gather(par, eta) %>%
  separate(par, into = c("par", "country_index", "year_index")) %>%
  mutate(country_index = as.numeric(country_index),
         year_index = as.numeric(year_index)) %>%
  dplyr::select(-par) %>%
  group_by(country_index, year_index) %>%
  dplyr::summarize(pi = mean(plogis(eta)),
            eta = mean(eta)) %>%
  right_join(events) %>%
  mutate(dissent_event_frac = ifelse(n_events == 0, 0, n_dissent_events/n_events)) %>%
  ungroup() %>%
  dplyr::select(year, ccode, dissent_event_frac, n_dissent_events, pi, eta)

# write latent measures to file
write_csv(sims, "latent-dissent.csv")
haven::write_dta(sims, "latent-dissent.dta")


