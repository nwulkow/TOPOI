function Pvec = transitionOperation(P,vec)
n = length(vec);

P_op = P;
for l = 1:n
    P_op(l,l) = 1;
end

for i = 1:n
    % W'keit, dass von einem anderen State nach Zustand i gewechselt wird
    probForTransitionFromAnyState = 1 - prod(1-vec.*P_op(:,i)');
    Pvec(i) = probForTransitionFromAnyState;
end
