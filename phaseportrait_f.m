function xdot = phaseportrait_f(x,t)
% xdot = [w w_dot] => x = [phi w]
  xdot = zeros(length(x),1);

  A = [0 1;-3 -4];
  if abs(x(1)) > 1;
    x(1) = 1*sign(x(1));
    x(2) = 0;%x(2);
    xdot(1) = x(2);
    xdot(2) = sin(x(1));
  else
    xdot(1) = x(2);
    xdot(2) = -sin(x(1));
  end
  %xdot = A * x;

  
endfunction