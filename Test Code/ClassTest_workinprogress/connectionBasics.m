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
    SerialInit=fread(comPort,1,'uchar');
end 
if (SerialInit=='A')
    disp('Serial read');
end 
fprintf(comPort, '%c', 'A');

%% Communicate with Arduino
% send the number 5
fprintf(comPort, '%d', '5');
% read back the number 5
while (strcmp(fscanf(comPort, '%s'),'5') == 1)
    disp('Value Received');
end
fscanf(comPort, '%s', 1)

% array1 = rand(2,2);
% array2 = rand(2,2);
% 
% sendArray(comPort, array1);
% fscanf(comPort, '%s')
% 
% sendArray(comPort, array2);
% fscanf(comPort, '%s')

%% Close the serial connection
fclose(comPort);

%% sendCoeffs function
%takes in matrix of coeffcients
%converts matrix to a string that with : delimiter
%sends string to Arduino

function sendArray(comPort, array)
str = inputname(2);
strList = sprintf(':%f', array);
strToSend = [str strList];
fprintf(comPort, strToSend);
end