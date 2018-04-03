length = 47.9; %cm
PulseperRev = 3200;
circumference = 11.64*pi; %mm
pulsetime = linspace(10,500,10000); %microseconds
speed = 10^-3*circumference./PulseperRev./(2.*pulsetime/10^6);
figure(1);
plot(pulsetime,speed);
xlabel('delayMicroseconds');
ylabel('Max Speed (m/s)');
figure(2);
x = linspace(0,4*pi,1000);
y = sin(pi/2*cos(x));
plot(x,y);
xlabel('delayMicroseconds');
ylabel('Max Speed (m/s)');


pmeas = [10,20,30,40,50,60,70,80,90,100];
pmeas = [pmeas,120:20:500];
tmeas = [3.026,4.374,5.720,7.066,8.413,9.760,11.107,12.454,13.800,15.147, ...
    17.839,20.533,23.266,25.919,28.614,31.307,34,36.694,39.387,42.082, ...
    44.775,47.467,50.161,52.853,55.547,58.241,60.934,63.628,66.321,69.014];

%spmeas = 0.479/2*(pi^2./tmeas).*sin(pi^2./tmeas).*cos(pi/2.*cos(pi^2./tmeas));
spmeas = 0.479/2*(pi^2./tmeas).*sin(pi/2).*cos(pi/2.*cos(pi/2));
figure(3);
plot(pmeas,spmeas);


