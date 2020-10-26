function write_xls(data,filename,sheetnum)
% function to write the output data (converted data) to new excel file
% The colum will be E - N - Z
%--------------------------------------------------------------------------
% Check if you have created an Excel file previously or not 
checkforfile=exist((pwd,'\',filename),'file');
if checkforfile==0; % if not create new one
    header = {'time', 'E' 'N' , 'Z'};
    xlswrite(filename,header,'Sheetname',1);
    N=0;
else % if yes, count the number of previous inputs
    N=size(xlsread(filename,'Sheetname'),1);
end
% add the new values (your input) to the end of Excel file
%AA=strcat('A',num2str(N+2));
BB=strcat('B',num2str(N+2));
%xlswrite(filename,NewName,'Sheetname',AA);
xlswrite(vfn,vout,'Sheetname',BB);
end