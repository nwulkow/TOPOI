function diff = rateML(data, times,  rates)

timesR = times(2:end);
timesL = times(1:end-1);
timesDelta = timesR - timesL;

[K,N] = size(data);
reconsData = zeros(K,N);
reconsData(:,1) = data(:,1);
for j = 1:K
    for i = 2:N
        reconsData(j,i) = reconsData(j,i-1)*(rates(j)^(timesDelta(i-1)));
    end
end
diff = sum(norm(data - reconsData) / N);
%diff = sum(abs(data - reconsData) ./ abs(data)) / N;