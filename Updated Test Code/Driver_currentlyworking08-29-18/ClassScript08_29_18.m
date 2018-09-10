a = ExperimentClass08_29_18('COM8');

a.calibrate();

a.moveTo(25,25,40);

a.calibrate();

a.moveTo(50,10,40);

a.linearOscillate(50,10,10,30,30,1,100);

a.smoothPursuit(20000,90,-90,40,1000);

a.calibrate();

% a.speedModelFit(15,60,5,14);

% a.linearOscillate(10,5,90,45,30,1,100);
% 
% a.calibrate();
% 
% a.moveTo(90,50,40);
% 
% a.calibrate();
% 
% a.arc(20000,90,-90,40,1000);

a.endSerial();



