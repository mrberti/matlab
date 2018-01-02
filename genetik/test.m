clc;
clear all;
close all;

dC = 1e-9;
C = 107e-9:dC:170e-9;

N = length(C);

f = 100e3;
omega = 2*pi*f;
Ue = 1;

R = 1;
L = 20e-6;

P = [ones(N,1) * R, ones(N,1) * L, C'];

R = P(:,1);
L = P(:,2);
C = P(:,3);

1./(j*omega*C);

Z = 1./(j*omega*C) + j*omega*L + R;

I = Ue ./ Z;
Ua = Ue * R ./ Z;

P = abs(I).*abs(Ua)
stem(C,P)

