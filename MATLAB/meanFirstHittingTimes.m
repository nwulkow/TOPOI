function f_d = meanFirstHittingTimes(chain)
chain_copy = chain;
states = [];
for i = 1:length(chain)
    if(sum(find(states == chain(i))) == 0)
        states = [states, chain(i)];
    end
end
states = sort(states);
noStates = length(states);

for j = 1:noStates
    for k = 1:noStates
        chain = chain_copy;
        startindex = 1;
        currentHittingTimes = [];
        while length(startindex) > 0
            chain = chain(startindex:end);
            firstJHit = min(find(chain == j));
            chainAtK = find(chain == k);
            if(length(firstJHit) == 0)
                startindex = [];
            else
                firstRelevantKHit = min(chainAtK( find(chainAtK > firstJHit)));
                currentHittingTimes = [currentHittingTimes,firstRelevantKHit - firstJHit];
                startindex = firstRelevantKHit;
            end
        end
        f_d(j,k) = mean(currentHittingTimes);
    end
end