%% isReceiving

% open serial connection
comPort = serial('COM8','DataBits',8,'StopBits',1,'BaudRate',9600,'Parity','none');
fopen(comPort);
% confirm serial connection
SerialInit = 'B';
while(SerialInit~='A')
    SerialInit=fread(comPort,1,'uchar');
end
disp('Serial read');
fprintf(comPort, '%c', 'A');

isReceiving = true;
if isReceiving == false
    fscanf(
    if a ~= 0
        isReceiving = true;
    end
end 
if isReceiving == true
    a = 1;
    