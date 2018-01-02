close all;
clear all;

R = 44100;
T_max = 4; % s
F = 1000; % Hz
t = [0:1/R:T_max-1/R];
n1 = rand(1,T_max * R);
n2 = randn(1,T_max * R);

s = sin(2*pi*F*t);

sn1 = s + n1;
sn2 = s + n2;

% rauschen filtern

filt = [1 1 1];
n1filt = conv(n1, filt, 'same');

[b, a] = butter(3, F/R); 

sn2 = filter(b,a,n1);

hold on;
plot(10*log10(abs(fftshift(fft(n1))).^2));
plot(10*log10(abs(fftshift(fft(n1filt))).^2), 'r');
plot(10*log10(abs(fftshift(fft(sn2))).^2), 'g');
hold off;

sn1 = sn1./max(abs(sn1));
sn2 = sn2./max(abs(sn2));
wavwrite(sn1, R, 'sn1.wav');
wavwrite(sn2, R, 'sn2.wav');
wavwrite(n1, R, 'n1.wav');
wavwrite(n1filt, R, 'n1filt.wav');