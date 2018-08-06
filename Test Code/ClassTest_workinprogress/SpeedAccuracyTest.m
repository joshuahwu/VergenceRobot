delays = 15:5:65;
testSpeeds = zeros(numel(delays),numel(angles));
for i = 1:numel(delays)
    for j = 1:numel(angles)
    testSpeeds(i,j) = a.delayToSpeed(delays(i),angles(j));
    end
end


% actualtestSpeeds(1,:) = [1211 1171 1149 1141 1145 1157 1177 1202 1232 1264];
% actualtestSpeeds(2,:) = [1013 986 973 972 979 995 1017 1043 1073 1105];
% actualtestSpeeds(3,:) = [870 852 844 846 856 873 894 921 950 982];
% actualtestSpeeds(4,:) = [764 749 745 749 760 777 799 824 853 883];
% actualtestSpeeds(5,:) = [680 669 667 672 684 700 721 746 773 802];
% actualtestSpeeds(6,:) = [612 604 603 610 621 637	658	681	707	735];
% actualtestSpeeds(7,:) = [558	551	551	557	569	585	604	627	652	678];
% actualtestSpeeds(8,:) = [512	506	507	514	525	540	559	581	604	629];
% actualtestSpeeds(9,:) = [473	468	470	476	487	502	520	540	563	587];
% actualtestSpeeds(10,:) = [439	435	437	444	455	469	486	506	527	550];
% actualtestSpeeds(11,:) = [410	407	409	416	426	440	456	475	496	518];
% actualtestSpeeds(12,:) = [385	382	384	391	401	414	430	448	468	489];
% actualtestSpeeds(13,:) = [362	360	362	369	378	391	407	424	443	463];

testDelays = zeros(numel(delays),numel(angles));
for i = 1:numel(delays)
    for j = 1:numel(angles)
    testDelays(i,j) = a.speedToDelaypoly3(speedArray(j,i),angles(j));
    end
end 
