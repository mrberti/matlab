function [ A_RNF B_RNF C_RNF ] = ZuRNF( A, B, C )
% Berechnet die Regelungsnormalform zu den Matrizen A, B, C
% Nach dem Systhemtheorie 2 Skript S. 93ff
% Autor: Simon Bertling

x = sym('x');
[N M] = size(A);
an = coeffs(poly(A),x); % Berechne Koeffizienten des Char. Polynoms
an = an(1:N); % Letzten Eintrag wegschmeiﬂen (=1)

% A_RNF erzeugen
A_RNF = eye(N-1);
A_RNF = cat(2,zeros(N-1,1),A_RNF);
A_RNF = cat(1,A_RNF, an);

%a = sym('a', [1 N]) % testzwecke

% Ax erzeugen (S = Qs * Ax)
a = an(2:N);
a = cat(2, a, 1);
Ax = a;
for n = 1:(N-1)
   Ax = cat(1,circshift(a, [1 -n]), Ax);
end
Ax = tril(Ax);

% Qs erzeugen (A^nB ... A(AB) AB B)
Qs = B;
AB = A * B;
for n = 1:(N-1)
    Qs = cat(2,Qs,AB);
    AB = A * AB;
end

S = Qs*Ax;

B_RNF = S^(-1)*B;
C_RNF = C*S;

A_RNF = simplify(A_RNF);
B_RNF = simplify(B_RNF);
C_RNF = simplify(C_RNF);

end

