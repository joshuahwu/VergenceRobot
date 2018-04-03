classdef Experiment
    % Class Experiment to
    
    properties
        reader
        obj
        dimensions
    end
    
    methods
        function initialize(port)
            Experiment.obj = setupSerial(port);
        end
        
        function Experiment = recalibrate(inputArg1,inputArg2)
            
            Experiment.Property1 = inputArg1 + inputArg2;
            fprintf(Experiment.obj,'Recalibrate','%s');
        end
        
        function outputArg = saccade(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
            fprintf(Experiment.obj,'Recalibrate + inputArg','%s');
        end
        
        function[obj,flag] = setupSerial(comPort)
            % It accept as the entry value, the index of the serial port
            % Arduino is connected to, and as output values it returns the serial
            % element obj and a flag value used to check if when the script is compiled
            % the serial element exists yet.
            flag = 1;
            % Initialize Serial object
            obj = serial(comPort);
            set(obj,'DataBits',8);
            set(obj,'StopBits',1);
            set(obj,'BaudRate',9600);
            set(obj,'Parity','none');
            fopen(obj);
            a = 'b';
            while (a~='a')
                a=fread(obj,1,'uchar');
            end
            if (a=='a')
                disp('Serial Read');
            end
            fprintf(obj,'%c','a');
            mbox = msgbox('Serial Communication Setup'); uiwait(mbox);
            fscanf(obj,'%u');
        end
        
        % denote trials
        function trialsOrg = saveTrials()
            removeNode(newNode);
            newNode.Next = nodeBefore.Next;
            newNode.Prev = nodeBefore;
            if ~isempty(nodeBefore.Next)
                nodeBefore.Next.Prev = newNode;
            end
            nodeBefore.Next = newNode;
        end
            
    end
end

