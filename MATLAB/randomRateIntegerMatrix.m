function R = randomRateIntegerMatrix(noStates, meanValue)

R = rand(noStates,noStates)*meanValue;
R = round(R);
for i = 1:noStates
    R(i,i) = - (sum(R(i,:)) - R(i,i));
end
