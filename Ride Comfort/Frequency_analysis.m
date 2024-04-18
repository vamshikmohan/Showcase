function [Weighted_PSD, frequency_arr, PSD] = Frequency_analysis(Z_r,time)
% Perform FFT on the simulated response
Fs = 1 / mean(diff(time)); % Sampling frequency
L = length(Z_r); % Length of the signal

% Compute one-sided spectrum
Y = fft(Z_r);
P2 = abs(Y / L);
P1 = P2(1:L/2 + 1);
P1(2:end - 1) = 2 * P1(2:end - 1);

% Frequency vector
f = Fs * (0:(L/2)) / L;

frequency_arr = f;
PSD = P1';
Weighted_PSD = apply_frequency_weighting(f, P1');

end