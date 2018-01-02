pkg load control

R = 200;
C = 470e-9;
L = 100e-3;

Fmitte = 55;
wmitte = 2*pi*Fmitte;

C = 1/(L*wmitte^2)

a = [L*C R*C 1];
b_C = [1];
b_L = [L*C 0 0];
b_R = [R*C 0];
b_LC = [L*C 0 1];
b_RL = [L*C R*C 0];

G_C = tf(b_C,a);
G_L = tf(b_L,a);
G_R = tf(b_R,a);
G_LC = tf(b_LC,a);
G_RL = tf(b_RL,a);

D = R/2 * sqrt(C/L);
w0 = 1/sqrt(L*C);

bode(G_R,G_C);