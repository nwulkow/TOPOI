% Funktion zur Ermittlung des posterior distribution Mittelwerte einer
% Normalverteilung. Es wird angenommen, dass die Daten 'data' einer
% Normalverteilung entstammen mit Mittelwerten mit STDs
% sigma. Ausgegeben werden der posterior und die laut posterior
% wahrscheinlichsten Mittelwerte
function result = bayesNormalDistribution(prior, ranges, data, sigma)

[n,m] = size(data);

X = vectorsToMatrix(ranges);
% P(y | theta)
conditional_likelihood_fh = @(x) mvnpdf(x, X, sigma/(min(n,m)))+eps;
% Wenn data nur eine Zeile ist, dann nimmt 'mean' den Durchschnitt ueber
% diese Zeile. Das will ich hier vermeiden
if(min(n,m) == 1)
    argument = data;
else
    argument = mean(data);
end
conditional_likelihood = conditional_likelihood_fh(argument);
conditional_likelihood = conditional_likelihood / sum(sum((conditional_likelihood)));
% size(conditional_likelihood)
% size(prior)
% P(theta | y)
size(conditional_likelihood)
size(prior)
posterior = conditional_likelihood .* prior;
posterior = posterior / sum(sum((posterior)));
% Ergebnis
% Optimale Mittelwerte laut posterior
optimal = X(posterior >= max(posterior),:);
result.posterior = posterior;
result.optimal = optimal;