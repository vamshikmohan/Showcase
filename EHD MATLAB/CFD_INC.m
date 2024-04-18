function [u1, v1, p1] = CFD_INC(u, v, X, Y, p, b, dt, nit, Boundary, VELOCITIES, P_NORMALS, INTERIOR, FORCE_X, FORCE_Y) 
    
    dx = X(1,2)-X(1,1);
    dy = Y(2,1)-Y(1,1);

    %BOUNDARY
    rg = Boundary(:,1)';
    cg = Boundary(:,2)';

    %Fluid Properties
    rho = 1;
    nu = 0.1;
    
    FORCE_X = FORCE_X/(dx*dy*rho);
    FORCE_Y = FORCE_Y/(dx*dy*rho);

    un = u;
    vn = v;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %BUILD UP FORCE
        b(2:end-1, 2:end-1) = rho * (1 / dt * ((u(2:end-1, 3:end) - u(2:end-1, 1:end-2)) / (2 * dx) + ...
        (v(3:end, 2:end-1) - v(1:end-2, 2:end-1)) / (2 * dy)) - ...
        ((u(2:end-1, 3:end) - u(2:end-1, 1:end-2)) / (2 * dx)).^2 - ...
        2 * ((u(3:end, 2:end-1) - u(1:end-2, 2:end-1)) / (2 * dy) .* ...
        (v(2:end-1, 3:end) - v(2:end-1, 1:end-2)) / (2 * dx)) - ...
        ((v(3:end, 2:end-1) - v(1:end-2, 2:end-1)) / (2 * dy)).^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %PRESSURE SOLVER
        pn = p;
        p1 = 0;
        for q = 1:nit

            pn = p;
    
            p(2:end-1, 2:end-1) = ((pn(2:end-1, 3:end) + pn(2:end-1, 1:end-2)) * dy^2 + ...
                (pn(3:end, 2:end-1) + pn(1:end-2, 2:end-1)) * dx^2) / (2 * (dx^2 + dy^2)) - ...
                dx^2 * dy^2 / (2 * (dx^2 + dy^2)) * b(2:end-1, 2:end-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Boundary conditions (PRESSURE ONLY)    
            for i=1:length(rg)
                if ~P_NORMALS(i,3)
                p1 = finterp(p, X, Y, [P_NORMALS(i,1), P_NORMALS(i,2)]);
                p(Boundary(i,1),Boundary(i,2)) = p1;
                elseif P_NORMALS(i,3)>0
                p(cg(i),rg(i)) = P_NORMALS(i,3);
                end
            end


        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
        %VELOCITIES UPDATE
        u(2:end-1, 2:end-1) = (un(2:end-1, 2:end-1) - ...
            un(2:end-1, 2:end-1) * dt / dx .* (un(2:end-1, 2:end-1) - un(2:end-1, 1:end-2)) - ...
            vn(2:end-1, 2:end-1) * dt / dy .* (un(2:end-1, 2:end-1) - un(1:end-2, 2:end-1)) - ...
            dt / (2 * rho * dx) .* (p(2:end-1, 3:end) - p(2:end-1, 1:end-2)) + ...
            nu * (dt / dx^2 .* (un(2:end-1, 3:end) - 2 * un(2:end-1, 2:end-1) + un(2:end-1, 1:end-2)) + ...
            dt / dy^2 .* (un(3:end, 2:end-1) - 2 * un(2:end-1, 2:end-1) + un(1:end-2, 2:end-1)))) + FORCE_X(2:end-1, 2:end-1)*dt;

        v(2:end-1, 2:end-1) = (vn(2:end-1, 2:end-1) - ...
            un(2:end-1, 2:end-1) * dt / dx .* (vn(2:end-1, 2:end-1) - vn(2:end-1, 1:end-2)) - ...
            vn(2:end-1, 2:end-1) * dt / dy .* (vn(2:end-1, 2:end-1) - vn(1:end-2, 2:end-1)) - ...
            dt / (2 * rho * dy) .* (p(3:end, 2:end-1) - p(1:end-2, 2:end-1)) + ...
            nu * (dt / dx^2 .* (vn(2:end-1, 3:end) - 2 * vn(2:end-1, 2:end-1) + vn(2:end-1, 1:end-2)) + ...
            dt / dy^2 .* (vn(3:end, 2:end-1) - 2 * vn(2:end-1, 2:end-1) + vn(1:end-2, 2:end-1)))) + FORCE_Y(2:end-1, 2:end-1)*dt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Boundary conditions (VELOCITY ONLY)

        for i=1:length(rg)
            u(Boundary(i,1),Boundary(i,2)) = VELOCITIES(i,1);
            v(Boundary(i,1),Boundary(i,2)) = VELOCITIES(i,2);
        end
        
        for i=1:height(INTERIOR)
            u(INTERIOR(i,1),INTERIOR(i,2)) = 0;
            v(INTERIOR(i,1),INTERIOR(i,2)) = 0;
        end


        u1 = u;
        v1 = v;
        p1 = p;

end
