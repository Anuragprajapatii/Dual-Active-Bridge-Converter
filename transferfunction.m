clc
clearvars
n=1; %turns ratio 1:n
V1=800 ;%input voltage
Vo0=400; %output voltage
fs=100000; %frequency
pmax=20000; %maximum power
dmax=0.5; %delta max
D=0.5
phi=pi*dmax;

a=V1*Vo0; %denominator constant 
b=2*pmax*fs*n; %numerator constant
c=dmax*(1-dmax); %duty cycle  constant
Llkg=20.4e-6 %inductor value


%to  calculate the capacitor Value
delQ=(V1*(dmax^2)*(dmax-2)^2)/(Llkg*16*n*(fs^2));
delVpk=0.05*Vo0;
% Co=(delQ)/(2*delVpk);
Co=0.000470;

Wsw=2*pi*fs;
Rt=0;
R=8;
% Co=38*10^(-6);

L=((1/R*Co)*(((Rt/Llkg)^2)+Wsw^2))+((8*Rt)/((pi^2)*(Llkg^2)*(Co)));




%to  calculate the capacitor Value 

%d=8*fs*L*pmax;        
%e=N*V1*V2;
%f=sqrt(1-(d/e));
%phase = (pi/2)*(1-f) 

% Transfer Function of Output Voltage wrt Phase Delay
 s=tf('s');
N=((Wsw*cos(D*pi))/(R*Co)+((16*V1*sin(D*pi))/( pi^2*Llkg*Co))-((Rt/(R*Llkg*Co))*(sin(D*pi))))/L

 
 
%N=((16*V1*sin(pi*D)/(pi^2*Llkg*Co))+((Wsw*cos(pi*D))/R*Co)-((Rt/(R*Co*Llkg))*sin(pi*D)))/((1/(R*Co))*(((Rt/Llkg)^2)+(Wsw^2))+((8*Rt)/(pi^2*Llkg^2*Co)));
delVo=(N*(s+(Rt/Llkg))^2+Wsw^2)+(8*Vo0*Wsw/pi*Co*Llkg);
deld=((((s+(Rt/Llkg))^2)*(s+(1/R*Co)))+((8/(pi^2*Llkg*Co))*(s+(Rt/Llkg)))+((s+(1/R*Co))*Wsw));

tf1=N*delVo/deld
figure
bode(tf1)
hold on
figure
rlocus(tf1)
[p,z]=pzmap(tf1)
%To find Kp and Ki
C=pidtune(tf1,'PI');
bode(C*tf1)
Kp=C.Kp
Ki=C.Ki