function [closest_value,closest_idx]=get_closestValue(vector,values2search)
% [closest_value,closest_idx]=get_closestValue(vector,values2search)
% ArgIN: 
%   - vector: vector to search in (must be 1 dimension numeric array)
%   - values2search (can be vector of values)
% ArgOUT:
%   - closest_value: closest values values found (along the different dimensions of input vector)
%   - closest_idx: index of closest values in input vector

%check input
if ~isnumeric(vector), disp('Warning: input vector must be numeric'), return, end 
if min(size(vector))>1, disp('Warning: input vector must be of 1 dimension only'), return, end 
if isempty(vector), disp('Warning: input vector is empty, check ability for dat file to support importadata function (depends on HMS time column: yes if hh:mm:ss, no if hh.mm.ss)'), return, end 

%get closest values (vector 'values2search') in vector 'vector'
for i=1:max(size(values2search))
    tmp = abs(vector-values2search(i));
    [C, idx] = min(tmp); %index of closest value

    closest_value(i,1) = vector(idx); %closest value
    closest_idx(i,1) = idx; %index of closest value of ti_sec & tf_sec
end

%check output
% if isequal(closest_idx(1),closest_idx(end))
%     disp('PROBLEM: indexes found are equal')
% end
if numel(idx)>1
    disp('NB: several values found with equal distances to values2search')
end