
# load data
dissent_df <- read_rds("measures/monthly-latent-dissent.rds")

# scatterplot matrix of four measures
gg <- GGally::ggpairs(select(dissent_df, n_dissent_events, frac_dissent_events, pi, eta)) + 
	theme_bw()
ggsave("figs/cors.png", gg, height = 6, width = 8)
