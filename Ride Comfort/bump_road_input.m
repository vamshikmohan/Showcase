function [X_r, Z_r] = bump_road_input(x_bump,Bump_radius,x_after_bump)

% Stretch 1
x_r_1_total = x_bump;        % Distance of the first stretch             [m]
dx_r_1 = 0.1;           % resolution                                [m]
x_r_1 = 0:dx_r_1:x_r_1_total;
z_r_1 = zeros(1,length(x_r_1));
% Stretch 2
R_r = Bump_radius;              % Radius                                    [m]
th_r = 0:0.01:pi;
x_r_2 = -R_r*cos(th_r) + x_r_1_total+R_r;
z_r_2 = R_r*sin(th_r);
% Stretch 3
x_r_3_total = x_after_bump;       % Distance of the last stretch              [m]
dx_r_2 = 0.1;           % resolution                                [m]
x_r_3 = x_r_1_total+2*R_r:dx_r_2:x_r_1_total+2*R_r+x_r_3_total;
z_r_3 = zeros(1,length(x_r_3));

% Concatenating 
X_r = [x_r_1 x_r_2(2:end) x_r_3(2:end)];
Z_r = [z_r_1 z_r_2(2:end) z_r_3(2:end)];

figure;
    plot(X_r, Z_r);
    xlabel('Distance (m)');
    ylabel('Amplitude');
    grid on;
    axis equal
    ylim([-1.5 1.5]);
    xlim([x_bump-1 x_bump+2*Bump_radius+4]);
    axis equal

end