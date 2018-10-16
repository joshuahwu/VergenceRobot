% load('timeTrials.mat');
% load('xVals.mat');
% load('yVals.mat');
% 
% %additiveDistance = x+y;
% %speeda = additiveDistance./(time./1000); %steps per second
% speedm = sqrt(x.^2+y.^2)./(time./1000);
% 
% delays = 15:5:65; %microseconds
% 
% delayArray = repmat(delays,11,1);
% speedArray = reshape(speedm,11,14);
% angles = atan(y./x)*180/pi;
% anglesA = angles(1:14);
% 
% ang1 = speedArray(:,1);
% ang2 = speedArray(:,2);
% ang3 = speedArray(:,3);
% del1 = speedArray(1,:);
% del2 = speedArray(2,:);
% del3 = speedArray(3,:);
% 
% coeffs_delays = zeros(length(anglesA),4);
% for i = 1:numel(anglesA)
%     f = fit(transpose(speedArray(i,:)),transpose(delays),'exp2');
%     coeffs_delays(i,:) = [f.a,f.b,f.c,f.d];
% end
% 
% coeffs_angles = zeros(length(delays),4);
% for i = 1:length(delays)
%     f = fit(speedArray(:,i),anglesA,'exp2');
%     coeffs_angles(i,:) = [f.a,f.b,f.c,f.d];
% end
% 
% secondary_coeffs = zeros(4,3);
% for i = 1:4
%     f = fit(anglesA,coeffs_delays(:,i),'poly2');
%     secondary_coeffs(i,:) = [f.p1,f.p2,f.p3];
% end
% 
% %angles = anglesi
% anglesB = angles(1:11);
% 
% % coefficients with respect to delays
% aa = coeffs_angles(:,1);
% ab = coeffs_angles(:,2);
% ac = coeffs_angles(:,3);
% ad = coeffs_angles(:,4);
% 
% % coefficients with respect to angles
% da = coeffs_delays(:,1);
% db = coeffs_delays(:,2);
% dc = coeffs_delays(:,3);
% dd = coeffs_delays(:,4);

angle = atan((25-10)/(30-10));
Delay = speedToDelay(reverse_coeffs,750,angle)

function [output] = delayToSpeed(coeff_array,delay,angle)
complex_coeffs = [exp2(coeff_array(1,:),delay),...
    exp2(coeff_array(2,:),delay),...
    exp2(coeff_array(3,:),delay),...
    exp2(coeff_array(4,:),delay)];
output = exp2(complex_coeffs,angle);
end

function [output] = speedToDelay(coeff_array,speed,angle)
complex_coeffs = [poly3(coeff_array(1,:),angle),...
    poly3(coeff_array(2,:),angle),...
    poly3(coeff_array(3,:),angle),...
    poly3(coeff_array(4,:),angle)];
output = exp2(complex_coeffs,speed);
end

function [output] = poly3(coeffs,x)
    output = coeffs(1).*x.^3 + coeffs(2).*x.^2 + coeffs(3).*x + coeffs(4);
end

% Final function
function [output] = exp2(coeffs,x)
    output = coeffs(1).*exp(coeffs(2).*x) + coeffs(3).*exp(coeffs(4).*x);
end

