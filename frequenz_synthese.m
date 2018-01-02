clear all;
close all;

F = [25 75 125];
amp = [0.45 0 0.150 0.09];

% 
amp = [0.45 0.15 0.09 0.065 0.05 0.04]
F = (1:2:length(amp)*2) * 1e6;
a0 = 0.5;

% calculate fourier coefficients
x0 = F(1);
x1 = F(3);
y0 = amp(1);
y1 = amp(3);
% for rect pulse we have a/(x-b)
b_hyp = (y1*x1-y0*x0)/(y1-y0);
a_hyp = y0*(x0-b_hyp);

amp_calc_hyp = a_hyp./(F-b_hyp);

T0 = 1/min(F);
TS = 1/max(F)/20;

t = 0:TS:1*T0;
s = zeros(length(F),length(t));

for i = 1:length(F)
  s(i,:) = amp_calc_hyp(i) * sin(2*pi*F(i)*t);
end

figure;
plot(s');
hold on;
plot(sum(s),'.-');

figure;
stem(amp);
hold;
stem(amp_calc_hyp,'r');