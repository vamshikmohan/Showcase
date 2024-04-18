function [camber,Toe,Castor,KingPIN,StrutLEN,LowerArmAngle,MotionRatioo] = Front_Susp_Parameters(ChassiHP,StrutIn,KnuckleHP,TieRodIn,z,delx,n_points)

if ~exist('n_points','var')
    n_points=15;
    if length(z)>=2
        n_points=length(z);
    end

end

if ~exist('delx','var')
    delx=0;
end

z=linspace(min(z),max(z),n_points);
StrutLength=zeros(length(z),1);

[c,t,cs,kp,sl,laa] = OP_Param(ChassiHP,StrutIn,KnuckleHP,TieRodIn,0,delx);
   cmin=double(c);
   cmax=double(c);

   tmin=(t);
   tmax=(t);

   csmin=(cs);
   csmax=(cs);

   kpmin=kp;
   kpmax=kp;

   slmin=sl;
   slmax=sl;

   laamin=laa;
   laamax=laa;

for i=1:length(z)
   [c,t,cs,kp,sl,laa] = OP_Param(ChassiHP,StrutIn,KnuckleHP,TieRodIn,z(i),delx);
   cmin(c<cmin)=double(c);
   cmax(c>cmax)=double(c);

   tmin(t<tmin)=t;
   tmax(t>tmax)=t;

   csmin(cs<csmin)=cs;
   csmax(cs>csmax)=cs;

   kpmin(kp<kpmin)=kp;
   kpmax(kp>kpmax)=kp;

   slmin(sl<slmin)=sl;
   slmax(sl>slmax)=sl;

   laamin(laa<laamin)=laa;
   laamax(laa>laamax)=laa;

   StrutLength(i)=sl;
end

MotionRatio=z;
MotionRatio(1)=abs((StrutLength(2)-StrutLength(1))/(z(2)-z(1)));
for i=2:(length(z)-1)
    MotionRatio(i)=abs((StrutLength(i+1)-StrutLength(i-1))/(z(i+1)-z(i-1)));
end
MotionRatio(end)=abs((StrutLength(end)-StrutLength(end-1))/(z(end)-z(end-1)));

[c,t,cs,kp,sl,laa] = OP_Param(ChassiHP,StrutIn,KnuckleHP,TieRodIn,0,delx);

camber=double([cmin,c,cmax]);
Toe=[tmin,t,tmax];
Castor=[csmin,cs,csmax];
KingPIN=[kpmin,kp,kpmax];
StrutLEN=[slmin,sl,slmax];
LowerArmAngle=[laamin,laa,laamax];
MotionRatioo=[min(MotionRatio),mean(MotionRatio),max(MotionRatio)];


end