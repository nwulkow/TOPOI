classdef Region
   properties
      population % Bevoelkerung der Region
      timeVector % Vektor mit allen Zeitpunkten, die betrachtet werden
      infected % Matrix mit 1 und 0: i,j-Eintrag bedeutet: Zu Zeit timeVector(j) war Innovation
      % i bekannt (1) oder nicht bekannt (0)
      spread % Matri mit 0, 1 oder 2: i,j-Eintrag bedeutet: Zu Zeit timeVector(j) war Innovation
      % zu Grad 0, 1 oder 2 ausgebreitet
      infectionProb % Wahrscheinlichkeit, dass eine Erfindung in der Region bekannt wird, wenn
      % jemand aus einer anderen Region sie mitbringt
      infectionProbDistribution % Aus Bayes'scher Analyse resultierende Verteilung 
      % fuer die Infektions-W'keit
      infectionProbDist_xVector % x-vector fuer die Werte der infectionProbDistribution
      spreadRate % Rate, mit der eine Erfindung sich in der Region ausbreitet
      rawData % Teil aus der Datenmenge der zu dieser Region gehoert
      spreadRateDistribution % Aus Bayes'scher Analyse resultierende Verteilung 
      % fuer die Ausbreitungsrate
      spreadRateDist_xVector % x-vector fuer die Werte der spreadRateDistribution
   end
   methods
       
      function t = findTimeOfFirstSpread(obj,index, value)
          [innovations, timeSteps] = size(obj.infected);
         for i = 1:timeSteps
             if(obj.spread(index,i) == value)
                 t = i;
                 break;
             end
         end
      end
      
   end
end