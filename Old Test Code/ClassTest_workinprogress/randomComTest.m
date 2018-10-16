obj = serial('COM8');
obj.DataBits = 8;
obj.StopBits = 1;
obj.BaudRate = 9600;
obj.Parity = 'none';
obj.Timeout = 1;
fopen(obj);
pause(0.5);

% Send a random character to the Arduino to get a reply
%fprintf(obj, '%c', 'k');
% Wait for the reply
% while (obj.BytesAvailable < 1)
%      pause(0.1);
%     fprintf(obj, '%c', 'k');
% end
% Read the reply and take measures
while (1)
    incoming = fscanf(obj, '%s')
    if (incoming == 'b')
        fprintf(obj, '%c', 'a');
        break;
    elseif (incoming ~= 'b')
        incoming = fscanf(obj, '%s');
    end
end  
%     bytes = obj.BytesAvailable
%     HandShake = fscanf(obj, '%s')
% if HandShake == 'b'
%     fprintf(obj, '%c', 'a');
% else
%     disp('Something wrong with the connection')
%     fclose(obj);
%     return;
% end 
% fprintf('HandShake %s\n', HandShake);
% The Arduino needs a small gap to prepare itself
flushinput(obj);

Z = fscanf(obj, '%s')
