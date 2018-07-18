% Delays and Distances Examined
% min delay in microseconds
delayi = 20; 
% max delay in microseconds
delayf = 80; 
ddelay = 5; 

% number of angles tested between 0 and 45 degrees
angleTrials = 12; 
% set up the serial connection
a = setUpSerial('COM8');
% return coefficients for exponential (what kind of exponential is it?
[forward_coeffs, reverse_coeffs] = speedModelFit(a,delayi,delayf,ddelay,angleTrials); 

testSpeeds = zeros(angleTrials,delayTrials);
for j = 20:5:80
    for i = 1:length(angles)
    testSpeeds(i,j) = delayToSpeed(forward_coeffs,j,angles(i));
    end
end 

% close the serial connection
fclose(a); 

% function: speedModelFit
function [forward_coeffs, reverse_coeffs] = speedModelFit(...
    comPort,delayi,delayf,ddelay,angleTrials)

% Communicate with Arduino all the variables 
fprintf(comPort,['SpeedModeling:%d:%d:%d:%d'],...
    [delayi,delayf,ddelay,angleTrials]);
% while Beginning is being sent from Arduino, print given message
while(strcmp(fscanf(comPort,'%s'),'Beginning')~=1)
   disp('Waiting for Experiment Start')
end
% 1st read from Arduino: ddistance
ddistance = fscanf(comPort,'%d');
finalDistance = ddistance*angleTrials;
delayTrials = floor((delayf-delayi)/ddelay + 1);

% Preallocate arrays
% Every column will be a different speed
time = zeros(angleTrials,delayTrials);
delays = delayi:ddelay:delayf;
x = zeros(angleTrials,delayTrials);
y = zeros(angleTrials,delayTrials);
delayCount = 0;

% Keep doing calculations until waitSignal=Done and then break;
while(1)
    % 2nd and until 'Done' read from Arduino: status of waitSignal
    waitSignal = fscanf(comPort,'%s')
    if (strcmp(waitSignal,'Done')==1)
        break;
    elseif (strcmp(waitSignal,'Sending')==1)
        % When waitSignal=Sending, prepare to read data 
        for i=1:angleTrials
            timeRead = fscanf(comPort,'%d')
            time(i,delayCount+1) = timeRead;
            x(i,delayCount+1) = fscanf(comPort,'%d');
            y(i,delayCount+1) = fscanf(comPort,'%d');
        end
        delayCount=delayCount+1
    end
end

% Euclidean speed
speedArray = sqrt(x.^2+y.^2)./(time./1000); %in steps/s measured
% Convert x and y distance to angle in degrees
angles = atan(y(1:angleTrials,1)./x(1:angleTrials,1))*180/pi;

%% Finding model of delay to speed
% For each delay finds the coefficients of a 2-term exponential model of
% angle vs measured speed
% Requires at least 10 trials each to generate a fit
coeffs_angles = zeros(length(delays),4);
for i = 1:length(delays)
    f = fit(angles,speedArray(:,i),'exp2');
    coeffs_angles(i,:) = [f.a,f.b,f.c,f.d]; % save coefficients
end

% Models the columns in coeffs_angles with a 2-term exponential with
% respect to delays
forward_coeffs = zeros(4,4);
for i = 1:4
    f = fit(transpose(delays),coeffs_angles(:,i),'exp2');
    forward_coeffs(i,:) = [f.a,f.b,f.c,f.d];
end

%% Finding model of speed to delay
% For each angle, finds the coefficients of a 2-term exponential model of
% measured speed vs delay
% Requires at least 10 trials each to generate a fit
coeffs_delays = zeros(length(angles),4);
for i = 1:numel(angles)
    f = fit(transpose(speedArray(i,:)),transpose(delays),'exp2');
    coeffs_delays(i,:) = [f.a,f.b,f.c,f.d];
end

% Models the columns in coeffs_delays with a 2nd degree polynomial with
% respect to angles
reverse_coeffs = zeros(4,3);
for i = 1:4
    f = fit(angles,coeffs_delays(:,i),'poly2');
    reverse_coeffs(i,:) = [f.p1,f.p2,f.p3];
end
end

%% Calculating a given delay and converting to speed
% coeff_array is a 4x4 array - rows and columns both representing exp2
function [speed] = delayToSpeed(coeff_array,delay,angle)
complex_coeffs = [exp2(coeff_array(1,:),delay),...
    exp2(coeff_array(2,:),delay),...
    exp2(coeff_array(3,:),delay),...
    exp2(coeff_array(4,:),delay)];
speed = exp2(complex_coeffs,angle);
end


%% Calculating input speed to a delay sent to Arduino
% coeff_array is a 4x3 array - rows representing exp2, columns representing
% poly2
function [delay] = speedToDelay(coeff_array,speed,angle)
complex_coeffs = [poly2(coeff_array(1,:),angle),...
    poly2(coeff_array(2,:),angle),...
    poly2(coeff_array(3,:),angle),...
    poly2(coeff_array(4,:),angle)];
delay = exp2(complex_coeffs,speed);
end

%% 2nd Degree Polynomial
function [output] = poly2(coeffs,x)
output = coeffs(1).*x.^2 + coeffs(2).*x.^2 + coeffs(3);
end

%% Two-Term Exponential Function
function [output] = exp2(coeffs,x)
output = coeffs(1).*exp(coeffs(2).*x) + coeffs(3).*exp(coeffs(4).*x);
end