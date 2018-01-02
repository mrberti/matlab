clc;
clear all;
close all;

%% Simulation parameters
N = 10;             % Size of population

f = 100e3;          % Frequency
omega = 2*pi*f;
Ue = 1;             % Input Voltage

sigma_R = 0;     % Standard deviation R
sigma_L = 0;     % Standard deviation L
sigma_C = 1e-9;     % Standard deviation C

%% Starting parameters
R = 1;
L = 20e-6;
C = 100e-9;

Ck = [];
Lk = [];
Fk = [];

%% Create starting Population 
P = [ones(N,1) * R, ones(N,1) * L, ones(N,1) * C];

tic();
for k = 1:50
    %% Evaluate current Population
    R = P(:,1);
    L = P(:,2);
    C = P(:,3);
    Z = 1./(j*omega*C) + j*omega*L + R;
    I = Ue ./ Z;
    Ua = Ue * R ./ Z;

    Fitness = abs(I).*abs(Ua);
    
    %% Determine parents
    index = find(Fitness == max(Fitness));
    Fmaxindex(k) = index(1);
    Fk(k) = Fitness(Fmaxindex(k));
    R = P(Fmaxindex(k),1);
    L = P(Fmaxindex(k),2);
    C = P(Fmaxindex(k),3);
    
    %% Create child population
    P = [ones(N,1) * R, ones(N,1) * L, ones(N,1) * C];
    Ck(k) = C;
    Lk(k) = L;
    
    %% Mutate Population
    noise_R = [sigma_R * randn(N,1)];
    noise_L = [sigma_L * randn(N,1)];
    noise_C = [sigma_C * randn(N,1)];
    noise = [noise_R noise_L noise_C];
    P = P + noise;
end
toc();

R
L
C
hold on;
plot(Fk);

