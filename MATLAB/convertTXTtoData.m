function data = convertTXTtoData(filename)
s = fileread(filename);
A = strread(s, '%s', 'delimiter', sprintf('\n'));

% Vektor mir Datenpunkten fuellen
datapoints = [];
for i = 2:length(A)-2
    if(i ~= 1865)
    d = DataPoint;
    line = strread(A{i}, '%s', 'delimiter', sprintf('\t'));
    d.ID = line{1};
    d.country = line{7};
    latitudeString = strtok(line{8},',');
    longitudeString = strtok(line{9},',');
    d.latitude = str2num(latitudeString);
    d.longitude = str2num(longitudeString);
    d.material_group = line{18};
    d.timeSpan_begin = str2num(line{26});
    d.timeSpan_end = str2num(line{27});
    d.wheel_type = line{47};
    datapoints = [datapoints, d];
    end
end

%---------------------------
% In Regionen einteilen
region1countries = {'Russia', 'Turkey', 'Slovakia', 'Romania'};
region2countries = {'Germany', 'Poland', 'Czech Republic', 'Austria', 'Switzerland'};
region3countries = {'Egypt', 'Libya', 'Algeria', 'Morocco', 'Sudan'};
region4countries = {'Iran', 'Iraq', 'Armenia'};
regions = {region1countries, region2countries,region3countries,region4countries};

wheeltypes = {'spoker wheel', 'cross-bar wheel', 'disc wheel'};

data = [];
for i = 1:length(datapoints)
    d = datapoints(i);
    regionNumber = -1;
    wagenType = -1;
    time = -1;
    % Region rausfinden
    for j = 1:length(regions)
        indexC = strfind(regions{j}, d.country);
        Index = find(not(cellfun('isempty', indexC)));
        if(length(Index) > 0)
            regionNumber = j;
            break;
        end
    end
    
    wagenIndexC = strfind(wheeltypes, d.wheel_type);
    wagenIndex = find(not(cellfun('isempty', wagenIndexC)));
    if(length(wagenIndex) > 0)
        wagenType = wagenIndex;
    end
    if(length(str2num(d.timeSpan_begin)) > 0 && length(str2num(d.timeSpan_end)) > 0)
        time = (str2num(d.timeSpan_begin) + str2num(d.timeSpan_end)) / 2;
    end
    regionNumber
    wagenType
    time
    if(regionNumber ~= -1 && wagenType ~= -1 && time ~= -1)
        data = [data; regionNumber, wagenType, time];
    end
    
    end