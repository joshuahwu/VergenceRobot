%% ModelTest_test.m
% modification of ModelTest.m
% separates/parses data obtained from speed model testing (using 
% speedModelFit function)
% data variables chosen for use in curve fitting app to check and choose 
% sufficient model for inner coefficients (to get coeffs_angles or coeffs_delays) 
% and outer coefficients (forward_coeffs or reverse_coeffs)

% load('timeTrials.mat');
% load('xVals.mat');
% load('yVals.mat');

%additiveDistance = x+y;
%speeda = additiveDistance./(time./1000); % steps per second
%speedCalc = sqrt(x.^2+y.^2)./(time./1000); % Euclidean speed in steps per second

delays = 15:5:60; % vector of experimental delays in microseconds
%speedArray = speedArray(1:10,1:11);
speedArrayTest = speedArray;%speedArraymeters./(0.037699./200);
%speedArray = reshape(speedCalc,12,11); % reshape array to 12 x 11 matrix; delays are similar; angles are different
%anglesCalc = atan(y./x)*180/pi; % vector of angles calculated from position movements
%angles = anglesCalc(1:11);

% speed data for 1st through 3rd delay
% for use finding inner model
% in curve fitting tool, fit x-data delays, y-data delspeed1
% from these results, exp2 is best model
delspeed1 = speedArrayTest(1,:);
delspeed2 = speedArrayTest(2,:);
delspeed3 = speedArrayTest(3,:);
% speed data for 1st through 3rd angle
angspeed1 = speedArrayTest(:,1);
angspeed2 = speedArrayTest(:,2);
angspeed3 = speedArrayTest(:,3);

% matrix of delay coefficients
% 4 coefficients for 2-term exponential (exp2)
% leading coefficient and exponential coefficient for each term
% for each angle, fit the speed and delay data with exp2
% each row of coeffs_delays represents coefficients for an specific angle
coeffs_delays = zeros(length(angles),4);
for i = 1:numel(angles)
    f = fit(transpose(speedArrayTest(i,:)),transpose(delays),'exp2');
    coeffs_delays(i,:) = [f.a,f.b,f.c,f.d];
end

% matrix of angle coefficients
% for each delay,fit the speed and angle data with exp2
% each row of coeffs_angles represents coefficients for a specific delay
coeffs_angles = zeros(length(delays),4);
for i = 1:length(delays)
    f = fit(speedArrayTest(:,i),angles,'exp2');
    coeffs_angles(i,:) = [f.a,f.b,f.c,f.d];
end

% outer function
% x-data: angles
% y-data: coeffs_delays
% for each 
% 
reverse_coeffs = zeros(4,4);
for i = 1:4
    f = fit(angles,coeffs_delays(:,i),'poly3');
    reverse_coeffs(i,:) = [f.p1,f.p2,f.p3,f.p4];
end

% coefficients with respect to delays
% for outer function model
% fit x-data delays, y-data coeffs_angles arrays
angA = coeffs_angles(:,1);
angB = coeffs_angles(:,2);
angC = coeffs_angles(:,3);
angD = coeffs_angles(:,4);

% coefficients with respect to angles
% for outer function model
% fit x-data angles, y-data coeffs_delays arrays
delA = coeffs_delays(:,1);
delB = coeffs_delays(:,2);
delC = coeffs_delays(:,3);
delD = coeffs_delays(:,4);

Delays = speedToDelay(reverse_coeffs,speedArray,angles
%% Functions
% none of which are currently used in this script

% coeff_array is forward_coeffs
function [output] = delayToSpeed(coeff_array,delay,angle)
complex_coeffs = [exp2(coeff_array(1,:),delay),...
    exp2(coeff_array(2,:),delay),...
    exp2(coeff_array(3,:),delay),...
    exp2(coeff_array(4,:),delay)];
output = exp2(complex_coeffs,angle);
end

% coeff_array is reverse_coeffs
% *This is the one we want to improve!*
function [output] = speedToDelay(coeff_array,speed,angle)
complex_coeffs = [poly3(coeff_array(1,:),angle),...
    poly3(coeff_array(2,:),angle),...
    poly3(coeff_array(3,:),angle),...
    poly3(coeff_array(3,:),angle)];
output = exp2(complex_coeffs,speed);
end

% Outer function: 2nd degree polynomial
% currently (hopefully will change) used to generate outer reverse_coeffs
function [output] = poly3(coeffs,x)
output = coeffs(1).*x.^3 + coeffs(2).*x.^2 + coeffs(3).*x + coeffs(4);
end

% Outer function: 2-term exponential
% used to generate outer forward_coeffs
function [output] = exp2(coeffs,x)
output = coeffs(1).*exp(coeffs(2).*x) + coeffs(3).*exp(coeffs(4).*x);
end