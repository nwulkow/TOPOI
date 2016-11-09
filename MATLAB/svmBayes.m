% SVM Bayes Beipiel
% Der classifier soll ermittelt werden
clear all
close all
mu = [1.3 -2.8, 12 -0.1]; 
sigma_weights = [.5,.5, 3, 0.01];
sigma_weights = diag(sigma_weights);

ranges = {0:0.05:4; -4:0.025:0; 8:1:16; -0.2:0.025:0};
X = vectorsToMatrix(ranges);

% P(theta)
prior_fh = @(x) mvnpdf(x,mu,sigma_weights);
prior = prior_fh(X);
%prior = reshape(prior, length(X), length(X'));
prior = prior / sum(sum(prior));

% Echte Gewichte
weights = [1.5, -2.5, 11, -0.15];

% Datenpunkte
N = 10;
mu_distribution = [1,2,3,40];
sigma_distribution = [0.2,0.4,0.6, 2];
Psi =  mvnrnd(mu_distribution, sigma_distribution, N);
y = Psi*weights'; %Y | theta verteilt wie: N(Psi^T * weights , sum(sigma*weights'))

% P(y | theta)
conditional_likelihood_fh = @(x) mvnpdf(mean(x), X*mu_distribution', sum(sum(sigma_weights)) / N );
conditional_likelihood = conditional_likelihood_fh(y);
%conditional_likelihood = reshape(conditional_likelihood, length(X1), length(X2));
conditional_likelihood = conditional_likelihood / sum(sum(conditional_likelihood));

% P(theta | y)
posterior = conditional_likelihood .* prior;% / likelihood;
posterior = posterior / sum(sum(posterior));

theoretical_theta = (Psi'*Psi)\Psi'*y;
%theoretical_posterior_fh = @(x) mvnpdf(range, (mu*sigma/N + mean(x)*sigma) / ((1+1/N)*sigma), (sigma^2) / ((1+1/N)*sigma));
%theoretical_posterior  = theoretical_posterior_fh(y);
%theoretical_posterior = theoretical_posterior / norm(theoretical_posterior, 1);
X(posterior >= max(posterior)*0.99,:)


