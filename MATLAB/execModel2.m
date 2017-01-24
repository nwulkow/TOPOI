% Funktion, die zu mit Daten gefuellten Regionen und Angaben zur
% Benachbarung der Regionen die Parameterschaetzung durchfuehrt

% B = kx2-Matrix mit benachbarten Regionen. Wenn Region i und j benachbart
% sind, ist [i,j] eine Zeile von B
% T = kxk-Matrix mit transfer rates zwischen den Regionen
% regions = cell array mit den regionen im Region-Typ
% wagenTypen = Anzahl verschiedener Wagentypen
function model = execModel2(B, T, regions, wagenTypen)

% Regionen, die benachbart sind, haben eine 1 an den entsprechenden Stellen
% in der Matrix, sonst 0.
N = neighbourMatrix(B,length(regions));

% travel rates: Personen pro timestep von Region i zu Region j
T = T.*N; % Zwischen nicht-benachbarten Regionen gibt es keine travelrate. Um
% Fehler zu vermeiden, wird eine 0 eingefuegt, wenn zwei Regionen nicht
% benachbart sind

noRegions = length(regions);

% Prior fuer die Transferrate. Hier erstmal nur TR von Region 1 nach Region 2
transferRate_domain = 80:1:120;

T12 = @(x) exp(-0.5*(x-100).^2 ./ 10);
T12 = @(x) 1/41 .* (x>=80) .* (x <= 120);

    
% Das Produkt aller Priors fuer die TRs. x ist eine Vektor der Laenge
% noRegions^2 welcher alle TRs enthaelt
allTRPrior = @(x) prod((1/41 .* (x>=80) .* (x <= 120)));


%timeSteps = length(regions(1).infected(1,:));

% Parameterschaetzung

% Infection probabilites:

% Fuer jede Region: Wie lange dauerte es bis zur Infektion und wie viele
% Personen sind seitdem in der Region angekommen, die aus einer Region
% kamen, in der es diese Erfindung schon gab:
for l = 1:noRegions
    timeUntilInfection = zeros(1,noRegions);
    %infectionProcessRunning = zeros(1,timeSteps);
    sumOfTravelers = 0;
    for g = 1:wagenTypen
        for j = 1:noRegions
            %infectionProcessRunning(find(regions(l).infected(g,:) - regions(j).infected(g,:) == -1)) = 1;
            timeUntilInfection(j) = length(find(regions(l).infected - regions(j).infected == -1));
%             if(j == 2)
%                 timeTo1 = length(find(regions(l).infected - regions(j).infected == -1));
%             else
                sumOfTravelers = sumOfTravelers + length(find(regions(l).infected - regions(j).infected == -1))*T(j,l);
            end
                %timeUntilInfection = timeUntilInfection + length(find(regions(l).infected(g,:) - regions(j).infected(g,:) == -1));
        end
    end
    %timeUntilInfection = sum(infectionProcessRunning);
    % Anzahl Erfindungen, die in der Region aufgetreten sind und von
    % woanders kamen
    sums = zeros(1,wagenTypen);
    for k = 1:noRegions
        if(k ~= l)
            sums = sums + min(0, sum((regions(l).infected - regions(k).infected)'));
        end
    end
    numberOfTimesInfected = sum(sums < 0);
    

    % BAYES:
    % Bayes auf die Infektions-W'keit
    infecProb_range = 0:0.0001:0.02;
    %regions(l).infectionProbDist_xVector = infecProb_range;
    infecProbPrior = @(p) normpdf(p,0.01,0.001); % Rate nach Normalverteilung
   
    
    % Bayes auf TransferRate
    % P(TR|t) = P(TR) * P(t|TR)
    % TRvector ist ein n Eintrage langer Vektor mit allen Transferrates von
    % Region nach Region l
    
    % Alle TR_ranges korrespondierend zur T-Matrix in einen Vektor
    % geschrieben. Nach Spalten aufgelistet. Also erste n Eintrage sind die
    % erste Spalte. Dann kommt die zweite Spalte usw.
   % ranges = {[90,100,110],[90,100,110],[90,100,110],[90,100,110],[90,100,110],[90,100,110],[90,100,110],[90,100,110],[90,100,110],[90,100,110],[90,100,110],[90,100,110],[90,100,110],[90,100,110],[90,100,110],[90,100,110]};
    TRranges = {0,[90,100],[90,100],[90,100],[90,100],0,[90,100],[90,100],[90,100],[90,100],0,[90,100],[90,100],[90,100],[90,100],0};
    allTR = vectorsToMatrix(TRranges);
    likelihoodTR_fh = @(TRvector) sum((1-infecProb_range).^(timeUntilInfection*TRvector - numberOfTimesInfected) .* infecProb_range.^numberOfTimesInfected .* infecProbPrior(infecProb_range));
%     for f = 1:length(transferRate_domain)
%         likelihoodTR(f) = likelihoodTR_fh(transferRate_domain(f));
%     end
    for f = 1:length(allTR)
            likelihoodTR(f) = likelihoodTR_fh(allTR(f,find(mod(1:noRegions^2,noRegions) == mod(l,noRegions)))'); % Nur die Spalten in allTR
            % betrachten, die zu TRs korrespondieren, welche nach Region l
            % gehen
    end
%    posteriorTR = T12(transferRate_domain) .* likelihoodTR;
    posteriorTR = allTRPrior(allTR') .* likelihoodTR;
%     hold on
%     figure(l)
%     plot(transferRate_domain,posteriorTR/norm(posteriorTR,1))
%     plot(transferRate_domain,T12(transferRate_domain) / norm(T12(transferRate_domain),1),'r o')
%     plot(transferRate_domain,likelihoodTR/ norm(likelihoodTR,1),'+y')
%     hold off
    
    % Bayes IP
    % P(IP|t) = P(IP) * P(t|IP) mit posterior statt dem prior fuer die Verteilung von TR
    %IPranges = {0:0.01:0.02,0:0.01:0.02,0:0.01:0.02,0:0.01:0.02};
   
    % Das hier stimmt noch nicht: Die Gewichtugn mit posteriorTR am Ende
    % ist falsch. Es muesste mit dem Produkt der W'keiten der TRs gewichtet werden, die zur Region
    % fuehren
    likelihoodIP_fh = @(IP) sum(sum((1-IP).^(timeUntilInfection*allTR(:,find(mod(1:noRegions^2,noRegions) == mod(l,noRegions)))' - numberOfTimesInfected) .* IP.^numberOfTimesInfected .* posteriorTR));
    for d = 1:length(infecProb_range)
       % sum((1-infecProb_range(d)).^(sumOfTravelers + timeFrom1*transferRate_domain-numberOfTimesInfected));
        likelihoodIP(d) = likelihoodIP_fh(infecProb_range(d));
    end
    posteriorIP = infecProbPrior(infecProb_range) .* likelihoodIP

%     hold on
%     figure(l + noRegions)
%     plot(infecProb_range,posteriorIP/norm(posteriorIP,1))
%     plot(infecProb_range,infecProbPrior(infecProb_range) / norm(infecProbPrior(infecProb_range),1),'r')
%     hold off
    %regions(l).spreadRateDistribution = fullPosterior(2,:);
    
%end

model.regions = regions;



end            