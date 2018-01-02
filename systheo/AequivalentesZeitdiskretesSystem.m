function [ A, B, C ] = AequivalentesZeitdiskretesSystem( F, G, H )
%AEQUIVALENTESZEITDISKRETESSYSTEM Summary of this function goes here
%   Detailed explanation goes here

C = H;

s = sym('s');
T = sym('T');
xi = sym('xi');

Psi_s = (eye(sqrt(numel(F)))*s-F)^(-1);

Psi_xi = ilaplace(Psi_s, xi);

B = int(Psi_xi*G, xi, 0, T);
A = subs(Psi_xi, T);

end
