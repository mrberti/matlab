function [ alive, fitness ] = select( P, F, Mu )
%SELECT Chooses the best Mu individuals out of P according F
%   Returns a population containing the best Mu individuals of P
%   fitness is the fitness value of the remaining population

Lambda = length(F);
[x index] = sort(F);
Fmaxindex = index((Lambda-Mu+1):Lambda);
alive = P(Fmaxindex,:);
fitness = F(Fmaxindex);

end

