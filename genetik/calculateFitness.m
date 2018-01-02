function [ fitness ] = calculateFitness( P )
%FITNESS Summary of this function goes here
%   Detailed explanation goes here

fitness = floor((-1.0 + -1.5*P.^1 + 9.333*P.^2 + 0.5*P.^3 -.333*P.^4  + 2*sin(20*P))*.1)+ 5*sin(4*P);
%fitness = (1*sin(.5*P)).*exp(sin((-.001*P).^2)) + 3*sin(.01*P);

%ind = find(fitness < 0);
%fitness(ind) = 0;
    

end

