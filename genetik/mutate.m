function [ mutation ] = mutate( P, sigma )
%MUTATE Mutates the Population P
%   
dim = size(P);
sigma = repmat(sigma,dim(1),1);
n = randn(dim) .* sigma;

mutation  = P + n;

end

