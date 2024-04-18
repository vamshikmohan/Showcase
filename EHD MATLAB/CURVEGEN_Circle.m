function curve = CURVEGEN_Circle(x1,y1,r,n_res)
    
    theta = linspace(pi/2.5, (2+1/2.5)*pi, n_res);
    circle_x = x1 + r * cos(theta);
    circle_y = y1 + r * sin(theta);
    curve = [circle_x',circle_y'];

end