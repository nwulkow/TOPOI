function X = modelMarkovProcessByEuler(X0, deltaT, b, sigma, numIter)
X(1) = X0;
for i = 1:numIter
    X(i+1) = EMstep(X(i),deltaT,b,sigma);
end
end