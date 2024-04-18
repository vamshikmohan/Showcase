function Plot_Suspension(ChassiHP,Knuckle,Strut,Tierod,TitleName,colour,WheelDirection)

    if ~exist("colour","var")
        colour='blue';
    end
    
    plotline([ChassiHP(1,:);Knuckle(1,:);ChassiHP(2,:)],'r');
    hold on
    plotline([ChassiHP(3,:);Knuckle(2,:);ChassiHP(4,:)],colour);
    plotline(Knuckle,colour);
    plotline(Strut,colour);
    plotline([ChassiHP(1,:);ChassiHP(2,:);ChassiHP(4,:);ChassiHP(3,:);ChassiHP(1,:)],colour)

    axis("equal")
    xlabel("X");
    ylabel("Y");
    zlabel("Z");
    
    if exist("TitleName","var")
        title(TitleName)
    end
%     
%     xlim([-700 100])
%     ylim([-1000 -600])
%     zlim([0 1000])

    if exist("Tierod","var")
            plotline([Tierod(1,:);Tierod(2,:);((Knuckle(1,:)+Knuckle(2,:))/2)],colour)
            plotline([Tierod(1,:);0,Tierod(1,2),Tierod(1,3)],'yellow')
    end
    
    if exist("WheelDirection","var")
        plotline(WheelDirection,'magenta')
    end


    hold off
end