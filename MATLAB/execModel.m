% Funktion, die zu mit Daten gefuellten Regionen und Angaben zur
% Benachbarung der Regionen die Parameterschaetzung durchfuehrt

% B = kx2-Matrix mit benachbarten Regionen. Wenn Region i und j benachbart
% sind, ist [i,j] eine Zeile von B
% T = kxk-Matrix mit transfer rates zwischen den Regionen
% regions = cell array mit den regionen im Region-Typ
% wagenTypen = Anzahl verschiedener Wagentypen
function model = execModel(B, T, regions, wagenTypen)

% Regionen, die benachbart sind, haben eine 1 an den entsprechenden Stellen
% in der Matrix, sonst 0.
N = neighbourMatrix(B,length(regions));

% travel rates: Personen pro timestep von Region i zu Region j
T = T.*N; % Zwischen nicht-benachbarten Regionen gibt es keine travelrate. Um
% Fehler zu vermeiden, wird eine 0 eingefuegt, wenn zwei Regionen nicht
% benachbart sind

noRegions = length(regions);
timeSteps = length(regions(1).infected(1,:));

% Parameterschaetzung

% Infection probabilites:

% Fuer jede Region: Wie lange dauerte es bis zur Infektion und wie viele
% Personen sind seitdem in der Region angekommen, die aus einer Region
% kamen, in der es diese Erfindung schon gab:
for l = 1:noRegions
    sumOfTravelers = 0;
    for j = 1:noRegions
        sumOfTravelers = sumOfTravelers + length(find(regions(l).infected - regions(j).infected == -1))*T(j,l);
    end
    % Anzahl Erfindungen, die in der Region aufgetreten sind und von
    % woanders kamen
    sums = zeros(1,wagenTypen);
    for k = 1:noRegions
        if(k ~= l)
            sums = sums + min(0, sum((regions(l).infected - regions(k).infected)'));
        end
    end
    numberOfTimesInfected = sum(sums < 0);
    
    %infectionProb = numberOfTimesInfected / sum(sumOfTravelers); % Analytische Loesung   
    
    % Ausbreitungs-Rate
    fullySpreadTypes = 0;
    timeNeededForSpread = zeros(1,noRegions);
    for i = 1:wagenTypen
        if(~isempty(find(regions(l).spread(i,:) == 2,1))) % Wenn diese Erfingund niemals Stufe 2 in der Region erreicht hat
           fullySpreadTypes = fullySpreadTypes + 1;
            if(~isempty(find(regions(l).spread(i,:) == 1,1)))
                timeNeededForSpread(i) = min(find(regions(l).spread(i,:) == 2,1)) - min(find(regions(l).spread(i,:) == 1,1)); %Pro Wagentyp: Wie lange dauerte
            % es vom ersten Erreichen von Stufe 1 bis zum ersten Erreichen
            % von Stufe 2?
                 % Wie viele Wagentypen haben ueberhaupt Stufe 2 erreicht?
            else
                timeNeededForSpread(i) = 0;
            end
        else
            if(~isempty(find(regions(l).spread(i,:) == 1,1)))
                timeNeededForSpread(i) = timeSteps - min(find(regions(l).spread(i,:) == 1,1));
            else
                timeNeededForSpread(i) = 0;
            end
         end
     end
       % timeNeededForSpread(i) = min(find(regions(l).spread(i,:) == 2)) - min(find(regions(l).spread(i,:) == 1));
        %spreadRate = fullySpreadTypes / sum(timeNeededForSpread);
   % end
    objectiveFunction = @(p,r) sum([-(1-p).^(sumOfTravelers-numberOfTimesInfected).*p.^numberOfTimesInfected*100 + 1e6*(p<0 || p>1); % '*10000', weil sonst irgendwie was falsches rauskommt fuer den ersten Parameter
                                    abs( r - fullySpreadTypes/sum(timeNeededForSpread))]);
    params = fminsearch(@(args) objectiveFunction(args(1),args(2)), [0.05,0.5]);
    % MATLAB-Loesung. Nuetzlich, wenn mehrere Parameter auf einmal bestimmt werden sollen
    % und eine analytische Loesung schwer zu finden ist
    infectionProb = params(1);
    spreadRate = params(2);
 
    regions(l).infectionProb = infectionProb;
    regions(l).spreadRate = spreadRate;
    
    % BAYES:
    % Bayes auf die Infektions-W'keit
    infecProb_range = 0:0.002:0.2;
    regions(l).infectionProbDist_xVector = infecProb_range;
    infecProbPrior = @(p) normpdf(p,0.01,0.01); % Rate nach Normalverteilung
    likelihood = @(y,p) (1-p).^((numberOfTimesInfected./y)-numberOfTimesInfected) .* p.^numberOfTimesInfected; % W'keit, dass
    % es 'numberOfTimesInfected' Infizierungen gab (binomial).
    % (numberOfTimesInfected./y) ist das n, fuer das y maximierend ist bei
    % numberOfTimesInfected Infizierungen
    
    %Bayes auf die SpreadRate
    ratePrior = @(r) normpdf(r,0.5,0.3);
    rateLikelihood = @(y,r) normpdf(y,r,0.3);
    rate_range = 0:0.01:1;
    regions(l).spreadRateDist_xVector = rate_range;

    ranges = [infecProb_range ; rate_range];
    fullPrior = @(arg) [infecProbPrior(arg(1,:)) ; ratePrior(arg(2,:))];
    fullLikelihood = @(y,arg) [likelihood(y(1),arg(1,:));rateLikelihood(y(2),arg(2,:))];
    fullPosterior = fullPrior(ranges).*fullLikelihood(params,ranges);
    
    % Plotten
    plotArgin = 0;
    if(plotArgin == 1)
        fullPriorOnRange = fullPrior(ranges);
        legendStrings = {'infec. prob.', 'spread rate'};
        for j = 1:length(params)
           figure(l+(j-1)*wagenTypen)
           fullPosterior(j,:) = fullPosterior(j,:) / norm(fullPosterior(j,:),1);
           fullPriorOnRange(j,:) = fullPriorOnRange(j,:) / norm(fullPriorOnRange(j,:),1);
           hold on
           plot(ranges(j,:), fullPosterior(j,:))
           plot(ranges(j,:), fullPriorOnRange(j,:), 'r')
           legend(strcat(legendStrings{j},' posterior'),strcat(legendStrings{j},' prior'))
        end
    end

    regions(l).infectionProbDistribution = fullPosterior(1,:);
    regions(l).spreadRateDistribution = fullPosterior(2,:);
    
end

model.regions = regions;



end            