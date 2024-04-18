function [Camber,Toe,Castor,Kingpin,StrutLength1,LowerArmAngle] = OP_Param(ChassiHP,StrutIn,KnuckleHP,TieRodIn,z,delx)


[Knuckle,Strut] = (Lotus_AARM(z,ChassiHP,KnuckleHP,StrutIn));
[~,WheelCenter,~] = (Lotus_TieROD(TieRodIn,KnuckleHP,Knuckle,delx));

%Calculations
Camber=-1*atand((WheelCenter(2,3)-WheelCenter(1,3)) / (WheelCenter(1,1)-WheelCenter(2,1)));
Toe=-1*atand((WheelCenter(1,2)-WheelCenter(2,2)) / (WheelCenter(1,1)-WheelCenter(2,1)));
Castor=-1*atand( (Knuckle(1,2)-Knuckle(2,2)) / (Knuckle(1,3)-Knuckle(2,3)) );
% S=(Knuckle(1,:)-Knuckle(2,:));
% Castor=acosd(sum(S.*[0 0 1]) / ((S(1)^2 + S(2)^2 + S(3)^2)^0.5));
Kingpin=atand( (Knuckle(1,1)-Knuckle(2,1)) / (Knuckle(1,3)-Knuckle(2,3)) );

S=Strut(1,:)-Strut(2,:);
StrutLength1 = StrutLength(Strut);

LowerArmAngle=atand((ChassiHP(3,3)-Knuckle(2,3))/(ChassiHP(3,1)-Knuckle(2,1)));  

end