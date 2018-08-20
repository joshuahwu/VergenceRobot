% a = setUpSerial('COM5');
% saccade(a,50,50,10000);
% saccade(a,10,10,10000);
% smoothpursuit(a,50,90,50,10,30,30,4);
% saccade(a,50,75,10000);
% smoothpursuit(a,10,50,90,50,30,30,4);
% calibrate(a);
% saccade(a,100,100,10000);
% fclose(a);

%% 5 microdelay
a = setUpSerial('COM5');
dimensionsx = fscanf(a,'%d');
while(isempty(dimensionsx))
    dimensionsx = fscanf(a,'%d');
end
dimensionsy = fscanf(a,'%d');
dimensionsx = dimensionsx/16
dimensionsy = dimensionsy/16
xerr5 = zeros(1,21);
yerr5 = zeros(1,21);

for i = 1:1
    disp('Experiment')
    disp(i)
    saccade(a,50,50,1500);
    [x,y] = calibrate(a);
    xerr5(i,1) = x;
    yerr5(i,1) = y;
    for j = 2:21
        disp('Trial')
        disp(j)
        smoothpursuit(a,10,10,90,90,5,50,j-1);
        saccade(a,50,50,1500);
        [x,y]= calibrate(a);
        xerr5(i,j) = x;
        yerr5(i,j) = y;
        if((x >= dimensionsx*0.58) || (x <= dimensionsx*0.42))
            break;
        end
        if((y >= dimensionsy*0.58) || (x >=dimensionsy*0.42))
            break;
        end
    end
end
%fclose(a);

% %% 10 microdelay

xerr10 = zeros(1,21);
yerr10 = zeros(1,21);
%saccade(a,50,50,1500);
for i = 1:1
    disp('Experiment')
    disp(i)
    saccade(a,50,50,1500);
    [x,y] = calibrate(a);
    xerr10(i,1) = x;
    yerr10(i,1) = y;
    for j = 2:21
        disp('Trial')
        disp(j)
        smoothpursuit(a,10,10,90,90,10,50,j-1);
        saccade(a,50,50,1500);
        [x,y]= calibrate(a);
        xerr10(i,j) = x;
        yerr10(i,j) = y;
        if((x >= dimensionsx*0.58) || (x <= dimensionsx*0.42))
            break;
        end
        if((y >= dimensionsy*0.58) || (x >=dimensionsy*0.42))
            break;
        end
    end
end
% % fclose(a);

%% 20 microdelay
xerr20 = zeros(1,21);
yerr20 = zeros(1,21);
%saccade(a,50,50,1500);
for i = 1:1
    disp('Experiment')
    disp(i)
    saccade(a,50,50,1000);
    [x,y] = calibrate(a);
    xerr20(i,1) = x;
    yerr20(i,1) = y;
    for j = 2:21
        disp('Trial')
        disp(j)
        smoothpursuit(a,10,10,90,90,20,50,j-1);
        saccade(a,50,50,1000);
        [x,y]= calibrate(a);
        xerr20(i,j) = x;
        yerr20(i,j) = y;
        if((x >= dimensionsx*0.58) || (x <= dimensionsx*0.42))
            break;
        end
        if((y >= dimensionsy*0.58) || (x >=dimensionsy*0.42))
            break;
        end
    end
end
% %fclose(a);
% 
%% 30 microdelay
xerr30 = zeros(1,21);
yerr30 = zeros(1,21);
%saccade(a,50,50,1500);
for i = 1:1
    disp('Experiment')
    disp(i)
    saccade(a,50,50,1500);
    [x,y] = calibrate(a);
    xerr30(i,1) = x;
    yerr30(i,1) = y;
    for j = 2:21
        disp('Trial')
        disp(j)
        smoothpursuit(a,10,10,90,90,30,50,j-1);
        saccade(a,50,50,1500);
        [x,y]= calibrate(a);
        xerr30(i,j) = x;
        yerr30(i,j) = y;
        if((x >= dimensionsx*0.58) || (x <= dimensionsx*0.42))
            break;
        end
        if((y >= dimensionsy*0.58) || (x >=dimensionsy*0.42))
            break;
        end
    end
end
%fclose(a);
% 
%% 50 microdelay
xerr50 = zeros(1,21);
yerr50 = zeros(1,21);
%saccade(a,50,50,1500);
for i = 1:1
    disp('Experiment')
    disp(i)
    saccade(a,50,50,1000);
    [x,y] = calibrate(a);
    xerr50(i,1) = x;
    yerr50(i,1) = y;
    for j = 2:21
        disp('Trial')
        disp(j)
        smoothpursuit(a,10,10,90,90,50,50,j-1);
        saccade(a,50,50,1000);
        [x,y]= calibrate(a);
        xerr50(i,j) = x;
        yerr50(i,j) = y;
        if((x >= dimensionsx*0.58) || (x <= dimensionsx*0.42))
            break;
        end
        if((y >= dimensionsy*0.58) || (x >=dimensionsy*0.42))
            break;
        end
    end
end
fclose(a);

% %% 100 microdelay
% a = setUpSerial('COM5');
% dimensionsx = fscanf(a,'%d');
% while(isempty(dimensionsx))
%     dimensionsx = fscanf(a,'%d');
% end
% dimensionsy = fscanf(a,'%d');
% dimensionsx = dimensionsx/16
% dimensionsy = dimensionsy/16
% 
% xerr100 = zeros(10,16);
% yerr100 = zeros(10,16);
% %saccade(a,50,50,1500);
% for i = 1:10
%     disp('Experiment')
%     disp(i)
%     saccade(a,50,50,1500);
%     [x,y] = calibrate(a);
%     xerr100(i,1) = x;
%     yerr100(i,1) = y;
%     for j = 2:16
%         disp('Trial')
%         disp(j)
%         smoothpursuit(a,10,10,90,90,100,50,j-1);
%         saccade(a,50,50,1500);
%         [x,y]= calibrate(a);
%         xerr100(i,j) = x;
%         yerr100(i,j) = y;
%         if((x >= dimensionsx*0.58) || (x <= dimensionsx*0.42))
%             break;
%         end
%         if((y >= dimensionsy*0.58) || (x >=dimensionsy*0.42))
%             break;
%         end
%     end
% end
% fclose(a);

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
