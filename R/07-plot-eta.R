
# load packages
library(tidyverse)

# read data
dissent_df <- read_csv("latent-dissent.csv") %>%
  mutate(percentile_rank_eta = ecdf(eta)(eta))

ggplot(dissent_df, aes(x = year, y = eta, group = ccode, 
                    color = percentile_rank_eta)) + 
  geom_line() + 
  facet_wrap(~ stateabb) + 
  theme_bw() + 
  theme(text = element_text(size = 8)) + 
  scale_color_continuous(low = "black", high = "red")
ggsave("figs/eta.png", height = 8, width = 8)
