%% This script reads and plots \t-separated data from a FIFO or /dev/shm
%
% Author: Simon Bertling, 2018
%
% Known problems:
% - When not using_tail, the data comes in quite randomly. The data columns and 
%   plot colors get messed up
% - When using a FIFO, the data is not buffered and thus not updated immediately
% - When reading from shm, the datafile might get quite big
% - Only tested on Linux

clear variables;
close all;
more off;

N_data_read = 6000;

Ts = 1;
Fs = 1/Ts;
t = 0:Ts:N_data_read*Ts;

use_log_fft = 1;
use_time_stamps = 1;

fname = "/dev/shm/data";
cmd_str = ["tail -n" num2str(N_data_read) " " fname];
fprintf("Reading from %s...\n", fname);


%% Main loop
%  The loop will end as soon as the plot handle gets destroyed
fig = figure();
while ishandle(fig)
  try
      fid = popen(cmd_str,"r");
      y = csvread(fid);
      fclose(fid);
      if length(y) < 1
        warning "Read length is too small. Continuing..."
        pause(.5);
        continue
      end
  catch
    warning "could not read file"
    pause(1);
  end

##  try
    % shape data vectors
##    y = y(max(end-N_data_read,2):end-1,:); % do not trust the first and last values
    N_y = length(y);
    if use_time_stamps
      t = y(:,1);
      t = t-t(1);
      y = y(:,2:end);
    end
    
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
    
    % Plot against time
    subplot(2,1,1);
    stairs(t(1:N_y),y);
    xlim([t(1) t(end)]);
##    ylim([0 5]);
##    grid on;
##    
    % Plot FFT
    subplot(2,1,2);
    stairs(f,Y_plot);
    if use_log_fft
      ylim([-60 10]);
    else
      ylim([0 1]);
    end
##    grid on;
##  catch
##    warning "An error occured during data processing. Continuing...";
##  end

  % Update screen
  refresh();
  pause(1);
end

disp("Closing...");
try
  fclose(fid);
end
disp("Script done");
