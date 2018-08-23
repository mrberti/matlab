clear variables;
more off;
pkg load control;

T_s = 1.234*1000e-6;
T_end = 100e-3;

s = tf('s');
z = tf('z', T_s);

U_q = 1;
C = 1e-6;
R = 1000;

U_c = 1/(R*C*s+1)/U_q*R;
U_cz = c2d(U_c, T_s);

t = 0:T_s:T_end;
N = length(t);

i_eq = zeros(1,N);
i_c = zeros(1,N);
u_c = zeros(1,N);
i_q = ones(1,N) * U_q/R;

F0 = 50;
%i_q = (sin(2*pi*F0*t) + 1/3*sin(2*pi*3*F0*t) + 1/5*sin(2*pi*5*F0*t) + 1/7*sin(2*pi*7*F0*t) + 1/9*sin(2*pi*9*F0*t)) * U_q/R;
i_q = zeros(1,N);
i_q(10:end) = 1;


K = 4;
% Gear 4th order
%a0 = 48/25;
%a1 = -36/25;
%a2 = 16/25;
%a3 = -3/25;
%bm1 = 12/25;
%b0 = 0;
%b1 = 0;
%b2 = 0;

%% Adams Moulton 4th order
a0 = 1;
a1 = 0;
a2 = 0;
a3 = 0;
bm1 = 9/24;
b0 = 19/24;
b1 = -5/24;
b2 = 1/24;

%% Trapezoidal
a0 = 1;
a1 = 0;
a2 = 0;
a3 = 0;
bm1 = 1/2;
b0 = 1/2;
b1 = 0;
b2 = 0;

% Backward Euler
%a0 = 1;
%a1 = 0;
%a2 = 0;
%a3 = 0;
%bm1 = 1;
%b0 = 0;
%b1 = 0;
%b2 = 0;

g_eq = C/(bm1*T_s);

Y = [1/R+g_eq];

an = [a0 a1 a2 a3]/bm1/T_s;
bn = [b0 b1 b2]/bm1;
N_a = length(an);
N_b = length(bn);
u_c_z = zeros(1,N_a);
i_c_z = zeros(1,N_b);

X = Y^-1;
tic
for k=1:N-1
  %i_eq(k) = -2*C/T_s * u_c(k) - i_c(k);
  %i_eq(k) = -1/bm1*(C/T_s*(a0*u_c(k) + a1*u_c(k-1) + a2*u_c(k-2) + a3*u_c(k-3)) + b0*i_c(k) + b1*i_c(k-1) + b2*i_c(k-2));
  
  i_eq = -(C*sum(an .* u_c_z) + sum(bn .* i_c_z));
  I = [i_q(k) - i_eq];
  
  u_c(k+1) = X*I;
  
  u_c_z = [u_c(k+1) u_c_z(1:end-1)];
  
  i_c(k+1) = g_eq * u_c(k+1) + i_eq;
  i_c_z = [i_c(k+1) i_c_z(1:end-1)];
end
toc

%step(U_cz, T_end);
%lsim(U_cz, i_q, t);
%lsim(U_c, i_q, t);
%hold on;
%plot(t, i_q*R, 'g.-');
plot(t, u_c,'r.-');
