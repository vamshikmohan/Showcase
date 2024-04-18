function modelplot(model,direction)

    if(~exist("direction","var"))
        direction=[1 2 3];
    end

    a = model.Points(:, direction);  % Swap X and Z axes
    m = model.ConnectivityList;
    figure
    patch('Faces', m, 'Vertices', a, 'FaceColor', 'blue');
    axis equal;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');

    view(30,45)
end