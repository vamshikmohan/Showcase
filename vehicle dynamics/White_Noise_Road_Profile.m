function [X_r, Z_r] = generateRoadProfileWithBumps(profile_length, sampling_rate, amplitude_factor, num_bumps, bump_amplitude, bump_frequency)
    % Generate white noise
    rng(1); % Set seed for reproducibility
    white_noise = amplitude_factor * randn(1, profile_length * sampling_rate);

    % Integrate white noise to get road profile
    road_profile = cumsum(white_noise);

    % Add bumps
    bump_indices = round(linspace(1, profile_length * sampling_rate, num_bumps));
    road_profile(bump_indices) = road_profile(bump_indices) + bump_amplitude * sin(2 * pi * bump_frequency * (1:num_bumps));

    % Time vector
    time = linspace(0, profile_length, profile_length * sampling_rate);

    % Create X_r and Z_r
    X_r = time;
    Z_r = road_profile;

    % Plot the road profile
    figure;
    plot(X_r, Z_r);
    xlabel('Distance (m)');
    ylabel('Amplitude');
    title('Road Profile Generated from White Noise with Bumps');
    grid on;
    axis equal
    ylim([-1.5 1.5]);
    xlim([0 4]);
    axis equal

end
