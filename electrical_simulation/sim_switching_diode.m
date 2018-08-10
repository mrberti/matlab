clear variables;
pkg load control;

T_s = 1e-6;
T_end = 10e-3;

z = tf('z', T_s);
s = tf('s');

R_L = 1;
L = 1e-3;
C = 100e-9;

%% Parameters
U_diode = 0.71;%0.7;
R_diode_on = 1/19;
R_diode_off = 6e6;

G_R = 1/R_L;

%% Initialize diode parameters
% In the first step, the diodes are not conducting

G_d = 1/R_diode_on;
I_d = -U_diode*G_d;

%G_z = (I_d*((T_s^2+2*G_R*L*T_s)*z^2+2*T_s^2*z+T_s^2-2*G_R*L*T_s))/(((G_d+G_R)*T_s^2+(2*G_R*G_d*L+2*C)*T_s+4*C*G_R*L)*z^2+((2*G_d+2*G_R)*T_s^2-8*C*G_R*L)*z+(G_d+G_R)*T_s^2+(-2*G_R*G_d*L-2*C)*T_s+4*C*G_R*L)
%U1_s = (I_d*(G_R*L*s+1))/(C*G_R*L*s^2+(G_R*G_d*L+C)*s+G_d+G_R)
%U2_s = (G_R*I_d*L*s)/(C*G_R*L*s^2+(G_R*G_d*L+C)*s+G_d+G_R)
%step(U1_s, U2_s);

%U1_z = (I_d*((T_s^2+2*G_R*L*T_s)*z^2+2*T_s^2*z+T_s^2-2*G_R*L*T_s))/(((G_d+G_R)*T_s^2+(2*G_R*G_d*L+2*C)*T_s+4*C*G_R*L)*z^2+((2*G_d+2*G_R)*T_s^2-8*C*G_R*L)*z+(G_d+G_R)*T_s^2+(-2*G_R*G_d*L-2*C)*T_s+4*C*G_R*L)
%step(U1_s, U1_z)

N = round(T_end/T_s)
u = zeros(1,N);
u(1:end) = 1;
N = length(u);
t = (0:N-1)*T_s;

T_RL = L/R_L;
a = exp(-T_s/T_RL);

U_z1 = 0;
I_z1 = 0;

y_z = [1 0];
u_z = [];
%y_z = [];

for k = 1:N
  
  a = [I_d*T_s^2+G_R*I_d*L*T_s,-G_R*I_d*L*T_s,0];
  b = [(G_d+G_R)*T_s^2+(G_R*G_d*L+C)*T_s+C*G_R*L,(-G_R*G_d*L-C)*T_s-2*C*G_R*L,C*G_R*L];
  
  [y y_z u_z] = calc_next_step(1, a, b, u_z, y_z);
  y_k(k) = y;
  
  if y > -U_diode
    I_d = 0;
    G_d = 0;
  else
    G_d = 1/R_diode_on;
    I_d = -U_diode*G_d;
  end
end

stairs(t, y_k)