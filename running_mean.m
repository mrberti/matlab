a = 255*randn(1,9999999);

N = size(a,2);
m1 = zeros(1,N);
m1(1) = a(1);

m2 = m1;
m3 = m1;

for n=2:N
  x_n = a(n);
  m1(n) = m1(n-1)*(1-1/n)+x_n/n;
  m2(n) = (n-1)*(m2(n-1) / n + x_n / n / (n-1));
  m3(n) = sum(a(1:n))/n;
endfor

m9 = sum(a) / N;

m1(end)
m2(end)
m3(end)
m9
