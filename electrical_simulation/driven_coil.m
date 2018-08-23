clear variables;
more on;

T_s = 10e-9;
N_sim = 1000;
t = (0:N_sim-1)*T_s;

V_q = 30;
R_q = 1e-3;

R_s = 2;
L   = 100e-6;

C_q = 10e-6;
C_1 = 1e-9;
C_2 = 1e-9;

R_diode_on  = 1/1.64;
R_diode_off = 100e6;
V_diode_on  = 0.8;

R_DS_on  = 10e-3;
R_DS_off = 100e6;
I_diode_on = V_diode_on / R_diode_on;
I_diode_off = 0;

G_D1_on = 1/R_diode_on;
G_D2_on = 1/R_diode_on;
I_D1_on = I_diode_on;
I_D2_on = I_diode_on;
G_DS_on = 1/R_DS_on;

G_D1_off = 1/R_diode_off;
G_D2_off = 1/R_diode_off;
G_DS_off = 1/R_DS_off;

G_q = 1/R_q;
I_q = V_q * G_q;
G_s = 1/R_s;

i_q = I_q * ones(1,N_sim);
i_q(1:10) = 0;

G_DS = G_DS_off;
G_D1 = G_D1_off;
G_D2 = G_D2_off;
I_D1 = I_diode_off;
I_D2 = I_diode_off;

% Gear 4th order
a0 = 48/25;
a1 = -36/25;
a2 = 16/25;
a3 = -3/25;
bm1 = 12/25;
b0 = 0;
b1 = 0;
b2 = 0;
an = [a0 a1 a2 a3]/bm1/T_s;
bn = 0/bm1;

%% Adams Moulton 4th order
%a0 = 1;
%a1 = 0;
%a2 = 0;
%a3 = 0;
%bm1 = 9/24;
%b0 = 19/24;
%b1 = -5/24;
%b2 = 1/24;
%an = a0/bm1/T_s;
%bn = [b0 b1 b2]/bm1;

%% Trapezoidal
a0 = 1;
bm1 = 1/2;
b0 = 1/2;
an = a0/bm1/T_s;
bn = b0/bm1;

% Backward Euler
%a0 = 1;
%bm1 = 1;
%an = a0/bm1/T_s;
%bn = 0;

N_a = length(an);
N_b = length(bn);

g_Cq_eq = C_q/(T_s*bm1);
g_C1_eq = C_1/(T_s*bm1);
g_C2_eq = C_1/(T_s*bm1);
r_L_eq = L/(T_s*bm1);

I_Cq_eq = 0;
I_C1_eq = 0;
I_C2_eq = 0;
V_L_eq = 0;

V_Cq_z = zeros(1, N_a);
V_C1_z = zeros(1, N_a);
V_C2_z = zeros(1, N_a);
I_L_z  = zeros(1, N_a);

I_Cq_z = zeros(1, N_b);
I_C1_z = zeros(1, N_b);
I_C2_z = zeros(1, N_b);
V_L_z  = zeros(1, N_b);

D1_state = zeros(1,N_sim);
D2_state = zeros(1,N_sim);

V = zeros(N_sim,4);
tic
for k = 1:N_sim

  %% Get input states
  if k*T_s > 7e-6
    G_DS = G_DS_on;
  end
  if k*T_s > 10e-6
    G_DS = G_DS_off;
  end
  
  if k*T_s < 1e-6
    i_q(k) = 0;
  end
  if k*T_s > 11e-6
    i_q(k) = 12 * G_q;
  end
  
%  if k*T_s > 13e-6
%    G_DS = G_DS_on;
%  end
%  
%  if k*T_s > 15e-6
%    G_DS = G_DS_off;
%  end

  %% Calculate substitute sources for storage components
  I_Cq_eq = -(C_q*sum(an .* V_Cq_z) + sum(bn .* I_Cq_z));
  I_C1_eq = -(C_1*sum(an .* V_C1_z) + sum(bn .* I_C1_z));
  I_C2_eq = -(C_2*sum(an .* V_C2_z) + sum(bn .* I_C2_z));
  V_L_eq = -(L*sum(an .* I_L_z) + sum(bn .* V_L_z));

  %% Solve state matrix and calculate voltage vector
  % 2 tries to check for diode states
  for tries = 1:2
    Y = [G_q + g_Cq_eq + G_s + g_C1_eq + G_D1, -G_s, -g_C1_eq - G_D1                                   , 0;
         -G_s                                , G_s , 0                                                 , 1;
         -g_C1_eq - G_D1                     , 0   , 1/r_L_eq + g_C1_eq + G_D1 + g_C2_eq + G_D2 + G_DS , -1;
         0                                   , 1   , -1                                                , -r_L_eq];

    X = inv(Y);

    I = [i_q(k) - I_Cq_eq - I_C1_eq - I_D1;
         0;
         I_C1_eq + I_D1 - I_C2_eq - I_D2;
         V_L_eq];
         
    V(k,:) = X*I; % [V1;V2;V3;I_L]
    
    %% Check diode states
    V_D1(k) = V(k,3) - V(k,1);
    V_D2(k) = 0 - V(k,3);
    
    if V_D1(k) > V_diode_on
      D1_state(k) = 1;
      G_D1 = G_D1_on;
      I_D1 = I_D1_on;
    else
      G_D1 = G_D1_off;
      I_D1 = 0;
    end
    
    if V_D2(k) > V_diode_on
      D2_state(k) = 1;
      G_D2 = G_D2_on;
      I_D2 = I_D2_on;
    else
      G_D2 = G_D2_off;
      I_D2 = 0;
    end
  end
  
  %% Get voltages
  V_1 = V(k,1);
  V_2 = V(k,2);
  V_3 = V(k,3);
  I_L = V(k,4);
  
  V_Cq = V_1 - 0;
  V_C1 = V_1 - V_3;
  V_C2 = V_3 - 0;
  
  V_Cq_z = [V_Cq V_Cq_z(1:end-1)];
  V_C1_z = [V_C1 V_C1_z(1:end-1)];
  V_C2_z = [V_C2 V_C2_z(1:end-1)];
  I_L_z  = [I_L  I_L_z(1:end-1)];
  
  %% Calculate storage elements
  I_Cq = g_Cq_eq * V_Cq + I_Cq_eq;
  I_Cq_z = [I_Cq I_Cq_z(1:end-1)];
  
  I_C1 = g_C1_eq * V_C1 + I_C1_eq;
  I_C1_z = [I_C1 I_C1_z(1:end-1)];
  
  I_C2 = g_C2_eq * V_C2 + I_C2_eq;
  I_C2_z = [I_C2 I_C2_z(1:end-1)];
  
  V_L = r_L_eq * I_L + V_L_eq;
  V_L_z = [V_L V_L(1:end-1)];
  
end
toc

subplot(3,1,1);
plot(t, V(:,1:3),'-');

subplot(3,1,2);
plot(t, V(:,4),'-');

subplot(3,1,3);
plot(t, D1_state, t, D2_state);
