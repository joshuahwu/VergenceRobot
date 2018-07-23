delayTrials = 15:5:75;
angleTrials = [0,6.34,12.53,18.43,23.96,29.05,33.69,37.87,41.63,45];
speedTrials = linspace(350,1350,10);
testSpeeds = zeros(numel(delayTrials),numel(angleTrials));
for i = 1:numel(delayTrials)
    for j = 1:numel(angleTrials)
    testSpeeds(i,j) = a.delayToSpeed(delayTrials(i),angleTrials(j));
    end
end


actualtestSpeeds(1,:) = [1211 1171 1149 1141 1145 1157 1177 1202 1232 1264];
actualtestSpeeds(2,:) = [1013 986 973 972 979 995 1017 1043 1073 1105];
actualtestSpeeds(3,:) = [870 852 844 846 856 873 894 921 950 982];
actualtestSpeeds(4,:) = [764 749 745 749 760 777 799 824 853 883];
actualtestSpeeds(5,:) = [680 669 667 672 684 700 721 746 773 802];
actualtestSpeeds(6,:) = [612 604 603 610 621 637	658	681	707	735];
actualtestSpeeds(7,:) = [558	551	551	557	569	585	604	627	652	678];
actualtestSpeeds(8,:) = [512	506	507	514	525	540	559	581	604	629];
actualtestSpeeds(9,:) = [473	468	470	476	487	502	520	540	563	587];
actualtestSpeeds(10,:) = [439	435	437	444	455	469	486	506	527	550];
actualtestSpeeds(11,:) = [410	407	409	416	426	440	456	475	496	518];
actualtestSpeeds(12,:) = [385	382	384	391	401	414	430	448	468	489];
actualtestSpeeds(13,:) = [362	360	362	369	378	391	407	424	443	463];
testDelays = zeros(numel(delayTrials),numel(angleTrials));
for i = 1:numel(delayTrials)
    for j = 1:numel(angleTrials)
    testDelays(i,j) = a.speedToDelay(actualtestSpeeds(i),angleTrials(j));
    end
end 
