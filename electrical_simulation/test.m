clear all;

pkg load control;

Ts = 0.1;

R = 1;
C = 0.5;

tau = R*C;

s = tf('s');
z = tf('z',Ts);

sz = 1/Ts*(z-1);

Gsz = 1/(tau*sz+1);

Gs = 1/(tau*s+1);

Gs_ss = ss(Gs);

N = 20;
t = (0:(N-1))*Ts;
h_z1 = 0;
u_z1 = 0;
u2_z1 = 0;
ui = ones(1,N);
u = zeros(1,N);
u2 = zeros(1,N);
h = zeros(1,N);

for i = 1:N-1
  u2(i+1) = 1/(Ts/2+R*C)*(-h_z1 - Ts/2 * u_z1 + ui(i));
  h(i+1) = h_z1 + (u2(i+1) + u2_z1) * Ts/2;
  h_z1 = h(i+1);
  u2_z1 = u2(i+1);
  u(i+1) = u_z1 + Ts/(tau+Ts) * (ui(i) - u_z1);
  u_z1 = u(i+1);
end

stairs(t,u, 'r');
hold on;
stairs(t,h, 'g');
step(Gs,Gsz);