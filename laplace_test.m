close all
clear all

syms x;

x = 0:.01:1;

s = (heaviside(x) - heaviside(x-.5)) .* cos(2*pi*x);
s = s + (heaviside(x-.5) - heaviside(x-1)) .* -cos(2*pi*x);

b = [1 1 1 1 1];
a = 1; %[1 .9];
u = filter(b,a,s);
u = cumsum(s);

hold on
plot(x,s);
plot(x,u, 'r');
hold off

close all
syms t;

h = heaviside(t)*exp(-t);
s = heaviside(t) - heaviside(t-.5);

H = laplace(h)
S = laplace(s)

U = H*S

u = ilaplace(U)
simple(u)

ezplot(u)
