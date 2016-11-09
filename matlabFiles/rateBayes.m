function result = rateBayes(data, times, mu_ranges)

[K,N] = size(data);

timesR = times(2:end);
timesL = times(1:end-1);
timesDelta = timesR - timesL;

sigma = 0.01;
%prior = @(x) exp(-0.5 * (1.4 - x).^2 ./ sigma^2);
%Pyut = @(x,x_previous,rate,timeDelta) exp( -0.5*(x_previous*(rate^timeDelta) - x).^2 ./ (x_previous*sigma^2));

%mu_range = 0:0.001:2.5;
for j = 1:K
    uniformDistributionInterval(j) = mu_ranges{j}(end) - mu_ranges{j}(1);
end

prior = @(x) ones(length(x),1)./ prod(uniformDistributionInterval); % Prior zu Beginn Gleichverteilung auf Intervall, wo die Rate vermutet wird
%prior = @(x) mvnpdf(x , [1.2, 3], diag(ones(1,K)*sigma));
X = vectorsToMatrix(mu_ranges);
prior_array = prior(X);
prior_array = prior_array / norm(prior_array,1);

% Jetzt noch: Prior ueber den Bestand zum ersten Zeitpunkt:
sigma_bestand = 0.001;
prior_bestand = @(x) mvnpdf(x, [10,2], diag(ones(K,1)*sigma_bestand));
prior_bestand = @(x) mvepdf(x, [10,2]);

bestand_range = vectorsToMatrix({9:1:10, 1.5:0.5:2.5});
for k = 1:length(bestand_range)
    prior = @(x) ones(length(x),1)./ prod(uniformDistributionInterval); % Prior zu Beginn Gleichverteilung auf Intervall, wo die Rate vermutet wird
    prior_array = prior(X);
    startingValue(k,:) = bestand_range(k,:)';
    for i = 1:N-1
        if(i == 1)
            result = bayesNormalDistribution(prior_array, mu_ranges, (data(:,i+1)./startingValue(k,:)').^(1./timesDelta(i))', diag(ones(K,1)*sigma));
        else
            result = bayesNormalDistribution(prior_array, mu_ranges, (data(:,i+1)./data(:,i)).^(1./timesDelta(i))', diag(ones(K,1)*sigma));
        end
        prior_array = result.posterior;
    end
    optimal(k,:) = result.optimal;
    posteriors(k,:) = result.posterior;
end
% Alle posteriors mit dem Bestands-Prior gewichten und den optimalen
% rate-Wert rausfinden
[max_pos, argmax_pos]= max(result.posterior);
result.optimal = X(argmax_pos,:);
% weightedPosteriors = (diag(prior_bestand(startingValue))*posteriors)';
% [maxes, argmaxes] = max(weightedPosteriors);
% [maxOfmaxes, argmaxOfmaxes] = max(maxes);
% result.optimal = X(argmaxes(argmaxOfmaxes),:)

%result.optimal = X(argmaxes(argmaxOfmaxes), argmaxOfmaxes);
%X_posterior = max(max(diag(prior_bestand(optimal))*posteriors));
%result.optimal = X(posteriors(:,argmaxOfmaxes) >= max(posteriors(argmaxOfmaxes)),:);


