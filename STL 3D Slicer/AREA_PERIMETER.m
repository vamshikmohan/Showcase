function [Area, Perimeter, Area_core] = AREA_PERIMETER(model, direction, z_slice, type)
    
    a = model.Points(:, direction);
    m = model.ConnectivityList;
    mini = min(a(:,3));
    maxi = max(a(:,3));

    if ~exist("type","var")
        type = "number";
    end

    if type =="percentage"
        z_slice(z_slice>=99.999) = 99.9999;
        z_slice(z_slice<=0.001) = 0.0001;
        z_slice = mini + z_slice*0.01*(maxi-mini);
    end

%     if type == "number"
%         z_slice(z_slice>=(maxi - (maxi-mini)/10000)) = maxi - (maxi-mini)/10000;
%         z_slice(z_slice<=(mini + (maxi-mini)/10000)) = mini + (maxi-mini)/10000;
%     end
    
    edges = boundary_vertices(m,a,z_slice);
    [verts,edgec] = edges2vertices(edges);
    [~, edgec]=merge_duplicates(edgec,verts,0);
    tt=find_loops(edgec);
    [Area,Perimeter,Area_core] = loop_area_perimeter(tt, verts);

end