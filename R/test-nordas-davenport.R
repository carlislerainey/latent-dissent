
# be sure to set working directory, e.g., 
# setwd("~/Dropbox/projects/latent-dissent")

# 
rm(list = ls())

# load packages
library(tidyverse)
library(magrittr)
library(stringr)
# also calls functions from MASS, arm, and GGally using ::

# load nordas and davenport's replication data and join in my measures
nd2013 <- haven::read_dta("data/nordas-davenport-2013-replication.dta") %>%
	rename(ccode = cow_, year = year1) %>%
	left_join(haven::read_dta("latent-dissent.dta")) %>%
  filter(!is.na(ythblgap)) %>%
  glimpse()

# create a data set across which both our measures exist
nd2013b <- filter(nd2013, !is.na(Amnesty) & !is.na(ldv_A) & !is.na(eta) & !is.na(dissent))

# counterfactual dataset with a 10% increase in youth bulge
nd2013b_cf <- nd2013b %>%
  mutate(ythblgap = ythblgap*1.3)

##############################
# part 1: compare the measures
##############################

# correlation matrix to compare my my measures with theirs
cor_df <- nd2013 %>%
  select( dissent, 
         n_dissent_events, frac_dissent_events, pi, eta) %>%
  na.omit() %>%
  glimpse()
GGally::ggpairs(cor_df)
ggsave("figs/nordas-davenport-compare-measures.png", height = 7, width = 7)

################################################################
# part 2: compare the estimates from the new sample and original
################################################################

# function to combine polr estimates into a data frame (broom-style)
polr_df <- function(fit) {
	est <- c(fit$coefficients, fit$zeta)
	se <- sqrt(diag(vcov(fit)))
	var <- names(est)
	df <- data.frame(var = var, est = est, se = se)
	rownames(df) <- NULL
	return(df)
}

# replicate nordas and davenport's model 
m1 <- MASS::polr(as.ordered(Amnesty) ~ ythblgap + I(polity %in% c(8, 9)) + I(polity == 10) +  
									arm::rescale(dissent) + civconflict + gdpcappppln + totpopln + as.factor(ldv_A) + 
									  as.factor(year), 
								data = filter(nd2013, !is.na(Amnesty) & !is.na(ldv_A)), method = "probit") %>%
	polr_df() %>%
	mutate(model = "Nordas and Davenport Replication")

# estimate the same model, but using only cases where both our measures exist
m2 <- MASS::polr(as.ordered(Amnesty) ~ ythblgap + I(polity %in% c(8, 9)) + I(polity == 10) +  
                   arm::rescale(dissent) + civconflict + gdpcappppln + totpopln + as.factor(ldv_A) + 
                   as.factor(year), 
											 data = nd2013b, 
											 method = "probit") %>%
	polr_df() %>%
	mutate(model = "Nordas and Davenport Replication for Cases Include in My Data")

# cbind and plot the estimates to see if they are similar
m <- rbind(m1, m2)
ggplot(m, aes(x = var, ymin = est - se, ymax = est + se, y = est, color = model)) + 
	geom_pointrange(position = position_dodge(width = 1/2)) + 
	theme_bw() + theme(legend.position = "bottom") + coord_flip()

#####################################################
# part 3: coefficient for models using the five measures
#####################################################

# fit amnesty model for each measure
m2 <- MASS::polr(as.ordered(Amnesty) ~ ythblgap + I(polity %in% c(8, 9)) + I(polity == 10) +  
								 arm::rescale(dissent) + 
								 	civconflict + 
								 	gdpcappppln + totpopln + as.factor(ldv_A) + as.factor(year), 
								 data = nd2013b, 
								 method = "probit")
m3 <- update(m2, . ~ . + arm::rescale(n_dissent_events) - arm::rescale(dissent))
m4 <- update(m2, . ~ . + arm::rescale(frac_dissent_events) - arm::rescale(dissent))
m5 <- update(m2, . ~ . + arm::rescale(pi) - arm::rescale(dissent))
m6 <- update(m2, . ~ . + arm::rescale(eta) - arm::rescale(dissent))

# fit state model for each measure
m2b <- update(m2, as.ordered(State_Dept) ~ .)
m3b <- update(m3, as.ordered(State_Dept) ~ .)
m4b <- update(m4, as.ordered(State_Dept) ~ .)
m5b <- update(m5, as.ordered(State_Dept) ~ .)
m6b <- update(m6, as.ordered(State_Dept) ~ .)

# coefficient tables
texreg::screenreg(list(m2, m3, m4, m5, m6))
texreg::screenreg(list(m2b, m3b, m4b, m5b, m6b))

#####################################################
# part 4: predictive performance of the five measures
#####################################################

# combine model fit statistics
measures <- c("ND's count", "number of dissent events", 
							"fraction of dissent events", "pi", "eta")
bic <- BIC(m2, m3, m4, m5, m6)[,2]
model_comparison <- data.frame(measures, bic, outcome = "Amnesty International") %>%
	mutate(measures = reorder(x = measures, X = bic, FUN = mean))

bic_b <- BIC(m2b, m3b, m4b, m5b, m6b)[,2]
model_comparison_b <- data.frame(measures, bic = bic_b, outcome = "State Department") %>%
  mutate(measures = reorder(x = measures, X = bic, FUN = mean))

model_comparison <- rbind(model_comparison, model_comparison_b)

# plot model fit statistcs
ggplot(model_comparison, aes(x = bic, y = measures)) + 
	geom_point() + 
  facet_wrap(~ outcome, scales = "free_x") + 
	theme_bw()
ggsave("figs/nordas-davenport-test.png", height = 3, width = 7)

##########################################################################
# part 3: first differences from the models using original measure and eta
##########################################################################

# calculate the qi for their model and my eta
qi2_df <- prediction(m2, data = nd2013b_cf)  %>% 
  select(cf_ = starts_with("Pr("), ccode = ccode, year = year) %>%
  right_join(prediction(m2)) %>%
  mutate(fd1 = cf_1 - `Pr(1)`, 
         fd2 = cf_2 - `Pr(2)`, 
         fd3 = cf_3 - `Pr(3)`, 
         fd4 = cf_4 - `Pr(4)`, 
         fd5 = cf_5 - `Pr(5)`) %>%
  mutate(measure = "dissent") %>%
  glimpse()
qi6_df <- prediction(m6, data = nd2013b_cf)  %>% 
  select(cf_ = starts_with("Pr("), ccode = ccode, year = year) %>%
  right_join(prediction(m6)) %>%
  mutate(fd1 = cf_1 - `Pr(1)`, 
         fd2 = cf_2 - `Pr(2)`, 
         fd3 = cf_3 - `Pr(3)`, 
         fd4 = cf_4 - `Pr(4)`, 
         fd5 = cf_5 - `Pr(5)`) %>%
  mutate(measure = "eta") %>%
  glimpse()

qi_df <- rbind(qi2_df, qi6_df) %>%
  gather(category, qi, starts_with("fd")) %>%
  glimpse() %>%
  mutate(category = str_replace(category, "fd", "Category ")) %>%
  select(year, country, ythblgap, qi, category, measure) %>%
  spread(measure, qi) %>%
  mutate(fd_change_percent = 100*(eta - dissent)/dissent, 
         fd_change_percent_cat = cut(fd_change_percent, breaks = c(-Inf, -50, -10, -5, -1, 1, 5, 10, 50, Inf)),
         effect_size = ifelse(abs(dissent) < median(abs(dissent)), "about zero", "not about zero")) %>%
  glimpse()

# plot the qi for their model and my eta
ggplot(sample_frac(qi_df), aes(x = dissent, y = eta, fill =  fd_change_percent_cat)) + 
  geom_point(color = "black", shape = 21, alpha = 0.5) + 
  facet_wrap(~ category) + 
  scale_color_brewer(type = "div", palette = 7, direction = 1) +
  geom_abline(slope = 1, intercept = 0)

# bar plot of percent change by category
ggplot(qi_df, aes(x = fd_change_percent_cat)) + 
  facet_grid(effect_size ~ category) + 
  geom_bar() + 
  coord_flip()

# density plot
gather(qi_df, qi, fd, eta, dissent) %>%
  glimpse() %>%
  ggplot(aes(x = fd, fill = qi)) + 
  geom_density(alpha = 0.5) +
  facet_wrap(~ category)


