coeffs = [0.01,0.02,0.03,0.04;0.05,0.06,0.07,0.08;0.09,0.010,0.011,0.012;0.013,0.014,0.015,0.016];
Speed = delayToSpeed(coeffs,10,10)

%% Two-Term Exponential Function
function [speed] = delayToSpeed(coeff_array,delay,angle)
complex_coeffs = [exp2(coeff_array(1,:),delay),...
    exp2(coeff_array(2,:),delay),...
    exp2(coeff_array(3,:),delay),...
    exp2(coeff_array(4,:),delay)];
speed = exp2(complex_coeffs,angle);
end

function [output] = exp2(coeffs,x)
output = coeffs(1).*exp(coeffs(2).*x) + coeffs(3).*exp(coeffs(4).*x);
end