function get_struct2var(S)
% get_struct2var(S)
% => will return each field of structure array as a variable on workspace 
%
% see also function "get_structfile2var(fileName)"

fieldNames = fieldnames(S);
for i=1:numel(fieldNames)
    assignin ('caller', fieldNames{i}, getfield(S, fieldNames{i}) )
    %assignin ('base', fieldNames{i}, getfield(S, fieldNames{i}) )
end