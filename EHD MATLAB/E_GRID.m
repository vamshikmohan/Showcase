function [E_x,E_y,V,rho] = E_GRID(X,Y,surfacee1,Anode_pos,V_d)
    
    E_x = X*0;
    E_y = E_x;
    V = E_x;
    
    for k = 1:numel(E_x)
    
            [E1,V1] = Electro_Static([X(k) Y(k)],surfacee1(1:end-1,:),Anode_pos,V_d);
            E_x(k) = E1(1);
            E_y(k) = E1(2);
            V(k) = V1;
            
    end

    min_coll = X*0;
    min_emmi = X*0;
    
    for m=1:numel(X)
        min_coll(m) = MIN_DISS(surfacee1,X(m),Y(m));
        min_emmi(m) = MIN_DISS(Anode_pos,X(m),Y(m));
    end
    
    rho = exp(-min_coll).*exp(-min_emmi);
    rho = rho/max(max(rho));

function [E,V,Q_dist] = Electro_Static(point,surfacee,Anode_pos,V_d)
    
    Q_dist = (Q_Distribution_perV(surfacee))';
    D = surfacee;
    
    % Estimating Potential
    D(:,1) = surfacee(:,1) - Anode_pos(1);
    D(:,2) = surfacee(:,2) - Anode_pos(2);
    L = zeros([height(surfacee) 1]);
    L =  D(:,1).*D(:,1) + D(:,2).*D(:,2);
    L = sqrt(L);

    V_x = V_d/(sum(Q_dist.*(1./L)));
    
    %Estiamting True Electrostatic Effects
    D(:,1) = surfacee(:,1) - point(1);
    D(:,2) = surfacee(:,2) - point(2);
    L = zeros([height(surfacee) 1]);
    L =  D(:,1).*D(:,1) +  D(:,2).*D(:,2);
    L = sqrt(L);
    E_Vec = (repmat(Q_dist.*(L.^(-3)),1,2)).*D;
    E = [sum(E_Vec(:,1)),sum(E_Vec(:,2))]*V_x;
    V = sum(Q_dist.*(1./L))*V_x;
    
    % Anode
    D_a = point - Anode_pos;
    L_a =  sqrt(D_a(1).*D_a(1) +  D_a(2).*D_a(2));
    q = sum(Q_dist);
    E = E + D_a*(q/(L_a*L_a*L_a))*V_x;
    V = V - (q*V_x)/(L_a*L_a);

    Q_dist = (Q_dist*V_x)/(8.99e9);

function [X] = Q_Distribution_perV(points)
    n = height(points);
    A = zeros(n);
    B = ones([n 1]);
    for i=1:n
        for j=1:n
            if i~=j
                A(i,j) = 1/(diss(points(i,:),points(j,:)));
            end
    
        end
    end
    X = B\A;
end

end

function [d,vector] = diss(point1, point2)
    d = ((point1(1)-point2(1))^2 + (point1(2)-point2(2))^2)^0.5;
    vector = point2-point1;
end


end