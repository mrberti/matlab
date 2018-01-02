%% based on http://matlab.cheme.cmu.edu/2011/08/09/phase-portraits-of-a-system-of-odes/
close all;
f = @(t,Y) [Y(2); -sin(Y(1))];

x1 = linspace(-2,2,50);
x2 = linspace(-2,2,50);

[x1_t, x2_t] = meshgrid(x1,x2);

u = zeros(size(x1_t));
v = zeros(size(x2_t));

t = 0;
for i = 1:numel(x1_t)
  X_dot = phaseportrait_f([x1_t(i); x2_t(i)],t);
  u(i) = X_dot(1);
  v(i) = X_dot(2);
end

quiver(x1_t,x2_t,u,v,'r');
xlabel('x1');
ylabel('x2');
axis tight equal;

Ts = 0.1;
Tend = 50;
t = 0:Ts:Tend;
x0_1 = 0;%-2:0.5:4;
x0_2 = 2;%-2:0.5:2;
hold on;

for i = 1:length(x0_2)
  x0 = [0;x0_2(i)];
  ys = lsode("phaseportrait_f",x0,t);
  plot(ys(:,1),ys(:,2));
  plot(ys(1,1),ys(1,2),'o');
end
for i = 1:length(x0_2)
  x0 = [0;-x0_2(i)];
  ys = lsode("phaseportrait_f",x0,t);
  plot(ys(:,1),ys(:,2));
  plot(ys(1,1),ys(1,2),'o');
end
for i = 1:length(x0_1)
  x0 = [x0_1(i);0];
  ys = lsode("phaseportrait_f",x0,t);
  plot(ys(:,1),ys(:,2));
  plot(ys(1,1),ys(1,2),'o');
end
for i = 1:length(x0_1)
  x0 = [-x0_1(i);0];
  ys = lsode("phaseportrait_f",x0,t);
  plot(ys(:,1),ys(:,2));
  plot(ys(1,1),ys(1,2),'o');
end


hold off