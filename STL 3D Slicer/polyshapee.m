function [x,y] = polyshapee(tt,verts)

x={};
y={};

for i=1:length(tt)
    xx = verts(tt{i},1);
    yy = verts(tt{i},2);
   
    x{end+1}=xx;
    y{end+1}=yy;
end

end