% a = ExperimentClass('COM4');
% a.moveTo(50,50,10000);
% a.calibrate();
% linearOscillate(a,10,10,90,90,50,2,1000);
% calibrate(a);
% a.endSerial();

forward_coeffs = zeros(4,4);
reverse_coeffs = zeros(4,3);
forward_coeffs = ones(4,4);

save('params.mat','forward_coeffs');
