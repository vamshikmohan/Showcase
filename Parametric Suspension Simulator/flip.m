function [B] = flip(Point,dir)

B=Point;

if dir=='x'
for i=1:height(Point)
    B(i,1)=-1*B(i,1);
end
elseif dir=='y'
for i=1:height(Point)
    B(i,2)=-1*B(i,2);
end   
elseif dir=='z'
for i=1:height(Point)
    B(i,3)=-1*B(i,3);
end
end


end