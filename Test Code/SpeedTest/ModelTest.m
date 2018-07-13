clear; clc;

load('timeTrials.mat');
load('xVals.mat');
load('yVals.mat');

%additiveDistance = x+y;
%speeda = additiveDistance./(time./1000); %steps per second
speedm = sqrt(x.^2+y.^2)./(time./1000);
delays = [40:10:150]; %microseconds

delayArray = repmat(delays,11,1);
speedArray = reshape(speedm,11,12);
angles = atan(y./x)*180/pi;
anglesi = angles(1:11);

coeffs_delays = zeros(length(anglesi),4);
for i = 1:numel(anglesi)
    f = fit(transpose(speedArray(i,:)),transpose(delays),'exp2');
    coeffs_delays(i,:) = [f.a,f.b,f.c,f.d];
end

% coeffs_angles = zeros(length(delays),4);
% for i = 1:length(delays)
%     f = fit(speedArray(:,i),anglesi,'exp2');
%     coeffs_angles(i,:) = [f.a,f.b,f.c,f.d];
% end

secondary_coeffs = zeros(4,3);
for i = 1:4
    f = fit(anglesi,coeffs_delays(:,i),'poly2');
    secondary_coeffs(i,:) = [f.p1,f.p2,f.p3];
end

function [output] = delayToSpeed(coeff_array,delay,angle)
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

% Final function
function [output] = exp2(coeffs,x)
output = coeffs(1).*exp(coeffs(2).*x) + coeffs(3).*exp(coeffs(4).*x);
end

