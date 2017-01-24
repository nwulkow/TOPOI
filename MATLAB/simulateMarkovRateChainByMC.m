function chain = simulateMarkovRateChainByMC(rates, starting_value, chain_length)
% Simuliert Markov Chain wobei sich der Prozess in den Zustaenden
% unterschiedlich lange aufhaelt. Diese Wartezeiten werden in waitingTimes
% festgehalten

for i = 1:length(rates)
    Q = rates;
    Q(:,i) = 0;
    waitingTimes(i) = 1 / sum(Q(i,:));
    P(i,:) = Q(i,:) * waitingTimes(i);
%     Q(i,i) = 0;
%     waitingTimes(i) = 1 ./ sum(Q(i,:)); % Durchschnittliche Wartezeit in Zustand i
end

inverseWaitingTimes = 1./waitingTimes;
lcm = lcms(inverseWaitingTimes); % kgv der Kehrwerte der Wartezeiten
chain_length = chain_length * lcm;

chain = zeros(1,chain_length);
chain(1:waitingTimes(starting_value)*lcm-1) = starting_value;
i = waitingTimes(starting_value)*lcm;
while i < chain_length
    this_step_distribution = P(chain(i-1),:);
    cumulative_distribution = cumsum(this_step_distribution);
    r = rand();
    currentWaitingTime = waitingTimes(chain(i-1))*lcm;
    chain(i:i+currentWaitingTime-1) = find(cumulative_distribution>r,1);
    i = i+currentWaitingTime;
end

end