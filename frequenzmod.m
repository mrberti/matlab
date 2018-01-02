clear all;
close all;

try
  pkg load control;
end

Tend = 1;
Fs = 500;
Ts = 1/Fs;
t = 0:Ts:Tend-Ts;
N = length(t);

A = 1;
Fc = 50;
Fd = 5;
phi_0 = 0;

Fsig = 1;
s = (2*sin(2*pi*Fsig*t) + 0*sin(2*pi*10*Fsig*t))/Fs;
%s = linspace(0,2,N)/N;

F_data = 10; Fsig = F_data;
data = [-1 1 -1 1 1 -1 1 1 -1 -1 1];
N_data = length(data);
o = ones(1,ceil(Fs/F_data))/Fs;
s = reshape(o'*data,1,[]);
s = s(1:N);

arg = 2*pi*(Fc*t+Fd*cumsum(s)) + phi_0;
u = A * cos(arg);
U = fftshift(fft(u)/N);

f_inst = diff(arg)*Fs/2/pi;

df = 1/Ts/N;
f = -Fs/2:df:Fs/2-df;

G = G = zpk([0],[-1/(2*pi*Fsig*0.02) -1/(2*pi*0.01)],1);
y = lsim(G,abs(cumsum(u)),t);

subplot(3,1,1);
plot(t,u);
subplot(3,1,2);
plot(t(1:end-1),f_inst);
subplot(3,1,3);
plot(f,abs(U));
%hold on;
%plot(f,real(U),'r--');
%plot(f,imag(U),'g--');
%figure('Name','w');
%plot(t, w);
%figure('Name','fft');
figure;
plot(t,y);
hold on;
plot(t,s);
