
fwild='*.tiff';
imgnames=dir([datadir,fwild]);
nimg=length(imgnames);

bg=0;
nimg=length(imgnames);
nimg=100;
for i=1:nimg
    img=imread([datadir,imgnames(i).name]);
  
    bg=bg+double(img); %/nimg;
      if mod(i,10)==0;
      fprintf(1,'%i ',i);
  end
   if mod(i,200)==0 fprintf(1,'\n');end;
end;
 bg=bg/nimg;