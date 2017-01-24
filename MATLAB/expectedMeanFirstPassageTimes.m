function f_m = expectedMeanFirstPassageTimes(P)

[n,m] = size(P);
c = ones(n-1,1);

for i = 1:n
    Q = P;
    Q(:,i) = [];
    Q(i,:) = [];
    tempVector = ((eye(n-1)-Q)\c);
    tempVector = [tempVector(1:i-1);0;tempVector(i:end)];
    f_m(:,i) = tempVector;
end