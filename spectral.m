clear all;
clc;

F = 1000;

Tmax = .4;
Fs = 44100;
dt = 1/Fs;
t = 0:dt:Tmax-dt;
N = length(t);

sigma = sqrt(1);
n = sigma*randn(1,N);
s = 1*sin(2*pi*F*t);% + 1*sin(2*pi*F*4*t);

g = s + n;

S = abs(fft(g)/N).^2;
R = ifft(S);

SNR = 10*log10(sum(s.^2)/sum(n.^2)*N)

plot(t,10*log10(S));
%plot(t,g);
%plot(t, S);
soundsc(g,Fs);