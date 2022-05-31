close all;clear all;clc
% get main directory (Projects directory)
pathFolder=uigetdir();
%oldf=cd(pathFolder);
[success,message,messageid] = fileattrib(strcat(pathFolder,'\*'));
%// final '\*' is needed to make the search recursive
isfolder = [message(:).directory]; %// true for folders, false for files
[folders{1:sum(isfolder)}] = deal(message(isfolder).Name); %// keep folders only
%// folders is a cell array of strings with all folder names
% isDeepest = cellfun(@(str) numel(strmatch(str,folders))==1, folders);
%// "==1" because each folder at least matches itself. So 1 match indicates
%// it's deepest, more matches indicates it's not.
deepestFolders = folders; %// keep deepest folders only
%// deepestFolders is a cell array of strings with all deepest-folder names
writecell(deepestFolders,'dirlist.txt');