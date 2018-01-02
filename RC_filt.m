pkg load control;

F1 = 10;
w1 = 2*pi*F1;
F2 = 100;
w2 = 2*pi*F2;

C1 = 470e-9;
R1 = 1/(w1*C1)
C2 = 10e-9;
R2 = 1/(w2*C2)

alpha = C2/C1
lambda = 1/(C1*R2)
wd = 1/2*((w1+w2*(1+alpha)+sqrt(w2^2*(alpha+1)^2+2*(w1*w2)*(alpha-1)+w1^2)))
wd1 = 1/2*((w2*(1+alpha)+w1)-sqrt((w1+w2+lambda)^2-4*w1*w2))
wd2 = 1/2*((w2+w1+lambda)+sqrt((w1+w2+lambda)^2-4*w1*w2))

b1 = [0 1];
a1 = [T11*T22 (T11+T22) 1pol];

T22 = C2*R2;
T11 = C1*R1;

b2 = [T11 0];
a2 = [T22*T11 T11*(1+alpha)+T22 1];

G1 = tf(b1,a1);
G2 = tf(b2,a2);
GCR = tf([1 0],[1 1/T11]);
GRC = tf([1],[T22 1]);
pole(G2)

Tslope = 0.05;
Gamp = tf([1],[Tslope 1]);

Fx = 50;
wx = Fx*2*pi;
Ax = 1/bode(G2,wx)
Ts = 100e-6;
t = 0:Ts:1;
slope = ones(1,length(t));
index_slope = 1:round(Tslope/Ts);
slope(index_slope) = t(index_slope)/(Tslope);
slope = lsim(Gamp,ones(size(t)),t);
noise = randn(size(t));
sigma = 0.2;

u = Ax*slope'.*(-cos(wx*t)+1)+sigma^2*noise;

bode(GCR,G2)
%figure;

%lsim(G2,u,t)