clear all;
close all;
clc;

N = 2000;
H = [1;.51;.21];

[m n] = size(H)

Fs = 44100;
dt = 1/Fs;
Tmax = N*dt;
t = 0:dt:Tmax-dt;

sigma_n = sqrt(1);
mu_theta = 10;
sigma_theta = sqrt(10);

Nb = 100;
b = ones(1,Nb) / Nb;
a = 1;

theta = sigma_theta * randn(n,N) + mu_theta;
theta = filter(b,a,theta);

noise = sigma_n * randn(m,N);

z = H * theta + noise;

Rn = cov(noise')
Rt = cov(theta')

for k = 1:N
    theta_hat_ML(k) = (H'*Rn^-1*H)^-1 * H'*Rn^-1*z(:,k);
    theta_hat_MAP(k) = ((H'*Rn^-1*H + Rt^-1)^-1) * (H'*Rn^-1*(z(:,k) - H*mu_theta)) + mu_theta;
end

figure;
hold on;
%plot(theta);
plot(t,z','b.');
plot(t,theta_hat_ML, 'r','LineWidth',2);
plot(t,theta_hat_MAP, 'g','LineWidth',2);
plot(t,theta,'LineWidth',2);

legend('\theta','\theta_{ML}','\theta_{MAP}','z');

MSE_ML_measured = mean((theta-theta_hat_ML).^2)
MSE_MAP_measured = mean((theta-theta_hat_MAP).^2)
MSE_ML_calculated = (H'*Rn^-1*H)^-1
MSE_MAP_calculated = (H'*Rn^-1*H + Rt^-1)^-1

%figure;
%hold on;
%plot(abs(fft(theta))/length(theta));