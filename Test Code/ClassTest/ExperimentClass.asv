classdef ExperimentClass
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    properties
        connection
    end
    
    methods
        function obj = setUpSerial(comPort)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.connection = serial(comPort);
            set(obj.connection,'DataBits',8);
            set(obj.connection,'StopBits',1);
            set(obj.connection,'BaudRate',9600);
            set(obj.connection,'Parity','none');
            fopen(obj.connection);
            a = 'b';
            while (a~='a')
                a=fread(obj.connection,1,'uchar');
            end
            if (a=='a')
                disp('Serial read');
            end
            fprintf(obj.connection,'%c','a');
            mbox = msgbox('Serial Communication setup'); uiwait(mbox);
            fscanf(obj.connection,'%u');
        end
        
        %% LINEAR OSCILLATION
        % Moves from point (x0,y0) to (x1,y1). Speed is characterized by the
        % pulse-width modulation of the signals set to the stepper motor. Movement
        % will oscillate the number of times as repetitions. Resolution represents
        % the step size for drawing of a pathway. Movement at the 10% edges are
        % slowed down.
        function linearOscillate(obj,x0,y0,x1,y1,speed,repetitions,resolution)
            fprintf(obj.connection,['oscillate:%d:%d:%d:%d:%d:%d:%d'],...
                [x0,y0,x1,y1,speed,repetitions,resolution]);
            while(strcmp(fscanf(obj.connection,'%s'),'Done')~=1)
                disp('Waiting Linear Oscillate Trial')
            end
        end
        
        %% CALIBRATION
        % Returns target to xMin and yMin at the bottom-left corner
        function [x,y]= calibrate(obj)
            fprintf(obj.connection,'Calibrate');
            while(strcmp(fscanf(obj.connection,'%s'),'Done')~=1)
                disp('Waiting Calibrate')
            end
            x = fscanf(obj.connection,'%d');
            y = fscanf(obj.connection,'%d');
        end
        
        %% Move
        % Moves target to (x,y) and holds for designated milliseconds
        function moveTo(obj,x,y,hold)
            fprintf(obj.connection,['move:%d:%d:%d'],[x,y,hold]);
            while(strcmp(fscanf(obj.connection,'%s'),'Done')~=1)
                disp('Waiting Linear Move Trial')
            end
        end
        
        %% Arc
        % Moves target in an arc specified by radius and initial and final
        % angles
        function arc(obj,radius,angInit,angFinal,speed,res)
            fprintf(obj.connection,['arc:%d:%d:%d:%d:%d'],...
                [radius,angInit,angFinal,speed,res]);
            while(strcmp(fscanf(obj.connection,'%s'),'Done')~=1)
                disp('Waiting Arc Move Trial')
            end
        end
        
        function endSerial(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            fclose(obj.connection);
        end
    end
    
end

