clear variables;
pkg load symbolic;

syms G_q G_R C L I_q s z sz T_s;

Y = [G_q + G_R + s*C, -G_R; -G_R, G_R+1/(s*L)];
I = [I_q;0];
X = factor(Y**-1, s);
U = X*I;

[d, n] = numden(X(1));
G = 1/n;

a = coeffs(n,s);
a = a/(a(1));
a = a(end:-1:2);

N = length(a);

e = eye(N-1);
z = zeros(N-1,1);
x = [z e];

A = [x;-a]';
B = zeros(N,1);
B(end) = 1;

XC = U*n;

C = []
for k = 1:N
  c = coeffs(XC(k), s);
  c = c/(a(1));
  c = c(end:-1:1);
  if length(C) == 0
    C = [c]
  else
    C = [C, c]
  end
end

C