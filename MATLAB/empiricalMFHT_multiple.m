numIter = 1000;
A = zeros(length(P));
for l = 1:numIter
    chain = simulateMarkovChainByMC_multipleStates(P,3,10);
    FHT = firstHittingTimes_multipleStates(chain);
    A = A + FHT;
end
A = A / numIter