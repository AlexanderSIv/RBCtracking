

%


%
C=[];


% filterp_narrow_channels;
filterp;
[labeled,numobjects]=bwlabel(bw,8);
data=regionprops(labeled,'basic');
% idx = find([data.Area] > 85);
% BW2 = ismember(labelmatrix(labeled), idx);
%j=1;
% for i=1:1:numobjects
%     if idx(j)==i
%         xyc(:,i)= data(i).Centroid;
%         j=j+1;
%         if j>length(idx)
%             break;
%         end
%     end
% end
trigger=false;
xyc=[];
kobj=1;
for il=1:1:numobjects
    %coord=data(i).Centroid;
    %    if data(i).Area>minAccArea && coord(1)>points(1,1) && coord(1)<points(2,1) && coord(2)<points(1,2) && coord(2)>points(2,2)
    if data(il).Area>minAccArea
        xyc(:,kobj)= data(il).Centroid;
        kobj=kobj+1;
        %isAnycell=true;
        trigger=true;
    end
end
%xyc=[data.Centroid];
% xyc=reshape(xyc,2,length(xyc)/2);
if trigger
    xc=xyc(1,:); yc=xyc(2,:);
    
    % gcol='rgbycmrgbycm'; gsym='++++++xxxxxx';
    
    %   if test==1
    %   imagesc(img-bg); colormap bone;
    %   ginput(1);
    %   daspect([1 1 1]);
    %   hold on; plot(xc,yc,'r+'); ginput(1);
    
    %   imagesc(img-bg); colormap bone;
    %   daspect([1 1 1]);
    %   hold on; ginput(1);
    
    %   end;
    C=[C;[xc',yc']];
end



