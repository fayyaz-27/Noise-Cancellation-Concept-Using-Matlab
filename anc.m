% Simple MATLAB program: Sine + Inverted Sine

clc; clear; close all;

% Parameters
fs = 1000;          % Sampling frequency (Hz)
t = 0:1/fs:1;       % Time vector for 1 second

% Generate sine wave
x = sin(2*pi*5*t);  % 5 Hz sine signal

% Generate inverted sine wave
x_inv = -sin(2*pi*5*t);  % inverted version

% Add both signals
y = x + x_inv;

% Display max residual value (shows numerical error, not exactly 0)
disp(['Maximum value in the resultant signal: ', num2str(max(abs(y)))]);

% Plot signals
figure;

subplot(3,1,1);
plot(t, x); grid on;
title('Original Sine Wave');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,2);
plot(t, x_inv); grid on;
title('Inverted Sine Wave');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,1,3);
plot(t, y); grid on;
title('Sum of Sine and Inverted Sine (Almost Zero)');
xlabel('Time (s)'); ylabel('Amplitude');
