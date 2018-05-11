%Sets up Serial Connection
a = setUpSerial('COM5');
while(1)
    moveTo(a,50,50,10000);
    smoothpursuit(a,50,90,50,10,10,30,2);
    moveTo(a,75,50,10000);
    calibrate(a);
    
    saccade(a,50,50,10000);
    smoothpursuit(a,10,50,90,50,10,30,2);
    calibrate(a);
    smoothpursuit(a,10,10,90,90,10,30,2);
    saccade(a,100,100,10000);
    calibrate(a);
end
% Closes serial connection
fclose(a);

%% LINEAR OSCILLATION
% Moves from point (x0,y0) to (x1,y1). Speed is characterized by the
% pulse-width modulation of the signals set to the stepper motor. Movement
% will oscillate the number of times as repetitions. Resolution represents
% the step size for drawing of a pathway. Movement at the 10% edges are
% slowed down.
function linearOscillate(connection,x0,y0,x1,y1,speed,repetitions,resolution)
fprintf(connection,['oscillate:%d:%d:%d:%d:%d:%d:%d'],[x0,y0,x1,y1,speed,repetitions,resolution])
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Smooth Pursuit Trial')
end
end

%% CALIBRATION
% Returns target to xMin and yMin at the bottom-left corner
function [x,y]= calibrate(connection)
fprintf(connection,'Calibrate');
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Calibrate')
end
x = fscanf(connection,'%d')
y = fscanf(connection,'%d')
end

%% Move
% Moves target to (x,y) and holds for designated milliseconds
function moveTo(connection,x,y,hold)
fprintf(connection,['move:%d:%d:%d'],[x,y,hold]);
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Saccade Trial')
end
end