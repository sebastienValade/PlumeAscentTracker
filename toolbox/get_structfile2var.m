function get_structfile2var(fileName)
% get_structfile2var(fileName)
% 
% argIN: fileName = 'name.mat'
% argOUT: none, will return each field of structure array as a variable on workspace 

S = open(fileName);

fieldNames = fieldnames(S);
for i=1:numel(fieldNames)
    assignin ('base', fieldNames{i}, getfield(S, fieldNames{i}) )
end