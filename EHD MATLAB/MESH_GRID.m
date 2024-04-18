function [X,Y] = MESH_GRID(x1, y1, x2, y2, nx, ny)
    x = linspace(x1, x2, nx);
    y = linspace(y1, y2, ny);
    [X, Y] = meshgrid(x, y);
end