
# be sure to set working directory, e.g., 
# setwd("~/Dropbox/projects/latent-dissent")

# load packages
library(tidyverse)
library(magrittr)
library(party)

# load my measure of dissent
dissent <- read_csv("latent-dissent.csv")

# load a singly imputed verion of hill and jones's data set I created
hj <- read.csv("data/hill-jones-2014-si.csv") %>%
  left_join(dissent) %>%
  dplyr::select(-ccode, -year, -physint, -disap, -kill, -polpris, -tort, -injud,
                -amnesty, -latent_sd)

# re-create a simply version of hill and jones's model comparison
rf <- cforest(latent ~ ., data = hj)
vi <- varimp(rf)

# organize the variable importance into data frame
vi_df <- data.frame(variable = names(vi), importance = vi) %>%
  mutate(highlight = ifelse(variable %in% c("pi", "eta", "n_dissent_events", 
                                            "frac_dissent_events"), 
  													"My Variables", "HJ's Variables"), 
         variable = reorder(variable, importance))

# plot variable importance
ggplot(vi_df, aes(x = importance, y = variable, color = highlight)) + 
  geom_point()
ggsave("figs/hj-test.png", height = 5, width = 7)

