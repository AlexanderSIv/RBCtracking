function DataAccumV3()

files=dir(strcat('*.txt'));
l=length(files);
n=1;
k=0;
for i=1:1:l
    disp(strncmpi( files(i).name,'wide', 4));
    if strncmpi( files(i).name,'wide', 4)
        k=k+1;
        A=dlmread(files(i).name);
        l2=length(A(:,1));
        altd=num2str(k);
        DatesW{k,1}=altd;
        str1=convertCharsToStrings(files(i).name);
        DatesW{k,2}=str1;
        for j=1:1:l2
            %         t=A(j,2)-A(j,1);
            %         t=A(j,5);
            %         if(lower <= t) && (upper >= t)
            times(n,1)=k;
            times(n,2)=A(j,2);
            %          times(n,3)=B;
            n=n+1;
            %         end
        end
    end
end
writecell(DatesW,'DatesW.txt','Delimiter','tab');
filename=strcat('wide.dat');
% fileID = fopen(filename,'w');
% fprintf(fileID,'%12.5f\n',times);
% fclose('all');
dlmwrite(filename, times, '\t')
n=1;
k=0;
for i=1:1:l
    disp(~strncmpi( files(i).name,'wide', 4));
    if ~strncmpi( files(i).name,'wide', 4)
        k=k+1;
        A=dlmread(files(i).name);
        l2=length(A(:,1));
        altd=num2str(k);
        Dates{k,1}=altd;
        str1=convertCharsToStrings(files(i).name);
        Dates{k,2}=str1;
        for j=1:1:l2
            %         t=A(j,2)-A(j,1);
            %         t=A(j,5);
            %         if(lower <= t) && (upper >= t)
            timesN(n,1)=k;
            timesN(n,2)=A(j,4);
            
            %          times(n,3)=B;
            n=n+1;
            %         end
        end
    end
end
filenameN=strcat('narrow.dat');
% fileID = fopen(filename,'w');
% fprintf(fileID,'%12.5f\n',times);
% fclose('all');
dlmwrite(filenameN, timesN, '\t')
writecell(Dates,'Dates.txt','Delimiter','tab');
end