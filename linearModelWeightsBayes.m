% Linear Model Bayes Beipiel
% Die Gewichte des linearen Modells sollen ermittelt werden
clear all
close all
mu = [1.3 -2.8]; 
sigma_weights = [.5,.5];
sigma_weights = diag(sigma_weights);

range = [0:0.05:4; -4:0.05:0]';
[X1,X2] = meshgrid(range);

% P(theta)
prior_fh = @(x) mvnpdf(x,mu,sigma_weights);
prior = prior_fh([X1(:),X2(:)]);
prior = reshape(prior, length(X1), length(X2));
prior = prior / sum(sum(prior));

% Echte Gewichte
weights = [1.5, -2.5];

% Datenpunkte
N = 100;
mu_distribution = [1,2];
Psi =  mvnrnd(mu_distribution, sigma_weights, N);
y = Psi*weights'; %Y | theta verteilt wie: N(Psi^T * weights , sum(sigma*weights'))

% P(y | theta)
conditional_likelihood_fh = @(x)( mvnpdf(mean(x), [X1(:),X2(:)]*mu_distribution', sum(sigma_weights*[1,1]') / N ));
conditional_likelihood = conditional_likelihood_fh(y);
conditional_likelihood = reshape(conditional_likelihood, length(X1), length(X2));
conditional_likelihood = conditional_likelihood / sum(sum(conditional_likelihood));

% P(theta | y)
posterior = conditional_likelihood .* prior;% / likelihood;
posterior = posterior / sum(sum(posterior));

theoretical_theta = (Psi'*Psi)\Psi'*y;
%theoretical_posterior_fh = @(x) mvnpdf(range, (mu*sigma/N + mean(x)*sigma) / ((1+1/N)*sigma), (sigma^2) / ((1+1/N)*sigma));
%theoretical_posterior  = theoretical_posterior_fh(y);
%theoretical_posterior = theoretical_posterior / norm(theoretical_posterior, 1);

%hold on
figure(1)
surf(X1,X2, posterior)
legend('Posterior')
figure(2)
surf(X1,X2, conditional_likelihood)
legend('Likelihood')
figure(3)
surf(X1,X2, prior)
legend('Prior')
%plot(range, prior)
%plot(range, conditional_likelihood, '--g')
%plot(range, posterior , '-+r')
%plot(range, theoretical_posterior, 'o-y')

