function [U, I, R_out] = calc_half_bridge(Gate_H, Gate_L, V_dc, I_L)
  %% Parameters
  U_diode = 0.7;
  R_diode_on = 1/19;
  R_diode_off = 1e8;

  R_ds_on = 10e-3;
  R_ds_off = 1e8;

  R_source = 1e-3;
  
  %% Prevent to drive loads when both gates off
  if (Gate_H == 0) && (Gate_L == 0) && (abs(I_L) < 1e-6)
    I_L = 0;
    U = [V_dc;0;0];
    I = [0; 0; V_dc];
    R_out = R_ds_off*2;
    return
  end
  
  %% Calculate parameters for admittance matrix
  G_q = 1/R_source;
  I_q = V_dc * G_q;
  
  %% Calculate gate resistances
  if Gate_H == 1
    G_ds_h = 1/R_ds_on;
  else
    G_ds_h = 1/R_ds_off;
  end
  
  if Gate_L == 1
    G_ds_l = 1/R_ds_on;
  else
    G_ds_l = 1/R_ds_off;
  end
  
  %% Initialize diode parameters
  % In the first step, the diodes are not conducting
  G_d_h = 1/R_diode_off;
  I_d_h = 0;
  G_d_l = 1/R_diode_off;
  I_d_l = 0;

  %% Calculate admittance matrix, voltages and currents
  for j = 1:2   
    Y = [ G_ds_h + G_d_h, -G_ds_h - G_d_h, 1;
          -G_ds_h - G_d_h, G_ds_h + G_d_h + G_ds_l + G_d_l, 0;
          1, 0, 0];
    I = [ - I_d_h;
          I_d_h - I_d_l - I_L;
          V_dc];
    
    X = inv(Y);
    U = X * I;
    
    % Check if the diodes should be conducting
    U_d_h = U(2) - U(1);
    if U_d_h >= U_diode
      G_d_h = 1/R_diode_on;
      I_d_h = U_diode/R_diode_on;
    end
    
    U_d_l = 0 - U(2);
    if U_d_l >= U_diode
      G_d_l = 1/R_diode_on;
      I_d_l = U_diode/R_diode_on;
    end
  end
  
  % Set output values
  R_out = X(2,2);
end