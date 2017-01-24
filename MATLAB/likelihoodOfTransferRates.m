function r = likelihoodOfTransferRates(R,f_d)
%f_d = [1.5511,1.4293,1.5387,1.4147]';
f_m_rates = expectedMeanFirstPassageTimesWithRate(R);
f_m_rates_sum = sum(f_m_rates,2);

% Rate-Matrix Bedingungen:
J = 0;
for j = 1:length(R)
    rowsum = 0;
    for i = 1:length(R)
       if(i ~= j)
        rowsum = rowsum + R(j,i);
       end
    end
    J = J + abs(rowsum + R(j,j));
end

r = (exp( - norm(f_m_rates_sum - f_d,2)));% + 1000*J;