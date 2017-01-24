%clear all
% Region, Wagen-Typ, Zeit
% data = [
% 1,1,105;
% 1,1,205;
% 2,1,205;
% 3,1,250;
% 1,2,305;
% 2,1,310;
% 1,1,315;
% 1,1,320;
% 3,1,330;
% 3,1,340;
% 2,1,315;
% 2,2,405;
% 1,2,420;
% 1,2,430;
% 3,2,410;
% 3,3,420;
% 2,3,505;
% 3,1,515;
% 3,1,525;
% 2,2,510;
% 2,2,515;
% 3,3,520;
% 3,3,540;
% 1,3,550;
% ];
[n,m] = size(data);
%times = [100,200,300,400,500];
times = [-2600,-2100,-1600,-1100,-600];
wagenTypen = 3;

regionNumbers = [];
regions = [];
for i = 1:n
    if(sum(find(regionNumbers == data(i,1))) == 0)
        regionNumbers = [regionNumbers, data(i,1)];
        r = Region;
        r.infected = zeros(wagenTypen, length(times));
        r.spread = zeros(wagenTypen, length(times));
        regions = [regions, r];
    end
    % In der entsprechenden Region beim richtigen Wagentyp eine 1 fuer
    % 'infected' schreiben

    regions(find(regionNumbers == data(i,1))).infected(data(i,2),max(find(times < data(i,3))):length(times)) = 1;
    regions(find(regionNumbers == data(i,1))).spread(data(i,2), max(find(times < data(i,3)))) = regions(find(regionNumbers == data(i,1))).spread(data(i,2), max(find(times < data(i,3)))) + 1;
end

populations = [400,100,500,750];
for j = 1:length(regions)
   regions(j).population = populations(j);
   regions(j).rawData = data(find(data(:,1) == j),:);
   regions(j).spread = min( 2 , regions(j).spread);
end

    
    