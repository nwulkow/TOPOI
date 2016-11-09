% Linear Model Bayes Beipiel
% Der Mittelwert einer 2-dim. normalverteilten Variable soll ermittelt
% werden. Die Gewichte des linearen Modells sind fest
mu = [1 1]; 
%sigma = [.9 .4; .4 .3]; 
sigma = [.9 .0; .0 .3]; 

range = [0:0.05:2; 0:0.05:2]';
[X1,X2] = meshgrid(range);

% P(theta)
prior_fh = @(x) mvnpdf(x,mu,sigma);
prior = prior_fh([X1(:),X2(:)]);
prior = reshape(prior, length(X1), length(X2));
prior = prior / norm(prior,1);

% Datenpunkte
N = 100;
weights = [1, 2];
Psi =  mvnrnd([0.7, 0.8], sigma, N);
y = Psi*weights'; %Y | theta verteilt wie: N(Psi^T * weights , *eine Standardabweichung aber welche?*)

% P(y | theta)
conditional_likelihood_fh = @(x)( mvnpdf(mean(x), [X1(:),X2(:)]*weights', sum(sigma*weights')/N ));
conditional_likelihood = conditional_likelihood_fh(y);
conditional_likelihood = reshape(conditional_likelihood, length(X1), length(X2));
conditional_likelihood = conditional_likelihood / norm(conditional_likelihood,1);

% P(theta | y)
posterior = conditional_likelihood .* prior;% / likelihood;
posterior = posterior / norm(posterior, 1);

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

