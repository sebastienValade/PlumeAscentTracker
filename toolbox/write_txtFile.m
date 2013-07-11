function write_txtFile(M,headerNames,fileName_withExt)
%ouput = tab-delimited file
% INPUTS:
% M = [colA'; colB']; %!! to have vertical vectors in txt file, vectors in the matrix M have to be horizontal !!
% headerNames={'radius','temp'};
% fileName_withExt = 'radius-vs-temp.txt'


fileID = fopen(fileName_withExt,'w');
%fill column headers
for i=1:numel(headerNames), fprintf(fileID,'%s\t',headerNames{i}); end
fprintf(fileID,'\r\n');


%define textscan format depending on nber of columns in file
% format=['%f %s' repmat(' %f',[1 nbCol-2]) ' %*n'];
format = [repmat('%.2f\t ',1,numel(headerNames)) '\r\n']; %.2f=floating pt with 2 decimals; \t = tab;

%fill vectors
fprintf(fileID,format,M);
fclose(fileID);