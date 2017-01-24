function X = simulateMarkovChainByMC_multipleStates(transition_probabilities, starting_value, chain_length)
X = zeros(length(transition_probabilities),1);
%chain = zeros(1,chain_length);
%chain(1)= starting_value;
X(starting_value) = 1;
    for i=2:chain_length
        for k = 1:length(X(:,i-1))
            if(X(k,i-1) == 1)
                X(k,i) = 1;
                this_step_distribution = transition_probabilities(k,:);
                cumulative_distribution = cumsum(this_step_distribution);
                r = rand();
                nextState = find(cumulative_distribution>r,1);
                X(nextState,i) = 1;
            end
        end
    end
end