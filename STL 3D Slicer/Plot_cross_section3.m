function Plot_cross_section3(model, direction, alpha, color, z_slice, type)

    a = model.Points(:, direction);
    m = model.ConnectivityList;
    
%     titlet=z_slice;

    mini = min(a(:,3));
    maxi = max(a(:,3));

    xmax = max(a(:,1));
    xmin = min(a(:,1));
%     xrang = xmax-xmin;

    ymax = max(a(:,2));
    ymin = min(a(:,2));
%     yrang = ymax - ymin;

    if ~exist("type","var")
        type = "number";
    end

    if type =="percentage"
        z_slice(z_slice>=99.9) = 99.9;
        z_slice(z_slice<=0.1) = 0.1;
        z_slice = mini + z_slice*0.01*(maxi-mini);
    end
   
    edges = boundary_vertices(m,a,z_slice);
    [verts,edgec] = edges2vertices(edges);
    [~, edgec]=merge_duplicates(edgec,verts,0);
    tt=find_loops(edgec);

    within = within_num_loops(tt,verts);

   
    hold on
    white=1;
    for i=0:(max(within))
        
        loops = find(within==i);
        
        for j=loops
            loop = tt{j};
            x = verts(loop(:),1);
            y = verts(loop(:),2);
            z = x*0 + z_slice;
%             plot3(x,y,z);
            if white
                fill3(x,y,z,color,"FaceAlpha",alpha,"LineStyle","none");
            else
                fill3(x,y,z+0.01,"black","LineStyle","none");
            end
            axis equal
        end
        white = white+1;
        white = rem(white,2);
%         xlim([xmin-xrang*0.1, xmax+xrang*0.1]);
%         ylim([ymin-yrang*0.1, ymax+yrang*0.1]);
    end
%     if type=="percentage"
%         title(append("Cross-Section at ",string(titlet),"%"));
%     else
%         title(append("Cross-Section at ",string(titlet),"mm"));
%     end
        

end