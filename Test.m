close all; clear all; clc;
data = [1,2,3,4;5,6,7,8;9,10,11,12];

filename="A.xls";
sheetnum=1;
%write_xls(data,'A.xls',1)

%function write_xls(data,filename,sheetnum)
% function to write the output data (converted data) to new excel file
% The colum will be E - N - Z
%--------------------------------------------------------------------------
% Check if you have created an Excel file previously or not 

fileExist = exist(filename,'file'); 
if fileExist==0
%header = {'T', 'E ','N' , 'Z'};
xlswrite(filename,data);
else
[~,~,input] = xlsread(filename); % Read in your xls file to a cell array (input)
new_data = data; % This is a cell array of the new line you want to add
%output = cat(1,input,new_data); % Concatinate your new data to the bottom of input
xlswrite(filename,new_data); % Write to the new excel file. 
end