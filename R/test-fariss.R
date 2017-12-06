
# be sure to set working directory, e.g., 
# setwd("~/Dropbox/projects/latent-dissent")

# load packages
library(tidyverse)
library(magrittr)

# load my measure of dissent
dissent <- read_csv("latent-dissent.csv")

# load fariss's measure of repression
fariss <- read.csv("data/farriss-scores.csv") %>%
  rename(year = YEAR,
         ccode = COW) %>%
  left_join(dissent)

# fit models using four alterative explanatory variables
m1 <- lm(latentmean ~ pi, data = fariss)
m2 <- lm(latentmean ~ eta, data = fariss)
m3 <- lm(latentmean ~ frac_dissent_events, data = fariss)
m4 <- lm(latentmean ~ n_dissent_events, data = fariss)
m5 <- lm(latentmean ~ log(n_dissent_events + 1), data = fariss)


# function to compute the rmse of the regression
calc_rmse <- function(m_list) {
  rmse <- numeric(length(m_list))
  for (i in 1:length(m_list)) {
    rmse[i] <- sqrt(mean(residuals(m_list[[i]])^2))
  }
  return(rmse)
}

# combine model fit statistics
measures <- c("pi", "eta", "fraction of dissent events", 
							"number of dissent events", 
							"log(number of dissent events + 1)")
bic <- BIC(m1, m2, m3, m4, m5)[, 2]
rmse <- calc_rmse(list(m1, m2, m3, m4, m5))
model_comparision <- data.frame(measures, bic, rmse) %>%
  mutate(measures = reorder(measures, bic))
mc_tall <- gather(model_comparision, fit_statistic, value, bic, rmse)

# plot model fit statistcs
ggplot(mc_tall, aes(x = value, y = measures)) + 
  facet_wrap(~ fit_statistic, scales = "free_x") + 
  geom_point() + 
  theme_bw()
ggsave("figs/fariss-test.png", height = 3, width = 7)




