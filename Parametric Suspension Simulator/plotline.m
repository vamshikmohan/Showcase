function plotline(A,colour)

    x=zeros(1,height(A));
    y=zeros(1,height(A));
    z=zeros(1,height(A));
    
    for i=1:height(A)
        x(i)=A(i,1);
        y(i)=A(i,2);
        z(i)=A(i,3);
    end

    if ~exist("colour","var")
        colour='blue';
    end
    
    plot3(x,y,z,'-o','Color',colour,'MarkerFaceColor','green')

end

