pkg load control;

s = tf('s');

Fs = 44e3;
Ts = 1/Fs;
Tend = 100;

Fgrenz = 1; %Hz
wgrenz = 2*pi*Fgrenz;

G = tf([1],[1/wgrenz 1]);

t = 0:Ts:1;
n = 1*randn(size(t))+10*sin(2*pi*10*t);
[y,ty] = lsim(G,n,t);

plot(t,n,ty,y);

Y = fft(y);
df = Fs*2/length(t);
f = df:df:Fs*2;

Y = Y(1:floor(length(Y)/2))/length(Y)*2;
f = f(1:floor(length(f)/2));

loglog(f,20*abs(Y));