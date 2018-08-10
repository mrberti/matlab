clear variables;
pkg load control;

T_s = 20*100e-6;
T_end = 20e-3;

s = tf('s');
z = tf('z', T_s);

U_q = 1;
C = 1e-6;
R = 1000;

U_c = 1/(R*C*s+1);
U_cz = c2d(U_c, T_s);

t = 0:T_s:T_end;
N = length(t);

i_eq = zeros(1,N);
i_c = zeros(1,N);
u_c = zeros(1,N);
i_q = ones(1,N) * U_q/R;

F0 = 100;
i_q = sin(2*pi*F0*t);

K = 4;
% Gear 4th order
a0 = 48/25;
a1 = -36/25;
a2 = 16/25;
a3 = -3/25;
bm1 = 12/25;
b0 = 0;
b1 = 0;
b2 = 0;

% Adams Moulton 4th order
a0 = 1;
a1 = 0;
a2 = 0;
a3 = 0;
bm1 = 9/24;
b0 = 19/24;
b1 = -5/24;
b2 = 1/24;

% Trapezoidal
a0 = 1;
a1 = 0;
a2 = 0;
a3 = 0;
bm1 = 1/2;
b0 = 1/2;
b1 = 0;
b2 = 0;

% Backward Euler
##a0 = 1;
##a1 = 0;
##a2 = 0;
##a3 = 0;
##bm1 = 1;
##b0 = 0;
##b1 = 0;
##b2 = 0;

g_eq = C/(bm1*T_s);

Y = [1/R+g_eq];
for k=K:N-1
  X = Y^-1;
  
  %i_eq(k) = -2*C/T_s * u_c(k) - i_c(k);
  i_eq(k) = -1/bm1*(C/T_s*(a0*u_c(k) + a1*u_c(k-1) + a2*u_c(k-2) + a3*u_c(k-3)) + b0*i_c(k) + b1*i_c(k - 1) + b2*i_c(k - 2));
  I = [i_q(k) - i_eq(k)];
  
  u_c(k+1) = X*I;
  
  i_c(k+1) = g_eq * u_c(k+1) + i_eq(k);
end

step(U_cz, T_end);
hold on;  
plot(t(1:(end-K+1)), u_c((K):end),'o-');
