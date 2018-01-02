% Autor: Simon Bertling
% Visualisierung von Quantisierungsrauschen
% 0 -> -1, 2^w-1 -> +1

clear all
close all

f_mod = 1;
R = 1000;
T_max = 1/f_mod;
t = [0:1/R:T_max-1/R];

w = 2;
K = 1/2;
% KT Skript S. 62
% 1/3 -> Gleichverteilung
% 1/2 -> Sinus
% 1/6 dreieckförmige Verteilung
% 1/24 Laplace Verteilungsdichte
% 1/300 .. 1/20 -> Sprache Messung

% s muss zwischen -1 .. 1 liegen
s = sin(2*pi*f_mod*t);
%s = 2*(t-0.5);
%s = 2*(rand(1,length(t))-0.5);
%s = rand(1, length(t)) + rand(1, length(t)) - 1;
%s = randn(1, length(t)); s = s / max(abs(s));

% Quantisieren
s = s * (2^w-1)/2 + (2^w-1)/2;
s_q = round(s);

% Fehlersignal
diff = s_q - s;

% Plotten
hold on
stairs(t, s);
stairs(t, s_q, 'r');
stairs(t, diff, 'g');
hold off
figure
hist(diff)

% SNR berechnen
maxi = max(s_q)
mini = min(s_q)

S = sum(s_q.^2) / length(diff)
S_t = K * maxi^2
N_q = sum(diff.^2) / length(diff)
N_q_t = ((maxi - mini) / 2^w)^2 / 12

SNR_schaetz = w * 6.02 + 10*log10(3*K) % KT Skript S. 60
SNR_mess = 10*log10(S/N_q)






