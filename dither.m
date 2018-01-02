close all;
clear all;

T = 1;
Fs = 44100;
dt = 1/Fs;
F = 440;
N = 8;

t = 0:dt:T-dt;

s = sin(2*pi*F*t);
q = floor(s*N)/N;
n = 0.05*rand(1,length(t));
q2 = floor((s + n)*N)/N;

hold on;
plot((abs(fft(q))));
plot((abs(fft(q2))), 'r');

figure;
hold on;
plot(s-q);
plot(s-q2, 'r');

%soundsc(q, Fs);
soundsc(q2, Fs);

