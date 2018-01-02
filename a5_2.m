clear all
close all

e = [0.01, 0.02, 0.05, 0.1, 0.2, 0.4];

hold all
for i=[5:5:20]
    dB = i;
    EsN0 = 10^(dB/10);

    g = 1+1/3*EsN0*(pi*e).^2;
    g = 10 * log10(g)
    plot(g)
end