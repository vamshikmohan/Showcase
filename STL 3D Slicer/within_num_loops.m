function num = within_num_loops(tt,verts)
    num=(1:length(tt))*0;
    for i=1:length(tt)
        num(i)=0;
        l1=tt{i};
        l=1:length(tt);
        l=l(l~=i);
        for j=l
            l2=tt{j};
            if (inpolygon(verts(l1(1),1),verts(l1(1),2),verts(l2(:),1),verts(l2(:),2)))
                num(i)=num(i)+1;
            end
        end
    end
end