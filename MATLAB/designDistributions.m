function S = designDistributions(noStates,P)

r = {[0,1]};
for i = 2:noStates
    r{end+1} = [0,1];
end
X = vectorsToMatrix(r);
X(1,:) = [];
[n,m] = size(X);

maxDistr = 1000;
if(n > maxDistr)
    indices = randsample(n,maxDistr);
else
    indices = 1:n;
end
noDistr = length(indices);
for k = 1:3
    for i = 1:length(indices)
        X(end+1,:) = transitionOperation(P,X((k==1)*indices(i) + (k>1)*i +(k>1)*n + (k>1)*(k-2)*noDistr,:));
    end
end
S = X;

% ranges = {0:0.1:1};
% for l = 2:noStates
%     ranges{end+1} = [0:0.1:1];
% end
% ranges
% S = vectorsToMatrix(ranges);