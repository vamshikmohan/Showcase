function [Circle_1] = CRCL(centre,radius,n)

    if ~exist('n','var')
        n=12;
    end

    theta=0:360/n:360;
    Points=zeros(length(theta),3);

    for i=1:((length(theta)))
        Points(i,2)=sind(theta(i));
        Points(i,3)=cosd(theta(i));
    end

    Points=Points*radius;
    Shift=(zeros(length(theta),3));

    for i=1:((length(theta)))
        Shift(i,:)=centre;
    end

    Circle_1=Points+Shift;
        
end