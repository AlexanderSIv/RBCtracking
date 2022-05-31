
tot=[];
kk=0;
for ii=i:20:min(nimg,(nim+i))
    img=imread([datadir,imgnames(ii).name]);
%     claheI = adapthisteq(img./255,'NumTiles',[10 10]);
%   img = imadjust(claheI);
    %img=imadjust(img./255);
    %img=rgb2gray(img);
    if length(img(1,1,:))>1
        img=img(:,:,1);
    end
    img=double(img);
    %img=img(:,:,2);
    kk=kk+1;
  tot(:,:,kk) = img;
 
  fprintf(1,'%i ',ii);
  if mod(ii-i+1,20)==0 fprintf(1,'\n'); end
end
if ~isempty(tot)
    [aa,ol]=min(abs(diff(tot,[],3)),[],3);
    bg=[];
    for ii=1:size(tot,1);
        for jj=1:size(tot,2)
            bg(ii,jj)=tot(ii,jj,ol(ii,jj));
        end
    end
    bg1=max(tot,[],3);
    mn=mean(tot,3);
end
bg=bg;
clear tot;
clear aa;
clear ol;