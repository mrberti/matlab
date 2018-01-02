%% Bild FFT IFFT

clear all;
close all;
clc;

N = 8;
th = 50;

bild = imread('bild.bmp');

b = reshape(bild,1,N*N*3);
dft = fft2(b);

%g = zeros(N,N,3);

select = find(abs(dft) > th);
N*N*3 - length(select)

g = zeros(1,N*N*3);
g(select) = (ifft2(dft(select)));

g = reshape(g,N,N,3);
g = g * 255 / max(max(max(g)));
g = uint8(g)

image(g);
