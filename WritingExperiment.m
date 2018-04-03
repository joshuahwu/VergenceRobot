a = setUpSerial('COM5');
saccade(a,50,50,10000);
saccade(a,10,10,10000);
smoothpursuit(a,50,90,50,10,30,30,4);
saccade(a,50,75,10000);
smoothpursuit(a,10,50,90,50,30,30,4);
calibrate(a);
saccade(a,100,100,10000);
fclose(a);

% fprintf(a,'Calibrate:');
% while(strcmp(fscanf(a,'%s'),'Done')~=1)
%     disp('Waiting Calibrate')
% end
% x=50;
% y=50;
% delay=2000;
% fprintf(a,['Saccade:%d:%d:%d'],[x,y,delay]);
% while(strcmp(fscanf(a,'%s'),'Done')~=1)
%     disp('Waiting Saccade')
% end
% fprintf(a,'Smooth:50:50:50:25:80:100:4');
% disp('Finished Experiment')
%fclose(a);

function smoothpursuit(connection,x0,y0,x1,y1,speed,res,rep)
fprintf(connection,['Smooth:%d:%d:%d:%d:%d:%d:%d'],[x0,y0,x1,y1,speed,res,rep])
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Smooth Pursuit Trial')
end
end

function calibrate(connection)
fprintf(connection,'Calibrate:');
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Calibrate')
end
end

function saccade(connection,x,y,delay)
fprintf(connection,['Saccade:%d:%d:%d:'],[x,y,delay]);
while(strcmp(fscanf(connection,'%s'),'Done')~=1)
    disp('Waiting Saccade Trial')
end
end

% %% Writing an Experiment
% a = Experiment();
% a.initialize = setUpSerial('COM5');
% 
% eyePos = [3000,2000];
% 
% fprintf(a.obj,'Recalibrate','%s');
% 
% % Trial 2
% fprintf(a.obj,'Saccade,50,50','%s');
% 
% %Trial 3
% a.speed('LeftEye',10,eyePos);
% 
% %% debugging
% 
% if(~exist('serialFlag','var'))
%     [arduino,serialFlag] = setupSerial(comPort);
% end
% 
% if (~exist('h','var') || ~ishandle(h))
%     h = figure(1);
%     set(h,'UserData',1);
% end
% 
% if (~exist('button','var'))
%     button = uicontrol('Style','togglebutton','String','Stop',...
%         'Position',[0 0 50 25], 'parent',h);
% end
% 
% if(~exist('myAxes','var'))
%     
%     buf_len = 50;
%     index = 1:buf_len; 
%     zeroIndex = zeros(size(index)); 
%     tcdata = zeroIndex;
%     limits = [15 50];
%     
%     myAxes = axes('Xlim',[0 buf_len],'Ylim',limits);
%     grid on;
%     
%     l = line(index,[tcdata;zeroIndex]);
% end
% 
