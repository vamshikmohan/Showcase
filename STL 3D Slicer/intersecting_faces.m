function faces = intersecting_faces(connect, vert, z_slice)
    
faces = [];
    z = vert(:,3) - z_slice;
    for i=1:height(connect)
        if z(connect(i, 1))*z(connect(i, 2))<=0 || z(connect(i, 2))*z(connect(i, 3))<=0 || z(connect(i, 1))*z(connect(i, 3))<=0
%             if z(connect(i, 1))~=0 && z(connect(i, 2))~=0 && z(connect(i, 3))~=0
                faces = [faces; connect(i,:)];
%             elseif
%                     z(connect(i, 1))<=0 || z(connect(i, 2))<=0 || z(connect(i, 3))<=0
%                     faces = [faces; connect(i,:)];
%             end
            
        end
    end

end