function diff = reconstructTransitionProcess(M,X)

[n,m] = size(X);
sum = 0;
for i = 2:n
    sum = sum + norm(M^(i-1) * X(1,:)' - X(i,:)',2);
end
diff = sum;
