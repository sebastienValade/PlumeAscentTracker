function [figFormat_cell]=figFormat_str2cell(figFormat_str)
% [figFormat_cell]=figFormat_str2cell(figFormat_str)
% Converts figFormat expressed as character to figFormat expressed as cell array (for save_sv.m for ex)
%   EX: figFormat_str = 'jpg,'fig' => figFormat_cell = {'jpg','fig'}

delimiter = [0, strfind(figFormat_str,','), length(figFormat_str)+1];

figFormat_cell={};
for i=1:numel(delimiter)-1
     txt = figFormat_str(delimiter(i)+1:delimiter(i+1)-1);
     figFormat_cell{i} = strtrim(txt); %remove leading and trailing white space from string
end