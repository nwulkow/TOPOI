function P = makeStochastic(M)

[n,m] = size(M);
for i = 1:n
    P(i,:) = M(i,:) / sum(M(i,:));
end