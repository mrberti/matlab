tic
clear all
close all
MAX_N = 123456789;
x = zeros(1,MAX_N);
y = 0;
for i=1:MAX_N
    x(i) = sqrt(i);
    %y = sqrt(i);
end
%x(end);
%y;
t = toc;
%%
str = sprintf('\n%d calculations in %f s\n', MAX_N, t);
str = [str  sprintf('roughly %d calculations per second',round(MAX_N/t))];
disp(str)