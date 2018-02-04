%% 
% A small script to simulate QAM transmission on a AWGN channel
%
% Autor: Simon Bertling

clear variables;
close all;

try
  pkg load signal
end

%% TODO
% - Auswahl von Modulationsart
% - Decodierung von Daten
% - Filter optimieren
% - Quantisierung
% - Kanalimpulsantwort, Amplitudenmodulation
% - Scatterplot schöner machen
% - paar Bugs

disp(['----- QAM SIMULATION -----']);

%% User parameters
use_random_data = 1      % using randomized data?
max_data_value = 3         % Maximum data value
min_data_value = 0         % Minimum data value
data = [0 1 2 3]   	% Use this data for non-randomized case
if use_random_data
    N_data = 100;
else
    N_data = length(data)  % Data length
end
use_demod_filter = 0         % Use a demodulation filter
use_time_plots = 1         % Plot time vectors
use_channel_noise = 1    % simulate channel noise?
mu = 0              % channel parameter
sigma = .2        % sqrt(variance)
Fs = 1e6             % Sample rate
f_mod = 100e3       % modulation frequency
R_d_m = 2           % Datenperioden pro Modulationsperiode
% filters
use_impulse_filter = 0;
f_lp_impulse = f_mod / Fs;
N_lp_impulse = 10;
f_lp_demod = f_mod /Fs;
N_lp_demod = 10;

% Calculated parameters
T_sym = R_d_m/(f_mod);      % symbol time
T_end = T_sym*N_data;       % simulation time
Ts = 1/Fs;                  % sample time
N_t = floor(T_end/Ts);            % total sample count
N_samples_per_symbol = floor(N_t/N_data); % samples per symbol

%% START
disp(['----- start simulation -----']);
if use_random_data
    data = randi([min_data_value max_data_value],1,N_data);
end;

% Create time vector
t = 0:Ts:T_end-Ts;

% define modulation symbols
N_mod = 0:3;
d_qpsk = exp(1j*(2*pi/4 * N_mod + pi/4));
%d_qpsk = exp(1j*(2*pi/4 * N_mod));
d = d_qpsk;

%% impulse former
% h_t => continuous signal after impulse former
hc_impulse = fir1(N_lp_impulse,f_lp_impulse,'low');
h_t_raw = ones(1,N_t);
for n = 0:N_data-1
    indexes = (1:N_samples_per_symbol) + n*N_samples_per_symbol;
    h_t_raw(indexes) = d(data(n+1)+1);
end
h_t_filt = filter(hc_impulse,1,h_t_raw);

if use_impulse_filter
    h_t = h_t_filt;
    plot(real(h_t_raw)); hold on; plot(real(h_t_filt));
else
    h_t = h_t_raw;
end

%% calculate transmission signal
% s_t = transmitted signal
osc_mod = -exp(-1j*(2*pi*f_mod*t+pi));
s_analytical = h_t.*osc_mod;
s_t = real(s_analytical) + imag(s_analytical);

if use_time_plots
    hold on
    stairs(t, real(h_t), 'g--');
    stairs(t, imag(h_t), 'r--');
    plot(t, real(s_analytical), 'g');
    plot(t, imag(s_analytical), 'r');
    plot(t, s_t, 'bo-', "linewidth", 2);
    legend("RE(h_t)", "IM(h_t)", "RE(s_{analytical})", "IM(s_{analytical})", "s_t");
    hold off
end;

%figure;
%subplot(2,1,1);
%hold on;
%plot(t,real(osc),'o-');
%plot(t,imag(osc),'o-');
%subplot(2,1,2);
%hold on;
%plot(t,real(s_analytical));
%plot(t,imag(s_analytical));
%error "STOP"

%% AWGN Channel
% n_t => noise signal
% r_t => signal at receiver
n_t = mu + sigma.*randn(1,length(t));
if use_channel_noise
    r_t = s_t + n_t;
else 
    r_t = s_t;
end;

%% DEMODULATION
% s_d => demodulated signal
phi_demod = 0;
osc_demod = osc_mod.*exp(1j*(2*pi/360*phi_demod));
s_d = r_t.*osc_demod;

%% LOW PASS FILTER
hc_demod = fir1(N_lp_demod,f_lp_demod,'low');
h_r_filt = filter(hc_demod,1,s_d);

%figure;
%subplot(2,1,1);
%hold on;
%plot(t,real(osc_demod),'o-');
%plot(t,imag(osc_demod),'o-');
%subplot(2,1,2);
%hold on;
%plot(t,real(s_d));
%plot(t,imag(s_d));
%error "STOP"

%figure;
%subplot(2,1,1);
%plot(real(s_d));
%hold on;
%plot(imag(s_d));
%plot(r_t);
%subplot(2,1,2);
%plot(real(h_r_filt));
%hold on;
%plot(imag(h_r_filt));
%error "STOP"

%% DECISION

for n = 0:length(data)-1
    indexes = [1:N_samples_per_symbol] + n*N_samples_per_symbol;
    %e_t_n(n+1) = mean(h_t(indexes));
    %e_r_n(n+1) = mean(h_r_filt(indexes));
    k_sample = round(n*N_samples_per_symbol+N_samples_per_symbol/4*3)
    e_t_n(n+1) = h_t(k_sample);
    e_r_n(n+1) = h_r_filt(k_sample);
    t_e_r(n+1) = t(k_sample);
    
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


if use_time_plots
    figure;
    subplot(2,1,1);
    hold on
    plot(t, real(s_d), 'b');    
    plot(t, imag(s_d), 'r');
    plot(t, s_t, 'g');
    legend("RE(s_d)", "IM(s_d)");
    subplot(2,1,2);
    hold on;
    %stairs(t, real(h_t), 'b--', 'LineWidth', 1);
    %stairs(t, imag(h_t), 'r--', 'LineWidth', 1);
    plot(t, real(h_r_filt), 'b', 'LineWidth', 1);
    plot(t, imag(h_r_filt), 'r', 'LineWidth', 1);
    stem(t_e_r,real(e_r_n), 'b');
    stem(t_e_r,imag(e_r_n), 'r');
    hold off
end;

if use_time_plots
    figure;
    hold on
    plot(e_t_n, 'o');
    plot(e_r_n, 'o');
    hold off
end;



% DATEN SAMMELN

% SNR (KT Skript Seite 277)
n = 1;  % Informationsbits
m = 1;  % Codelänge
K = log2(length(d));   % Bits pro Modulationssymbol
alpha = 0;       % rolloff Faktor
c = 1;           % Filterparameter

E_b = sum(s_t.^2) / length(data); % Energie pro Bit
N_0 = sum(n_t.^2) / length(data); % Rauschleistungsdichte ???

SNR = E_b/N_0 * n/m * K/(1+alpha) * 1/c;
SNR_db = 10*log(SNR);

% Fehler z�hlen
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
