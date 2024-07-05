data {
  int <lower=0> N; // Number of observations to simulate
  array[N] real ages;
  array[N] int sex;
  array[N] int died;
}

parameters {
  real intercept;
  int beta_sex;
  real beta_age;
}

model {
  // Priors
  intercept ~ normal(-3, 1);
  beta_sex ~ bernoulli(0.6);
  beta_age ~ skew_normal(58, 14, 0.5);

  // Likelihood
    for (i in 1:N) {
        died[i] ~ bernoulli_logit(intercept + ages[i] * beta_age + sex[i] * beta_sex);
    }
}

generated quantities {
    array[N] real died_pred;
    array[N] real log_lik;
    array[N] real p;
    for (i in 1:N) {
        log_lik[i] = bernoulli_logit_lpmf(died[i] | intercept + sex[i] * beta_sex + ages[i] * beta_age);
        p[i] = inv_logit(log_lik[i]); // Convert logit to probability
        died_pred[i] = bernoulli_rng(p[i]); // Simulate death outcome
    }
}