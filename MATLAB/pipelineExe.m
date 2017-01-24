T = [0,100000,250000,200000;
    150,0,200,300;
    100,200,0,100;
    150,200,200,0]; % i,j-Eintrag: Personen von i nach j pro Zeitschritt
T = T / 10000;
B = [1,2; 1,3; 1,4; 2,3; 2,4; 3,4;];
%data = convertTXTtoData('wagons09122016.txt');
%regions = dataToRegions(data);


model = execModel2(B,T,regions, 3);