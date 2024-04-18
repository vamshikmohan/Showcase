function [B] = RZ(Point,angl,dir)

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


a=angl;
rzz=[cosd(a) -1*sind(a) 0; sind(a) cosd(a) 0; 0 0 1];
for i=1:height(Point)
    B(i,:)=(rzz*(B(i,:))')';
end


end
