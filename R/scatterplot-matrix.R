
# load packages
library(tidyverse)

# load data
dissent <- read_csv("latent-dissent.csv")

# scatterplot matrix of four measures
gg <- GGally::ggpairs(select(dissent, n_dissent_events, frac_dissent_events, pi, eta)) + 
	theme_bw()
ggsave("figs/cors.png", gg, height = 6, width = 8)
