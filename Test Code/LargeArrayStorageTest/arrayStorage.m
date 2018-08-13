%% Practice with PROGMEM storage

comPort = serial('COM8','BaudRate',9600);
fopen(comPort);
% while Beginning is being sent from Arduino, print given message
while(strcmp(fscanf(comPort,'%s'),'Beginning')==1)
    disp('Waiting for Experiment Start')
end


X = rand(1,60);
valuesReceivedX = zeros(size(X));

sendArray(comPort, X);

for i = 1:numel(X)
    valuesReceivedX(i) = fscanf(comPort, '%f');
end

fclose(comPort);
%% sendArray function
%takes in array of values
%converts array to a string that with : delimiter
%sends string to Arduino

function sendArray(comPort, array)
str = inputname(2);
strList = sprintf(':%f', array);
strToSend = [str strList];
fprintf(comPort, strToSend);
end