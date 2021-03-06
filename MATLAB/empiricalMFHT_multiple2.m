%from = 3;
tic
to = 1;
numIter = 100;
counter = zeros(1,noStates);
A = zeros(1,noStates);
for k = 1:noStates
    for l = 1:numIter
        %chain = simulateMarkovRateChainByMC_multiple(R,k,10);
        chain = simulateMarkovChainByMC(P,k,500);
        f = firstHittingTimes(chain);
        if(f(k,to) > 0)
            A(k) = A(k) + f(k,to);
            counter(k) = counter(k) + 1;
        end
        %A = A + firstHittingTimes_multipleStates(chain);
    end
end
eMFHT = A ./ counter;
eMFHT(to) = 0
toc