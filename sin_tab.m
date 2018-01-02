clear all;
close all;

try
    pkg load signal;
end

N = 80;
Ts = 1/8000;%1e-3;
F_sin = 400;
T_sin = 1/F_sin;

N_sin_bit = 10;
N_T_mov_bit = 16;
N_F_sin_bit = 5;
N_sin = 2^N_sin_bit;

F_sin_FIX = fix16(F_sin, N_F_sin_bit)
Ts_FIX = fix16(Ts, N_T_mov_bit)

T_mov = Ts*F_sin
T_mov_FIX = fix16(T_mov, N_T_mov_bit)

t = 0:Ts:N*Ts-Ts;%linspace(0,N*Ts,N);
sig = zeros(1,N);
n_sin = zeros(1,N);

% create sine table
sin_t = sin(2*pi*[0:N_sin-1]/N_sin);


ts_FIX = fix16(0,N_T_mov_bit);
x = fix16(0,N_T_mov_bit);
for n = 1:N
  n_sin_fix(n) = bitand(ts_FIX/2^(N_T_mov_bit-N_sin_bit),2^N_sin_bit-1)+1;
  n_sin(n) = rem(round((F_sin*t(n))*N_sin),N_sin)+1;
  sig(n) = sin_t(n_sin(n));
  sig_fix(n) = sin_t(n_sin_fix(n));
  
  % Check if this step would lead to an integer overflow
  if ts_FIX+T_mov_FIX >= intmax(class(ts_FIX))
    ts_FIX = ts_FIX - intmax(class(ts_FIX));
  end
  % Move to next time step
  ts_FIX = ts_FIX + T_mov_FIX;

end

Ts2 = Ts/10
t2 = 0:Ts2:N*Ts-Ts2;
figure;
hold on;
%stairs(t,sig,'b.-');
stairs(t,sig_fix,'r.-');
pure_sin = sin(2*pi*F_sin*t2);
plot(t2, pure_sin, 'g');

z = tf('z',Ts2);
Tz = 0.94;
sys = (1-Tz)/(1-Tz*z^(-1));

x1 = upsample(sig_fix,10);
x2 = filter(ones(1,10),1,x1);
y = filter(1-Tz,[1, -Tz],x2);
stairs(t2,x2,'r');
stairs(t2,y,'b');

sound(sig);
soundsc(sig_fix);
sound(y,1/Ts*10);

f = linspace(0,2/Ts,length(t));
f2 = linspace(0,2/Ts*10,length(t2));
figure;
hold on;
grid on;
%plot(f2,10*log10(abs(fft(pure_sin/length(f2)))),'b.-');
plot(f,10*log10(abs(fft(sig_fix/length(f2)))),'r');
plot(f2,10*log10(abs(fft(y/length(y)))),'g');