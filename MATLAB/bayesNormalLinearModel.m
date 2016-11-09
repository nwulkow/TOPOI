% Funktion zur Ermittlung des posterior distribution der normalverteilten Gewichte eines
% linearen Modells. Es wird angenommen, dass die Daten 'data' einer
% Normalverteilung entstammen mit Mittelwerten mu_distribution und STDs
% sigma_distribution. Außerdem muss die STD der Gewichte normalverteilt
% sind mit 'sigma_distribution'. Ausgegeben werden der posterior und die laut posterior
% wahrscheinlichsten Gewichte

function result = bayesNormalLinearModel(prior, ranges, data, mu_distribution, sigma_weights)

sigma_weights = diag(sigma_weights);

X = vectorsToMatrix(ranges);

% P(y | theta)
conditional_likelihood_fh = @(x) mvnpdf(x, X*mu_distribution', sum(sum(sigma_weights)) / length(data) );
% Wenn data nur eine Zeile ist, dann nimmt 'mean' den Durchschnitt ueber
% diese Zeile. Das will ich hier vermeiden
[n,m] = size(data);
if(min(n,m) == 1)
    argument = data;
else
    argument = mean(data);
end

conditional_likelihood = conditional_likelihood_fh(argument);
conditional_likelihood = conditional_likelihood / sum(sum(conditional_likelihood));

% P(theta | y)
posterior = conditional_likelihood .* prior;
posterior = posterior / sum(sum(posterior));
weights = X(posterior >= max(posterior),:);
result.posterior = posterior;
result.weights = weights;



