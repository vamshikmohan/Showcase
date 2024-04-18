function [vertices, edgeconnectivity] = edges2vertices(edges)
    vertices = zeros(2*height(edges),2);
    for i = 1:height(edges)
        vertices(2*i - 1, 1:2) = edges(i,1:2);
        vertices(2*i, 1:2) = edges(i,3:4);
    end
    
    edgeconnectivity = zeros(height(edges),2);
    edgeconnectivity(:,1)=1:2:(2*height(edges)-1);
    edgeconnectivity(:,2)=2:2:2*height(edges);



end