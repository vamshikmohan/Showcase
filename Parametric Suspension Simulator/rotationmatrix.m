function [R] = rotationmatrix(a,b,c)


R=[cosd(c) -1*sind(c) 0; sind(c) cosd(c) 0; 0 0 1];
R=R*[cosd(b) 0 sind(b);0 1 0; -1*sind(b) 0 cosd(b)];
R=R*[1 0 0; 0 cosd(c) -1*sind(c); 0 sind(c) cosd(c)];



end