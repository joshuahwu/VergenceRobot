%% isReceiving1

% open serial connection
comPort = serial('COM8','DataBits',8,'StopBits',1,'BaudRate',9600,'Parity','none');
fopen(comPort);
% confirm serial connection
SerialInit = 'B';
while(SerialInit~='A')
    SerialInit = fscanf(comPort,'%c',1);
end
if SerialInit == 'A' % while statement could time out
    disp('Serial read');
end 
fprintf(comPort, '%c', 'A');

%should receive "Done"
check(comPort)
% %% playing with communication
% % send and receive a 5
fprintf(comPort, '%s', '5');
check(comPort)
%send and receive "Hello"
fprintf(comPort, '%s', 'Hello');
check(comPort)

fclose(comPort);   

function check(comPort)
incoming = "";
while(1)
    disp('checking port');
    data = fscanf(comPort, '%s');
    if isempty(data) == 1
        isReceiving = false;
    elseif isempty(data) == 0
        isReceiving = true;
    end
    if isReceiving == false
        disp('checking port again');
        data = fscanf(comPort, '%s');
        if isempty(data) == 0
            disp('receiving! and storing');
            incoming = [incoming, data]
            isReceiving = true;
        end 
    elseif isReceiving == true
        disp('still receiving');
        if isempty(data) == 0
            disp('store character arrays');
            incoming = [incoming, data]
        elseif isempty(data) == 1
            isReceiving = false; 
            disp('not receiving');
        end  
    end 
    if (strcmp(data, 'Done') == 1)
        break;
    end 
end 
end