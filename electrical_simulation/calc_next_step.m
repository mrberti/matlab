function [y y_z_out, u_z_out] = calc_next_step(u, a, b, u_z, y_z)

  N = size(b)(2);
  N_y = N - 1;
  N_u = N - size(a)(2);
  
  N_dim = size(a)(1);
  
  a = [zeros(N_dim, N_u) a];
  
  if N_u < 0 
    error('Length of b must be greater than or equal to a to make a causal system.')
  end
  
  if length(u_z) == 0
    u_z = zeros(N_dim, N);
  end
  
  if length(y_z) == 0
    y_z = zeros(N_dim, N_y);
  end
    
  b0 = b(:,1);
  
  a_n = a ./ b0;
  b_n = b(:,2:end) ./ b0;
  
  u_z_out = [u u_z(:,1:end-1)];
  
  y_A = a_n .* u_z_out;
  y_B = b_n .* y_z;
  
  y = sum(y_A, 2) - sum(y_B, 2);

  y_z_out = [y y_z(:, 1:end-1)];
end
