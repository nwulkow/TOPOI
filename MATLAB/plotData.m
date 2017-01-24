
times = [];
maxTime = -10000;
minTime = 10000000;
for i = 1:length(datapoints)
    timestart = datapoints(i).timeSpan_begin;
    timeend = datapoints(i).timeSpan_end;
    time = (datapoints(i).timeSpan_begin + datapoints(i).timeSpan_end) / 2;
    if( time < minTime)
        minTime = time;
    end
    if (time > maxTime)
        maxTime = time;
    end   
end

deltaT = (maxTime - minTime) / 20;
times = minTime:deltaT:maxTime;
dataPerTimeStep = {};
for l = 1:length(times)
    dataPerTimeStep = [dataPerTimeStep, {[0,0]}];
end


for j = 1:length(datapoints)
    time = (datapoints(j).timeSpan_begin + datapoints(j).timeSpan_end) / 2;
    for k = 2:length(times)
        if((times(k) > time))
            if((times(k-1) < time))
                dataPerTimeStep{k} = [ dataPerTimeStep{k}; datapoints(j).latitude, datapoints(j).longitude];
            end
        end
    end
end


for h = 1:length(times)
    currentMatrix = dataPerTimeStep{h};
    [n,m] = size(currentMatrix);
    for g = 1:n
        imshow(currentMatrix(g,1), currentMatrix(g,2),troll)
        hold on
    end
    hold off
    axis([0,120,0,120])
    pause(1)
end


    