delays = 15:5:65;
speedArrayTest = speedArray; %speedArraymeters./(0.037699./200);

coeffs_delays = zeros(length(angles),4);
for i = 1:numel(angles)
    f = fit(transpose(speedArrayTest(i,:)),transpose(delays),'exp2');
    coeffs_delays(i,:) = [f.a,f.b,f.c,f.d];
end

reverse_coeffs_poly3 = zeros(4,4);
for i = 1:4
    f1 = fit(angles,coeffs_delays(:,i),'poly3');
    reverse_coeffs_poly3(i,:) = [f1.p1,f1.p2,f1.p3,f1.p4];
end
%%
testDelaysP = zeros(numel(angles),numel(delays));
for i = 1:numel(angles)
    for j = 1:numel(delays)
    testDelaysP(i,j) = speedToDelay(reverse_coeffs_poly3,speedArrayTest(i,j),angles(i));
    end
end 

function [output] = speedToDelay(coeff_array,speed,angle)
complex_coeffs = [poly3(coeff_array(1,:),angle),...
    poly3(coeff_array(2,:),angle),...
    poly3(coeff_array(3,:),angle),...
    poly3(coeff_array(4,:),angle)];
output = exp2(complex_coeffs,speed);
end

        %% 3rd Degree Polynomial
        function [output] = poly3(coeffs,x)
            output = coeffs(1).*x.^3 + coeffs(2).*x.^2 + coeffs(3).*x + coeffs(4);
        end 
        
                %% Two-Term Exponential Function
        function [output] = exp2(coeffs,x)
            output = coeffs(1).*exp(coeffs(2).*x) + coeffs(3).*exp(coeffs(4).*x);
        end