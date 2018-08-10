clear all
pkg load control

T_s = 1e-6;

s = tf('s');
z = tf('z', T_s);

C = 1e-6;
L = 1e-3;
R_q = 1;
U_q = 1;
R_s = 1;

G = [(U_q*(L*R_q*s+R_q*R_s))/(R_q*(C*L*R_q*s^2+(C*R_q*R_s+L)*s+R_s+R_q));(L*U_q*s)/(C*L*R_q*s^2+(C*R_q*R_s+L)*s+R_s+R_q)];
G = minreal(G);
G_ss = ss(G);

[a, b, c, d] = ssdata(G_ss);

a_d = expm(a*T_s);
b_d = (a_d-eye(length(a_d))) / a * b;
c_d = c;
d_d = d;

%Gz = ...
%    [((R_s*T_s^2+L*T_s)*U_q*z^2-L*T_s*U_q*z)/(((R_s+R_q)*T_s^2+(C*R_q*R_s+L)*T_s+C*L*R_q)*z^2+((-C*R_q*R_s-L)*T_s-2*C*L*R_q)*z+C*L*R_q);
%    (L*T_s*U_q*z^2-L*T_s*U_q*z)/(((R_s+R_q)*T_s^2+(C*R_q*R_s+L)*T_s+C*L*R_q)*z^2+((-C*R_q*R_s-L)*T_s-2*C*L*R_q)*z+C*L*R_q)];

Gz = c2d(G, T_s);


%Gz_ss = ss(a_d, b_d, c_d, d_d, T_s);
%[num den] = tfdata(Gz_ss);

I_L = (C*U_q*s)/(C*L*s^2+C*R_q*s+1);

subplot(2,1,1);
step(G(1,1), 10e-3);

subplot(2,1,2);
step(Gz, 10e-3);