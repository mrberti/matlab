% Buch: Regelungstechnik

% endwert sprungantwort
ks = -C*A^-1*B+D % page: 169

% relativer rang r
% page 156
r = 3;
C*A^(r-2)*B; % = 0
C*A^(r-1)*B; % != 0