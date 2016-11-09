% Bayes Parameter Estimation mit p(y|theta) als function handle
function posterior = BayesPosteriorDistribution(prior, Pyut)

sigma = 1;
% prior fuer mu
%prior = @(x) exp(-0.5* (0.8 - x).^2 ./ sigma^2); 

% P( x | p )
%Pyut = @(x,mu) exp( -0.5*(mu - x).^2 ./ sigma^2); 

% Range, wo mu vermutet wird
mu_range = -1.5:0.1:2.5;

% Data
y = randn(1,50) + 1;
n = length(y);

% P( y | o ) fuer die Daten y ausrechnen
P_yUnderTheta = ones(1,length(mu_range));
    for j = 1:n
        P_yUnderTheta = P_yUnderTheta .* Pyut(y(j),mu_range).*prior(mu_range);  
    end

% P( o | y ) ausrechnen
posterior = (P_yUnderTheta.*prior(mu_range));
posterior = posterior / norm(posterior,1);


priorOnRange = prior(mu_range);
priorOnRange = priorOnRange / norm(priorOnRange,1);
hold on
plot(mu_range, posterior)
plot(mu_range, priorOnRange, 'r')
legend('prior', 'posterior')

figure(2)
plot(y,ones(1,length(y)), 'o')
