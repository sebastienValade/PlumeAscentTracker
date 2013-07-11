function  [cmapTxt,limTxt,style,bkgColor,fColor] = get_defaultCmap(plotContent)

%cmap: define default depending on chosen plot in monitor fig

if find(cell2mat(strfind(plotContent,'imgRaw')))
    if find(cell2mat(strfind(plotContent,'imgRaw_celsius'))); cmapTxt = 'jet_baseK';
    elseif find(cell2mat(strfind(plotContent,'imgRaw_kelvin'))); cmapTxt = 'jet_baseK';
    elseif find(cell2mat(strfind(plotContent,'imgRaw_rgb'))); cmapTxt = 'none';
    elseif find(cell2mat(strfind(plotContent,'imgRaw_idx'))); cmapTxt = 'gray';
    end
elseif find(cell2mat(strfind(plotContent,'imgDiff_'))), cmapTxt = 'blue_white_red';
elseif find(cell2mat(strfind(plotContent,'plume3D_'))), cmapTxt = 'jet';
elseif find(cell2mat(strfind(plotContent,'[empty]'))), cmapTxt = '';
else cmapTxt = 'jet'; %default cmap is jet if not specified
end

%clim
if ~isempty(cell2mat(strfind(plotContent,'imgRaw'))) %|| ~isempty(cell2mat(strfind(plotContent,'imgDiff_')))
    style = 'edit'; limTxt = '[ ]'; bkgColor = [1,1,1]; fColor=[0,0,0];
else style = 'frame'; limTxt = ''; bkgColor = [0.9412, 0.9412, 0.9412]; fColor=[0.65,0.65,0.65];
end