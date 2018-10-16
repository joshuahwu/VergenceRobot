a = ExperimentClass('COM8');

a.linearOscillate(10,10,30,25,30,2,100);

a.moveTo(90,45,500);

a.calibrate();

a.smoothPursuit(54000,-45,45,20,1000);

calibrate();

a.endSerial();