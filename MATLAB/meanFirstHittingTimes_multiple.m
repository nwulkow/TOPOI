
noStates = 4;
time = 1;
R = randomRateIntegerMatrix(noStates,5);
%index = find(ismember(S,[1 1 0],'rows'));
%P = [0 1 0; 1 0 0; 0 0 1];
P = rand(noStates);
for h = 1:noStates
    P(h,h) = 0;
end
P = makeStochastic(P);
tic
%P = [0.0,0.5,0.5; 0.5, 0, 0.5; 0.5, 0.5, 0];
S = designDistributions(noStates,P);
%S = designDistributionsWithRates(noStates,R,time);

n = length(S);
j = 1;
M = zeros(n,n);
Psi = zeros(n,1);
sumOfDistances = 0;
for i = 1:n
    vec = S(i,:);
    index = find(ismember(S,vec,'rows'));
    %Pvec = P*vec';
    Pvec = transitionOperation(P,vec)';
    %Pvec = transitionOperationWithRates(R,vec,time)';
    [diff,index2] = closestToVector(S,Pvec');
    %index2 = find(ismember(S,Pvec','rows'));
    M(index,index2) = 1;
    sumOfDistances = sumOfDistances + diff;
    Psi(i) = vec(j);
end
%sumOfDistances / n

K = diag(1-Psi);
m = pinv(eye(n)-K*M)*(time*(1-Psi));

MFHT = [];
for l = 1:noStates
    startVec = zeros(1,noStates);
    startVec(l) = 1;
    [diff,index] = closestToVector(S, startVec);
    MFHT = [MFHT, m(index)];
end
toc
MFHT