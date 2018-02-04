f = "../gqrx_20180204_030822_852793300.wav"
[wav, Fs] = wavread(f);

N_max = 5000;

x1 = wav(1:N_max,1);
x2 = wav(1:N_max,2);

Ts = 1/Fs;
Tend = Ts*N_max;
t = 0:Ts:Tend-Ts;
F_m = 25000;
F_bp = 1000;

bp = [F_m - F_bp F_m+F_bp]
bp_norm = bp/Fs

hc = fir1(100,bp_norm, 'bandpass');

y1 = filter(hc,1,x1);
y2 = filter(hc,1,x2);

s1 = sin(2*pi*F_m*t);

plot(x1);
hold on;
plot(y1);

figure
plot(abs(fft(x1)));
hold on;
plot(abs(fft(y1)));