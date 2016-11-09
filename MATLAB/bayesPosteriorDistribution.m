% Bayes Parameter Estimation mit p(y|theta) als function handle
% Input: Prior als vektor; P( x | theta ) als function handle mit
% Argument x und Parameter theta; Data y
function posterior = bayesPosteriorDistribution(prior, Pyut, y, mu_range, plotVarArgin)


% Data
n = length(y);

% P( y | o ) fuer die Daten y ausrechnen
P_yUnderTheta = ones(1,length(mu_range));
    for j = 1:n
        P_yUnderTheta = P_yUnderTheta .* Pyut(y(j),mu_range).*prior;  
    end

% P( o | y ) ausrechnen
posterior = (P_yUnderTheta.*prior);
posterior = posterior / norm(posterior,1);
if(plotVarArgin == 1)
    prior = prior / norm(prior,1);
    hold on
    plot(mu_range, posterior)
    plot(mu_range, prior, 'r');
    legend('prior', 'posterior');

    figure(2)
    plot(y,ones(1,length(y)), 'o');
end
