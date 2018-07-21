function mosfet
try
  pkg load control;
end

%% Parameter
Ts = 0.1e-3;

U_diode = 0.7;
R_diode_on = 1/19;
R_diode_off = 1e8;

R_ds_on = 1e-3;
R_ds_off = 1e8;

R_source = 1e-3;
U_source = 10;

R_L = 0.4;
L = 1e-3;

S = \
[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 1 1 1 1 1;
 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0];
N = length(S);
%Uemf = zeros(1,N);
Uemf = \
[0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] * 10;
U = [];
Y = [];
I = [];

Tend = N*Ts-Ts;
t = 0:Ts:Tend;
T_RL = L/R_L;
a = exp(-Ts/T_RL);
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

for i = 1:N
  %I_l = -1;
  I_l = I_L(i);

  G_q = 1/R_source;
  I_q = U_source * G_q;
  
  if S(1,i) == 1
    G_ds1 = 1/R_ds_on;
  else
    G_ds1 = 1/R_ds_off;
  end
  
  if S(2,i) == 1
    G_ds2 = 1/R_ds_on;
  else
    G_ds2 = 1/R_ds_off;
  end
  
  G_d1 = 1/R_diode_off;
  I_d1 = 0;
  G_d2 = 1/R_diode_off;
  I_d2 = 0;

  for j = 1:2
    Y = [ G_q + G_ds1 + G_d1, -G_ds1 - G_d1;
          -G_ds1 - G_d1, G_ds1 + G_d1 + G_ds2 + G_d2];
    X = inv(Y)
    I = [ I_q - I_d1;
          I_d1 - I_d2 - I_l ];

    U(:,i) = X * I;
    
    U_d1 = U(2,i) - U(1,i);
    U_d2 = 0 - U(2,i);
    if U_d1 >= U_diode
      G_d1 = 1/R_diode_on;
      I_d1 = U_diode/R_diode_on;
    end
    if U_d2 >= U_diode
      G_d2 = 1/R_diode_on;
      I_d2 = U_diode/R_diode_on;
    end
  end
  
  U_L(i) = U(2,i) - Uemf(i);
  I_L(i+1) = 1/R_L*(U_L(i)*(1-a)) + (I_L(i) * a);
end

I_source = (I_q/G_q-U(1,:))*G_q;

subplot(2,1,1);
stairs(t,U');
subplot(2,1,2);
stairs(t,I_L(1:N))
hold on;
stairs(t,I_source);
disp(U);
