clear variables;
pkg load control;

s = tf('s');

R = 1;
C = 1;
T_s = .5;

N = 30;

UC = 1/(R*C*s+1);

ue = ones(1,N);
uc_fw = zeros(1,N);
uc_bw = uc_fw;
uc_tr = uc_fw;

t = (0:N-1)*T_s;

for k = 1:N-1
  uc_fw(k+1) = uc_fw(k) + T_s/(R*C)*(ue(k)-uc_fw(k));
  uc_bw(k+1) = 1/(1+T_s/(R*C))*(uc_bw(k) + T_s/(R*C)*ue(k));
  uc_tr(k+1) = 1/(1+T_s/(2*R*C))*(uc_bw(k) + T_s/(2*R*C)*(2*ue(k)-uc_bw(k)));
endfor

stairs(t, uc_fw);
hold on;
%stairs(t, uc_bw);
stairs(t, uc_tr);
step(UC, max(t));