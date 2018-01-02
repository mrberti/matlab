clear all;
close all;

Tmax = 1000e-3;
Fs = 44100;
F1 = 500;
F2 = 5000;

Fstop = 3000;   % Stopband Frequency
Fpass = 3500;   % Passband Frequency
Astop = 60;     % Stopband Attenuation (dB)
Apass = 1;      % Passband Ripple (dB)

dt = 1/Fs;
t = 0:dt:Tmax-dt;
df = Fs/length(t);
f = -Fs/2:df:Fs/2-df;
f = 0:df:Fs-df;
s = sin(2*pi*F1*t) + sin(2*pi*F2*t);

%s = wavread('test.wav');

h = fdesign.highpass('fst,fp,ast,ap', Fstop, Fpass, Astop, Apass, Fs);

Hd = design(h, 'equiripple', ...
    'MinOrder', 'any');

g = filter(Hd, s);

hold on;
plot(f,10*log10(2*abs(fft(s)/length(fft(s)))));
plot(f,10*log10(2*abs(fft(g)/length(fft(g)))),'r');
title('hallo \alpha \cdot \int_0^t x dt')


%soundsc(s, Fs);
%soundsc(g, Fs);
