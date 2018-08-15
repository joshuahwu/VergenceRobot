%% isReceiving

% open serial connection
comPort = serial('COM8','DataBits',8,'StopBits',1,'BaudRate',9600,'Parity','none');
fopen(comPort);
% confirm serial connection
SerialInit = 'B';
while(SerialInit~='A')
    SerialInit = fscanf(comPort,'%c',1);
end
disp('Serial read');
fprintf(comPort, '%c', 'A');


incoming = "Beginning";
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

fclose(comPort);   