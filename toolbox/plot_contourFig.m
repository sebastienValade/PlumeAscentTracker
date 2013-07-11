function plot_contourFig

load_workspaceVar

% % NB: because 'plumeTracker' is a function, it has its own workspace which is different than the 'base' workspace. 
% % => the function 'load_workspaceVar' does not load the variables from 'plumeTracker'. 
% % => way around it:
% 
% %get 'caller'
% workspaceVar_caller = evalin('caller','who');
% idx_caller = find(strcmp('caller',workspaceVar_caller));
% callerName = evalin('caller',workspaceVar_caller{idx_caller});
% 
% %--- LOAD workspace variables:
% if strcmp(callerName,'plumeTracker_GUI'); workspace = 'base';
% elseif strcmp(callerName,'plumeTracker_FCN'); workspace = 'caller';
% end
% 
% varNames = evalin(workspace,'who');
% for i= 1 : length(varNames)
%       varVal = evalin(workspace,varNames{i});    %evaluate variable named 'variables{i}' from workspace ('base')
%       S.(varNames{i}) = varVal;
% end
% get_struct2var(S)
% %---

frame_first = 1;
frame_last = numel(plumeInfo_frame);
frame_step = 1;
nber_ofFrames = numel(frame_first:frame_step:frame_last);
cmap = jet(nber_ofFrames);

%method 1 (home made)
figure
for i = frame_first:frame_step:frame_last
    plot(plumeInfo_contour_pxX{i},plumeInfo_contour_pxY{i},'.','color',cmap(i,:))
    hold on
end
set(gca,'ydir','reverse')
axis equal;
colormap(jet(nber_ofFrames))
h=colorbar('ytick',(1:nber_ofFrames)+0.5,'yticklabel',plumeInfo_frame,'fontSize',6);
ylabel(h,'frame number')
title(['contour level: plumeTemp\_thresh=' num2str(plumeTemp_thresh)])

if figSave
    if isempty(figName), fileName = 'contourPlot_meth1'; 
    else fileName = [figName '_contourMeth1'];
    end
    pathNfile = [path2folder_outputs fileName];
    save_sv(pathNfile,figFormat)
end

%method 2
if exist('plumeInfo_contourXY_mtlb','var')
    figure
    for i = frame_first:frame_step:frame_last
        for j=1:numel(plumeInfo_contourXY_mtlb{i}) %loop through contours contained (can be several per frame)
            contour=plumeInfo_contourXY_mtlb{i}(j);
            plot(contour{1}(1,:),contour{1}(2,:),'color',cmap(i,:))
            hold on
        end
    end
    set(gca,'ydir','reverse')
    axis equal;
    colormap(jet(nber_ofFrames))
    h=colorbar('ytick',(1:nber_ofFrames)+0.5,'yticklabel',plumeInfo_frame,'fontSize',6);
    ylabel(h,'frame number')
    title(['contour level: plumeTemp\_thresh=' num2str(plumeTemp_thresh)])
    
    if figSave
        if isempty(figName), fileName = 'contourPlot_meth2';
        else fileName = [figName '_contourMeth2'];
        end
        pathNfile = [path2folder_outputs fileName];
        save_sv(pathNfile,figFormat)
    end
end