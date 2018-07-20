classdef ExperimentClass
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    properties
        connection
        forward_coeffs = zeros(4,4);
        reverse_coeffs = zeros(4,3);
        save_filename = 'params.mat';
    end
    
    methods
        %% Experiment Constructor
        function obj = ExperimentClass(comPort)
            % Intializes Experiment class and opens connection
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
            params = load(obj.save_filename);
            obj.forward_coeffs = params.forward_coeffs;
            obj.reverse_coeffs = params.reverse_coeffs;
            
            forward_coeffs = obj.forward_coeffs;
            sendCoeffs(obj, forward_coeffs);

            reverse_coeffs = obj.reverse_coeffs;
            sendCoeffs(obj, reverse_coeffs);
            %fscanf(obj.connection,'%s')
        end
        
        function output = readSerial(obj,type)
            output = fscanf(obj.connection,type);
        end
        
        %% LINEAR OSCILLATION
        function linearOscillate(obj,x0,y0,x1,y1,speed,repetitions,resolution)
            % Moves from point (x0,y0) to (x1,y1). Speed is characterized by the
            % pulse-width modulation of the signals set to the stepper motor. Movement
            % will oscillate the number of times as repetitions. Resolution represents
            % the step size for drawing of a pathway. Movement at the 10% edges are
            % slowed down.
            fprintf(obj.connection,['oscillate:%d:%d:%d:%d:%d:%d:%d'],...
                [x0,y0,x1,y1,speed,repetitions,resolution]);
            while(strcmp(fscanf(obj.connection,'%s'),'Done')~=1)
                disp('Waiting Linear Oscillate Trial')
            end
        end
        
        %% CALIBRATION
        function [x,y]= calibrate(obj)
            % Returns target to xMin and yMin at the bottom-left corner
            fprintf(obj.connection,'calibrate:');
            while(strcmp(fscanf(obj.connection,'%s'),'Done')~=1)
                disp('Waiting Calibrate')
            end
            x = fscanf(obj.connection,'%d');
            y = fscanf(obj.connection,'%d');
        end
        
        %% Move
        function moveTo(obj,x,y,hold)
            % Moves target to (x,y) and holds for designated milliseconds
            fprintf(obj.connection,['move:%d:%d:%d'],[x,y,hold]);
            while(strcmp(fscanf(obj.connection,'%s'),'Done')~=1)
                disp('Waiting Linear Move Trial')
            end
        end
        
        %% Arc
        function arc(obj,radius,angInit,angFinal,speed,res)
            % Moves target in an arc specified by radius and initial and final
            % angles
            fprintf(obj.connection,['arc:%d:%d:%d:%d:%d'],...
                [radius,angInit,angFinal,speed,res]);
            while(strcmp(fscanf(obj.connection,'%s'),'Done')~=1)
                disp('Waiting Arc Move Trial')
            end
        end
        
        %% Close Connection
        function endSerial(obj)
            fclose(obj.connection);
        end
        
        %% Calculate Speed Model
        function obj = speedModelFit(...
                obj,delayi,delayf,ddelay,angleTrials)
            
            % Communicate with Arduino all the variables
            fprintf(obj.connection,['SpeedModeling:%d:%d:%d:%d'],...
                [delayi,delayf,ddelay,angleTrials]);
            % while Beginning is being sent from Arduino, print given message
            while(strcmp(fscanf(obj.connection,'%s'),'Beginning')~=1)
                disp('Waiting for Experiment Start')
            end
            
            % 1st read from Arduino: ddistance
            ddistance = fscanf(obj.connection,'%d');
            finalDistance = ddistance*angleTrials;
            delayTrials = floor((delayf-delayi)/ddelay + 1);
            
            % Preallocate arrays
            % Every column will be a different speed
            time = zeros(angleTrials,delayTrials);
            delays = delayi:ddelay:delayf;
            x = zeros(angleTrials,delayTrials);
            y = zeros(angleTrials,delayTrials);
            speedCount = 0;
            
            % Keep doing calculations until waitSignal=Done and then break;
            while(1)
                % 2nd and until 'Done' read from Arduino: status of waitSignal
                waitSignal = fscanf(obj.connection,'%s')
                if (strcmp(waitSignal,'Done')==1)
                    break;
                elseif (strcmp(waitSignal,'Sending')==1)
                    % When waitSignal=Sending, prepare to read data
                    for i=1:angleTrials
                        timeRead = fscanf(obj.connection,'%d')
                        time(i,speedCount+1) = timeRead;
                        x(i,speedCount+1) = fscanf(obj.connection,'%d');
                        y(i,speedCount+1) = fscanf(obj.connection,'%d');
                    end
                    speedCount=speedCount+1;
                end
            end
            
            % Euclidean speed
            speedArray = sqrt(x.^2+y.^2)./(time./1000); %in steps/s measured
            % Convert x and y distance to angle in degrees
            angles = atan(y(1:angleTrials,1)./x(1:angleTrials,1))*180/pi;
            
            %% Finding model of delay to speed
            % For each delay finds the coefficients of a 2-term exponential model of
            % angle vs measured speed
            % Requires at least 10 trials each to generate a fit
            coeffs_angles = zeros(length(delays),4);
            for i = 1:length(delays)
                f = fit(angles,speedArray(:,i),'exp2');
                coeffs_angles(i,:) = [f.a,f.b,f.c,f.d]; % save coefficients
            end
            
            % Models the columns in coeffs_angles with a 2-term exponential with
            % respect to delays
            forward_coeffs = zeros(4,4);
            for i = 1:4
                f = fit(transpose(delays),coeffs_angles(:,i),'exp2');
                forward_coeffs(i,:) = [f.a,f.b,f.c,f.d];
            end
            
            %% Finding model of speed to delay
            % For each angle, finds the coefficients of a 2-term exponential model of
            % measured speed vs delay
            % Requires at least 10 trials each to generate a fit
            coeffs_delays = zeros(length(angles),4);
            for i = 1:numel(angles)
                f = fit(transpose(speedArray(i,:)),transpose(delays),'exp2');
                coeffs_delays(i,:) = [f.a,f.b,f.c,f.d];
            end
            
            % Models the columns in coeffs_delays with a 2nd degree polynomial with
            % respect to angles
            reverse_coeffs = zeros(4,3);
            for i = 1:4
                f = fit(angles,coeffs_delays(:,i),'poly2');
                reverse_coeffs(i,:) = [f.p1,f.p2,f.p3];
            end
            
            obj.forward_coeffs = forward_coeffs;
            obj.reverse_coeffs = reverse_coeffs;
            save(obj.save_filename,'forward_coeffs','reverse_coeffs');
        end
        
        %% Calculating a given delay and converting to speed
        % coeff_array is a 4x4 array - rows and columns both representing exp2
        function [speed] = delayToSpeed(obj,delay,angle)
            complex_coeffs = [exp2(obj.forward_coeffs(1,:),delay),...
                exp2(obj.forward_coeffs(2,:),delay),...
                exp2(obj.forward_coeffs(3,:),delay),...
                exp2(obj.forward_coeffs(4,:),delay)];
            speed = exp2(complex_coeffs,angle);
        end
        
        %% Calculating input speed to a delay sent to Arduino
        % coeff_array is a 4x3 array - rows representing exp2, columns representing
        % poly2
        function [delay] = speedToDelay(obj,speed,angle)
            complex_coeffs = [poly2(obj.reverse_coeffs(1,:),angle),...
                poly2(obj.reverse_coeffs(2,:),angle),...
                poly2(obj.reverse_coeffs(3,:),angle),...
                poly2(obj.reverse_coeffs(4,:),angle)];
            delay = exp2(complex_coeffs,speed);
        end
        
        %% 2nd Degree Polynomial
        function [output] = poly2(coeffs,x)
            output = coeffs(1).*x.^2 + coeffs(2).*x.^2 + coeffs(3);
        end
        
        %% Two-Term Exponential Function
        function [output] = exp2(coeffs,x)
            output = coeffs(1).*exp(coeffs(2).*x) + coeffs(3).*exp(coeffs(4).*x);
        end
        
        %% sendCoeffs function
        %takes in matrix of coeffcients
        %converts matrix to a string that with : delimiter
        %sends string to Arduino
        
        function sendCoeffs(obj, coeffs)
            while(strcmp(fscanf(obj.connection,'%s'),'Send')~=1)
                disp('Waiting to Send Coefficients');
            end 
            str = inputname(2);
            strList = sprintf(':%d', coeffs);
            strToSend = [str strList];
            fprintf(obj.connection, strToSend)
        end
        
    end
    
end

