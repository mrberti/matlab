function [ fitness ] = calculateFitness( P )
%FITNESS Summary of this function goes here
%   Detailed explanation goes here

A = P(:,1);
B = P(:,2);
x = A;
y = B;
fitness =  exp(-((A+5).^2/30 + (B-7).^2/30)) + 2*exp(-((A+50).^2/100 + (B-70).^2/100));
%fitness =  3*(1-x).^2.*exp(-(x.^2) - (y+1).^2) ... 
   - 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2) ... 
   - 1/3*exp(-(x+1).^2 - y.^2);
end

