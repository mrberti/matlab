% Buch: Regelungstechnik 1
% Seite: 160
pkg load control
eq_0 = 1e-10;

G = zpk([1+1i 1-1i],[-1+1i -1-1i -3 -10 -15],1);
%sys = zpk([1],[-1 -2],1);
G = ss(G);

A = G.A;
B = G.B;
C = G.C;
D = G.D;

A(abs(A)<eq_0) = 0;
B(abs(B)<eq_0) = 0;
C(abs(C)<eq_0) = 0;
D(abs(D)<eq_0) = 0;

n = length(A);
% calculate rank of system
r = 0;
a = zeros(1,n);
for i = 1:n
  a(i) = C*A^(i-1)*B;
  if abs(a(i)) < eq_0
    a(i) = 0;
    r = r+1;
  end
end
r = min(n,r+1);
if(D == 1)
  r = 0;
end
q = n-r;

% calculate transformation into regelungsnormalform
Ss = zeros(size(A));
for i = 1:n
  Ss(:,i) = [A^(i-1)*B];
end
Ssi = inv(Ss);
srt = Ssi(end,:);

% calculate transformation for EA normalform
Tei = zeros(size(A));
for i = 1:r
  Tei(i,:) = C*A^(i-1);
end
for i = 1:n-r
  Tei(i+r,:) = srt*A^(i-1);
end
Te = inv(Tei);

% execute transformation
Ae = Tei*A*Te;
Be = Tei*B;
Ce = C*Te;
De = D;

Ae(abs(Ae)<eq_0) = 0;
Be(abs(Be)<eq_0) = 0;
Ce(abs(Ce)<eq_0) = 0;
De(abs(De)<eq_0) = 0;

AII = Ae(1:r,1:r);
AIN = Ae(1:r,r+1:end);
ANI = Ae(r+1:end,1:r);
ANN = Ae(r+1:end,r+1:end);
BI = Be(1:r);
CI = Ce(1:r);

Ge = ss(Ae,Be,Ce,De);
GI = ss(AII,BI,CI,0);
%GN = ss(ANN,0,0,D);