

# be sure to set working directory, e.g., 
# setwd("~/Dropbox/projects/latent-dissent")

# load packages
library(tidyverse)
library(magrittr)

# read data
dissent <- read_csv("latent-dissent.csv") %>%
  mutate(country_abbr = countrycode::countrycode(ccode, "cown", "cowc"), 
         percentile_rank_eta = ecdf(eta)(eta))

ggplot(dissent, aes(x = year, y = eta, group = ccode, 
                    color = percentile_rank_eta)) + 
  geom_line() + 
  facet_wrap(~ country_abbr) + 
  theme_bw() + 
  theme(text = element_text(size = 8)) + 
  scale_x_continuous(breaks = c(1992, 2000)) + 
  scale_color_continuous(low = "black", high = "red")
ggsave("figs/eta.png", height = 8, width = 8)
