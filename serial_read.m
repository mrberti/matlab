%% This script reads and plots \t-separated data from a FIFO or /dev/shm
%
% Author: Simon Bertling, 2018
%
% Known problems:
% - As the data comes in quite randomly, the data columns and plot colors also 
% get messed up
% - When using a FIFO, the data is not buffered and thus not updated immediately
% - When reading from shm, the datafile might get quite big
% - Only tested on Linux

clear variables;
close all;
more off;

N_values = 3;
N_data_read = 1000;

Ts = 1e-3;
Fs = 1/Ts;
t = 0:Ts:N_data_read*Ts;

use_fifo = 1;
use_log_fft = 1;

fname_fifo = "/home/simon/fifo";
fname_shm = "/dev/shm/data";

if use_fifo
  try
    fprintf("Opening FIFO %s...\n", fname_fifo);
    fid = fopen("/home/simon/fifo", "r");
    fprintf("FIFO opened. ID = %d\n", fid);
  catch
    error "Could not read from FIFO";
  end
else
  fprintf("Reading from %s...", fname_shm);
end

cycle = 0;
while(1)
  cycle = cycle+1;
  try
    if use_fifo
      s = fscanf(fid,"%d",N_data_read*N_values);
    else
      fid = fopen(fname_shm);
      fseek(fid,-N_data_read*N_values*3,SEEK_END());
      s = fscanf(fid,"%d");
      fclose(fid);
      if length(s) < 1
        warning "Read length is too small. Continuing..."
        pause(1);
        continue
      end
    end
  catch
    warning "could not read file"
    pause(1);
  end

  try
    % shape data vectors
    N_s = length(s);
    N_data = floor(N_s/N_values);
    s = s(1:N_data*N_values);
    y = reshape(s,N_values,N_data)';
    y = y(2:end-1,:); % do not trust the first and last values
    y = y/1024*5; % Scale to voltage
    N_y = length(y);
    
    % FFT
    Y = fft(y);
    Y = Y(1:ceil(N_y/2),:); % use only left side spectrum
    Y_log = 10*log10(abs(Y)/N_y);
    if use_log_fft
      Y_plot = Y_log;
    else
      Y_plot = abs(Y)/N_y;
    end
    N_Y_plot = length(Y_plot);
    dF = Fs/N_y;
    f = 0:dF:Fs-dF;
    f = f(1:N_Y_plot);
    
    % Plot time
    subplot(2,1,1);
    stairs(t(1:N_y),y);
    ylim([0 5]);
    
    % Plot FFT
    subplot(2,1,2);
    stairs(f,Y_plot);
    if use_log_fft
      ylim([-60 10]);
    else
      ylim([0 1]);
    end
    grid on;
  catch
    warning "An error occured during data processing. Continuing...";
  end

  % Update screen
  pause(0.01);
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
