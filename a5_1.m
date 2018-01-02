clear all
format shortE

x = [0:1:30];
x10 = x/10;
EsN0 = 10.^x10;

BERbpsk = 0.5 * erfc(sqrt(EsN0))

hold all
for i = [1:4]
    M = 4^i;
    BER = 1-(1-2*(1-1/sqrt(M))*0.5*erfc(sqrt(3/2*EsN0*log2(M)/(M-1)))).^2;
    BER = BER ./ log2(M)
    semilogx(BER);
end