function [verts, edges1] = merge_duplicates(edgeconnectivity, vertices, tolerance)

    edges1=edgeconnectivity;
    for i=1:height(vertices)
        for j=1:height(vertices)
            if (abs(vertices(i,1)-vertices(j,1)) <= tolerance) && (abs(vertices(i,2)-vertices(j,2)) <= tolerance)
                edges1(edges1==j)=i;
            end
        end
    end
    verts = unique(vertices,'rows');
    
end