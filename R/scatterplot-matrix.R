
# load packages
library(tidyverse)

# load data
dissent <- read_csv("latent-dissent.csv")

# scatterplot matrix of four measures
GGally::ggpairs(select(dissent, n_dissent_events, dissent_event_frac, pi, eta)) + 
	theme_bw()
ggsave("figs/cors.png", height = 6, width = 8)
