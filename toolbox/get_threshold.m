function [operationType,threshold,threshold_txt] = get_threshold(h_threshTxtBox)

% get threshold text
threshold_txt = get(h_threshTxtBox,'String'); %sym function from Symbolic Math Toolbox could be used

% get threshold value
[~, idx_digit] = get_digitINstr(threshold_txt);
if isempty(idx_digit)
    h = msgbox('Threshold not properly defined: numeric value missing.','warning','none'); uiwait(h);
    operationType='error'; threshold=[]; threshold_txt='';
    return
else
    threshold = str2double(threshold_txt(idx_digit));
end

% get operation type
if strfind(threshold_txt,'<')
    operationType = 'below';
elseif strfind(threshold_txt,'>')
    operationType = 'above';
else
    h = msgbox('Operation type not properly defined: add < or > before numeric value.','warning','none'); uiwait(h); 
    operationType='error'; threshold=[]; threshold_txt='';
    return
end

% get special case: absolute value
idxAbs = strfind(threshold_txt,'|');
if ~isempty(idxAbs)
    if numel(idxAbs)==2
        operationType = ['abs_' operationType];
    else
        h = msgbox('Absolute value not properly defined: add symbol | around numeric value.','warning','none'); uiwait(h);
        operationType='error'; threshold=[]; threshold_txt='';
        return
    end
end
