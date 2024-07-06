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
  // real e;
  real f;
}

model {
  a ~ normal(0.0205, 0.003);
  b ~ normal(0.0608, 0.001);
  c ~ normal(1.4, 0.02);

  d ~ normal(2.1, 0.1);
  // e ~ normal(13, 2);
  f ~ normal(5.5, 0.2);

    for (i in 1:N) {
        real p = (a * exp(b * age[i]) * (c ^ sex[i])) * (d * exp(-((hospital_days[i] - 14)^2)/(2*e^2)))/100;

        p = fmin(fmax(p, 0), 1);

        death[i] ~ bernoulli(p);
    }
}

generated quantities {
    array[N] real death_pred;
    array[N] real log_lik;

  for (i in 1:N) {
    real p = (a * exp(b * age[i]) * pow(c, sex[i])) * (d * exp(-((hospital_days[i] - e)^2)/(2*e^2))) / 100;
    p = fmin(fmax(p, 0), 1);

    log_lik[i] = bernoulli_lpmf(death[i] | p);

    death_pred[i] = bernoulli_rng(p); // Simulate death outcome
  }
}