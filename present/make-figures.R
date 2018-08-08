
# plot three countries -------------------

# load packages
library(tidyverse)

# load data
dissent_df <- read_csv("latent-dissent.csv") %>%
  glimpse()

sum_df <- dissent_df %>%
  group_by(country_name) %>%
  summarize(avg_events = mean(n_dissent_events/frac_dissent_events))

# reshape data
df <- dissent_df %>% 
  filter(country_name %in% c("Cape Verde", "United States", "Russia")) %>%
  gather(measure, dissent, n_dissent_events:eta) %>%
  mutate(measure = factor(measure, levels = c("n_dissent_events", 
                                              "frac_dissent_events", 
                                              "pi", 
                                              "eta"))) %>%
  glimpse()

# plot example data
ggplot(df, aes(x = year, y = dissent, color = country_name)) + 
  geom_line() + 
  facet_wrap(~ measure, scales = "free") + 
  theme_bw()
ggsave("present/figs/compare-measures-3-states.png",
       height = 6, width = 8)

# look at total events versus gdp and population -----

# load nordas and davenport's replication data and join in my measures
nd2013_df <- haven::read_dta("data/nordas-davenport-2013-replication.dta") %>%
  glimpse()

ggplot(nd2013_df, aes(x = totpopln, y = dissent)) + 
  geom_point() + 
  geom_smooth() + 
  theme_bw()
ggsave("present/figs/scatter-pop-dissent-events.png",
       height = 6, width = 8) + 
