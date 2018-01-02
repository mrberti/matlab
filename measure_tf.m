try
  pkg load signal;
end

close all;

Fs = 1e3;
Ts = 1/Fs;
T_end = 10;

F_start = 0;
F_end = 500;

t = 0:Ts:T_end;

s_in_sin = chirp(t,F_start,T_end,F_end,'linear');
s_in_cos = chirp(t,F_start,T_end,F_end,'linear',90);

%s_in_sin = randn(1,length(t));

%G = zpk(2*pi*[0.1],2*pi*[1 10 20],1); G = G/dcgain(G);
G = tf([1],[1/(2*pi*10) 1]);
G2 = tf([1/(2*pi*10) 0], [1/(2*pi*10) 1]);
%G = G2*G;
%G = tf(1,1);

filt_lp = tf([1],[1/(2*pi*0.1) 1]);

s_out = lsim(G, s_in_sin, t)';

s_mod_i = s_out .* s_in_sin;
s_mod_q = s_out .* s_in_cos;
s_mod_i_filt = lsim(filt_lp, s_mod_i, t);
s_mod_q_filt = lsim(filt_lp, s_mod_q, t);

s_mod = s_mod_i + 1j*s_mod_q;
s_mod_filt = s_mod_i_filt + 1j * s_mod_q_filt;


plot(t,s_in_sin,t,s_out');
figure;
[A,F] = tfestimate(s_in_sin,s_out);
loglog(F,abs(A));