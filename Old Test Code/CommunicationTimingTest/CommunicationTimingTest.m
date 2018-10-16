clear
comPort = serial('COM8','DataBits',8,'StopBits',1,'BaudRate',14400,'Parity','none');
fopen(comPort);

SerialInit = 'X';
while(SerialInit~='A')
    0
    SerialInit = check(comPort);
end
if SerialInit ~= 'A'
    disp('Serial Communication Not Setup');
else
    disp('Serial Read');
end
fprintf(comPort, '%s', 'A');
flushinput(comPort);

forward_coeffs = rand(4,4);
reverse_coeffs = rand(4,4);

 output = check(comPort) %should receive Z

 output = check(comPort) %should receive "ReadyToReceiveCoeffs"
 sendArray(comPort, forward_coeffs);
 output = check(comPort) %should receive "ForwardCoeffsReceived"
 sendArray(comPort, reverse_coeffs);
 output = check(comPort) %should receive "ReverseCoeffsReceived"
 
% should receive "Ready"
 output = check(comPort)
 
% random playing with communication
% send and receive a 5
fprintf(comPort, '%s', '5');
 output = check(comPort)
% send and receive "Hello"
fprintf(comPort, '%s', 'Hello');
 output = check(comPort)

fclose(comPort);

function output = check(comPort)
data = '';
while(1)
    data = fscanf(comPort, '%s');
    if isempty(data) == 1
        data = fscanf(comPort, '%s');
        %1
    elseif isempty(data) == 0
        %disp(data);
        output = data;
        %2
        break;
    end
end
end

%% sendArray function
%takes in matrix of coeffcients
%converts matrix to a string that with : delimiter
%sends string to Arduino

function sendArray(comPort, array)
str = inputname(2);
strList = sprintf(':%f', array);
strToSend = [str strList];
fprintf(comPort, strToSend);
end