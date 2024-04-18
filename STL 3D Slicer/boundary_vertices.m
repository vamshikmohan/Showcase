function edges = boundary_vertices(connect, vert, z_slice)
    
faces = [];
    z = vert(:,3) - z_slice;
    for i=1:height(connect)
        if z(connect(i, 1))*z(connect(i, 2))<=0 || z(connect(i, 2))*z(connect(i, 3))<=0 || z(connect(i, 1))*z(connect(i, 3))<=0
            if z(connect(i, 1))*z(connect(i, 2))~=0 && z(connect(i, 2))*z(connect(i, 3))~=0 && z(connect(i, 1))*z(connect(i, 3))~=0
                faces = [faces; connect(i,:)];
            else
                if z(connect(i, 1))<=0 && z(connect(i, 2))<=0 && z(connect(i, 3))<=0
                    faces = [faces; connect(i,:)];
                end
            end
        end
    end
    c=0;
    edges=zeros(height(faces), 4);
    edge=[0,0,0,0]; %x1 y1 x2 y2
    for i=1:height(faces)
        v = [faces(i,1),vert(faces(i,1),:); faces(i,2),vert(faces(i,2),:); faces(i,3),vert(faces(i,3),:)];
        v = sortrows(v,4,'descend');
        if v(2,4)>=z_slice
            c = (z_slice - v(1,4)) / (v(3,4) - v(1,4));
            edge(1) = v(1,2) + c * (v(3,2) - v(1,2));
            edge(2) = v(1,3) + c * (v(3,3) - v(1,3));
            c = (z_slice - v(2,4)) / (v(3,4) - v(2,4));
            edge(3) = v(2,2) + c * (v(3,2) - v(2,2));
            edge(4) = v(2,3) + c * (v(3,3) - v(2,3));
        else
            c = (z_slice - v(1,4)) / (v(3,4) - v(1,4));
            edge(1) = v(1,2) + c * (v(3,2) - v(1,2));
            edge(2) = v(1,3) + c * (v(3,3) - v(1,3));
            c = (z_slice - v(1,4)) / (v(2,4) - v(1,4));
            edge(3) = v(1,2) + c * (v(2,2) - v(1,2));
            edge(4) = v(1,3) + c * (v(2,3) - v(1,3));
        end

        edges(i,1:4) = edge;
        edge = [-10,-10,-10,-10];
        
    end

end



% vector_prev = [x_prev, y_prev];
% vector_current = [x, y];
% 
% cross_product = vector_prev(1) * vector_current(2) - vector_prev(2) * vector_current(1);
% 
% if cross_product > 0
%     disp('The current point is rotated counterclockwise with respect to the previous point.');
% elseif cross_product < 0
%     disp('The current point is rotated clockwise with respect to the previous point.');
% else
%     disp('The points are collinear.');
% end