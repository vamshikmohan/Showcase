function min_distance = MIN_DISS(surface_points, x, y)
    % Calculate the least distance from a point (x, y) to a surface defined by a set of 2D points
    
    % If there is only one point in the surface_points set, return the distance to that point
    if size(surface_points, 1) == 1
        point = surface_points(1, :);
        min_distance = norm([x, y] - point);
        return;
    end
    
    % Initialize minimum distance to a large value
    min_distance = Inf;
    
    % Iterate through each line segment formed by adjacent points on the surface
    for i = 1:size(surface_points, 1) - 1
        % Extract coordinates of the current line segment
        p1 = surface_points(i, :);
        p2 = surface_points(i + 1, :);
        
        % Calculate the distance from the point to the line segment
        distance = point_to_line_distance(p1, p2, x, y);
        
        % Update the minimum distance if necessary
        min_distance = min(min_distance, distance);
    end

    function distance = point_to_line_distance(p1, p2, x, y)
    % Calculate the distance from a point (x, y) to a line segment defined by two points p1 and p2
    
    % Compute vector components
    dx = p2(1) - p1(1);
    dy = p2(2) - p1(2);
    
    % Calculate parameters for the line equation
    a = dx^2 + dy^2;
    b = dx * (p1(1) - x) + dy * (p1(2) - y);
    c = (p1(1) - x)^2 + (p1(2) - y)^2;
    
    % Calculate the closest point on the line segment to the point (x, y)
    if a ~= 0
        t = -b / a;
        t = max(0, min(1, t)); % Ensure t is within [0, 1] to stay within the line segment
        closest_point = [p1(1) + t * dx, p1(2) + t * dy];
    else
        % Handle degenerate case where the line segment collapses to a point
        closest_point = p1;
    end
    
    % Calculate the distance between the point and the closest point on the line segment
    distance = norm([x, y] - closest_point);
end


end

