function [diff,index] = closestToVector(M,v)
[n,m] = size(M);
minNorm = norm(M(1,:) - v,2);
index = 1;
for i = 2:n
    currentNorm = norm(M(i,:) - v,2);
    if(currentNorm < minNorm)
        minNorm = currentNorm;
        index = i;
    end
end
diff = minNorm;