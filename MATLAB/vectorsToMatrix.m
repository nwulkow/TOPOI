function M = vectorsToMatrix(X)

% Input: Vektoren in einem Cell Array.
% Output: Matrix mit allen moeglichen Kombinationen aus Eintraegen aus den
% jeweiligen Vektoren
m = length(X);
product = 1;
for k = 1:m
    lengths(k) = length(X{k});%length(find(X{k} == -eps));
    product = product * lengths(k);
end

for j = m:-1:1
    blocklength = prod(lengths(j+1:m));
    noBlocks = prod(lengths(1:j-1));
    fullblock = [];
    for i = 1:length(X{j})
        for l = 1:blocklength
            fullblock = [fullblock; X{j}(i)];
        end
    end
    allBlocks = [];
    for k = 1:noBlocks
        allBlocks = [allBlocks; fullblock];
    end
    M(:,j) = allBlocks;
end

% for i = 1:product
%     for j = m:-1:1
%         blocklength = prod(lengths(j+1:m));
%         block = floor((i-0.1) / blocklength) + 1;
%         index = floor(mod(block-0.1, lengths(j)))+1;
%         M(i,j) = X{j}(index);
%     end
% end

