%% This octave script reads directly from a /dev/tty and plots the data in 
%  real time
%
%  Author: Simon Bertling, 2018
%
%  Known problems:
%   - The tty properties (like parity bits) must be set somehow before runngin
%     this script. I usually use minicom
%   - If the data processing takes up too much time, the plotting does not catch
%     up to the data.

more off;
close all;

fname = "/dev/ttyUSB0";

N_values = 3;
N_buffer = 1000;
N_plot_freq = 200;

Ts = 1e-3;
Fs = 1/Ts;
t = 0:Ts:N_buffer*Ts;

% Open device
fid = fopen(fname);  

% Initialize data vectors
A = zeros(N_buffer,N_values);
B = zeros(N_buffer,N_values);
plot_handle = [];
k = 0;
r = 1;

% Create plot handles
% We use set to update the data afterwards
fig_handle = figure();
sub_plot_handle1 = subplot(2,1,1);
plot_handle1 = plot(A);
sub_plot_handle2 = subplot(2,1,2);
plot_handle2 = plot(B);

%% Main loop
%  As soon as the plot gets close, this loop will end
while ishandle(fig_handle)
  % Check for buffer end
  if k < N_buffer
    k = k+1;
  else
    k = 1;
  end
  
  % Read one line from the device
  line = textscan(fgetl(fid),"%d");
  
  % Now put the values into the buffer vector
  for n_value=1:N_values
    try 
      A(k,n_value) = line{1}(n_value);
    catch
      A(k,n_value) = NaN;
    end
  end
  
  % Plot every N_plot_freq
  if mod(k,N_plot_freq) == 0
    % Reassamble buffer
    B = [A(k+1:end,:); A(1:r-1,:); A(r:k,:)]*5/1024;
    r = r + N_plot_freq;
    if r > N_buffer
      r = 1;
    end
    % Plot result
    % Using set appears to be much faster, but does not work well with matrices
    %set(plot_handle1,'YData',A);
    %set(plot_handle2,'YData',B);
    subplot(2,1,1);
    plot(B);
    subplot(2,1,2);
    Y = 10*log10(abs(fft(B)/N_buffer));
    plot(Y(1:floor(N_buffer/2),:));
    drawnow();
  end
end

disp("Closing...");
fclose(fid);
disp("Script done.");
