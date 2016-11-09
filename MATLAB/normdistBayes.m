% Ziehung aus Normalverteilung Bayes Beipiel
mu = 180;
sigma = 10;
range = 100:1:250;

% P(theta)
prior_fh = @(x) normpdf(x,mu,sigma); % Prior fuer den Mittelwert der Koerpergroesse
prior = prior_fh(range);
prior = prior / sum(sum(prior));

% Anzahl Datenpunkte
N = 10;
y = normrnd(190, sigma, 1, N);

% P(y | theta)
conditional_likelihood_fh = @(x) normpdf(mean(x), range, sigma/N);
conditional_likelihood = conditional_likelihood_fh(y);
conditional_likelihood = conditional_likelihood / sum(sum(conditional_likelihood));

% P(y)
likelihood_fh = @(x) conditional_likelihood_fh(x).*prior;
likelihood = likelihood_fh(y);

% P(theta | y)
posterior = conditional_likelihood .* prior;
posterior = posterior / sum(sum(posterior));

theoretical_posterior_fh = @(x) normpdf(range, (mu*sigma/N + mean(x)*sigma) / ((1+1/N)*sigma), (sigma^2)/N / ((1+1/N)*sigma));
theoretical_posterior  = theoretical_posterior_fh(y);
theoretical_posterior = theoretical_posterior / sum(sum(theoretical_posterior));

hold on
plot(range, prior)
plot(range, conditional_likelihood, '--g')
plot(range, posterior , '-+r')
plot(range, theoretical_posterior, 'o-y')
legend('Prior', 'Likelihood', 'Posterior', ' Theoretical posterior')

