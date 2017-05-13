
data {
    int<lower=1> N; // number of observations
    int<lower=1> J; // number of groups
    int<lower=1> T; // number of time periods
    int year_index[N]; // variable that indexes years, e.g., 1, 2, 3,...
    int country_index[N];  // variable that indexes countries, e.g., 1, 2, 3,...
    int<lower=0> n_dissent_events[N]; // number of dissent events
    int<lower=0> n_events[N]; // total number of events
}

parameters {
    real<lower=0> sigma; // SD of latent intensity innovations
    vector[T] eta[J]; // latent intensity on logit scale
}

model {
    eta[1, ] ~ cauchy(0, 2); // intensity of initial observation
    sigma ~ gamma(1, .1); // prior for latent innovations
    // intensity of subsequest observations
    for (t in 2:T) {
      for (j in 1:J) {
        eta[j, t] ~ normal(eta[j, t-1], sigma);
      }
    }
    // binomial likelihood, parameterized so that eta = logit(Pr(y = 1))
    for (i in 1:N) {
      n_dissent_events[i] ~ binomial_logit(n_events[i], eta[country_index[i], year_index[i]]);
    }
}
