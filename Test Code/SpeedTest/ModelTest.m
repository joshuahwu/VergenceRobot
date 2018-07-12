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

secondary_coeffs = zeros(4,4);
for i = 1:4
    if(i==1 || i==3) 
        f = fit(coeffs_delays(:,i),anglesi,'sin2');
    else 
        f = fit(coeffs_delays(:,i),anglesi,'exp2');
    end
    secondary_coeffs(i,:) = [f.a,f.b,f.c,f.d];
end

function [output] = finalModel(coeff_array,delay,angle)
complex_coeffs = [exp2(coeff_array(1,:),delay),...
    exp2(coeff_array(2,:),delay),...
    exp3(coeff_array(3,:),delay),...
    exp4(coeff_array(4,:),delay)];
output = exp2(complex_coeffs,angle);
end

% Final function
function [output] = exp2(coeffs,x)
output = coeffs(1).*exp(coeffs(2).*x) + coeffs(3).*exp(coeffs(4).*x);
end

