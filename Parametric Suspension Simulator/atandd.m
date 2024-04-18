function [t] = atandd(x1,x2)

    if x1==0 && x2==0
        t=0;
    else
        t=atand(x1/x2);
    end

end