clc;
clear all;
close all;

%% Simulation parameters
Ndim = 2;
paus = .000;            % Pause
Mu = 3;                 % Select the Mu best individuals
Pressure = 10;
Lambda = Mu*Pressure;   % Size of Population
K = 500;                  % Simulation length

sigma_max = 100;
sigma_min = .00000;


%% Starting parameters
startscale = linspace(-1000,1000,Ndim);

%% Create starting Population
P = linspace(-1,1, Lambda)';
P = repmat(P,1,Ndim) .* repmat(startscale,Lambda,1);

[x y]= meshgrid(-100:1:100, -100:1:100);
fitness =  3*(1-x).^2.*exp(-(x.^2) - (y+1).^2) ... 
   - 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2) ... 
   - 1/3*exp(-(x+1).^2 - y.^2);
fitness =  exp(-((x+5).^2/30 + (y-7).^2/30)) + 2*exp(-((x+50).^2/100 + (y-70).^2/100));
surf(x,y,fitness);

tic();
for k = 1:K
    %% Evaluate current Population
    Fitness = calcFitMulti(P);
    
    %% Determine parents
    [P Fk] = select(P, Fitness, Mu);
    
    pause(paus);
    
    %% Create child population
    % Simply clone the surviving Population
    P = repmat(P,Pressure,1);
    
    %% Mutate Population
    sigma_C = (sigma_min-sigma_max) * k/K + sigma_max;
    sigma_C = repmat(sigma_C, 1, Ndim);
    P = mutate(P, [sigma_C]);
end
toc();

[P Fk] = select(P, calcFitMulti(P), 1)
