clear all
close all

t = 0:0.01:2*pi*10;
s1 = sin(t);
%s1 = sqrt(.5)*randn(1,length(t));
s2 = sqrt(3)*randn(1,length(t));
s = [s1;s2];

A = [1 0; 0 0]
A = randn(2,2) % %
x = A*s;

h1 = hist(x(1,:),200);
h1 = h1 / length(t);
h2 = hist(x(2,:),200);
h2 = h2 / length(t);
h = [h1;h2];

subplot(2,2,1);
plot(x(1,:));
subplot(2,2,3);
plot(x(2,:));
subplot(2,2,2);
plot(h1);
subplot(2,2,4);
plot(h2);

% figure;
% subplot(2,1,1);
% plot(h1);
% subplot(2,1,2);
% plot(h2);

H = h1'*h2;
H = H/max(max(H))*255;
figure;
%image(H);
mesh(H);
colorbar;

figure;
plotmatrix(s1,s2);
%colormap(hot(256));