function f_m = estimateMeanFirstPassageTimes_multipleStates(P,phi0)

[n,m] = size(P);
c = ones(n-1,1);

for i = 1:n
    Q = P;
    Q(:,i) = [];
    Q(i,:) = [];
    phi0_mod = phi0;
    phi0_mod(i) = [];
    tempVector = ((eye(n-1)-Q)\(phi0_mod));
    tempVector = [tempVector(1:i-1);0;tempVector(i:end)];
    f_m(:,i) = tempVector;
end