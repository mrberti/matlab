pkg load control;

T_s = 100e-9;

s = tf('s');
z = tf('z', T_s);
%s = 2*(z-1)/(T_s*(z+1));

L = 1e-6;
C = 1e-6;
R_q = 1;
R_s = 1;

U_q = 1;
V_C0 = 1;
I_L0 = 1;

U_q = 0;
U_C_init = (C*L*R_q*V_C0*s^2+(C*R_q*R_s*V_C0+L*U_q-I_L0*L*R_q)*s+R_s*U_q)/(C*L*R_q*s^2+(C*R_q*R_s+L)*s+R_s+R_q);
U_L_init = ((C*L*R_q*V_C0-C*I_L0*L*R_q*R_s)*s^2+(L*U_q-I_L0*L*R_s-I_L0*L*R_q)*s)/(C*L*R_q*s^2+(C*R_q*R_s+L)*s+R_s+R_q);

U_q = 1;
V_C0 = 0;
I_L0 = 0;
U_C = (C*L*R_q*V_C0*s^2+(C*R_q*R_s*V_C0+L*U_q-I_L0*L*R_q)*s+R_s*U_q)/(C*L*R_q*s^2+(C*R_q*R_s+L)*s+R_s+R_q);
U_L = ((C*L*R_q*V_C0-C*I_L0*L*R_q*R_s)*s^2+(L*U_q-I_L0*L*R_s-I_L0*L*R_q)*s)/(C*L*R_q*s^2+(C*R_q*R_s+L)*s+R_s+R_q);

I_L = U_L/(s*L) + I_L0;
I_C = U_C*(s*C);

subplot(2,1,1);
step(U_C, U_L);

subplot(2,1,2);
step(U_C_init, U_L_init);
%step(I_C);


%step(Uss, 100e-6);
##
##Pi = eye(2)*sqrt(C*L);
##P = inv(Pi);
##
##a2 = P*a*Pi;
##b2 = P*b;
##c2 = c*Pi;
##d2 = d;
##
##Uss2 = ss(a2, b2, c2, d2);

##Qb = [c; c*a];
##
##qb = inv(Qb)*[0;1];
##
##Pbi = [qb a*qb];
##Pb = inv(Pbi);
##
##ab = Pb*a*Pbi
##bb = Pb*b
##cb = c*Pbi
##
##ab = a';
##bb = c';
##cb = b';
##
##Ussb = ss(ab, bb, cb, d);

U_Cz = (((C*R_q*R_s*T_s^2+C*L*R_q*T_s)*V_C0+(R_s*T_s^2+L*T_s)*U_q-I_L0*L*R_q*T_s^2)*z^2+(-C*L*R_q*T_s*V_C0-L*T_s*U_q)*z)/(((R_s+R_q)*T_s^2+(C*R_q*R_s+L)*T_s+C*L*R_q)*z^2+((-C*R_q*R_s-L)*T_s-2*C*L*R_q)*z+C*L*R_q);