clear variables;
close all;
try
  more off;
  pkg load control;
end

%% Parameter
Ts = 10000e-9;
U_source = 10;
R_source = 1e-3;
Rs_L = 0.4;
L = 10e-6;


Gate_state1 = zeros(1,75);
Gate_state2 = Gate_state1;
Gate_state1([1:3]+2) = 0;
%Gate_state1([0:999]+200) = 0;

Gate_state2([1:3]+2) = 0;
%Gate_state2([0:90]+200) = 1;

Gate_state1 = dec2bin(Gate_state1,2);
Gate_state2 = dec2bin(Gate_state2,2);

Gate_L1 = str2num(Gate_state1(:,1));
Gate_H1 = str2num(Gate_state1(:,2));
Gate_L2 = str2num(Gate_state2(:,1));
Gate_H2 = str2num(Gate_state2(:,2));
N = length(Gate_state1);
%U_emf = ...
%[0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] * 0;
U_emf = zeros(1,N);

Tend = N*Ts-Ts;
t = 0:Ts:Tend;
U_L = zeros(1,N);
I_L = zeros(1,N);
I_source = I_L;

##stairs(t, I_L)
##hold on
##z = tf('z',Ts);
##Gz_L = 1/R_L * (1-a)*z^-1/(1-a*z^-1);
##s = tf('s');
##Gs_L = 1/R_L / (L/R_L*s+1);
##
##step(Gs_L, Gz_L);

I_L_z1 = 1;
U_L_z1 = 0;
I_L(1) = I_L_z1;

U_diff_z1 = 0;
U_diff_z2 = 0;
U_diff_z3 = 0;

I_L2_z1 = 0;
I_L2_z2 = 0;
I_L2_z3 = 0;

for i = 1:N  

  [U(:,i), I(:,i), R_out(:,i)] = calc_half_bridge(Gate_H1(i), Gate_L1(i), U_source, I_L_z1);
  U_a = U(2, i);
  U_b = 0;
  
##  [U(:,i), I(:,i), I_dc] = calc_h_bridge(Gate_H1(i), Gate_L1(i), Gate_H2(i), Gate_L2(i), U_source, R_source, I_L_z1, Rs_L);
##  U_a = U(2, i);
##  U_b = U(3, i);
  
  U_diff(i) = U_a - U_b;
  
  temp = U_diff(i) - U_diff_z1;
##  if abs(temp) >= U_source && Gate_state1(i) == '0'
##    %U_diff(i) = U_diff_z1 + 0.2 * sign(temp);
##    i
##  end
  
  %U_diff(i) = U_diff(i)*0.665241 + U_diff_z1 * 0.244728 + U_diff_z2 * 0.090031;
  %a3 = exp(-Ts/Ts/10);
  %U_diff(i) = U_diff(i)*(1-a3) + U_diff_z1 * a3;
  U_diff_z3 = U_diff_z2;
  U_diff_z2 = U_diff_z1;
  U_diff_z1 = U_diff(i);
  
  
  U_L(i) = U_diff(i) - U_emf(i);
  
  R_L = Rs_L;
  T_RL = L/R_L;
  a = 1+2*T_RL/Ts;
  b = 1-2*T_RL/Ts;
  %I_L(i+1) = 1/R_L / a * ( U_L(i) + U_L_z1 ) - b/a * I_L_z1;
  
  a2 = exp(-Ts/T_RL);
  I_L(i) = 1/R_L * U_L(i)*(1-a2) + I_L_z1 * a2;
##  if (sign(I_L(i+1)) != sign(I_L(i))) && abs(I_L(i)) > 0.000001
##    I_L(i+1) = 0;
##  end
  
##  I_L2(i+1) = I_L(i) * 0.665241 + I_L2_z1 * 0.244728 + I_L2_z2 * 0.090031;
##  I_L2_z3 = I_L2_z2;
##  I_L2_z2 = I_L2_z1;
##  I_L2_z1 = I_L2(i+1);
  
  %I_L(i+1) = I_L2(i+1) ;
  I_L_z1 = I_L(i);
  U_L_z1 = U_L(i);
  
end

##I_source = (I_q/G_q-U(1,:))*G_q;
##
##subplot(4,1,1);
##stairs(t,Gate_H1);
##hold on;
##stairs(t,Gate_L1);
##subplot(4,1,2);
##stairs(t,Gate_H2);
##hold on;
##stairs(t,Gate_L2);
##subplot(4,1,3);
##stairs(t,U_L');
##hold on;
##%stairs(t,U2');
##hold on;
##plot([0 Tend], [0 0], 'bk--');
##plot([0 Tend], [10 10], 'bk--');
##plot([0 Tend], [-10 -10], 'bk--');
##subplot(4,1,4);
##stairs(t,I_L(1:N))
##hold on;
##plot([0 Tend], [0 0], 'bk--');
##%stairs(t,I_source);

subplot(2,1,1);
stairs(t,U_L');
hold on;
%stairs(t,U2');
hold on;
plot([0 Tend], [0 0], 'bk--');
plot([0 Tend], [10 10], 'bk--');
plot([0 Tend], [-10 -10], 'bk--');
subplot(2,1,2);
stairs(t,I_L(1:N))
hold on;
plot([0 Tend], [0 0], 'bk--');
%stairs(t,I_source