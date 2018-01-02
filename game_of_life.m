clear all;
close all;
N_x = 25;
N_y = 25;%N_x;

A = round(rand(N_y,N_x)-0.0);
A = A+min(min(A));
A = A/max(max(A));

A_new = zeros(size(A));

while 1
%for i = 1:100
%break
  A_new = zeros(size(A));
  for y = 2:N_y-1
    for x = 2:N_x-1
      C = A(y-1:y+1,x-1:x+1);
      Z = C(2,2);
      C(2,2) = 0;
      N_alive = sum(sum(C));
      if Z == 0 % is dead
        if N_alive == 3 %new born
          A_new(y,x) = 1;
        end
      else % is alive
        if N_alive == 2 || N_alive == 3 % survive
          A_new(y,x) = Z;
        end;        
      end
    end
  end
  
  if A == A_new
    break
  end
  A = A_new;
  imshow(A);
  pause(0.01);
end
disp 'end'