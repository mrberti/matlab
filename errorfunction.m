x = 0:0.05:4;
y = erfc(x);
A = [x' y'];
loglog(x,y);