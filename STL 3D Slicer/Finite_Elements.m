function T = Finite_Elements(model, direction, num, limits, LOI)
    
    %AFS Sand Density
    density = 2.5e-6; %kg / mm3

    Sl_no = (1:num)';
    Percentage = (linspace(limits(1), limits(end), num))';
    
    if ~exist("limits","var")
        limits = [0 100];
    end
    
    if ~exist("LOI","var")
        LOI = 1.5;
    end
    
    if ~exist("num","var")
        num = 950;
    end
    
    a = model.Points(:, direction);
    mini = min(a(:,3));
    maxi = max(a(:,3));
    
    Height = mini + Percentage*0.01*(maxi-mini);
    
    Area = Height*0;
    Perimeter = Height*0;
    Area_core = Height*0;
    Perimeter_core = Height*0;
    
    for i=1:length(Percentage)

        [a, p, ac, pc] = ap(model, direction, Percentage(i), 'percentage');
        Area(i) = a;
        Perimeter(i) = p;
        Area_core(i) = ac;
        Perimeter_core(i) = pc;

    end
    
    Time = Height*0 - 1;

    Height = Height - min(Height);
    Perimeter_Mold = Perimeter - Perimeter_core;
    Volume = Height*0 - 1;
    
    dh = Height(2) - Height(1);
    Volume(1) = 0;

    for i=2:length(Height)

        Volume(i) = Volume(i-1) + dh*(Area(i-1)+Area(i))*0.5;

    end

    Unit_Flowrate_velocity = 1 ./ Area;
    Time = Volume;

    Acceleration = Time*0;
    
    for i = 2:(length(Time)-1)
        Acceleration(i) = (Unit_Flowrate_velocity(i+1) - Unit_Flowrate_velocity(i-1)) / (Time(i+1) - Time(i-1));
    end
    
    Acceleration(end) = (Unit_Flowrate_velocity(end) - Unit_Flowrate_velocity(end-1)) / (Time(end) - Time(end-1));
    Mass_Core = density * Area_core * dh;
    Gas_Available_core = Mass_Core*LOI*0.01;

    T = table(Sl_no, Percentage, Height, Area, Area_core, Perimeter, Perimeter_Mold, Perimeter_core, Volume, Mass_Core, Gas_Available_core, Unit_Flowrate_velocity, Acceleration, Time);
    
end






function [Area, Perimeter, Area_core, Perimeter_core] = ap(model, direction, z_slice, type)
    
    a = model.Points(:, direction);
    m = model.ConnectivityList;
    mini = min(a(:,3));
    maxi = max(a(:,3));

    if ~exist("type","var")
        type = "number";
    end

    if type =="percentage"
        z_slice(z_slice>=99.999) = 99.9999;
        z_slice(z_slice<=0.001) = 0.0001;
        z_slice = mini + z_slice*0.01*(maxi-mini);
    end

%     if type == "number"
%         z_slice(z_slice>=(maxi - (maxi-mini)/10000)) = maxi - (maxi-mini)/10000;
%         z_slice(z_slice<=(mini + (maxi-mini)/10000)) = mini + (maxi-mini)/10000;
%     end
    
    edges = boundary_vertices(m,a,z_slice);
    [verts,edgec] = edges2vertices(edges);
    [~, edgec]=merge_duplicates(edgec,verts,0);
    tt=find_loops(edgec);
    [Area,Perimeter,Area_core,Perimeter_core] = loop_area_perimeter(tt, verts);
    

end

