clear all;
clc;

datadir0=readcell('dirlist.txt');
h = waitbar(0,'Please wait...');
for num_dir=1:1:length(datadir0)
    waitbar(num_dir/length(datadir0),h)
    datadir=strcat(datadir0{num_dir},'\');
    cd(datadir);
    DataAccumV3;
    DataMean;
    DataDelete;
end
close(h);