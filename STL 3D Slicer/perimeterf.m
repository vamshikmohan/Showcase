function Perimeter = perimeterf(x,y)
    
    Perimeter=0;
    for i=1:(length(x)-1)
        Perimeter = Perimeter + ((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2)^0.5;
    end

end