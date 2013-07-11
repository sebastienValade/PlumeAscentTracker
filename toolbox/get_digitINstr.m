function [isdigit, idx_digit] = get_digitINstr(str)
% [isdigit, idx_digit] = get_digitINstr(str)
% 
% IN: string array
% OUT:
%   isdigit = vector with value 0 or 1 for each element of input string
%   idx_digit = index of digits in string
% 
% EX: str='>|2|' => isdigit=[0 0 1 0]; idx_digit=3;

% digits = '0123456789';
digits = '-0123456789';

isdigit = [];
for i = 1 : numel(str)
    idx = find(digits == str(i));
    if ~isempty(idx), isdigit(i) = 1;
    else isdigit(i) = 0;
    end
end

idx_digit = find(isdigit==1);