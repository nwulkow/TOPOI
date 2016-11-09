% Bayes Parameter Estimation mit p(y|theta) als function handle
% Input: Prior als function handle mit Argument x; P( x | theta ) mit
% Argument x und Parameter; Data y
function posterior = bayesPosteriorDistributionFH(prior, mu_range, Pyut, y, plotVarArgin)

% Data
n = length(y);

% P( y | o ) fuer die Daten y ausrechnen
P_yUnderTheta = ones(1,length(mu_range));
    for j = 1:n
        P_yUnderTheta = P_yUnderTheta .* Pyut(y(j),mu_range).*prior(mu_range);  
    end

% P( o | y ) ausrechnen
posterior = (P_yUnderTheta.*prior(mu_range));
posterior = posterior / norm(posterior,1);

if(plotVarArgin == 1)
    priorOnRange = prior(mu_range);
    priorOnRange = priorOnRange / norm(priorOnRange,1);
    hold on
    plot(mu_range, posterior);
    plot(mu_range, priorOnRange, 'r');
    legend('prior', 'posterior');

    figure(2)
    plot(y,ones(1,length(y)), 'o');
end