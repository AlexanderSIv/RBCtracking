datadir0=readcell('datadir.txt');

notdatadir=[];
notdatadir{1}='D:\RBC\Microchannels\1.5 mcm\tBh\2021_12_03_MIV_6h\tBH 0.7\tot_files';
%notdatadir{2}='D:\RBC\Microchannels\Oldchip_1.5um\2021_09_24\tBH 0.5\tot_0.5_files';
% notdatadir{3}='D:\RBC\Microchannels\3 mcm\2020_09_20\1.5\1.5_tot_files';
% notdatadir{4}='D:\RBC\Microchannels\3 mcm\2020_09_20\2.0\2_tot_files';
% notdatadir{5}='D:\RBC\Microchannels\3 mcm\2020_09_20\control\c0n_tot_files';


for idd=1:1:length(datadir0)
    dirflag(idd)=true;
    for jdd=1:1:length(notdatadir)
        if dirflag(idd) && ~strcmp(notdatadir{jdd}, datadir0{idd})
            dirflag(idd)=true;
        else
            dirflag(idd)=false;
        end
    end
end
for num_dirr=1:1:length(datadir0)
    if dirflag(num_dirr)
        datadir=strcat(datadir0{num_dirr},'\');
        format='*.png';
        imagesnames=dir([datadir,format]);
        frame=imread([datadir,imagesnames(1).name]);
        imshow(frame);
        [x, y] = ginput(2);
        points1(num_dirr,1) = x(1);
        points1(num_dirr,2) = y(1);
        points2(num_dirr,1) = x(2);
        points2(num_dirr,2) = y(2);
        disp(num_dirr);
    end
end
dlmwrite('points1.txt', points1, '\t')
dlmwrite('points2.txt', points2, '\t')