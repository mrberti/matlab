clear all;
close all;

try
  pkg load control
end

F0 = 100;
dF = 10;
F_start = F0-dF/2;
F_end = F0+dF/2;

Fs = F0*20;
dt = 1/Fs;
Tend = 1/F0*100;
t = 0:dt:Tend-dt;

N = length(t);

NF = 4;
%f = F_start:dF/N*NF:F_end-dF/N;
%f = repmat(f,1,NF);
f = [F_start*ones(1,N/NF/2) F_end*ones(1,N/NF/2) ];
f = repmat(f,1,NF);
imp = ones(1,round(N/NF/10))/(N/NF/10);
f = conv(f,imp);
f = f(1:N);

%f = F0+dF*sin(2*pi*F0/20*t);

sig0 = sin(2*pi*F0*t);
sig = sin(2*pi*f.*t);
%sig = sig0;
sig2 = sig0.*sig;

F3db = dF*0.1;
s = tf('s');
sys = 1/(2*pi*1/F3db*s+1);
sig_filt = lsim(sys,sig2,t);

df = Fs/N;
f_bins = -Fs/2:df:Fs/2-df;

figure;
plot(t,sig);
figure;
plot(t,sig2,t,sig_filt);

figure;
%%
plot(f_bins,20*log10(abs(fftshift(fft(sig)))/N));
hold on;
plot(f_bins,20*log10(abs(fftshift(fft(sig2)))/N),'r');