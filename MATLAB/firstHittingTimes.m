function f_d = firstHittingTimes(chain)

states = [];
for i = 1:length(chain)
    if(sum(find(states == chain(i))) == 0)
        states = [states, chain(i)];
    end
end
states = sort(states);
noStates = length(states);

for j = 1:noStates
    firstJHit = min(find(chain == j));
    for k = 1:noStates
        chainAtK = find(chain == k);
        firstRelevantKHit = min(chainAtK( find(chainAtK > firstJHit))) ; 
        f_d(j,k) = firstRelevantKHit - firstJHit;
    end
end