function output = Parametric_Output_FUNCTION(T,n_points,long_front_dir,lateral_side)
    
    if ~exist('n_points','var')
        n_points=15;
    end

    ChassiHP = [table2array(T(1,2:4));table2array(T(1,5:7));table2array(T(1,8:10));table2array(T(1,11:13))];
    StrutIn = [table2array(T(1,14:16));table2array(T(1,17:19))];
    KnuckleHP = [table2array(T(1,20:22));table2array(T(1,23:25))];
    TieRodIn = [table2array(T(1,26:28));table2array(T(1,29:31))];
    z = [table2array(T(1,32));table2array(T(1,33))];
    delx = table2array(T(1,34));
    Sl_no = table2array(T(1,1));
    
    if exist("long_front_dir",'var') && exist("lateral_side",'var')

        [Rotation,FLIP]=Rotation_FLIP(long_front_dir,lateral_side);
        ChassiHP=RZ(ChassiHP,Rotation,FLIP);
        StrutIn=RZ(StrutIn,Rotation,FLIP);
        KnuckleHP=RZ(KnuckleHP,Rotation,FLIP);
        TieRodIn=RZ(TieRodIn,Rotation,FLIP);
        
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
MotionRatioo=[min(MotionRatio),mean(MotionRatio),max(MotionRatio)];

output = [Sl_no, camber, -1*tmin,-1*t,-1*tmax, -1*csmin,-1*cs,-1*csmax, kpmin,kp,kpmax, slmin,sl,slmax, laamin,laa,laamax, MotionRatioo];

end