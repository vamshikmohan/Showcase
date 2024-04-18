function [Rotation,Flip_Axis] = Rotation_FLIP(Current_Direction,Left_Right)
cd=Current_Direction;

if ~exist('Left_Right','var')
    Left_Right="Right";
end

if cd =="+x" || cd=='x'
    rz=-90;
elseif cd=="-x"
    rz=90;
elseif cd=="+y" || cd=='y'
    rz=180;
elseif cd=="-y"
    rz=0;
else
    rz="INVALID DIRECTION"
end

if Left_Right=="Left" || Left_Right=="LEFT" || Left_Right=="left" || Left_Right=='l'
    if cd=='x' || cd=="-x" || cd=="+x"
        Flip_Axis='x';
    elseif cd=='y' || cd=="+y" || cd=="-y"
        Flip_Axis='y';
    else
        Flip_Axis="INVALID SIDE"
    end
elseif Left_Right=="Right" || Left_Right=="RIGHT" || Left_Right=="right" || Left_Right=='r'
    Flip_Axis='o';
else
    Flip_Axis="INVALID SIDE"
end
Rotation=rz;

end
