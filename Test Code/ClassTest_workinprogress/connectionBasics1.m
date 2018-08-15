%% connectionBasics.m
% The purpose of this script is to investigate the basics of serial
% communication between MATLAB and Arduino.
%% Initialization
% open serial connection
comPort = serial('COM8','DataBits',8,'StopBits',1,'BaudRate',9600,'Parity','none');
fopen(comPort);
% confirm serial connection
SerialInit = 'B';
while(SerialInit~='A')
    SerialInit=fscanf(comPort,'%c',1);
end
disp('Serial read');
% if (SerialInit=='A')
%     disp('Serial read');
% end 
fprintf(comPort, '%c', 'A');

%% Communicate with Arduino
% send the number 5
fprintf(comPort, '%d', '5');
% read back the number 5
while (strcmp(fscanf(comPort, '%s'),'5') == 1)
    disp('Value Received');
end
fscanf(comPort, '%s', 1)
% while(isEmpty(fscanf(comPort, '%s')))
% end


%% Close the serial connection
fclose(comPort);