function [Boundary,VELOCITIES,P_NORMALS] = BC_End_Wall(X,Y,direction,bc,Boundary,VELOCITIES,P_NORMALS)

    if bc == 0
        Boundary = [];
        VELOCITIES = [];
        P_NORMALS  = [];
    end

    x = X(1,:);
    y = Y(:,1);

    if direction=="left"
    Boundary = [Boundary;(1:length(y))',ones(length(y),1)];
    VELOCITIES = [VELOCITIES;ones(length(y),1)*0,(1:length(y))'*0];
    P_NORMALS = [P_NORMALS;X(:,2),Y(:,2),Y(:,2)*0];
    %bc.P_NORMALS = [bc.P_NORMALS;(1:length(y))';2*ones(length(y),1)];

    elseif direction=="right"
    Boundary = [Boundary;(1:length(y))',length(x)*ones(length(y),1)];
    VELOCITIES = [VELOCITIES; 0*ones(length(y),1) , 0*(1:length(y))'];
    P_NORMALS = [P_NORMALS;X(:,end-1),Y(:,end-1),X(:,end-1)*0];
    %bc.P_NORMALS = [bc.P_NORMALS;(1:length(y))';(length(x)-1)*ones(length(y),1)];

    elseif direction=="up"
    Boundary = [Boundary;length(y)*ones(length(x),1), (1:length(x))'];
    VELOCITIES = [VELOCITIES;0*(1:length(x))',0*ones(length(x),1)];
    P_NORMALS = [P_NORMALS;X(end-1,:)',Y(end-1,:)',Y(end-1,:)'*0];
    %bc.P_NORMALS = [bc.P_NORMALS;(length(y)-1)*ones(length(x),1);(1:length(x))'];

    elseif direction=="down"
    Boundary = [Boundary;ones(length(x),1), (1:length(x))'];
    VELOCITIES = [VELOCITIES;0*(1:length(x))',0*ones(length(x),1)];
    P_NORMALS = [P_NORMALS;X(2,:)',Y(2,:)',Y(2,:)'*0];
    %bc.P_NORMALS = [bc.P_NORMALS;(2)*ones(length(x),1);(1:length(x))'];

    end    

end