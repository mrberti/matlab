% Autor: Simon Bertling
% Simuliert die Demodulation mit einem �C mittels Integerarithmetik
%
% TODO:
% - QAM fixen
% - Korrelationsempf�nger

clear all;
close all;

format short;
pkg load signal;

disp('--- DEMODSIM ---');

N = 10;                             % Anzahl Daten
if N > 500
    %return
end;
QAM = 0;                            % QAM bentzen?
N_modn = 8;                         % Anzahl Modulationssymbole
N_max = 10;                         % Wenn N > N_max werden keine Zeitsignale geplottet
data = randi([0 N_modn-1], 1, N);    % Daten zuf�llig f�llen

Rs = 40000;                       % Samplerate des �C
f_mod = 400;                    % Modulationsfrequenz
T_max = length(data)/f_mod      % Simulationsdauer
R = 10*Rs;                       % Samplerate der Simulation
T = 1/R;

w = 2;      % Wortbreite des ADC
wm = ceil(log2(2^(2*w-1))); % Maximale Wortbreite
s_max = 1; % Maximaler messbarer Wert
sigma = 0;    % Standardabweichung St�rung


% Zeitvektoren
t = 0:T:T_max-T;
t_mess = downsample(t, R/Rs);

% Samples pro Periode
anz = floor(length(t)/length(data));   

% LUT definieren
explut = exp(-1j*2*pi*f_mod*t_mess);
explut = round(explut * (2^w-1)/2);


% Modulationssymbole definieren
if (QAM == 0)
    N_mod = 0:N_modn;
    d = exp(1j*(2*pi/N_modn)*N_mod);
    d_qpsk = exp(1j*(2*pi/4 * N_mod + pi/4));
    d_qpsk = exp(1j*(2*pi/4 * N_mod));
    d_8psk = exp(1j*(2*pi/8 * N_mod));
    d_16psk = exp(1j*(2*pi/16 * N_mod));
else
    v = 0:2/sqrt(2)/(sqrt(N_modn)-1):2/sqrt(2)
    d_qam = [];
    for n = 0:2/sqrt(2)/(sqrt(N_modn)-1):2/sqrt(2)
        d_qam = horzcat(d_qam,v+n*1j);
    end;
    d_qam = d_qam - 1/sqrt(2)*(1+1j);
    d = d_qam;
end;
dq = round(d * (2^(wm-2)));

% Impulsformer
e_t = ones(1,length(t));
for n = [0:length(data)-1]
    man = [1:anz] + n*anz;
    e_t(man) = d(data(n+1)+1);
end

% Sendesignal definieren
r = (randn(1, length(t))) * sigma;
s = e_t.*exp(1j*2*pi* f_mod * t);
s = real(s);
s = s + r;
% Clippen
for n = 1:length(s)
    if abs(s(n)) > s_max
        s(n) = s_max * sign(s(n));
    end;
end;

%%%% MIKROCONTROLLER EMPF�NGER %%%%

% Abtastung
s_mess = downsample(s, R/Rs);

% Quantisierung
s_quant = round(s_mess * (2^w-1)/2 + (2^w-1)/2);
s_quant_norm = (s_quant - ((2^w-1)/2))/ ((2^w-1)/2) ;

% Vorzeichen einbauen
s_quant = floor(s_quant - (2^w-1)/2);

% Ins Basisband
sd = s_quant .* explut;

%w_max = ceil(log2(2*max(abs(sd))));

% Demudolation
anz = floor(Rs/f_mod);
e_r = ones(1, length(data));
for n = [0:length(data)-1]
    interval = [1:anz] + n*anz;
    e_r(n+1) = sum(sd(interval));
    e_r(n+1) = floor(e_r(n+1)/anz);
    
    % dekodieren
    min = abs(e_r(n+1) - anz*dq(1));
    min_i = 1;
    for i = [2:length(d)]
        diff = abs(e_r(n+1) - anz*dq(i));
        if (diff < min)
            min = diff;
            min_i = i;
        end;
    end
    data_dec(n+1) = min_i - 1;
end

errors = sum(abs(data_dec-data));
BER = errors/N

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plotten
if length(data) <= N_max
    figure('Name','Abtastung');
    hold on
    plot(t,s);
    stem(t_mess, s_mess, 'r');
    stem(t_mess, s_quant_norm, 'g');
    hold off

    figure('Name','Quantisiertes Signal �C');
    hold on
    stairs(t_mess, s_quant);
    %stairs(t_mess, real(explut), 'r');
    %stairs(t_mess, imag(explut), 'g');
    hold off

    figure('Name','sd');
    hold on
    stem(t_mess, real(sd));
    stem(t_mess, imag(sd), 'g');
    hold off
end;

figure('Name','Scatter')
hold on
scatter(real(dq), imag(dq), 'r')
scatter(real(e_r), imag(e_r))
hold off

% figure('Name','FFT');
% hold on
% plot((abs(fftshift(fft(s_quant)))));
% hold off