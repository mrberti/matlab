pkg load control;

T_s = 1e-6;
T_f = 2;

x1 = exp(-T_s/T_f);
x2 = T_s/T_f;
a = [1-x1; x2];
b = [1 -x1; 1 -(1-x2)];
u = [1;1];

a = [1-x1];
b = [1 -x1];
u = [1];

N_steps = 200;
t = (0:1:N_steps-1)*T_s;

a = [0.99201  -0.98210];
b = [1.000000000  -0.980224868   0.000044948];
u = 1;

[n, d] = tfdata(Gz(1,1));
a = cell2mat(n);
b = cell2mat(d);
u = zeros(1,N_steps);
u(100:end) = 1;

u_z = [];
y_z = [];

y_k = [];
for k = 1:N_steps
  [y y_z u_z] = calc_next_step(u(k), a, b, u_z, y_z);
  y_k(:,k) = y;
end

%subplot(2,1,1);
stem(t, y_k', '-');
hold on;
%G = tf(a, b, T_s)
%Gs = d2c(G)
%step(G, N_steps, 'r');

%subplot(2,1,2);
%step(Gs, N_steps*T_s);