Fs = 44000;
x = record(1,Fs);
audiowrite('s.wav',x,Fs);

subplot(2,1,1);
plot(x);
subplot(2,1,2);
plot(abs(fft(x)));

%sound(x,8000);