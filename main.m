clear all;
clc;
% imagesc(aa) дл€ настройки
VideoL=500;%длина видео с траектори€ми
test=0;
start_num=1; %номер видео, с которого начинаем обработку
RAD=100; %радиус поиска траектории
fps=100;
differ=-0.05; %отличие от фона
minAccArea=50; %минимальна€ площадь клетки
folderDepth = 3; %сколько папок мы используем в названии файла
savefolderDeph=2; %как по какой папке мы называем папку с готовыми данными
dateordata=0; %0, если надо сохранить в папку с названием данных, 1 если в папку с сегодн€шней датой
lentraj=15; %минимальна€ длина траектории дл€ подсчета
datadir0=readcell('datadir.txt');
concentrDeph=1; %как глубоко лежит название образца

%savefolderName=[];
if dateordata==0
    flipPath = flip(datadir0{1});
    deph = 0;
    curd = 1;
    curs=1;
    while (true)
        if (flipPath(curd+1) == '\')
            deph = deph + 1;
            if (deph > savefolderDeph)
                break;
            end
        elseif deph == savefolderDeph
            savefolderName(curs) = flipPath(curd+1);
            curs = curs + 1;
        end
        curd=curd+1;
    end
    savefolderName = flip(savefolderName);
    mkdir(savefolderName);
    disp(savefolderName);
else
    savefolderName=date; %итоговые файлы с данными будут сохран€тьс€ в подпапку с сегодн€шней датой
    mkdir(savefolderName);
end

currentfolder=pwd;
%savedir=strcat(currentfolder,'\',savefolderName,'\');


notdatadir=[];
notdatadir{1}='D:\RBC\Microchannels\1.5 mcm\tBh\2021_12_03_MIV_6h\tBH 0.7\tot_files';
% notdatadir{2}='D:\RBC\Microchannels\Oldchip_1.5um\2021_09_24\tBH 0.5\tot_0.5_files';
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



%pointsw = zeros(2, length(datadir0), 2);
% for num_dirr=start_num:1:length(datadir0)
%     if dirflag(num_dirr)
%         datadir=strcat(datadir0{num_dirr},'\');
%         format='*.png';
%         imagesnames=dir([datadir,format]);
%         frame=imread([datadir,imagesnames(1).name]);
%         imshow(frame);
%         [x, y] = ginput(2);
%         pointsw(1, num_dirr, 1) = x(1);
%         pointsw(2, num_dirr, 1) = y(1);
%         pointsw(1, num_dirr, 2) = x(2);
%         pointsw(2, num_dirr, 2) = y(2);
%     end
% end

points1=dlmread('points1.txt');
points2=dlmread('points2.txt');

% datadir_save='F:\pillars\human\200 um\final_data_pillars_200um\';
for num_dir=start_num:1:length(datadir0)
    if dirflag(num_dir)
        savedir=strcat(currentfolder,'\',savefolderName);
        datadir=strcat(datadir0{num_dir},'\')
        disp(strcat('Dir number:',num2str(num_dir)));
        flipPathh = flip(datadir);
        deph = 0;
        curd = 1;
        curs=1;
        while (true)
            if (flipPathh(curd+1) == '\')
                deph = deph + 1;
                if (deph > concentrDeph)
                    break;
                end
            elseif deph == concentrDeph
                saveffolderName(curs) = flipPathh(curd+1);
                curs=curs+1;
            end
            curd = curd + 1;
        end
        saveffolderName = flip(saveffolderName);
        disp(saveffolderName);
        oldd=cd(savedir);
        %if ~exist(saveffolderName, 'dir')
        mkdir(saveffolderName);
        %end
        cd(oldd);
        savedir=strcat(savedir,'\',saveffolderName,'\');
        points(1,1)=points1(num_dir,1);
        points(1,2)=points1(num_dir,2);
        points(2,1)=points2(num_dir,1);
        points(2,2)=points2(num_dir,2);
        follow_IDL;
        if ~isempty(XYVT)
            tracking;
            %traj_connection;
            Video_traj_long_pic;
            V_accum;
            ImageMicroChannelCellDetector_v3(datadir, points, savedir, folderDepth, fps);
        else
            differ=-differ;
            follow_IDL;
            if ~isempty(XYVT)
                tracking;
                %traj_connection;
                Video_traj_long_pic;
                V_accum;
                ImageMicroChannelCellDetector_v3(datadir, points, savedir, folderDepth, fps);
            else
                errMsg=strcat('No cells found in ',datadir);
                disp(errMsg);
            end
            differ=-differ;
        end
        clear saveffolderName;
    end
    close all;
end
