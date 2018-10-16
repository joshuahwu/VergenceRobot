obj = serial('COM8');
obj.DataBits = 8;
obj.StopBits = 1;
obj.BaudRate = 9600;
obj.Parity = 'none';
obj.Timeout = 1;
fopen(obj);
pause(0.5);

while(1)
    byte = obj.BytesAvailable
    incoming = fscanf(obj, '%s')
    
%     if obj.BytesAvailable > 0
%         break;
%     end 
end 

fclose(obj);