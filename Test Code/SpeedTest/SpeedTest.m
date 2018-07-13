% Delays and Distances that we're examing
delayi = 20; % in microseconds
delayf = 80;
ddelay = 10;
xi = 0; % in steps
xf = 2000;
dx = 250;
angleTrials = 4;
a = setUpSerial('COM8');
secondary_coeffs = speedModelFit(a,delayi,delayf,ddelay,angleTrials);
fclose(a);
    
function [secondary_coeffs] = speedModelFit(...
    comPort,delayi,delayf,ddelay,angleTrials)

% Communicate with Arduino all the variables 

fprintf(comPort,['SpeedModeling:%d:%d:%d:%d'],...
    [delayi,delayf,ddelay,angleTrials]);

while(strcmp(fscanf(comPort,'%s'),'Beginning')~=1)
   disp('Waiting for Experiment Start')
end
ddistance = fscanf(comPort,'%d')
finalDistance = ddistance*angleTrials

delayLoopDim = floor((delayf-delayi)/ddelay + 1);

% Every column will be a different speed
time = zeros(angleTrials,delayLoopDim);
delays = delayi:ddelay:delayf;
x = zeros(angleTrials,delayLoopDim);
y = zeros(angleTrials,delayLoopDim);
speedCount = 0;

while(1)
    waitSignal = fscanf(comPort,'%s')
    if (strcmp(waitSignal,'Done')==1)
        break;
    elseif (strcmp(waitSignal,'Sending')==1)
        for i=1:angleTrials
            timeRead = fscanf(comPort,'%d')
            time(i,speedCount+1) = timeRead;
            x(i,speedCount+1) = fscanf(comPort,'%d');
            y(i,speedCount+1) = fscanf(comPort,'%d');
        end
        speedCount=speedCount+1;
    end
end

speedArray = sqrt(x.^2+y.^2)./(time./1000); %in steps/s measured
%speedArray = reshape(speeds,angleTrials,delayLoopDim);
angles = atan(y(1:angleTrials,1)./x(1:angleTrials,1))*180/pi

%% Finding model of delay to speed
coeffs_angles = zeros(length(delays),4);
for i = 1:length(delays)
    f = fit(angles,speedArray(:,i),'exp2');
    coeffs_angles(i,:) = [f.a,f.b,f.c,f.d];
end

foward_coeffs = zeros(4,4);
for i = 1:4
    f = fit(transpose(delays),coeffs_angles(:,i),'exp2');
    forward_coeffs(i,:) = [f.a,f.b,f.c,f.d];
end

%% Finding model of speed to delay
coeffs_delays = zeros(length(angles),4);
for i = 1:numel(angles)
    f = fit(transpose(speedArray(i,:)),transpose(delays),'exp2');
    coeffs_delays(i,:) = [f.a,f.b,f.c,f.d];
end

reverse_coeffs = zeros(4,3);
for i = 1:4
    f = fit(angles,coeffs_delays(:,i),'poly2');
    reverse_coeffs(i,:) = [f.p1,f.p2,f.p3];
end
end

function [output] = finalModel(coeff_array,delay,angle)
complex_coeffs = [exp2(coeff_array(1,:),delay),...
    exp2(coeff_array(2,:),delay),...
    exp2(coeff_array(3,:),delay),...
    exp2(coeff_array(4,:),delay)];
output = exp2(complex_coeffs,angle);
end

function [output] = speedToDelay(coeff_array,speed,angle)
complex_coeffs = [poly2(coeff_array(1,:),angle),...
    poly2(coeff_array(2,:),angle),...
    poly2(coeff_array(3,:),angle),...
    poly2(coeff_array(3,:),angle)];
output = exp2(complex_coeffs,speed);
end

function [output] = poly2(coeffs,x)
output = coeffs(1).*x.^2 + coeffs(2).*x.^2 + coeffs(3);
end

% Two-Term Exponential Function
function [output] = exp2(coeffs,x)
output = coeffs(1).*exp(coeffs(2).*x) + coeffs(3).*exp(coeffs(4).*x);
end