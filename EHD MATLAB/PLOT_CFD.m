function PLOT_CFD(X,Y,p,u,v,Bound,Anode)

    dx = X(1,2)-X(1,1);
    dy = Y(2,1)-Y(1,1);

    min_x = min([Bound(:,1);Anode(1)])*0.8;
    max_x = max([Bound(:,1);Anode(1)])*1.2;
    min_y = min([Bound(:,2);Anode(2)])*0.8;
    max_y = max([Bound(:,2);Anode(2)])*1.2;

    cg_m = round(min_x/dx);
    cg_M = round(max_x/dx);
    rg_m = round(min_y/dy);
    rg_M = round(max_y/dy);
    
    P_min = min(min(p(rg_m:rg_M,cg_m:cg_M)));
    P_max = max(max(p(rg_m:rg_M,cg_m:cg_M)));

    presss = linspace(P_min, P_max, 20);

    ylim([min(Bound(:,2)*0.8) max(Bound(:,2)*1.2)])

    figure('Name', 'Grid', 'Position', [100, 100, 1100, 700]);
    pcolor(X,Y,v*0);
    title('MESH GRID');
    axis equal


    figure('Name', 'FLOW', 'Position', [100, 100, 1100, 700]);
%     % Plotting the pressure field as filled contours
%     contourf(X, Y, p);
%     colorbar;
    
    hold on;
    % Plotting the pressure field outlines with transparencys
    contourf(X, Y, p, 15, 'LineStyle', 'none');
    colorbar
    % Plotting velocity field
    quiver(X(1:2:end, 1:2:end), Y(1:2:end, 1:2:end), u(1:2:end, 1:2:end), v(1:2:end, 1:2:end), 'Color', 'red', 'LineWidth', 1.2);
    fill(Bound(:,1),Bound(:,2),'white', FaceAlpha=0.5)
    
    xlabel('X');
    ylabel('Y');
    title('FLOW');
    
    axis equal;

    hold off;

    figure('Name', 'Pressure Contour');
    hold on;
    contourf(X, Y, p, presss,'LineStyle','none');
    colorbar
    colormap('turbo')
    axis equal
    fill(Bound(:,1),Bound(:,2),'white', FaceAlpha=0.1)
    xlim([min(Bound(:,1)*0.8) max(Bound(:,1)*1.2)])
    ylim([min(Bound(:,2)*0.8) max(Bound(:,2)*1.2)])
    colorbar
    colormap('turbo')
    

    hold off

    figure('Name', 'X Velocity', 'Position', [100, 100, 1100, 700]);
    pcolor(X,Y,u);
    shading interp;
    title('X Velocity');
    axis equal
    colorbar

    figure('Name', 'Y Velocity', 'Position', [100, 100, 1100, 700]);
    pcolor(X,Y,v);
    shading interp;
    title('Y Velocity');
    axis equal
    colorbar

end