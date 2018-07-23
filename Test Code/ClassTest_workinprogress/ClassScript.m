a = ExperimentClass('COM8');
%fscanf(a.connection,'%s')
a.speedModelFit(15,75,5,14);
a.endSerial();

REV = a.reverse_coeffs;
FWD = a.forward_coeffs;
speeds = a.SpeedArray;
angles = a.angles;

% forward_coeffs = zeros(4,4);
% reverse_coeffs = zeros(4,3);
% forward_coeffs = ones(4,4);
%
% save('params.mat','forward_coeffs');

