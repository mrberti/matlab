function [U, I, I_dc] = calc_h_bridge(Gate_H1, Gate_L1, Gate_H2, Gate_L2, V_dc, R_dc, I_L, R_L)
  %% Parameters
  U_diode = 0.71;%0.7;
  R_diode_on = 0.032;%1/19;
  R_diode_off = 6e6;

  R_ds_on = 10e-3;
  R_ds_off = 5.5710e+011;
  
  G_L = 1/R_L;
  
  G_x = 0;1/1e3;
  
  %% Prevent to drive loads when both gates off
  if (((Gate_H1 == 0) && (Gate_L1 == 0)) || ((Gate_H2 == 0) && (Gate_L2 == 0))) && (abs(I_L) < 1e-6)
    U = [V_dc;V_dc/2;V_dc/2;V_dc/2];
    I = [0;0;0;0];
    I_dc = 0;
    return
  end
  
  %% Calculate parameters for admittance matrix
  G_q = 1/R_dc;
  I_q = V_dc * G_q;
  
  %% Calculate gate resistances
  if Gate_H1 == 1
    G_ds_h1 = 1/R_ds_on;
  else
    G_ds_h1 = 1/R_ds_off;
  end
  if Gate_H2 == 1
    G_ds_h2 = 1/R_ds_on;
  else
    G_ds_h2 = 1/R_ds_off;
  end
  
  if Gate_L1 == 1
    G_ds_l1 = 1/R_ds_on;
  else
    G_ds_l1 = 1/R_ds_off;
  end
  if Gate_L2 == 1
    G_ds_l2 = 1/R_ds_on;
  else
    G_ds_l2 = 1/R_ds_off;
  end
  
  %% Initialize diode parameters
  % In the first step, the diodes are not conducting
  G_d_h1 = 1/R_diode_off;
  I_d_h1 = 0;
  G_d_l1 = 1/R_diode_off;
  I_d_l1 = 0;
  G_d_h2 = 1/R_diode_off;
  I_d_h2 = 0;
  G_d_l2 = 1/R_diode_off;
  I_d_l2 = 0;

  %% Calculate admittance matrix, voltages and currents
  for j = 1:2
##    Y = [ G_q + G_ds_h1 + G_d_h1 + G_ds_h2 + G_d_h2, -G_ds_h1 - G_d_h1, -G_ds_h2 - G_d_h2;
##          -G_ds_h1 - G_d_h1, G_ds_h1 + G_d_h1 + G_ds_l1 + G_d_l1 + G_L, -G_L;
##          -G_ds_h2 - G_d_h2, -G_L, G_ds_h2 + G_d_h2 + G_ds_l2 + G_d_l2 + G_L];
##    I = [ I_q - I_d_h1 - I_d_h2;
##          I_d_h1 - I_d_l1 - I_L;
##          I_d_h2 - I_d_l2 + I_L];
    Y = [ G_q + G_ds_h1 + G_d_h1 + G_ds_h2 + G_d_h2, -G_ds_h1 - G_d_h1, -G_ds_h2 - G_d_h2, 0;
          -G_ds_h1 - G_d_h1, G_ds_h1 + G_d_h1 + G_ds_l1 + G_d_l1 + G_x, 0, -G_x;
          -G_ds_h2 - G_d_h2, 0, G_ds_h2 + G_d_h2 + G_ds_l2 + G_d_l2 + G_L, -G_L;
          0, -G_x, -G_L, G_L + G_x];
    I = [ I_q - I_d_h1 - I_d_h2;
          I_d_h1 - I_d_l1 - I_L;
          I_d_h2 - I_d_l2;
          I_L];
    
    X = inv(Y);
    U = X * I;
    
    % Check if the diodes should be conducting
    U_d_h1 = U(2) - U(1);
    if U_d_h1 >= U_diode
      G_d_h1 = 1/R_diode_on;
      I_d_h1 = U_diode/R_diode_on;
    end
    U_d_h2 = U(3) - U(1);
    if U_d_h2 >= U_diode
      G_d_h2 = 1/R_diode_on;
      I_d_h2 = U_diode/R_diode_on;
    end
    
    U_d_l1 = 0 - U(2);
    if U_d_l1 >= U_diode
      G_d_l1 = 1/R_diode_on;
      I_d_l1 = U_diode/R_diode_on;
    end
    U_d_l2 = 0 - U(3);
    if U_d_l2 >= U_diode
      G_d_l2 = 1/R_diode_on;
      I_d_l2 = U_diode/R_diode_on;
    end
  end
  
  I_dc = U(1)*G_q-I_q;
end