% MLCounter = 0;
% bayesCounter = 0;
% for k = 1:100

% Startwerte
clear all

X1 = 10;
X2 = 2;
X3 = 10;
X4 = 3;
X5 = 0.4;
X = [X1,X2,X3,X4,X5];

% Echte Raten
rate1 = 1.201; 
rate2 = 3.2;
rate3 = 1.1;
rate4 = 2.3;
rate5 = 10.4;
rates = [rate1,rate2,rate3,rate4,rate5];

% Ranges
mu_range1 = 0:0.1:3;
mu_range2 = 0:0.1:6;
mu_range3 = 0.9:0.01:1.1;
mu_range4 = 0:0.1:5;
mu_range5 = 7:0.1:13;
mu_ranges = {mu_range1,mu_range2,mu_range3,mu_range4,mu_range5};

N = 100; % Anzahl Datenpunkte
K = 2; % Anzahl Orte
X = X(1:K);
rates = rates(1:K);
mu_ranges_temp = mu_ranges(1);
for l = 2:K
    mu_ranges_temp{l} = mu_ranges{l};
end
mu_ranges = mu_ranges_temp;
data = zeros(K,N);
times = zeros(1,N);
timesDelta = zeros(1,N-1);

data(:,1) = X;
times(1) = 1;

for j = 1:K
    for i = 2:N
        times(i) = times(i-1) + rand(1,1); % Zeitpunkte, auf die die Daten datiert werden
        timesDelta(i-1) = times(i) - times(i-1); % Abstaende zwischen den Zeitpunkten
        data(j,i) = data(j,i-1)*(rates(j)*(0.9+rand(1,1)*0.2))^(timesDelta(i-1)); % Erstellen der Daten
    end
end

initialParams = (data(:,2) ./ data(:,1)).^(1/timesDelta(1));
bestRateML = fminsearch(@(rates)rateML(data,times,rates), initialParams); % Beste Rate mit fminsearch
bestRateBayes = rateBayes(data,times,mu_ranges); % Beste Rate mit Bayes
bestRateBayes = bestRateBayes.optimal;

reconsDataML = zeros(K,N);
reconsDataBayes = zeros(K,N);
reconsDataML(:,1) = X;
reconsDataBayes(:,1) = X;
for j = 1:K
    for i = 2:N
        reconsDataML(j,i) = reconsDataML(j,i-1).*(bestRateML(j)^(timesDelta(i-1))); % Entwicklung der Daten rekonsturieren mit bestRates
        reconsDataBayes(j,i) = reconsDataBayes(j,i-1).*(bestRateBayes(j)^(timesDelta(i-1)));
    end
end
% if(norm(rate-bestRateML)<norm(rate-bestRateBayes))
%     MLCounter = MLCounter + 1;
% else if(norm(rate-bestRateML)>norm(rate-bestRateBayes))
%     bayesCounter = bayesCounter + 1;
%     end
% end
% end
%Plotten
for h = 1:K
    figure(h)
    hold on
    plot(times,data(h,:), '-o','LineWidth',1.5)
    plot(times,reconsDataML(h,:),'--go','Color','r','LineWidth',1.5)
    plot(times,reconsDataBayes(h,:),'y-*','LineWidth',1.5)
    legend(strcat('data with real rate =', num2str(rates(h))),strcat('reconstructed data with ML rate = ', num2str(bestRateML(h))),strcat('reconstructed data with Bayes rate = ', num2str(bestRateBayes(h))))
end

% MLCounter
% bayesCounter
