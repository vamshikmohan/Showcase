function [Boundary1,VELOCITIES1,P_NORMALS1, INTERIOR1, XY_COORDS] = BC_Custom_Obstacle(curve, X, Y, bc, Boundary,VELOCITIES,P_NORMALS, INTERIOR)

if bc == 0
    Boundary = [];
    VELOCITIES = [];
    P_NORMALS = [];
end


if ~exist('INTERIOR', 'var')
        INTERIOR = [];
end


x_curve = curve(:,1)';
y_curve = curve(:,2)';
x = X(1,:);
y = Y(:,1);
dx = x(2)- x(1);

idx = dsearchn([X(:), Y(:)], [x_curve(1), y_curve(1)]);

% Convert index to row and column indices
[row, col] = ind2sub(size(X), idx);

% Closest grid point coordinates
closest_x = X(row, col);
closest_y = Y(row, col);

xg = [];
yg = [];
rg = [];
cg = [];

xg(end+1) = closest_x;
yg(end+1) = closest_y;
rg(end+1) = row;
cg(end+1) = col;

x_c1 = x_curve(1);
y_c1 = y_curve(1);

for i = 2:length(x_curve)

    x_c2 = x_curve(i);
    y_c2 = y_curve(i);
    xg_c1 = xg(end);
    yg_c1 = yg(end);
    r_c1 = rg(end);
    c_c1 = cg(end);

    bool = x_c2>=x(c_c1+1) | x_c2<=x(c_c1-1) | y_c2>=y(r_c1+1) | y_c2<=y(r_c1-1);
    
    %MAIN WHILE LOOP
    while x_c2>x(c_c1+1) || x_c2<x(c_c1-1) || y_c2>y(r_c1+1) || y_c2<y(r_c1-1)

        xg_c1 = xg(end);
        yg_c1 = yg(end);

        y_c1 = yg_c1;
        x_c1 = xg_c1;
        
        slope = (y_c2 - y_c1)/(x_c2-x_c1);
        right_bool = x_c2>x_c1;

        if right_bool
            %RIGHT SIDE SLOPE ARGUMENTS
            if slope<=0.5 && slope>-0.5
                cg(end+1) = c_c1+1;
                rg(end+1) = r_c1;
            elseif slope<=2 && slope>0.5
                cg(end+1) = c_c1+1;
                rg(end+1) = r_c1+1;
            elseif slope<=-0.5 && slope>-2
                cg(end+1) = c_c1+1;
                rg(end+1) = r_c1-1;
            elseif slope>2
                cg(end+1) = c_c1;
                rg(end+1) = r_c1+1;
            else
                cg(end+1) = c_c1;
                rg(end+1) = r_c1-1;
            end
        else
            %LEFT SIDE SLOPE ARGUMENTS
            if slope<=0.5 && slope>-0.5
                cg(end+1) = c_c1-1;
                rg(end+1) = r_c1;
            elseif slope<=2 && slope>0.5
                cg(end+1) = c_c1-1;
                rg(end+1) = r_c1-1;
            elseif slope<=-0.5 && slope>-2
                cg(end+1) = c_c1-1;
                rg(end+1) = r_c1+1;
            elseif slope>2
                cg(end+1) = c_c1;
                rg(end+1) = r_c1-1;
            else
                cg(end+1) = c_c1;
                rg(end+1) = r_c1+1;
            end

        end
        %END of IF ELSE Block

        r_c1 = rg(end);
        c_c1 = cg(end);
        xg(end+1) = x(c_c1);
        yg(end+1) = y(r_c1);

    end

end

XY_COORDS=[xg;yg]';
GRID_COORDS = [rg;cg]';

xg1 = xg;
yg1 = yg;
%NORMAL VECTOR ANALYZER
d_vectorx = circshift(xg1,-1) - xg;
d_vectory = circshift(yg1,-1) - yg;

slope_dsx = (circshift(d_vectorx,1) + d_vectorx)/2;
slope_dsy = (circshift(d_vectory,1) + d_vectory)/2;

NORMALS = [slope_dsy;-slope_dsx;slope_dsy*0];
magnitudes = xg*0;

for i = 1:length(xg)

    magnitudes(i) = (NORMALS(1,i)^2 + NORMALS(2,i)^2)^0.5;

end

NORMALS(1,:) = NORMALS(1,:)./magnitudes;
NORMALS(2,:) = NORMALS(2,:)./magnitudes;
NORMALS = NORMALS';
NORMALS(:,1:2) = NORMALS(:,1:2)*dx + XY_COORDS;
%  NORMALS(:,1:2) = NORMALS(:,1:2);



VELOCITY = XY_COORDS*0;

Boundary1 = [Boundary; GRID_COORDS];
VELOCITIES1 = [VELOCITIES; VELOCITY];
P_NORMALS1 = [P_NORMALS; (NORMALS)];

for i = 1:height(X)
    for j = 1:width(Y)
        if inpolygon(X(i,j),Y(i,j),xg,yg)
            INTERIOR = [INTERIOR; i, j];
        end
    end
end

INTERIOR1 = INTERIOR;
end