function [Knuckle,Strut] = Lotus_AARM(z,ChassiHP,KnuckleHP,StrutIn)

%Chassi HPs include the points in order [[upper forward];[upper
%rear];[lower forward];[lower rear]]

%Knuckle HPs include points in order [[upper Knuckle point];[Lower knuckle
%Point]];

%Strut Points are [[Upper mounting point];[lower mounting point]];


xu1=ChassiHP(1,1);
yu1=ChassiHP(1,2);
zu1=ChassiHP(1,3);
xu2=ChassiHP(2,1);
yu2=ChassiHP(2,2);
zu2=ChassiHP(2,3);

xl1=ChassiHP(3,1);
yl1=ChassiHP(3,2);
zl1=ChassiHP(3,3);
xl2=ChassiHP(4,1);
yl2=ChassiHP(4,2);
zl2=ChassiHP(4,3);

xm=StrutIn(1,1);
ym=StrutIn(1,2);
zm=StrutIn(1,3);

xp0=KnuckleHP(1,1);
yp0=KnuckleHP(1,2);
zp0=KnuckleHP(1,3);

z=z+zp0;

xq0=KnuckleHP(2,1);
yq0=KnuckleHP(2,2);
zq0=KnuckleHP(2,3);

xr0=StrutIn(2,1);
yr0=StrutIn(2,2);
zr0=StrutIn(2,3);


l1=((xp0-xu1)^2+(yp0-yu1)^2+(zp0-zu1)^2)^0.5;
l2=((xp0-xu2)^2+(yp0-yu2)^2+(zp0-zu2)^2)^0.5;
l3=((xq0-xl1)^2+(yq0-yl1)^2+(zq0-zl1)^2)^0.5;
l4=((xq0-xl2)^2+(yq0-yl2)^2+(zq0-zl2)^2)^0.5;
l=((xq0-xp0)^2+(yq0-yp0)^2+(zq0-zp0)^2)^0.5;

r1=((xr0-xp0)^2+(yr0-yp0)^2+(zr0-zp0)^2)^0.5;
r2=((xr0-xu1)^2+(yr0-yu1)^2+(zr0-zu1)^2)^0.5;
r3=((xr0-xu2)^2+(yr0-yu2)^2+(zr0-zu2)^2)^0.5;

zp=z;

    syms xp yp xq yq zq xr yr zr;
    eqns=[(xp-xu1)^2+(yp-yu1)^2+(zp-zu1)^2==l1*l1;
          (xp-xu2)^2+(yp-yu2)^2+(zp-zu2)^2==l2*l2;
          (xq-xl1)^2+(yq-yl1)^2+(zq-zl1)^2==l3*l3;
          (xq-xl2)^2+(yq-yl2)^2+(zq-zl2)^2==l4*l4;
          (xq-xp)^2+(yq-yp)^2+(zq-zp)^2==l*l];
    
    vars=[xp,yp,xq,yq,zq];
    
    [xp1,yp1,xq1,yq1,zq1] = solve(eqns,vars);
    xp1 = double(xp1);
    yp1 = double(yp1);
    xq1 = double(xq1);
    yq1 = double(yq1);
    zq1 = double(zq1);
    
    xp2=xp1(1);
    yp2=yp1(1);
    zp2=z;
    xq2=xq1(1);
    yq2=yq1(1);
    zq2=zq1(1);
    
    for i=1:length(xp1)
        if zq1(i)<zp && xp1(i)<xu1 && xp1(i)<xu2
            xp2=xp1(i);
            yp2=yp1(i);
            xq2=xq1(i);
            yq2=yq1(i);
            zq2=zq1(i);
        end


    end
    Knuckle=double([([xp2,yp2,z]);([xq2,yq2,zq2])]);

    eqns1=[(xr-xp2)^2+(yr-yp2)^2+(zr-zp2)^2==r1*r1;
           (xr-xu1)^2+(yr-yu1)^2+(zr-zu1)^2==r2*r2;
           (xr-xu2)^2+(yr-yu2)^2+(zr-zu2)^2==r3*r3];

    vars1=[xr,yr,zr];

    [xr1,yr1,zr1]=(solve(eqns1,vars1));
 
    xr2=xr1(1);
    yr2=yr1(1);
    zr2=zr1(1);
    for i=1:length(xr1)
        if xr1(i)>xu1 && zr1(i)<zm && zr1(i)>zq2 && xr1(i)>xp2
            xr2=xr1(i);
            yr2=yr1(i);
            zr2=zr1(i);
        end
    end

    Strut=double([xm,ym,zm;xr2,yr2,zr2]);

end