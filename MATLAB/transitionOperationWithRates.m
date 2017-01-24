function Pvec = transitionOperationWithRates(R,vec,time)
n = length(vec);

R_op = R;
for l = 1:n
    R_op(l,l) = Inf;
end

for i = 1:n
    % W'keit, dass von j nach i gewechselt wird in bestimmter Zeit (davon ausgehend,
    % dass der Zustand besetzt ist):
    for j = 1:n
        F(j) = 1-exp(-R_op(j,i)*time);
    end
    % W'keit, dass von einem anderen State nach Zustand i gewechselt wird
    probForTransitionFromAnyState = 1 - prod(1-vec.*F);
    Pvec(i) = probForTransitionFromAnyState;
end