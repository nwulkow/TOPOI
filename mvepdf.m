function p = mvepdf(X,lambda)

[n,m] = size(X);
for i = 1:n
    p(i) = prod(exppdf(X(i,:), lambda));
end