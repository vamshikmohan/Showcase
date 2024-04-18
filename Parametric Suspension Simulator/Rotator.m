function [RM] = Rotator(n1,n2)

    n1=n1/((n1(1)*n1(1) + n1(2)*n1(2) + n1(3)*n1(3)))^0.5;
    n2=n2/((n2(1)*n2(1) + n2(2)*n2(2) + n2(3)*n2(3)))^0.5;

    a1=atand(n1(1)/n1(2));
    n3=rotationmatrix(0 0 -a1);
    n3=n3*n1;

    a2=atand(n3(3)/n3(1));
    n4=rotationmatrix(0 -a2 0);
    n3=n4*n3;

    a3=atand(n3(3)/n3(1));
    n4=rotationmatrix(-a3 0 0);
    n3=n4*n3;
    
    
    b1=atand(n1(1)/n1(2));
    n3=rotationmatrix(0 0 -b1);
    n3=n3*n1;

    a2=atand(n3(3)/n3(1));
    n4=rotationmatrix(0 -a2 0);
    n3=n4*n3;

    a3=atand(n3(3)/n3(1));
    n4=rotationmatrix(-a3 0 0);
    n3=n4*n3;
    a=1*(a2-a1);
    b=1*(b2-b1);
    c=-1*(c2-c1);

    RM=[1 0 0; 0 cosd(a) -1*sind(a); 0 sind(a) cosd(a)]*[cosd(b) 0 sind(b);0 1 0;-1*sind(b) 0 cosd(b)]*[cosd(c) -1*sind(c) 0; sind(c) cosd(c) 0;0 0 1];
%     

end