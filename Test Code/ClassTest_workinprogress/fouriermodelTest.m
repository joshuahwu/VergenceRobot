delays = 15:5:65;
speedArrayTest = speedArray; %speedArraymeters./(0.037699./200);

coeffs_delays = zeros(length(angles),4);
for i = 1:numel(angles)
    f = fit(transpose(speedArrayTest(i,:)),transpose(delays),'exp2');
    coeffs_delays(i,:) = [f.a,f.b,f.c,f.d];
end

reverse_coeffs_four2 = zeros(4,6);
for i = 1:4
    f2 = fit(angles,coeffs_delays(:,i),'fourier2');
    reverse_coeffs_four2(i,:) = [f2.a0,f2.a1,f2.b1,f2.a2,f2.b2,f2.w];
end 
%%
testDelaysF = zeros(numel(angles),numel(delays));
for i = 1:numel(angles)
    for j = 1:numel(delays)
    testDelaysF(i,j) = speedToDelay(reverse_coeffs_four2,speedArrayTest(i,j),angles(i));
    end
end 

function [output] = speedToDelay(coeff_array,speed,angle)
complex_coeffs = [fourier2(coeff_array(1,:),angle),...
    fourier2(coeff_array(2,:),angle),...
    fourier2(coeff_array(3,:),angle),...
    fourier2(coeff_array(4,:),angle)];
output = exp2(complex_coeffs,speed);
end

        %% 2-term Fourier
        function [output] = fourier2(coeffs,x)
            output = coeffs(1) + coeffs(2).*cos(x.*coeffs(6)) +...
                coeffs(3).*sin(x.*coeffs(6)) +...
                coeffs(4).*cos(2.*x.*coeffs(6)) +... 
                coeffs(5).*sin(2.*x.*coeffs(6));
        end
        
                %% Two-Term Exponential Function
        function [output] = exp2(coeffs,x)
            output = coeffs(1).*exp(coeffs(2).*x) + coeffs(3).*exp(coeffs(4).*x);
        end
        