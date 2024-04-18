function f = finterp(f1, X, Y, curve)

    x = X(1,:);
    y = Y(:,1)';
    
    x1 = curve(:,1)';
    y1 = curve(:,2)';
    f = x1;
    
    dx = x(2) - x(1);
    dy = y(2) - y(1);
    
    for i  = 1:length(x1)
    
    ng_x = floor((x1(i)-x(1))/dx)+1;
    ng_y = floor((y1(i)-y(1))/dy)+1;
    
    if x1(i)<x(2) || x1(i)>(x(end-1)) || y1(i)<y(2) || y1(i)>y(end-1)
    
    f(i) = f1(ng_y, ng_x);

    else

    w11 = (x(ng_x+1) - x1(i))*(y(ng_y+1) - y1(i));
    w12 = (x(ng_x+1) - x1(i))*(y1(i) - y(ng_y));
    w21 = (x1(i) - x(ng_x))*(y(ng_y+1) - y1(i));
    w22 = (x1(i) - x(ng_x))*(y1(i) - y(ng_y));

    f(i) = (w11*f1(ng_y,ng_x) + w12*f1(ng_y+1,ng_x) + w21*f1(ng_y,ng_x+1) + w22*f1(ng_y+1,ng_x+1))/(dx*dy);
    
    end

    end
    
end