logfilterpar=12;
sigma=2;
% noiseopenpar=1;
% thresholdpar=6;
aa=(img-bg)./255;

% if test==1
%     imagesc(aa);
%     ginput(1);
% end
if differ>=0
bw=(aa>differ);
else
    bw=(aa<differ);
end
%bw1=(aa>20);
% bw2=imdilate(aa<-15,strel('disk',2));
% bw1=imdilate(aa>25,strel('disk',2));
% bw=imclose((bw2+bw1)>0,strel('disk',2));
%a0=imfilter((img)-mean2((bg-img)),fspecial('average',3));
%
%a=imfilter((img-bg),fspecial('log',logfilterpar,sigma));
%
%
% imagesc(img-bg);
% ginput(1)
%bw=imclose(img-bg>30,strel('disk',3));

%bw=imopen(a>0.2,strel('disk',1));
% imagesc(bw);
% ginput(1);
%
bb=imfill(bw,'holes');
%bb=imopen(bb,strel('disk',1));
%bb=bwareaopen(bb,2);
% imagesc(bb);
% ginput(1);
%b1=bwareaopen(bb,10000);
% imagesc(b1);
% ginput(1);

%b2=bb-b1;

% imagesc(b2);
% ginput(1);
%b2=bwareaopen(b2,6);
%  bw=bb-b;
%  bw=bwareaopen(bw,1);
%b=imopen(a<thresholdpar,strel('disk',noiseopenpar));
%bw=img>180;
bw=imclearborder(bb);
% imagesc(bw);
% ginput(1);