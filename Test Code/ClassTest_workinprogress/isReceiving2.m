%% isReceiving
clear
% open serial connection
comPort = serial('COM8','DataBits',8,'StopBits',1,'BaudRate',9600,'Parity','none');
% fopen(comPort);
% fclose(comPort);

fopen(comPort);

forward_coeffs = rand(4,4);
reverse_coeffs = rand(4,4);

%confirm serial connection

SerialInit = 'X';
while(SerialInit~='B')
    0
    SerialInit = check(comPort);%fread(comPort,1,'uchar');
end
if SerialInit ~= 'B' % while statement could time out
    disp('Serial Communication Not Setup');
else
    disp('Serial Read');
end
fprintf(comPort, '%s', 'A');
flushinput(comPort);

%fprintf(comPort, '%s', 'SerialInitialized');

Z = check(comPort);
% mbox = msgbox('Serial Communication Setup'); uiwait(mbox);

 sendArray(comPort, forward_coeffs);
 check(comPort);
 sendArray(comPort, reverse_coeffs);
 check(comPort);
 check(comPort);
%  
%  %should receive "Ready"
% check(comPort);
% % % %% playing with communication
% % % % send and receive a 5
% % fprintf(comPort, '%s', '5');
% % check(comPort);
% % %send and receive "Hello"
% % fprintf(comPort, '%s', 'Hello');
% % check(comPort);
% 
fclose(comPort);

function output = check(comPort)
data = '';
while(1)
    data = fscanf(comPort, '%s');
    if isempty(data) == 1
        isReceiving = false;
        1
    elseif isempty(data) == 0
        isReceiving = true;
        2
    end
    if isReceiving == false
        data = fscanf(comPort, '%s');
        if isempty(data) == 0
            isReceiving = true;
            3
        end
    elseif isReceiving == true
        disp(data);
        output = data;
        4
        break;
    end
end
end

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