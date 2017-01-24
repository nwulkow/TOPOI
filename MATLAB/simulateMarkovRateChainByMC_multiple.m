function chain = simulateMarkovRateChainByMC_multiple(rates, starting_value, chain_length)
% Simuliert Markov Chain wobei sich der Prozess in den Zustaenden
% unterschiedlich lange aufhaelt. Diese Wartezeiten werden in waitingTimes
% festgehalten
[n,m] = size(rates);
for i = 1:length(rates)
    Q = rates;
    Q(:,i) = 0;
    waitingTimes(i) = 1 / sum(Q(i,:));
    P(i,:) = Q(i,:) * waitingTimes(i);
%     Q(i,i) = 0;
%     waitingTimes(i) = 1 ./ sum(Q(i,:)); % Durchschnittliche Wartezeit in Zustand i
end

% states = [starting_value, 1:n];
% sIndex = find(states == starting_value);
% states(sIndex(end)) = [];
inverseWaitingTimes = 1./waitingTimes;
lcm = lcms(inverseWaitingTimes); % kgv der Kehrwerte der Wartezeiten
chain_length = chain_length * lcm;

chain = zeros(n,chain_length);
chain(starting_value,1:end) = 1;
%i = waitingTimes(starting_value)*lcm;
next = starting_value;
for k = 1:n
    s = next;
    this_step_distribution = P(s,:);
    %currentMeanWaitingTime = waitingTimes(s)*lcm;
    %currentMeanWaitingTime = inverseWaitingTimes(s)*lcm;
    i = min(find(chain(s,:) == 1));
    if(k == 1)
        i = 1;
    end
    justStarted = true;
    while i < chain_length
        cumulative_distribution = cumsum(this_step_distribution);
        r = rand();
        nextState = find(cumulative_distribution>r,1);
        % Wartezeit aus Exp.-Verteilung ziehen:
        %currentWaitingTime = round(exprnd(currentMeanWaitingTime));
        currentUnadjustedWaitingTime = (exprnd(waitingTimes(s)));
        currentWaitingTime = round(currentUnadjustedWaitingTime * lcm);
        %currentWaitingTime = round(exprnd(currentMeanWaitingTime));
        chain(nextState,i+currentWaitingTime:chain_length) = 1;
        if(justStarted)
            next = nextState;
            justStarted = false;
        end
        i = i+currentWaitingTime;
    end
end

lastIndex = find(ismember(chain',ones(1,n),'rows'),1);
if(length(lastIndex) > 0)
    chain = chain(:,1:lastIndex);
end