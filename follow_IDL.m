
% datadir='G:\experiments_2017\pillars5\5\170406-19.41\';
% test=0;
fwild='*.png';
imgnames=dir([datadir,fwild]);
nimg=length(imgnames);
if isempty(imgnames)
    fwild='*.tiff';
    imgnames=dir([datadir,fwild]);
    nimg=length(imgnames);
end

%textname=dir([datadir,'*frametimes.txt']);

% [a1 a2 V a4] = textread([datadir,'frametimes.txt'],'%12s%11s%f%2s','delimiter','\n');
% file=readtable([datadir,'frametimes.txt'],'Delimiter',' ','ReadVariableNames',false);
% timer=dtstr2dtnummx(file.Var1, 'HH:mm:ss.SSS');
% T=24*60*60*(timer-timer(1,1));
%textname=dir([datadir,'*frametimes.txt']);
%T=load([datadir,textname.name]);
%V=file.Var4;
T=0:1/fps:(nimg-1)/fps;
V=zeros(length(T),1);
% T=T-T(1);
%
% for i=1:length(T)-1
%    if T(i+1)<T(i)
%        T(i+1:end)=T(i+1:end)+65536;
%    end
% end



% T=load([datadir,'T.txt']);
% V=load([datadir,'V.txt']);
% T=timer-timer(1,1);
% V=zeros(length(T),1);
save([datadir,'T.txt'],'T','-ascii');
save([datadir,'V.txt'],'V','-ascii');


XYVT=[];


if length(T)<nimg
    nimg=length(T);
end
nim=200;
num=floor(nimg/nim);
for i=1:num*nim
    if mod(i-1,nim)==0
        medcalc;
    end
    
    img=imread([datadir,imgnames(i).name]);
    if length(img(1,1,:))>1
        img=img(:,:,1);
    end
    img=double(img);
    
    %   imagesc(img)
    %   colormap bone;
    %   ginput(1)
    %   claheI = adapthisteq(img./255,'NumTiles',[10 10]);
    %   img = imadjust(claheI);
    %img=rgb2gray(img);
    %
    
    t=T(i);
    v=V(i);
    
    %   imagesc(img./255)
    %   ginput(1)
    
    %img=img./255;
    %img2=bpass((img-bg)./255,1,5);
    %img2=1-(img-bg)./255;
    %    img2=(img-bg)./255;
    %   imagesc(img2)
    %   ginput(1)
    %
    %C=pkfnd(img2,1.2,6);
    markcorrbubble2;
    %cnt=cntrd(img,pk,15);
    
    %   hold on
    %   plot(pk(:,1),pk(:,2),'r+');
    %   hold off
    %   ginput(1)
    
    %   markcorrbubble2;
    %   pause(0.01);
    %
    if length(C)>0
        XYVT=[XYVT;[C,v(ones(size(C,1),1)),t(ones(size(C,1),1))]];
    end
    
    if test==1
        imagesc(aa); colormap bone;
        %ginput(1);
        daspect([1 1 1]);
        if ~isempty(C)
            hold on; plot(C(:,1),C(:,2),'ro'); ginput(1);
        end
    end
    fprintf(1,'%i=%i ',i,size(C,1));
    
    if mod(i,10) == 0 fprintf(1,'\n'); end
    %
    %   if (i==1)&&(test==0)
    %       h=figure('units','normalized','outerposition',[0 0 1 1])
    %       imagesc(img-bg); colormap bone;
    %       hold on;
    %       plot(C(:,1),C(:,2),'r+')
    %       hold off
    %       F = getframe;
    %       imwrite(F.cdata, [datadir,['Centers','.jpg']],'jpg');
    %   end
end
%plotXYIT;

fid = fopen([datadir,'centers_IDL.dat'],'wt');
for j=1:size(XYVT,1)
    fprintf(fid,'%f %f %f %f\n',XYVT(j,:));
end
fclose(fid);


