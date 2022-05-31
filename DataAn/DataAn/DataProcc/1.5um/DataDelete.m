function DataDelete()

deletelist=[-5 -10]; %сюда записываем номера неугодных экспериментов
P=1; %коэффициент Стьюдента 
C=0.025; %отношение площадей сечения каналов
% deletelist=[-1];
% C=1;
files=dir(strcat('*.dat'));
l=length(files);
h=5000;
step=1;
lower=1;
upper=lower+step;
n=1;
for f=1:1:l
    if strcmp(files(f).name,'wide.dat')
        A=dlmread(files(f).name);
        l1=length(A(:,1));
        i=1;
        while(upper <= h)
            n=1;
            N=[0];
            vW=[0];
            for j=1:1:l1
                t=A(j,1);
                if(lower <= t) && (upper > t)
                    N(n)=A(j,1);
                    vW(n)=A(j,2);
                    n=n+1;
                end
            end
            if(n>1)
                M(i,1)=mean(vW);
                M(i,2)=std(vW);
                i=i+1;
            end
            lower=lower+step;
            upper=upper+step;
        end
        lower=1;
        upper=lower+step;
        n=1;
        i=1;
        while(upper <= h)
            n=1;
            N=[0];
            vW=[0];
            for j=1:1:l1
                t=A(j,1);
                var=false; 
                l3=length(deletelist);
                for p=1:1:l3
                    if A(j,1)~=deletelist(p)
                        var=true;
                    end
                end
                if (lower <= t) && (upper > t) && A(j,2)>=(M(i,1)-2*M(i,2)) && A(j,2)<=(M(i,1)+2*M(i,2)) && var
                    N(n)=A(j,1);
                    vW(n)=A(j,2);
                    n=n+1;
                end
            end
            if(n>1)
                L(i,1)=lower;
                L(i,2)=n-1;
                L(i,3)=mean(vW);
                L(i,4)=std(vW)*P/sqrt(n-1);
                L(i,5)=P*std(vW)/(mean(vW)*sqrt(n-1));
                i=i+1;
            end
            lower=lower+step;
            upper=upper+step;
        end
    end
end
n=1;
for f=1:1:l
    if strcmp(files(f).name,'narrow.dat')
        lower=1;
        upper=lower+step;
        A=dlmread(files(f).name);
        l1=length(A(:,1));
        i=1;
        while(upper <= h)
            n=1;
            N=[0];
            vW=[0];
            for j=1:1:l1
                t=A(j,1);
                if(lower <= t) && (upper > t)
                    N(n)=A(j,1);
                    vW(n)=A(j,2);
                    n=n+1;
                end
            end
            if(n>1)
                M1(i,1)=mean(vW);
                M1(i,2)=std(vW);
                i=i+1;
            end
            lower=lower+step;
            upper=upper+step;
        end
        lower=1;
        upper=lower+step;
        n=1;
        i=1;
        k=1;
        while(upper <= h)
            n=1;
            for j=1:1:l1
                t=A(j,1);
                 var=true; 
                l3=length(deletelist);
                for p=1:1:l3
                    if t == deletelist(p)
                        var=false;
                    end
                end
                if (lower == t) && (upper > t) && A(j,2)>=(M1(i,1)-2*M1(i,2)) && A(j,2)<=(M1(i,1)+2*M1(i,2)) && var
                    D(k,1)=t;
                    D(k,2)=C*A(j,2)/L(lower,3);
                    D(k,3)=L(lower,5)*C*A(j,2);
                    k=k+1;
                    n=n+1;
                end
            end
%                 D(i,1)=lower;
%                 D(i,2)=n-1;
%                 D(i,3)=mean(vW);
%                 D(i,4)=std(vW);
%                 D(i,5)=std(vW)/mean(vW);
                i=i+1;
            lower=lower+step;
            upper=upper+step;
        end
        m=length(D(:,1));
        FD1=mean(D);
        FD2=P*std(D)/sqrt(m);
        FD(1)=FD1(2);
        disp(L);
        FD(2)=sqrt((FD2(2))^2 + (FD1(3))^2);
        disp(FD);
        filename=strcat('FinalVelocityData.txt');
        dlmwrite(filename, D, '\t')
        %формат данных
        %1 номер эксперимента     2 отнормированная скорость    3
        %погрешность скорости
        filename=strcat('FinalVelocityMean.txt');
        dlmwrite(filename, FD, '\t')
    end
end
end