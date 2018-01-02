clear all;
close all;

data = [0 0 0 1 1 0 1 1];
N_data = length(data);
N_symbol = 2;
N_symbols = floor(N_data/N_symbol);

Ts = 1/10e3;
T_end = (N_symbols*2)*Ts;
T_symbol = T_end;

F_mod = 10;

t = 0:Ts:T_end-Ts;
N_t = length(t);

for run=1:10

data = round(rand(1,8));

%s = zeros(N_symbols*2,N_t);

%symbols = zeros(1,N_symbols*2+1);
symbols = zeros(1,N_symbols);
for i=1:N_symbols
  symbol_data = data(((i-1)*N_symbol+1):(i*N_symbol));
  if N_symbol > 1
    val = 0;
    for k=0:N_symbol-1
      val = val + symbol_data(N_symbol-k)*2^k;
    end
    arg(i) = 2*pi*val/2^N_symbol;%+pi/4;
    X = exp(1j*arg(i));
  else
    X = data(i);
  end
  symbols(i) = X;
  %s(i,:) = X*exp(2j*pi*t*(i-1)/T_symbol);
  
  %symbols(i+N_symbols + 1) = conj(exp(1j*arg(i)));
end

A = [symbols 0 conj(symbols(end:-1:2))];
a = ifft(A);

%s = [s ; conj(s(2:end,:))];
%v = sum(s,1);
v = a;
E = sum(abs(v).^2);
V = fft(v)/length(v);
v_real = real(v);
v_imag = imag(v);

D = fft(v)/length(v);
D = D(1:N_symbols);

subplot(2,1,1);
stairs(t,v_real);
ylim([-1 1]);
title(['Energy = ' num2str(E)]);
subplot(2,1,2);
stem(fft(v));
hold on;
stairs(t,v_imag);
ylim([-1 1]);
hold off;

pause(0.05)

end;