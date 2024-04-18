function [Boundary,VELOCITIES,P_NORMALS] = BC_Vel_Shear(vel,X,Y,direction,bc,Boundary,VELOCITIES,P_NORMALS)

    if bc == 0
        Boundary = [];
        VELOCITIES = [];
        P_NORMALS  = [];
    end

    x = X(1,:);
    y = Y(:,1);

    if direction=="left"
    Boundary = [Boundary;ones(length(y),1),(1:length(y))'];
    VELOCITIES = [VELOCITIES;ones(length(y),1)*0,ones(length(y),1)*vel];
    P_NORMALS = [P_NORMALS;X(:,2),Y(:,2),(Y(:,2)*0)];
    %bc.P_NORMALS = [bc.P_NORMALS;(1:length(y))';2*ones(length(y),1)];

    elseif direction=="right"
    Boundary = [Boundary;length(x)*ones(length(y),1),(1:length(y))'];
    VELOCITIES = [VELOCITIES; 0*ones(length(y),1) , vel*ones(length(y),1)];
    P_NORMALS = [P_NORMALS;X(:,end-1),Y(:,end-1),(X(:,end-1)*0)];
    %bc.P_NORMALS = [bc.P_NORMALS;(1:length(y))';(length(x)-1)*ones(length(y),1)];

    elseif direction=="up"
    Boundary = [Boundary;(1:length(x))',length(y)*ones(length(x),1)];
    VELOCITIES = [VELOCITIES;vel*ones(length(x),1), 0*ones(length(x),1)];
    P_NORMALS = [P_NORMALS;X(end-1,:)',Y(end-1,:)',(Y(end-1,:)'*0)];
    %bc.P_NORMALS = [bc.P_NORMALS;(length(y)-1)*ones(length(x),1);(1:length(x))'];

    elseif direction=="down"
    Boundary = [Boundary;(1:length(x))',ones(length(x),1)];
    VELOCITIES = [VELOCITIES; vel*ones(length(x),1), 0*ones(length(x),1)];
    P_NORMALS = [P_NORMALS;X(2,:)',Y(2,:)',(Y(2,:)'*0)];
    %bc.P_NORMALS = [bc.P_NORMALS;(2)*ones(length(x),1);(1:length(x))'];

    end    

end