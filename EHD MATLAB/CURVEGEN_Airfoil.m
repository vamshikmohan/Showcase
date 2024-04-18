function [x, y] = CURVEGEN_Airfoil(NACA_digits, num_points, AoA_deg)
    % NACA_digits: String containing the 4-digit NACA series (e.g., '2412')
    % num_points: Number of points to generate along the airfoil
    % AoA_deg: Angle of attack in degrees
    
    % Parse NACA digits
    m = str2double(NACA_digits(1)) / 100; % Maximum camber
    p = str2double(NACA_digits(2)) / 10;  % Location of maximum camber
    t = str2double(NACA_digits(3:4)) / 100;% Maximum thickness

    % Generate x-coordinates
    x = linspace(0, 1, num_points)';
    
    % Calculate mean camber line
    if p > 0
        yc = (m/p^2) * (2*p*x - x.^2);
        dyc_dx = (2*m/p^2) * (p - x);
    else
        yc = zeros(size(x));
        dyc_dx = zeros(size(x));
    end
    
    % Calculate thickness distribution
    yt = 5 * t * (0.2969 * sqrt(x) - 0.1260 * x - 0.3516 * x.^2 + 0.2843 * x.^3 - 0.1015 * x.^4);

    % Calculate upper and lower surfaces
    xu = x - yt .* sin(atan(dyc_dx));
    yu = yc + yt .* cos(atan(dyc_dx));
    
    xl = x + yt .* sin(atan(dyc_dx));
    yl = yc - yt .* cos(atan(dyc_dx));
    
    % Combine upper and lower surfaces
    x = [xu; flipud(xl(2:end-1))];
    y = [yu; flipud(yl(2:end-1))];
    
    % Make last point equal to the first point
    x(end) = x(1);
    y(end) = y(1);
    
    % Rotate the airfoil based on angle of attack
    theta = deg2rad(AoA_deg);
    x_rotated = x * cos(theta) - y * sin(theta);
    y_rotated = x * sin(theta) + y * cos(theta);
    
    x = x_rotated;
    y = y_rotated;

    % Reverse the direction
    x = flipud(x);
    y = flipud(y);  
end
