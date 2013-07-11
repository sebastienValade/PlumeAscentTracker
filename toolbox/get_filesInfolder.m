function [list_fileNamesSpecif]=get_filesInfolder(path2folder,varargin)
% [list_fileNamesSpecif]=get_filesInfolder(path2folder,fileSpecif)
% 
% ArgIN:
%   Compulsory:
%   - path2folder: folder to seek in (EX: 'c:\arenal\datFiles\')
%   Optional: (!one option or the other, not both!)
%   - fileSpecif: string specification that must be included in file to have it in output (EX: '_(radargram).dat')
%   - 'sortByDate' => file names in output will be sorted by date
% ArgOUT:
%   - list_fileNamesSpecif: string array containing the files in folder that have the specification 'fileSpecif'

%get list of files in folder
listing=dir(path2folder);
listingCell = struct2cell(listing); %listingCell(1,:) => 1st line cell array = file names
list_fileNames = listingCell(1,:)'; %cell array of strings

if ~isempty(varargin)
    
    if strcmp(varargin,'sortByDate')
        %NB: info concerning dates stored in "listing" structure
        %  field "date" (col2) = Modification date timestamp (char array)
        %  field "datenum" (col5) = Modification date as serial date number. (double)
        list_filenameNdate = listingCell(1:2,3:end)'; %take 'name' and 'date' columns 1 and 2; exclude first two lines (not files)
        list_filenameNdate_sorted=sortrows(list_filenameNdate,2); %sort according to 2nd column => date column
        list_fileNamesSpecif = strvcat(list_filenameNdate_sorted(:,1));
        
    else
        fileSpecif = varargin{1};
        %get list of files which contain the file specification fileSpecif
        A=regexpi(list_fileNames, regexptranslate('wildcard',fileSpecif),'match'); %search if fileSpecif is in string
        B=find(~cellfun('isempty',A)); %find non empty cells
        list_fileNamesSpecif = strvcat(list_fileNames(B)); %get string array of files which contain fileSpecif
    end
else
    list_fileNamesSpecif = list_fileNames;
end