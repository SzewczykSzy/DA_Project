data {
  int <lower=0> N; // Number of observations to simulate
  array[N] real age;
  array[N] int sex;
}

generated quantities {
  real alpha = normal_rng(0.0205, 0.003);
  real beta_age = normal_rng(0.0608, 0.001);
  real beta_sex = normal_rng(1.4, 0.02);

  array[N] real<lower=0, upper=1> p;
  array[N] int<lower=0, upper=1> death;


  for (n in 1:N) {
    p[n] = alpha * exp(beta_age * age[n]) * (beta_sex ^ sex[n])/100;

    if (p[n] > 1) p[n] = 1;
    else if (p[n] < 0) p[n] = 0;
    death[n] = bernoulli_rng(p[n]); // Simulate death outcome
  }
}