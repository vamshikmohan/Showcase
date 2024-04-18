function [TieRod,WheelDirection,KnuckleCentre] = Lotus_TieROD(TieRodIn,KnuckleHP,Knuckle,delx,WheelNormalIn)
    
    %TieRod include the points in order [[Body End];[Knuckle End]]


    if ~exist('WheelNormalIn','var')
        WheelNormalIn=[-100 0 0];
    end

    xm0=TieRodIn(1,1);
    ym0=TieRodIn(1,2);
    zm0=TieRodIn(1,3);
    
    xp0=KnuckleHP(1,1);
    yp0=KnuckleHP(1,2);
    zp0=KnuckleHP(1,3);
    
    xq0=KnuckleHP(2,1);
    yq0=KnuckleHP(2,2);
    zq0=KnuckleHP(2,3);
    
    xr0=TieRodIn(2,1);
    yr0=TieRodIn(2,2);
    zr0=TieRodIn(2,3);

    l1=((xp0-xr0)^2+(yp0-yr0)^2+(zp0-zr0)^2)^0.5;
    l2=((xq0-xr0)^2+(yq0-yr0)^2+(zq0-zr0)^2)^0.5;
    l3=((xm0-xr0)^2+(ym0-yr0)^2+(zm0-zr0)^2)^0.5;

    WN=([xp0+xq0,yp0+yq0,zp0+zq0]*0.5) + WheelNormalIn;
    xr01=WN(1);
    yr01=WN(2);
    zr01=WN(3);
    
    l10=((xp0-xr01)^2+(yp0-yr01)^2+(zp0-zr01)^2)^0.5;
    l20=((xq0-xr01)^2+(yq0-yr01)^2+(zq0-zr01)^2)^0.5;
    l30=((xr0-xr01)^2+(yr0-yr01)^2+(zr0-zr01)^2)^0.5;
    
    xp0=Knuckle(1,1);
    yp0=Knuckle(1,2);
    zp0=Knuckle(1,3);
    
    xq0=Knuckle(2,1);
    yq0=Knuckle(2,2);
    zq0=Knuckle(2,3);

    dx=delx;

    syms xr yr zr
    eqns=[((xp0-xr)^2+(yp0-yr)^2+(zp0-zr)^2==l1*l1);
          ((xq0-xr)^2+(yq0-yr)^2+(zq0-zr)^2==l2*l2);
          (((xm0 + dx)-xr)^2+(ym0-yr)^2+(zm0-zr)^2==l3*l3)];
    
    vars=[xr,yr,zr];
    
    [xr1,yr1,zr1]=solve(eqns,vars);

    for i=1:length(xr1)
        if yr1(i)<((yp0+yq0)/2) 
            xr2=xr1(i);
            yr2=yr1(i);
            zr2=zr1(i);
        end
    end

    KnuckleCentre=double([(xp0+xq0),(yp0+yq0),(zp0+zq0)]*0.5);
    TieRod=double([(xm0+dx),ym0,zm0; xr2, yr2, zr2]);

    %%Wheel Normal Calculation
    

    eqns=[((xp0-xr)^2+(yp0-yr)^2+(zp0-zr)^2==l10*l10);
      ((xq0-xr)^2+(yq0-yr)^2+(zq0-zr)^2==l20*l20);
      ((xr2-xr)^2+(yr2-yr)^2+(zr2-zr)^2==l30*l30)];
    
    vars=[xr,yr,zr];
    
    [xr1,yr1,zr1]=solve(eqns,vars);

    for i=1:length(xr1)
        if xr1(i)<((xp0+xq0)/2) 
            xr2=xr1(i);
            yr2=yr1(i);
            zr2=zr1(i);
        end
    end
   
    WheelDirection=double([KnuckleCentre;xr2,yr2,zr2]);

end