clear variables;
close all;
fclose("all")

N_values = 2;

Ts = 1e-3;
Fs = 1/Ts;
t = 0:Ts:5;

while(1)
  % Read data from shm file
  try
    fid = fopen("/dev/shm/data");
    fseek(fid,-5010,SEEK_END());
    s = fscanf(fid,"%d");
    fclose(fid);
  catch
    warning "could not read file"
  end
  if mod(length(s),N_values) == 1
    s = s(1:end-1);
  end
  
  try
    
    % create data
    A = reshape(s,N_values,floor(length(s)/N_values))';
    %y = A(2:end-1,1)/1024*5; % do not trust the first and last values
    y = A(2:end-1,:);
    y = y/1024*5; % Scale to voltage
    N_y = length(y);
    
    % Plot time
    subplot(2,1,1);
    stairs(t(1:N_y),y);
    %ylim([0 1]);
    
    % FFT
    subplot(2,1,2);
    Y = fft(y);
    Y = Y(1:floor(N_y/2),:);
    Y_log = 10*log10(abs(Y)/N_y);
    N_Y_log = length(Y_log);
    dF = Fs/N_y;
    f = 0:dF:Fs-dF;
    f = f(1:N_Y_log);
    stairs(f,Y_log);
    ylim([-60 10]);
    grid on;
  end

  % Update screen
  pause(0.001);
end

%try
%  pkg load instrument-control
%catch
%  error "could not load package"
%end

%ser = serial("/dev/ttyUSB0",38400,10);
%set(ser,"parity","N");
%pause(1);
%srl_flush(ser);

%for k=1:10
%  c = 0;
%  i = 0;
%  j = 1;
%  str = [];
%  for i=1:30
%    c = srl_read(ser,1);
%    str(i) = char(c);
%    if(c == 9)
%      %A(i,j) = str2num(str);
%      j = j+1;
%    end
%    if(c == 13)
%      break
%    end
%  end
%  str
%end

%fclose(ser)
