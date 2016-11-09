% Muenzwurf Bayes Beipiel
mu = 0.5;
sigma = 0.1;
range = 0:0.01:1;
% P(theta)
prior_fh = @(x) normpdf(x,mu,sigma); % Prior fuer die W'keit, dass die Muenze Kopf zeigt
prior = prior_fh(range);
prior = prior / norm(prior,1);

% Anzahl Datenpunkte
N = 10;
y = binornd(N,0.3);

% P(y)
likelihood_fh = @(x) binopdf(x, N, range)*prior';
likelihood = likelihood_fh(y);

% P(y | theta)
conditional_likelihood_fh = @(x) binopdf(x, N, range);
conditional_likelihood = conditional_likelihood_fh(y);
conditional_likelihood = conditional_likelihood / norm(conditional_likelihood,1);

% P(theta | y)
posterior = conditional_likelihood .* prior;% / likelihood;
posterior = posterior / norm(posterior, 1);

hold on
plot(range, prior)
plot(range, conditional_likelihood, '--g')
plot(range, posterior , '-+r')
legend('Prior', 'Likelihood', 'Posterior')

