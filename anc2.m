%% Active Noise Cancellation by Phase-Inverted Noise Addition
% Author: Fayyaz Nisar Shaikh
% DSP Course Project - Active Noise Cancellation
% ---------------------------------------------------------------

clc; clear; close all;

%% Step 1: Read Audio Files
[speech, fs1] = audioread('hello_sound.wav');   % clean speech
[noise, fs2]  = audioread('noise.wav');         % pure noise

if fs1 ~= fs2
    error('Sampling frequencies must match.');
end
fs = fs1;

% Convert to mono
if size(speech,2)>1, speech = mean(speech,2); end
if size(noise,2)>1, noise = mean(noise,2); end

% Ensure same duration
minLen = min(length(speech), length(noise));
speech = speech(1:minLen);
noise  = noise(1:minLen);
t = (0:minLen-1)/fs;

%% Step 2: Create a noisy signal
noisy_signal = speech + noise;

%% Step 3: Find optimal alignment between noise and noisy signal
% Cross-correlate to find best alignment offset
[xcorr_vals, lags] = xcorr(noisy_signal, noise);
[~, idx] = max(abs(xcorr_vals));
best_delay = lags(idx);

% Align noise with noisy signal
if best_delay > 0
    aligned_noise = [zeros(best_delay,1); noise(1:end-best_delay)];
elseif best_delay < 0
    aligned_noise = noise(-best_delay+1:end);
    aligned_noise = [aligned_noise; zeros(-best_delay,1)];
else
    aligned_noise = noise;
end

aligned_noise = aligned_noise(1:length(noisy_signal));

%% Step 4: Invert and add (destructive interference)
cancelled_signal = noisy_signal - aligned_noise;   % inverted addition
cancelled_signal = cancelled_signal / max(abs(cancelled_signal));

%% Step 5: Play and Compare
disp('▶ Playing Original Noisy Signal...');
sound(noisy_signal, fs); pause(6);

disp('▶ Playing After Phase-Inverted Noise Cancellation...');
sound(cancelled_signal, fs);

%% Step 6: Plot for Visualization
figure('Position',[100 100 900 600]);

subplot(3,1,1);
plot(t, noisy_signal, 'r');
title('Noisy Signal (Speech + Noise)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(3,1,2);
plot(t, aligned_noise, 'm');
title('Aligned Noise (Inverted Reference)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(3,1,3);
plot(t, cancelled_signal, 'b');
title('After Noise Cancellation (Inversion Method)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

sgtitle('Noise Cancellation using Inverted Noise Addition');

%% Step 7: Frequency Spectrum
NFFT = 4096;
f = (0:NFFT-1)*(fs/NFFT);
Y_noisy = abs(fft(noisy_signal, NFFT));
Y_clean = abs(fft(cancelled_signal, NFFT));

figure('Position',[100 100 900 400]);
plot(f(1:NFFT/2), Y_noisy(1:NFFT/2), 'r', 'LineWidth', 1.2); hold on;
plot(f(1:NFFT/2), Y_clean(1:NFFT/2), 'b', 'LineWidth', 1.2);
legend('Before Inversion', 'After Inversion');
xlabel('Frequency (Hz)'); ylabel('Magnitude');
title('Frequency Spectrum Before and After Noise Cancellation');
grid on;

%% Step 8: Save the result
audiowrite('cancelled_output.wav', cancelled_signal, fs);
disp('✅ Saved: cancelled_output.wav');
