function DataMean()

dataname='wide'; %выбираем, по какому образцу собираем данные, записывать в таких кавычках ''
files=dir(strcat('*',dataname,'*.dat')); %находим все файлы с экспериментом
h=5000;
step=1;
lower=1;
upper=lower+step;
n=1;
A=dlmread(files(1).name);
l=length(A(:,1));
i=1;
while(upper <= h)
    n=1;
    v=[0];
    vN=[0];
    for j=1:1:l
        t=A(j,1);
        if(lower <= t) && (upper > t)
%             B2(n)=t;
%             B1(n)=A(j,2);
            v(n)=A(j,1);
            vN(n)=A(j,2);
            n=n+1;
        end
    end
%     B1=transpose(B1);
%     B2=transpose(B2);
if(n>1)
    M(i,1)=mean(vN);
    M(i,2)=std(vN);
    i=i+1;
end
    lower=lower+step;
    upper=upper+step;
end
lower=1;
upper=lower+step;
n=1;
A=dlmread(files(1).name);
l=length(A(:,1));
i=1;
while(upper <= h)
    n=1;
    v=[0];
    vN=[0];
    for j=1:1:l
        t=A(j,1);
        if(lower <= t) && (upper > t) && A(j,2)>=(M(i,1)-2*M(i,2)) && A(j,2)<=(M(i,1)+2*M(i,2))
%             B2(n)=t;
%             B1(n)=A(j,2);
            v(n)=A(j,1);
            vN(n)=A(j,2);
            n=n+1;
        end
    end
%     B1=transpose(B1);
%     B2=transpose(B2);
if(n>1)
    L(i,1)=lower;
    L(i,2)=n-1;
    L(i,3)=mean(vN);
    L(i,4)=std(vN)/sqrt(n-1);
    i=i+1;
end
    lower=lower+step;
    upper=upper+step;
end
disp(L);
filename=strcat(dataname,'.txt');
dlmwrite(filename, L, '\t')

dataname='narr'; %выбираем, по какому образцу собираем данные, записывать в таких кавычках ''
files=dir(strcat('*',dataname,'*.dat')); %находим все файлы с экспериментом
h=5000;
step=1;
lower=1;
upper=lower+step;
n=1;
A=dlmread(files(1).name);
l=length(A(:,1));
i=1;
while(upper <= h)
    n=1;
    v=[0];
    vN=[0];
    for j=1:1:l
        t=A(j,1);
        if(lower <= t) && (upper > t)
%             B2(n)=t;
%             B1(n)=A(j,2);
            v(n)=A(j,1);
            vN(n)=A(j,2);
            n=n+1;
        end
    end
%     B1=transpose(B1);
%     B2=transpose(B2);
if(n>1)
    M(i,1)=mean(vN);
    M(i,2)=std(vN);
    i=i+1;
end
    lower=lower+step;
    upper=upper+step;
end
lower=1;
upper=lower+step;
n=1;
A=dlmread(files(1).name);
l=length(A(:,1));
i=1;
while(upper <= h)
    n=1;
    v=[0];
    vN=[0];
    for j=1:1:l
        t=A(j,1);
        if(lower <= t) && (upper > t) && A(j,2)>=(M(i,1)-2*M(i,2)) && A(j,2)<=(M(i,1)+2*M(i,2))
%             B2(n)=t;
%             B1(n)=A(j,2);
            v(n)=A(j,1);
            vN(n)=A(j,2);
            n=n+1;
        end
    end
%     B1=transpose(B1);
%     B2=transpose(B2);
if(n>1)
    L(i,1)=lower;
    L(i,2)=n-1;
    L(i,3)=mean(vN);
    L(i,4)=std(vN)/sqrt(n-1);
    i=i+1;
end
    lower=lower+step;
    upper=upper+step;
end
disp(L);
filename=strcat(dataname,'.txt');
dlmwrite(filename, L, '\t')
%формат данных
%номер эксперимента   количество клеток   средн€€ скорость  погрешность
%скорости
end