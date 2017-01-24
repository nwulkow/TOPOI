function f_d = firstHittingTimes_multipleStates(X)

[n,m] = size(X);
f_d = zeros(n,n);
for i = 1:n
    for j = 1:n
        duration = min(find(X(j,:) == 1)) - min(find(X(i,:) == 1));
        if(duration > 0)
            f_d(i,j) = duration;
        end
    end
end