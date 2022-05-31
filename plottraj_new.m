function [TRAJ, TRAJ_V,TRI]=plottraj_new(XYIT,TAG,TRI)

gap=1;
%tri=0;
TRAJ=[];
TRAJ_V=[];
%tag=load([datadir,'tag.dat']);
for i=1:max(TAG)
   j=find(TAG==i);
 
   if (length(j)>(gap+1))% && (XYIT(j(1),4)~=XYIT(j(end),4))
       TRI=TRI+1;
       
       x=XYIT(j(1:end),1);
       y=XYIT(j(1:end),2);
       t=XYIT(j(1:end),4);
       Q=XYIT(j(1:end),3);
    
       VVx=diff(x)./diff(t);
       VVy=diff(y)./diff(t);
       TRAJ=[TRAJ;[XYIT(j,4),XYIT(j,1),XYIT(j,2),ones(length(j),1)*TRI]];
       TRAJ_V=[TRAJ_V;[t(2:end),x(2:end),y(2:end),VVx,VVy,Q(2:end),TRI*ones(length(x(2:end)),1)]];
        
        if mod(i,10)==0
      fprintf(1,'%i ',i);
  end
   %if mod(i,200)==0 fprintf(1,'\n');end;
  
   end
  
end
 fprintf(1,'\n')


%save([datadir,'traj_v.dat'],'TRAJ_V','-ascii');
%save([datadir,'trajsv.dat'],'TRAJ','-ascii');

