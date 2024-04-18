function [Area, Perimeter, Area_core, Perimeter_core] = loop_area_perimeter(tt, verts)
    
    [x,y] = polyshapee(tt,verts);
    sol_holo = rem(within_num_loops(tt,verts),2);
    sol_holo(sol_holo==0)=-1;

    Area = 0;
    Area_core = 0;
    Perimeter = 0;
    Perimeter_core = 0;

    for i=1:length(tt)
        Area = Area - sol_holo(i)*polyarea(x{i},y{i});

        if sol_holo(i)==1
            Area_core = Area_core + polyarea(x{i},y{i});
            Perimeter_core = Perimeter_core + perimeterf(x{i},y{i});
        end

        Perimeter = Perimeter + perimeterf(x{i},y{i});
    end
    

end