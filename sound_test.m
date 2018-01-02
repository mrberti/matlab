Fs = 44e3;
t = 0:1/Fs:1;

s = 1*sin(2*pi*400*t);

%sound(s,Fs);

r = record(1);

plot(r) 
