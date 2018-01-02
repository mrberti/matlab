clc;
clear all;
close all;

%% Simulation parameters
Mu = 5;                 % Select the Mu best individuals
Pressure = 100;
Lambda = Mu*Pressure;   % Size of Population
K = 5;

sigma_C = 1000;     % Standard deviation C
sigma_max = sigma_C;
sigma_min = .001;

paus = .000;

%% Starting parameters
C = 6;

Ck = [];
Lk = [];
Fk = [];

Tmax = abs(C);
dt = 2*Tmax/1000000;
t = -Tmax:dt:Tmax;
f = calculateFitness(t);

%% Create starting Population
P = linspace(-Tmax/1,Tmax/1, Lambda)';
x = calculateFitness(P);

clf;
%hold on;
plot(P',x,'o');
xlim([-Tmax Tmax]);
%pause(1);
clf;

tic();
for k = 1:K
    %% Evaluate current Population
    C = P(:,1);
    Fitness = calculateFitness(P);
    
    %% Determine parents
    [P Fk(k,:)] = select(P, Fitness, Mu);
    C = P(:,1);
    Ck(k,:) = C;
    
    clf;
    hold on;
   % plot(t,f,'w');
    %plot(Ck,Fk,'k.');
    plot(P,Fk(k,:),'r.');
    xlim([min(min(Ck)) max(max(Ck))]);
    ylim([min(min(Fk)) max(max(Fk))]);
    %plot(Ck(k,:),Fk(k,:),'o');
    
    pause(paus);
    
    %% Create child population
    P = repmat(P,Pressure,1);
    
    %% Mutate Population
    sigma_C = (sigma_min-sigma_max) * k/K + sigma_max;
    P = mutate(P, [sigma_C]);
end
toc();

min1 = min(min(Ck));
max1 = max(max(Ck));
dt = abs(min1-max1)/10000;
t = min1:dt:max1;
f = calculateFitness(t);

clf;
hold on;
k = length(Ck);
plot(t,f,'b');
plot(Ck,Fk,'k.');
F = calculateFitness(P);
P = select(P, F, 1);
F = calculateFitness(P);
plot(P, F, 'ro');

Best = [P F]
MaxFk = max(max(Fk))
diff = abs(MaxFk-F)/MaxFk
