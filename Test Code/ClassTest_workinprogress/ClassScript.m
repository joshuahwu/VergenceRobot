a = ExperimentClass('COM8');

% a.linearOscillate(10,5,90,45,30,1,100);
% 
% a.calibrate();
% 
% a.moveTo(90,50,40);
% 
% a.linearOscillate(50,50,50,0,50,2,100);
% 
% a.calibrate();

a.arc(20000,90,-90,40,1000);

a.calibrate();

a.arc(20000,45,-45,40,1000);

a.calibrate();

a.endSerial();



