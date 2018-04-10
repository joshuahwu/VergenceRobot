a = setUpSerial('COM5');
while(1)
    saccade(a,50,50,10000);
    smoothpursuit(a,50,90,50,10,10,30,2);
    saccade(a,75,50,10000);
    calibrate(a);
    
    saccade(a,50,50,10000);
    smoothpursuit(a,10,50,90,50,10,30,2);
    calibrate(a);
    smoothpursuit(a,10,10,90,90,10,30,2);
    saccade(a,100,100,10000);
    calibrate(a);
end
fclose(a);

function smoothpursuit(connection,x0,y0,x1,y1,speed,res,rep)
fprintf(connection,['Smooth:%d:%d:%d:%d:%d:%d:%d'],[x0,y0,x1,y1,speed,res,rep])
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Smooth Pursuit Trial')
end
end

function [x,y]= calibrate(connection)
fprintf(connection,'Calibrate:');
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Calibrate')
end
x = fscanf(connection,'%d')
y = fscanf(connection,'%d')
end

function saccade(connection,x,y,delay)
fprintf(connection,['Saccade:%d:%d:%d:'],[x,y,delay]);
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Saccade Trial')
end
end