% Autor: Simon Bertling
% 

clear all
close all

disp('Resampling');
Rd = 100;
R = 10*Rd;
Nd = 10;
data = randi([-5 5], 1, Nd);
td = [0 :1/Rd : Nd/Rd - 1/Rd];
t = [0 : 1/R : Nd/Rd - 1/R];

figure('Name','Data');
stem(td, data);

tau = 3;
for n = [1:ceil(R/Rd)]
    filt(n) = exp(-n/tau);
end;

a = 1;
b = filt;
b = b/sum(b);

%b = 1;
%a = [1 -1/tau*exp(-1/tau)];

s = upfirdn(data, ones(1,ceil(R/Rd)), ceil(R/Rd));
fs = filter(b, a, s);

figure('Name','Resampling');
hold on
plot(t,s, 'y');
plot(t,fs);
hold off

