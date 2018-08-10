clear all

try
  pkg load control
end

U = [ 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0  ] * 10;
N = length(U);
I = zeros(1,N);
I2 = zeros(1,N);

Ts = 1e-3;
L = 1e-3;
R = 0.4;

K = 1/R;
tau = L/R;

K2 = K/(2*tau/Ts);
tau2 = Ts/(2*tau);

s = tf('s');
z = tf('z', Ts);
sz = 2/Ts * (z-1)/(z+1);

Gs = K/(tau*s+1);
Gsz = K/(tau*sz+1);
Gz = K*(z+1)/(z*(2*tau/Ts+1)+(1-2*tau/Ts));

%step(Gs, Gsz, Gz);

a = 1+2*tau/Ts;
b = 1-2*tau/Ts;

Gz2 = K/a * (1+z^-1) / (1+b/a*z^-1);

a2 = exp(-Ts/tau);

I_z1 = 0;
U_z1 = 0;

I2_z1 = 0;
for i = 1:N
  I(i) = K/a * ( U(i) + U_z1 ) - b/a * I_z1;
  I_z1 = I(i);

  
  I2(i) = K * U_z1*(1-a2) + I2_z1 * a2;
  I2_z1 = I2(i);
  
  U_z1 = U(i);
end

stairs(I);
hold on;
stairs(I2);