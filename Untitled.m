clear all;
close all;
clc;

F1 = 2000;
F2 = 2000;
Fs = 44100;
Tmax = 1000/(min(F1,F2));

dt = 1/Fs;
t = 0:dt:Tmax-dt;

s1 = sin(2*pi*F1*t);
s2 = sin(2*pi*F2*t);

s = s1 + s2;
s = s / max(s) * .5;


hold on;
g = s.^2;
g = sqrt(abs(s));
g = g;% - mean(g);
%plot(s);
%plot(g,'g');
plot(abs(fftshift(fft(s)))/length(fft(s)),'g');
stem(abs(fftshift(fft(g)))/length(fft(g)),'r');

soundsc(s,Fs);
soundsc(g,Fs);