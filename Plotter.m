figure(1);

%plot(0:10,mean(yerr5(:,1:11),1),0:10,mean(yerr10,1),0:10,mean(yerr20,1),0:10,mean(yerr50,1))
plot(0:20,yerr5,'k-',0:20,yerr10,'r-',0:20,yerr20,'g-',0:20,yerr30,'b-',0:20,yerr50,'c-')
axis([0 20 1000 1200])
ylabel('Steps to yMin')
legend('5 delayMicroseconds','10','20','30','50')
xlabel('Trial Number')

figure(3);
yerr501 = 1047.*ones(1,21);
yerr201 = 1047.*ones(1,21);
yerr201(5) = 1046;
yerr201(8) = 1048;
yerr201(14) = 1046;
yerr201(16) = 1046;
yerr201(21) = 1046;
plot(0:20,yerr5,'k-',0:20,yerr10,'r-',0:20,yerr201,'g-',0:20,yerr30,'b-',0:20,yerr501,'c-')
axis([0 20 1000 1200])
ylabel('Steps to yMin')
legend('5 delayMicroseconds','10','20','30','50')
xlabel('Trial Number')

figure(2);
plot(0:20,xerr10,'k-',0:20,xerr10,'r-',0:20,xerr20,'g-',0:20,xerr30,'b-',0:20,xerr50,'c-')
axis([0 20 800 840])
ylabel('Steps to xMin')
legend('5 delayMicroseconds','10','20','30','50')
xlabel('Trial Number')