a = setUpSerial('COM7');

saccade(a,50,50,10000);
oscillate(a,50,90,50,10,10,30,2);
% saccade(a,75,50,10000);
calibrate(a);

% saccade(a,50,50,10000);
% oscillate(a,10,50,90,50,10,30,2);
% calibrate(a);
% oscillate(a,10,10,90,90,10,30,2);
% saccade(a,100,100,10000);
% calibrate(a);
fclose(a);

function oscillate(connection,x0,y0,x1,y1,speed,res,rep)
fprintf(connection,['oscillate:%d:%d:%d:%d:%d:%d:%d'],[x0,y0,x1,y1,speed,res,rep]);
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Oscillation Trial')
end
end

function [x,y]= calibrate(connection)
fprintf(connection,'calibrate');
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Calibrate')
end
x = fscanf(connection,'%d')
y = fscanf(connection,'%d')
end

function move(connection,x,y,delay)
fprintf(connection,['move:%d:%d:%d'],[x,y,delay]);
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Saccade Trial')
end
end

function arc(connection,radius,angInit,angFinal,speed,res)
fprintf(connection,['arc:%d:%d:%d:%d:%d'],[radius,angInit,angFinal,speed,res]);
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Arc Trial')
end
end