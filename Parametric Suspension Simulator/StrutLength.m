function [Strut_Length, Strut_Angle] = StrutLength(Strut)

    Strut_Length=(Strut(1,1)-Strut(2,1))^2 + (Strut(1,2)-Strut(2,2))^2 + (Strut(1,3)-Strut(2,3))^2;
    Strut_Length=double(Strut_Length^0.5);
    Strut_Vector=[(Strut(1,1)-Strut(2,1)),(Strut(1,2)-Strut(2,2)),(Strut(1,3)-Strut(2,3))];
    vertical=[0,0,1];
    dotprod=Strut_Vector.*vertical;

    Strut_Angle=double(acosd((sum(dotprod))/Strut_Length));

end