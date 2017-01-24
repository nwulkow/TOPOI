clear all
R = [-6,1,3,2; 2,-6,2,2; 2,3,-6,1; 4,1,2,-7];
[n,m] = size(R);
f_m_rates = expectedMeanFirstPassageTimesWithRate(R);
f_m_rates_sum = sum(f_m_rates,2);

% Prozess simulieren
numIter = 1000;
x0 = 1;
chain_rates = simulateMarkovRateChainByMC(R,x0,numIter);
f_d_rates = meanFirstHittingTimes(chain_rates);
f_d_rates = f_d_rates / lcms(-diag(R));
f_d_rates = f_d_rates - diag(diag(f_d_rates))
f_d_rates_sum = sum(f_d_rates,2)
% likelihoods ausrechnen fuer alle moeglichen Rate-Matrizen
ranges = {[0.5,1,1.5],[2.5,3,3.5],[1.5,2,2.5],[1.5,2,2.5],[1.5,2,2.5],[1.5,2,2.5],[1.5,2,2.5],[2.5,3,3.5],[0.5,1,1.5],[3.5,4,4.5],[0.5,1,1.5],[1.5,2,2.5]};
prior = @(x) mvnpdf(x, [1,3,2,2,2,2,2,3,1,4,1,2], eye(12) );
X = vectorsToMatrix(ranges);
l_vec = [];
p_vec = [];
for i = 1:length(X)
    i
    currentR = zeros(size(R));
    for j = 1:length(X(i,:))
        currentR(j + 1 + floor((j-0.1)/n)) = X(i,j);
    end
    for k = 1:n
        currentR(k,k) = -sum(currentR(k,:));
    end
    currentR = currentR';
    %f_m_rates = expectedMeanFirstPassageTimesWithRate(R);
    %f_m_rates_sum = sum(f_m_rates,2);
    likelihood = likelihoodOfTransferRates(currentR,f_d_rates_sum);
    posterior = likelihood * prior(X(i,:));
    l_vec = [l_vec, likelihood];
    p_vec = [p_vec, posterior];
end

