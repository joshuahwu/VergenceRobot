a = setUpSerial('COM5');

fprintf(a,'SpeedMetrics');

% Speed and Distances that we're using
while(strcmp(fscanf(a,'%s'),'Beginning')~=1)
    disp('Waiting for Experiment Start')
end

spdi = fscanf(a,'%d')
spdf = fscanf(a,'%d')
dspd = fscanf(a,'%d')
di = fscanf(a,'%d')
df = fscanf(a,'%d')
dd = fscanf(a,'%d')
spdLoopDim = floor((spdf-spdi)/dspd + 1);
distLoopDim = floor((df-di)/dd + 1);


% Every column will be a different speed
time = zeros(distLoopDim,spdLoopDim);
speeds = spdi:dspd:spdf;
x = zeros(distLoopDim,1);
y = zeros(distLoopDim,1);
speedCount = 1;
while(1)
    waitSignal = fscanf(a,'%s')
    if (strcmp(waitSignal,'Done')==1)
        break;
    elseif (strcmp(waitSignal,'Sending')==1)
        for i=1:distLoopDim
            timeRead = fscanf(a,'%d')
            time(i,speedCount) = timeRead;
        end
        if(speedCount==1)
            for i = 1:distLoopDim
                x(i) = fscanf(a,'%d')
                y(i) = fscanf(a,'%d')
            end
        end
        speedCount=speedCount+1;
    end

end
fclose(a);