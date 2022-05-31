




%datadir='F:\AU\RBC\2020_08_13 RBC 1.5x200\2mM tBH\2nd channel_files\';
%folderDepth = 3; %сколько папок мы используем в названии файла
%lentraj=15; %минимальна€ длина траектории дл€ подсчета
% folderDate=date; %итоговые файлы с данными будут сохран€тьс€ в подпапку с сегодн€шней датой
% currtime=fix(clock);
% hr=currtime(4);
% minute=currtime(5);
% secu=currtime(6);
% Shr=num2str(hr);
% Sminute=num2str(minute);
% Ssecu=num2str(secu);
% Scurrtime=strcat(Shr,'-',Sminute,'-',Ssecu);
% Fname=strcat(folderDate,'-',Scurrtime);
C1=100; %FPS в предыдущей программе
% mkdir(Fname);
% currentfolder=pwd;
% savedir=strcat(currentfolder,'\',Fname,'\');
save_fname=[];
flipPath = flip(datadir);
count = 0;
iii = 1;
while (true)
    if (flipPath(iii+1) == '\')
        count = count + 1;
        if (count >= folderDepth)
            break;
        end
        save_fname(iii) = '_';
    else
        save_fname(iii) = flipPath(iii+1);
    end
    iii = iii + 1;
end
save_fname = flip(save_fname);
LData=load([datadir,'traj_v_all_IDL.dat']);
Vdata=[];
trcount=1;
Tr=zeros(max(LData(:,7)),1);
for b=1:1:max(LData(:,7))
    for b1=1:1:length(LData(:,1))
        if LData(b1,7)==b
            Tr(b)=Tr(b)+1;
        end
    end
end
for a=1:1:length(LData(:,1))
    if LData(a,4)~=0 && Tr(LData(a,7))>lentraj && (LData(a,2)>max(points(1,1),points(2,1)) || LData(a,2)<min(points(1,1),points(2,1)))
        Vabs=sqrt((LData(a,4))^2+(LData(a,5))^2)/C1;
        Vdata(trcount,1)=trcount;
        Vdata(trcount,2)=Vabs;
        trcount=trcount+1;
    end
end
%disp(Vdata);
% filename=strcat('FinalVelocityData.txt');
% dlmwrite(filename, Vdata, '\t')
% finalV(1)=mean(Vdata);
% finalV(2)=std(Vdata)/sqrt(length(Vdata));
% filename=strcat('FinalVelocityMean.txt');
% dlmwrite(filename, finalV, '\t')
% filename=strcat('FinalVelocityTraj.txt');
% dlmwrite(filename, Tr, '\t')
%     ChNum=num2str(Numch);
%     save_fname=strcat('wide_',save_fname,Numch,'.txt');
save_fname=strcat('wide_',save_fname,'.txt');
save([savedir,save_fname],'Vdata','-ascii');