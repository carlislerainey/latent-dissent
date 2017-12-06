
# be sure to set working directory, e.g., 
# setwd("~/Dropbox/projects/latent-dissent")

# load packages
library(tidyverse)
library(magrittr)
library(broom)
# also calls functions from MASS, arm, and GGally using ::

# load my measure of dissent
nd2013 <- haven::read_dta("data/nordas-davenport-2013-replication.dta") %>%
	rename(ccode = cow_, year = year1) %>%
	left_join(haven::read_dta("latent-dissent.dta")) %>%
  glimpse()

# correlation matrix
cor_df <- nd2013 %>%
  select( dissent, 
         n_dissent_events, frac_dissent_events, pi, eta) %>%
  na.omit() %>%
  glimpse()
GGally::ggpairs(cor_df, alpha = 0.4)
ggsave("figs/nordas-davenport-compare-measures.png", height = 7, width = 7)

polr_df <- function(fit) {
	est <- c(fit$coefficients, fit$zeta)
	se <- sqrt(diag(vcov(fit)))
	var <- names(est)
	df <- data.frame(var = var, est = est, se = se)
	rownames(df) <- NULL
	return(df)
}

m1 <- MASS::polr(as.ordered(Amnesty) ~ ythblgap + I(polity %in% c(8, 9)) + I(polity == 10) +  
									arm::rescale(dissent) + civconflict + gdpcappppln + totpopln + as.factor(ldv_A), 
								data = filter(nd2013, !is.na(Amnesty) & !is.na(ldv_A)), method = "probit") %>%
	polr_df() %>%
	mutate(model = "Nordas and Davenport Replication")

nd2013b <- filter(nd2013, !is.na(Amnesty) & !is.na(ldv_A) & !is.na(eta) & !is.na(dissent))

m2 <- MASS::polr(as.ordered(Amnesty) ~ ythblgap + I(polity %in% c(8, 9)) + I(polity == 10) +  
											 	arm::rescale(dissent) + civconflict + gdpcappppln + totpopln + as.factor(ldv_A), 
											 data = nd2013b, 
											 method = "probit") %>%
	polr_df() %>%
	mutate(model = "Nordas and Davenport Replication for Cases Include in My Data")

m <- rbind(m1, m2)

ggplot(m, aes(x = var, ymin = est - se, ymax = est + se, y = est, color = model)) + 
	geom_pointrange(position = position_dodge(width = 1/2)) + 
	theme_bw() + theme(legend.position = "bottom") + coord_flip()

m2 <- MASS::polr(as.ordered(Amnesty) ~ ythblgap + I(polity %in% c(8, 9)) + I(polity == 10) +  
								 arm::rescale(dissent) + 
								 	civconflict + 
								 	gdpcappppln + totpopln + as.factor(ldv_A), 
								 data = nd2013b, 
								 method = "probit")

m3 <- MASS::polr(as.ordered(Amnesty) ~ ythblgap + I(polity %in% c(8, 9)) + I(polity == 10) +  
								 	arm::rescale(n_dissent_events) + 
								 	civconflict + 
								 	gdpcappppln + totpopln + as.factor(ldv_A), 
								 data = nd2013b, 
								 method = "probit")

m4 <- MASS::polr(as.ordered(Amnesty) ~ ythblgap + I(polity %in% c(8, 9)) + I(polity == 10) +  
								 	arm::rescale(frac_dissent_events) + 
								 	civconflict + 
								 	gdpcappppln + totpopln + as.factor(ldv_A), 
								 data = nd2013b, 
								 method = "probit")

m5 <- MASS::polr(as.ordered(Amnesty) ~ ythblgap + I(polity %in% c(8, 9)) + I(polity == 10) +  
								 	arm::rescale(pi) + 
								 	civconflict + 
								 	gdpcappppln + totpopln + as.factor(ldv_A), 
								 data = nd2013b, 
								 method = "probit")

m6 <- MASS::polr(as.ordered(Amnesty) ~ ythblgap + I(polity %in% c(8, 9)) + I(polity == 10) +  
								 	arm::rescale(eta) + 
								 	civconflict + 
								 	gdpcappppln + totpopln + as.factor(ldv_A), 
								 data = nd2013b, 
								 method = "probit")


texreg::screenreg(list(m2, m3, m4, m5, m6))

m2b <- update(m2, as.ordered(State_Dept) ~ .)
m3b <- update(m3, as.ordered(State_Dept) ~ .)
m4b <- update(m4, as.ordered(State_Dept) ~ .)
m5b <- update(m5, as.ordered(State_Dept) ~ .)
m6b <- update(m6, as.ordered(State_Dept) ~ .)


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


