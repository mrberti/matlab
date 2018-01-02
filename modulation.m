% Autor: Simon Bertling
% Visualisierung der Modulation

clear all;
close all;

% TODO
% - Auswahl von Modulationsart
% - Decodierung von Daten
% - Filteroptimieren
% - Quantisierung
% - Kanalimpulsantwort, Amplitudenmodulation
% - Scatterplot schöner machen
% - paar Bugs

disp(['----- MODULATION SIMULATION -----']);

% BENUTZERPARAMETER
randomData = 1              % zufällige Daten?
    dataN = 5            % Anzahl Daten
    dataMax = 3
    dataMin = 0
    data = [0 1 2 3]   	% Daten bei nichtzufälligen Daten
filtern = 0                 % demodulationsfilter?
plotten = 1                 % Zeitfunktionen plotten?
channelNoise = 1            % störung im Kanal?
    mu = 0                 % Kanal parameter
    sigma = .2              % sqrt(varianz)
R = 1000000                  % Abtastrate
f_mod = 100000                % Modulationsfrequenz % Teiler von R ansonsten witzige Effekte
R_d_m = 2                   % Datenperioden pro Modulationsperiode

% START
disp(['----- Simulationsstart -----']);
if randomData
    data = randi([dataMin dataMax],1,dataN);
end;

T_sym = R_d_m/(f_mod);                  % Symboldauer
T_max = T_sym*length(data);         % Simulationszeit

deltaT = 1/R;
t = [0:deltaT:T_max-deltaT];

% Modulationssymbole definieren
N_mod = [0:3];
d_qpsk = exp(1j*(2*pi/4 * N_mod + pi/4));
%d_qpsk = exp(1j*(2*pi/4 * N));
d = d_qpsk;

% Impulsformer
e_t = ones(1,length(t));
anz = floor(length(t)/length(data));
for n = [0:length(data)-1]
    man = [1:anz] + n*anz;
    e_t(man) = d(data(n+1)+1);
end

% Sendesignal definieren
s = e_t.*exp(1j*2*pi* f_mod * t);
s_send = real(s);

if plotten
    hold on
    stairs(t, imag(e_t), '--g');
    stairs(t, s_send, 'r');
    stairs(t, real(e_t), 'b');
    hold off
end;

% KANAL
s_chan = s_send;

r = zeros(1,length(t));
if channelNoise
    r = mu + sigma.*randn(1,length(t));
    s_chan = s_chan + r;
end;

% DEMODULATION
s_rec = s_chan;

s_d = 2*s_rec.*exp(-1j*2*pi*f_mod*t);   % ins Basisband

if filtern
    Wn = [-10/R 10/R] + 2*f_mod/(2*pi*R)
    Wn = 0.631
    [b a] = butter(1, Wn, 'low');
    e_r_real = filter(b,a, real(s_d));
    e_r_imag = filter(b,a, imag(s_d));
else
    e_r_real = real(s_d);
    e_r_imag = imag(s_d);
end;

e_r = e_r_real + 1j*e_r_imag;

if plotten
    figure;
    hold on
    stairs(t, real(s_d), 'r');
    stairs(t, imag(s_d), 'y');
    stairs(t, real(e_t), 'b', 'LineWidth', 3);
    stairs(t, imag(e_t), '--g', 'LineWidth', 3);
    stairs(t, real(e_r), 'b', 'LineWidth', 1);
    stairs(t, imag(e_r), 'g', 'LineWidth', 1);
    hold off
end;

% ENTSCHEIDUNG

for n = [0:length(data)-1]
    interval = [1:anz] + n*anz;
    e_t_n(n+1) = mean(e_t(interval)); %mean(real(e_t(interval))) + 1j*mean(imag(e_t(interval)));
    e_r_n(n+1) = mean(e_r(interval));
    
    % dekodieren
    min = abs(e_r_n(n+1) - d(1));
    min_i = 1;
    for i = [2:length(d)]
        diff = abs(e_r_n(n+1) - d(i));
        if (diff < min)
            min = diff;
            min_i = i;
        end;
    end
    data_dec(n+1) = min_i - 1;
end

if plotten
    figure;
    hold on
    scatter(real(e_r_n), imag(e_r_n));
    scatter(real(e_t_n), imag(e_t_n));
    hold off
end;

% DATEN SAMMELN

% SNR (KT Skript Seite 277)
n = 1;  % Informationsbits
m = 1;  % Codelänge
K = log2(length(d));   % Bits pro Modulationssymbol
alpha = 0;       % rolloff Faktor
c = 1;           % Filterparameter

E_b = sum(s_send.^2) / length(data); % Energie pro Bit
N_0 = sum(r.^2) / length(data); % Rauschleistungsdichte ???

SNR = E_b/N_0 * n/m * K/(1+alpha) * 1/c;
SNR_db = 10*log(SNR);

% Fehler zählen
errors = sum(abs(data - data_dec));
BER = errors/length(data);

% Übertragunsrate
R_data = K/T_sym;

% Daten ausgeben
disp(['----- Simulationsende -----']);
disp(['Datenrate = ', num2str(R_data/1000), ' kBit/s']);
disp(['SNR = ', num2str(SNR_db), ' dB']);
disp(['Anzahl Fehler = ', num2str(errors)]);
disp(['BER = ', num2str(BER*100), '%']);






