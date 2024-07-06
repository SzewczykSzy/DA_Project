data {
  int <lower=0> N; // Number of observations to simulate
  array[N] real age;
  array[N] int sex;
  array[N] real hospital_days;
}

generated quantities {
  real a = normal_rng(0.0205, 0.003);
  real b = normal_rng(0.0608, 0.001);
  real c = normal_rng(1.4, 0.02);

  real d = normal_rng(10, 0.5);
//   real e = normal_rng(13, 2);
//   real e = 14;
  real f = normal_rng(6.4, 0.2);
  

  array[N] real<lower=0, upper=1> p;
  array[N] int<lower=0, upper=1> death;


  for (n in 1:N) {
    p[n] = (a * exp(b * age[n]) * (c ^ sex[n])) * (d * exp(-((hospital_days[n] - 14)^2)/(2*f^2))) /100;

    if (p[n] > 1) p[n] = 1;
    else if (p[n] < 0) p[n] = 0;
    death[n] = bernoulli_rng(p[n]); // Simulate death outcome
  }
}