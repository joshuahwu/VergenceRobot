comPort = serial('COM6','BaudRate',9600);
fopen(comPort);
pause(2);

forward_coeffs = rand(4,4);
reverse_coeffs = rand(4,3);
valuesReceivedFWD = zeros(size(forward_coeffs));
valuesReceivedREV = zeros(size(reverse_coeffs));

sendCoeffs(comPort, forward_coeffs);
for i = 1:numel(forward_coeffs)
    valuesReceivedFWD(i) = fscanf(comPort, '%f');
end

sendCoeffs(comPort, reverse_coeffs);
for i = 1:numel(reverse_coeffs)
    valuesReceivedREV(i) = fscanf(comPort, '%f');
end

fclose(comPort);
%% sendCoeffs function
%takes in matrix of coeffcients
%converts matrix to a string that with : delimiter
%sends string to Arduino

function sendCoeffs(comPort, coeffs)
str = inputname(2);
strList = sprintf(':%f', coeffs);
strToSend = [str strList];
fprintf(comPort, strToSend);
end