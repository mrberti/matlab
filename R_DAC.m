clear all;
close all;

R0 = 75;
U0 = 3.3;
Rp = [500 1000 2000 4000 ];

bits = length(Rp);

x = 0:2^bits-1;
A = dec2bin(x,bits);

for i=1:bits
  B(:,i) = str2num(A(:,i));
end

Rb = B .* Rp;

for i = 1:2^bits
  y = Rb(i,:);
  Rs(i) = 1./sum(1./y(y>0));
end

V = U0*R0./(R0 + Rs);

[V_sort index_sort] = sort(V);

plot(x,Rs);
figure;
stairs(x,V);