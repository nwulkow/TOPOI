function f_m = expectedMeanFirstPassageTimesWithRate(R)

[n,m] = size(R);
c = ones(n-1,1);

for j = 1:n
    W(j) = sum(R(j,:))-R(j,j);
    P(j,:) = R(j,:) / W(j);
    P(j,j) = 0;
end

for i = 1:n
    Q = P;
    Q(:,i) = [];
    Q(i,:) = [];
    currentW = W;
    currentW(i) = [];
    tempVector = ((eye(n-1)-Q)\(1./currentW)');
    tempVector = [tempVector(1:i-1);0;tempVector(i:end)];
    f_m(:,i) = tempVector;
end