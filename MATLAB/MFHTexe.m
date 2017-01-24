clear all
R = [-6,1,3,2; 2,-6,2,2; 2,3,-6,1; 4,1,2,-7];
for i = 1:length(R)
    P(i,:) = R(i,:) / (sum(R(i,:))-R(i,i));
    P(i,i) = 0;
end
f_m_rates = expectedMeanFirstPassageTimesWithRate(R);
f_m_transitions = expectedMeanFirstPassageTimes(P);

f_m_rates_sum = sum(f_m_rates,2);
% Prozess simulieren
numIter = 1000;
x0 = 1;
chain_rates = simulateMarkovRateChainByMC(R,x0,numIter);
f_d_rates = meanFirstHittingTimes(chain_rates)

chain_transitions = simulateMarkovChainByMC(P,x0,numIter);
f_d_transitions = meanFirstHittingTimes(chain_transitions)

% Norm der Differenz-Matrizen
f_d_rates = f_d_rates / 42;
f_d_rates = f_d_rates - diag(diag(f_d_rates));
f_d_rates_sum = sum(f_d_rates,2);
likelihood = likelihoodOfTransferRates(R,f_d_rates_sum)


f_d_transitions = f_d_transitions - diag(diag(f_d_transitions));

norm(f_m_rates - f_d_rates,'fro') / norm(f_m_rates, 'fro')
norm(f_m_transitions - f_d_transitions ,'fro') / norm(f_m_transitions, 'fro')

