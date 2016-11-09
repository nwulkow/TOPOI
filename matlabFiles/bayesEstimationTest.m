clear all
y = randn(1,1)+1;
sigma = 0.5;
prior = @(x) exp(-0.5* (0.3 - x).^2 ./ sigma^2);
%prior = @(x) ones(1,length(x)).*1 / (2.5 - (-1.5));
Pyut = @(x,mu) exp( -0.5*(mu - x).^2 ./ sigma^2);
mu_range = -1.5:0.1:2.5;
prior_array = prior(mu_range);
prior_array = prior_array / norm(prior_array,1);
prior_Matrix = [prior_array];

numIter = 1;
for i = 1:numIter
    y = randn(1,1)+1;
    posterior = bayesPosteriordistribution(prior_array,Pyut,y,mu_range,0);
    prior_array = posterior;
    prior_array = prior_array / norm(prior_array,1);
    prior_Matrix = [prior_Matrix; prior_array];
end
hold on
plot(mu_range, prior_Matrix)
plot(mu_range, Pyut(y,mu_range) / norm(Pyut(y,mu_range),1), 'r')
legendstring = {};
for j = 1:numIter+1
    legendstring{end+1} = num2str(j);
end
legend(legendstring)

%posterior = bayesPosteriordistribution(prior_array,Pyut, y, 1);
