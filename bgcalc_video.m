xyloObj = VideoReader([datadir,movnames(1).name]);
nimg = xyloObj.NumberOfFrames;
sizey = xyloObj.Height;
sizex = xyloObj.Width;
xs=sizex;
ys=sizey;
mov = struct('cdata', zeros(sizey, sizex, 3, 'uint8'),'colormap', []);

bg=0;

%nimg=600;
for i=1:nimg
    %img=imread([datadir,imgnames(i).name]);
    mov.cdata = read(xyloObj, i);
    img=mov.cdata;
    img=double(img(:,:,1));
    bg=bg+double(img); %/nimg;
      if mod(i,10)==0;
      fprintf(1,'%i ',i);
  end
   if mod(i,200)==0 fprintf(1,'\n');end;
end;
 bg=bg/nimg;