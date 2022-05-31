% clear all;
% clc;
clear mov2;

%  datadir='F:\pillars\human\100 um\pillars6_Ph\3\3\';

fwild='*.png';
imgnames=dir([datadir,fwild]);
nimg=length(imgnames);

% fwild='*.mov';
% movnames=dir([datadir,fwild]);
% nmov=length(movnames);


     
% xyloObj = VideoReader([datadir,movnames(1).name]);
% nimg = xyloObj.NumberOfFrames;
% sizey = xyloObj.Height;
% sizex = xyloObj.Width;
% xs=sizex;
% ys=sizey;
% mov = struct('cdata', zeros(sizey, sizex, 3, 'uint8'),'colormap', []);


%T=0:1/xyloObj.FrameRate:xyloObj.Duration;
T=load([datadir,'T.txt']);

if length(T)<nimg
    nimg=length(T);
end

traj_all=load([datadir,'traj_v_all_IDL.dat']);


T=round(T*1000)/1000;
traj_all(:,1)=round(traj_all(:,1)*1000)/1000;
traj_long=[];
for i=1:traj_all(end,7)
    index=find(traj_all(:,7)==i);
    traj=traj_all(index,:);
    if length(traj(:,1))>10
        V_mod=mean(sqrt(traj(:,4).^2+traj(:,5).^2));
        if V_mod>5e-3;
            
            traj_long=[traj_long;traj];
          
        end
    end
end

mov2=VideoWriter([datadir,'ex_switch_v2_test','.avi']);
open(mov2);
%mov2 = avifile([datadir,'ex_switch_v2','.avi'], 'fps',30);
scrsz = get(0,'ScreenSize');
figure('Units','normalized','Position',[0 0 1 1]) 

for i=1:min(VideoL,nimg)
%   mov.cdata = read(xyloObj, i);
%   img=mov.cdata;
%   img=double(img(:,:,1));
  img=imread([datadir,imgnames(i).name]);
  %img=rgb2gray(img);
  img=double(img);

  imagesc(img); colormap bone;
  hold on;
  
  
  index=find(traj_long(:,1)==T(i));
  if i>1
    traj_num_prev=unique(traj_plot(:,7));
    traj_plot=[traj_plot;traj_long(index,:)];
    traj_num=unique(traj_long(index,7));
    traj_del=setdiff(traj_num_prev,traj_num);
    if ~isempty(traj_del)
        for j=1:length(traj_del)
            index2=find(traj_plot(:,7)==traj_del(j));
            index3=find(traj_long(:,7)==traj_del(j));
            if traj_long(index3(end),1)<=T(i)
                traj_plot(index2,:)=[];
            end
        end
    end
  else
      traj_plot=traj_long(index,:);
  end
  plot(traj_plot(:,2),traj_plot(:,3),'r+');
  
  %ginput(1)
  F = getframe;
  writeVideo(mov2,F);
  %mov2 = addframe(mov2,F);
  hold off;
end
close(mov2); 

    