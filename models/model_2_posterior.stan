data {
  int <lower=0> N; // Number of observations to simulate
  array[N] real age;
  array[N] int sex;
  array[N] real hospital_days;
  array[N] int death;
}

parameters {
  real a;
  real b;
  real c;
  real d;
  real f;
}

model {
  a ~ normal(0.22, 0.05);
  b ~ normal(0.0608, 0.01);
  c ~ normal(1.4, 0.04);

  d ~ normal(14, 4);
  f ~ normal(6, 0.6);

    for (i in 1:N) {
        real p = (a * exp(b * age[i]) * (c ^ sex[i])) * (exp(-((hospital_days[i] - d)^2)/(2*f^2)))/100;

        p = fmin(fmax(p, 0), 1);

        death[i] ~ bernoulli(p);
    }
}

generated quantities {
    array[N] real death_pred;
    array[N] real log_lik;

  for (i in 1:N) {
    real p = (a * exp(b * age[i]) * pow(c, sex[i])) * (exp(-((hospital_days[i] - d)^2)/(2*f^2))) / 100;
    p = fmin(fmax(p, 0), 1);

    log_lik[i] = bernoulli_lpmf(death[i] | p);

    death_pred[i] = bernoulli_rng(p); // Simulate death outcome
  }
}