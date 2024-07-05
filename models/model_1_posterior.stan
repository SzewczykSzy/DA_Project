data {
  int <lower=0> N; // Number of observations to simulate
  array[N] real age;
  array[N] int sex;
  array[N] int death;
}

parameters {
  real alpha;
  real beta_age;
  real beta_sex;
}

model {
  alpha ~ normal(0.0205, 0.003);
  beta_age ~ normal(0.0608, 0.001);
  beta_sex ~ normal(1.4, 0.02);

    for (i in 1:N) {
        real p = alpha * exp(beta_age * age[i]) * (beta_sex ^ sex[i])/100;
        // if (p[i] > 1) p[i] = 1;
        // else if (p[i] < 0) p[i] = 0;
        p = fmin(fmax(p, 0), 1);

        death[i] ~ bernoulli(p);
    }
}

generated quantities {
    array[N] real death_pred;
    array[N] real log_lik;

  for (i in 1:N) {
    real p = alpha * exp(beta_age * age[i]) * pow(beta_sex, sex[i]) / 100;
    p = fmin(fmax(p, 0), 1);
    // if (p[i] > 1) p[i] = 1;
    // else if (p[i] < 0) p[i] = 0;

    log_lik[i] = bernoulli_lpmf(death[i] | p);

    death_pred[i] = bernoulli_rng(p); // Simulate death outcome
  }
}