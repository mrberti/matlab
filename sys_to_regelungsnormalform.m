% Buch: Regelungstechnik 1
% Seiten: 153 - 155

sys = ss(sys);

A = sys.A;
B = sys.B;
C = sys.C;
D = sys.D;

n = length(A);

Ss = zeros(size(A));

for i = 1:n
  Ss(:,i) = [A^(i-1)*B];
end

Ssi = inv(Ss);

srt = Ssi(end,:);

Tri = zeros(size(A));
for i = 1:n
  Tri(i,:) = srt*A^(i-1);
end
Tr = inv(Tri);

Ar = Tri*A*Tr;
Br = Tri*B;
Cr = C*Tr;
Dr = D;

sys_r = ss(Ar,Br,Cr,Dr)



