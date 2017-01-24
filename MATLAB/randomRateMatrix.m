function R = randomRateMatrix(noStates, meanValue)

R = rand(noStates,noStates)*meanValue;

for i = 1:noStates
    R(i,i) = - (sum(R(i,:)) - R(i,i));
end
