function plot_monitorFig

% load_workspaceVar
% NB: because 'plumeTracker' is a function, it has its own workspace which is different than the 'base' workspace.
% => the function 'load_workspaceVar' does not load the variables from 'plumeTracker'.
% => way around it:

%--- LOAD workspace variables:
ws_base= evalin('caller','who');
varNames= ws_base;
for i= 1 : length(varNames)
    varVal = evalin('caller',varNames{i});    %evaluate variable named 'variables{i}' from workspace ('base')
    S.(varNames{i}) = varVal;
end
get_struct2var(S)
%---

set(0,'currentFigure',h_monitorFig)
clf

%create cell array for legend handles
nb_rows = max(plot_monitorImg_posIJ(:,1));
nb_cols = max(plot_monitorImg_posIJ(:,2));
H=cell(nb_rows*nb_cols,1);
% H=cell(nb_rows,nb_cols);

%-get selection
fieldList = fields(row);
nonEmptyFields = ~structfun(@isempty, row); %, 'UniformOutput', true);
idx_nonEmptyFields = find(nonEmptyFields);
selectedFields = fieldList(idx_nonEmptyFields);
selectedFields_struct = cell2struct(cell(numel(selectedFields),1), selectedFields);


%contour from Matlab function
varName = 'plumeContour_mtlb';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        %plot all contours above temperature threshold
        for k=1:numel(C_cell)
            plot(C_cell{k}(1,:),C_cell{k}(2,:),'w'), hold on
        end
        
        %plot contours identified as plume (i.e. specific position in img)
        for k=1:numel(W)
            plot(W{k}(1,:),W{k}(2,:),'r')
        end
        
        %plot largest contour identified
        plot(plumeInfo_largestContourXY_mtlb{idxLine}(1,:),plumeInfo_largestContourXY_mtlb{idxLine}(2,:),'g')
        
        title(['contour level: plumeTemp\_thresh=' num2str(plumeTemp_thresh)],'fontSize',6)
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
        hold on
    end
end


%FILTERED PIXELS:

%.filter temperature
varName = 'filterTemp_px';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        h=plot(filtInfo_temp_pxX{idxLine},filtInfo_temp_pxY{idxLine},'r.','displayName',['filterTemp\_px (' plumeTemp_thresh_str ')']); hold on
        H{plotPosition_idx}(end+1)=h;
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end

%.filter temperature variation
varName = 'filterTempVar_px';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        h=plot(filtInfo_tempVar_pxX{idxLine},filtInfo_tempVar_pxY{idxLine},'g.','displayName',['filterTempVar\_px (+/-' plumeTempVar_thresh_str ')']); hold on
        H{plotPosition_idx}(end+1)=h;
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end

%filter img region
varName = 'filterImgReg_px';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        h=plot(filtInfo_imgReg_pxX{idxLine},filtInfo_imgReg_pxY{idxLine},'c.','displayName',['filterImgReg\_px (' limH_px_str ')']); hold on
        H{plotPosition_idx}(end+1)=h;
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end

%plume pixels (interaction between filters)
varName = 'plumePixels';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        h=plot(plumeInfo_pxX{idxLine},plumeInfo_pxY{idxLine},'y.','displayName',['plumePixels (' strrep(filterInteraction,'_','\_') ')']); hold on
        H{plotPosition_idx}(end+1)=h;
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end

%contour pixels (home-made)
varName = 'plumeContour_px';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        h=plot(plumeInfo_contour_pxX{idxLine},plumeInfo_contour_pxY{idxLine},'color','r','marker','.','lineStyle','none','displayName','contourPixels'); %[0.5,0.5,0.5]
        H{plotPosition_idx}(end+1)=h;
                
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
        hold on
    end
end

%plume top (mean) 
varName = 'plumeTop_mean';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)

        %plot mean value
        h=plot(plumeInfo_topMean_pxXY{idxLine}(1), plumeInfo_topMean_pxXY{idxLine}(2), 'gx', 'displayName','plumeTop\_mean'); hold on %'marker','+', 'MarkerEdgeColor','m','MarkerFaceColor','w');
        H{plotPosition_idx}(end+1)=h;
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end
%plume top (mean) pixel used
varName = 'plumeTop_mean_pxUsed';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        %plot pixels used
        h=plot(plumeInfo_topMean_pxXused{idxLine},plumeInfo_topMean_pxYused{idxLine},'m.','displayName','plumeTop\_mean (px used)');  hold on
        H{plotPosition_idx}(end+1)=h;
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
        uistack(h,'bottom')
    end
end

%plume top (absolute) pixel
varName = 'plumeTop';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        %highest pixels
        h=plot(plumeInfo_top_pxX(idxLine),plumeInfo_top_pxY(idxLine),'g+','displayName','plumeTop px'); hold on
        H{plotPosition_idx}(end+1)=h;
        
        %highest interpolated point from matlab contour (contours at temperature threshold):
        %plot(plumeInfo_topXY_mtlb{idxLine}(1),plumeInfo_topXY_mtlb{idxLine}(2),'m+');
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end

% %plume center (mean XY of the largest closed contour)
% varName = 'plumeCenter';
% if isfield(selectedFields_struct,varName)
%     r=row.(varName);
%     c=col.(varName);
%     for i=1 : numel(r)
%         %define subplot position
%         plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
%         subplot(nbplots_row,nbplots_col,plotPosition_idx)
%         
%         %computed by mean(X) mean(Y) of the largest contour found using the 'contour function' applied on contour_pxX&Y)
%         h=plot(plumeInfo_centerXY{idxLine}(1),plumeInfo_centerXY{idxLine}(2),'r+','displayName','plume center (mean XY of the largest closed contour)');
%         H{plotPosition_idx}(end+1)=h;
% 
%         %computed on largest contour found using the 'contour function' applied on the ENTIRE image (or specified img region)
%         %plot(plumeInfo_centerXY_mtlb{idxLine}(1),plumeInfo_centerXY_mtlb{idxLine}(2),'g+');
%     end
% end

%contour & px used to compute plume centroid
varName = 'plumeCentroid_pxUsed';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)

        %plot largest contour found using the 'contour function' applied on contour_pxX & contour_pxY)
        h=plot(plumeInfo_largestContourXY_used2getCentroid{idxLine}(1,:),plumeInfo_largestContourXY_used2getCentroid{idxLine}(2,:),'r','displayName','largest contour used to get plume center (built from plumePixels\_contour)'); hold on
        H{plotPosition_idx}(end+1)=h;
        
        %plot pixels used 
        plot(plumeInfo_largestContourPxX_used2getCentroid{idxLine}, plumeInfo_largestContourPxY_used2getCentroid{idxLine}, 'w.'); hold on
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end

%plume centroid (mean XY of the plume px held in largest closed contour)
varName = 'plumeCentroid';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        %computed by mean(X) mean(Y) of the largest contour found using the 'contour function' applied on contour_pxX&Y)
        h=plot(plumeInfo_centroidXY{idxLine}(1),plumeInfo_centroidXY{idxLine}(2),'mx','displayName','plume centeroid (mean XY of the plume px held in largest closed contour)'); hold on
        H{plotPosition_idx}(end+1)=h;
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end


%plume radius MAX
varName = 'plumeDiameter_max';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        h=plot(plumeInfo_radMax_pxXEdge{idxLine},plumeInfo_radMax_pxYEdge{idxLine},'m:','displayName','max plume diameter'); hold on
        H{plotPosition_idx}(end+1)=h;
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end

%plume radius MEAN
varName = 'plumeDiameter_mean';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        %plot plume mean diameter, plotted from plume centroid position
        XX = [plumeInfo_centroidXY{idxLine}(1)-plumeInfo_radMean_px(idxLine), plumeInfo_centroidXY{idxLine}(1)+plumeInfo_radMean_px(idxLine)];
        YY = [plumeInfo_centroidXY{idxLine}(2), plumeInfo_centroidXY{idxLine}(2)];
        
        h=plot(XX,YY,'k-','displayName','mean plume diameter'); hold on
        H{plotPosition_idx}(end+1)=h;
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end

%plume radius at centroid's alt
varName = 'plumeDiameter_centroid';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        h=plot(plumeInfo_radCent_pxXEdge{idxLine},plumeInfo_radCent_pxYEdge{idxLine},'w-','displayName','centroid plume diameter'); hold on
        H{plotPosition_idx}(end+1)=h;
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end


%img region tracked
varName = 'regionTracked';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        if filter_imgRegion
            if strcmp(side_ofLimH,'left'), X=[0,limH_px];
            elseif strcmp(side_ofLimH,'right'), X=[limH_px,imgSize(1)];
            end
            plot(X,[ventY,ventY],'color',[0.75,0.75,0.75]);
            plot([limH_px,limH_px],[ventY,0],'color',[0.75,0.75,0.75]);
        else
            %rectangle('Position',[0,ventY,imgSize(2),ventY],'EdgeColor',[0.75,0.75,0.75])
            plot([0,imgSize(2)],[ventY,ventY],'color',[0.75,0.75,0.75]);
        end
    end
end


%plot atmospheric T (at reference px)



%plot plume 3D (side view or oblique view)
varName = 'plume3D_sideV';
if isfield(selectedFields_struct,varName)
    viewAngle=[0.5,0];
    r=row.(varName);
    c=col.(varName);
    
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        for j=1:size(plumeCoord_px3D,1)
            X_baseNtop = [plumeCoord_px3D(j,:,1);plumeCoord_px3D(j,:,1)];
            Y_baseNtop = [plumeCoord_px3D(j,:,2);plumeCoord_px3D(j,:,2)];
            Z_baseNtop = [plumeCoord_px3D(j,:,3)-0.5; plumeCoord_px3D(j,:,3)+0.5]; %cylinder with height = pixel
            surf(X_baseNtop,Y_baseNtop,Z_baseNtop,'EdgeColor',[0.5,0.5,0.5],'edgeAlpha',0.1) %'edgeAlpha',0.25
            %surf(X_baseNtop,Y_baseNtop,Z_baseNtop,'EdgeColor','none')
            hold on
        end
        set(gca,'zdir','reverse')
        view(viewAngle);
        axis equal; %axis vis3d;
        grid('on')
        xlim([1,size(imgRaw,2)]); xlabel('image width');
        zlim([1,size(imgRaw,1)]); zlabel('image height');%im height
        %ylim([1,size(imgRaw,1)]); %im depth
        
        %set colormap
        cMap_i = cMap_matrix{r(i),c(i)};
        colormap(cMap_i);
        if distinctCmapNeeded, freezeColors; end %cbfreeze(colorbar);
    end
end
varName = 'plume3D_obliqueV';
if isfield(selectedFields_struct,varName)
    viewAngle=[-30,20];
    r=row.(varName);
    c=col.(varName);
    
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        for j=1:size(plumeCoord_px3D,1)
            X_baseNtop = [plumeCoord_px3D(j,:,1);plumeCoord_px3D(j,:,1)];
            Y_baseNtop = [plumeCoord_px3D(j,:,2);plumeCoord_px3D(j,:,2)];
            Z_baseNtop = [plumeCoord_px3D(j,:,3)-0.5; plumeCoord_px3D(j,:,3)+0.5]; %cylinder with height = pixel
            %surf(X_baseNtop,Y_baseNtop,Z_baseNtop,'EdgeColor',[0.5,0.5,0.5],'edgeAlpha',0.1) %'edgeAlpha',0.25
            surf(X_baseNtop,Y_baseNtop,Z_baseNtop,'EdgeColor','none')
            hold on
        end
        set(gca,'zdir','reverse')
        view(viewAngle);
        axis equal; %axis vis3d;
        grid('on')
        xlim([1,size(imgRaw,2)]); xlabel('image width');
        zlim([1,size(imgRaw,1)]); zlabel('image height');%im height
        %ylim([1,size(imgRaw,1)]); %im depth
        
        %set colormap
        cMap_i = cMap_matrix{r(i),c(i)};
        colormap(cMap_i);
        if distinctCmapNeeded, freezeColors; end %cbfreeze(colorbar);
    end
end


%measure tools
varName = 'measureTools';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        %plot
        for k=1:size(measurePts_coordXY,1)
            h=plot(measurePts_coordXY{k,1}, measurePts_coordXY{k,2}, ':r+','displayName','measureTools'); hold on
            H{plotPosition_idx}(end+1)=h;
            
            h_txt=text(measurePts_coordXY{k,1}(end)+3, measurePts_coordXY{k,2}(end)-3, num2str(k), 'color','r');
        end
    end
end

%% IMAGES
%  nb: images need to be at the end of function, so that their colorbar stays even if additional elts (e.g. pixels, contours, ...) are plotted.

%imgRaw
if isfield(selectedFields_struct,'imgRaw_celsius') || isfield(selectedFields_struct,'imgRaw_idx')
    try 
        r=row.imgRaw_celsius; c=col.imgRaw_celsius; %radiometric img => celsius values
    catch
        r=row.imgRaw_idx; c=col.imgRaw_idx;         %non-radiometric img => indexed values
    end
    
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        hold on
        h_img = imagesc(imgRaw); axis image;
        uistack(h_img,'bottom')
        
        %set colormap
        cMap_i = cMap_matrix{r(i),c(i)};
        colormap(cMap_i); %NB: cmap_jet_baseK conseillee
        
        %set colorlimit
        cLim_i = cLim_matrix{r(i),c(i)};
        if ~isempty(cLim_i)
            idx_NaN = find(isnan(cLim_i));
            if isempty(idx_NaN)
                set(gca,'clim',cLim_i);
            elseif idx_NaN==1
                minVal = min(imgRaw(:));
                set(gca,'clim',[minVal,cLim_i(2)]);
            elseif idx_NaN==2
                maxVal = max(imgRaw(:));
                set(gca,'clim',[cLim_i(1),maxVal]);
            end
        end
        
        title(['frame ' num2str(currentFrame)],'fontSize',6)
        if add_colorbar, h_cb = colorbar; ylabel(h_cb,'temperature [°C]','fontsize',6); end
        hold on
        
        %freeze colormap & colorbar if several image requested (SLOWS down code execution by factor of 2)
        if distinctCmapNeeded, freezeColors; cbfreeze(colorbar); end
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end

%img rgb
varName = 'imgRaw_rgb';
if isfield(selectedFields_struct,varName)
    r=row.(varName); %non-radiometric img => rgb values
    c=col.(varName);

    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        hold on
        h_img = imagesc(imgRaw_rgb); axis image;
        uistack(h_img,'bottom')
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
    
    title(['frame ' num2str(currentFrame)],'fontSize',6)
%     if add_colorbar, h_cb = colorbar; ylabel(h_cb,'temperature [°C]','fontsize',6); end
    hold on
    
%     %freeze colormap & colorbar if several image requested (SLOWS down code execution by factor of 2)
%     if distinctCmapNeeded, freezeColors; cbfreeze(colorbar); end
end

%img kelvin
varName = 'imgRaw_kelvin';
if isfield(selectedFields_struct,varName)
    r=row.(varName); %non-radiometric img => rgb values
    c=col.(varName);

    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        hold on
        h_img = imagesc(imgRaw_kelvin); axis image;
        uistack(h_img,'bottom')
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
    
    title(['frame ' num2str(currentFrame)],'fontSize',6)
    if add_colorbar, h_cb = colorbar; ylabel(h_cb,'temperature [K]','fontsize',6); end
    hold on
    
    %freeze colormap & colorbar if several image requested (SLOWS down code execution by factor of 2)
    if distinctCmapNeeded, freezeColors; cbfreeze(colorbar); end
    
end

%image differences
%.with respect to reference image (frameRef)
varName = 'imgDiff_frameRef';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        hold on
        h_img = imagesc(imgDiff_frameRef); axis image;
        uistack(h_img,'bottom')
        
        %set colormap
        cMap_i = cMap_matrix{r(i),c(i)};
        colormap(cMap_i); %cmap_jet_centerW | cmap_bwr

        %set colorlimit
        center_cAxis_at0 = 1;
        if center_cAxis_at0
            max_absVal = max(abs(imgDiff_frameRef(:))); max_absVal=double(max_absVal);
            caxis([-1 1]*max_absVal);
        end
        title(['frame ' num2str(currentFrame)],'fontSize',6)
        
        if add_colorbar, h_cb = colorbar; ylabel(h_cb,'temp. diff. (frameRef) [°C]','fontsize',6); end
        hold on
        
        %freeze colormap & colorbar if several image requested (SLOWS down code execution by factor of 2)
        if distinctCmapNeeded, freezeColors; cbfreeze(colorbar); end
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end
%.with respect to previous image (currentFrame - 1)
varName = 'imgDiff_framePrev';
if isfield(selectedFields_struct,varName)
    r=row.(varName);
    c=col.(varName);
    for i=1 : numel(r)
        %define subplot position
        plotPosition_idx = (r(i)-1)*nbplots_col + c(i); %NB: idx=find(plotPosition) gives linear indexing, which is different then subplot indexing
        subplot(nbplots_row,nbplots_col,plotPosition_idx)
        
        hold on
        h_img = imagesc(imgDiff_framePrev); axis image;
        uistack(h_img,'bottom')
        
        %set colormap
        cMap_i = cMap_matrix{r(i),c(i)};
        colormap(cMap_i); %cmap_jet_centerW | cmap_bwr
        
        %set colorlimit
        center_cAxis_at0 = 1;
        if center_cAxis_at0
            max_absVal = max(abs(imgDiff_frameRef(:)));
            caxis([-1 1]*max_absVal);
        end
        title(['frame ' num2str(currentFrame)],'fontSize',6)
        
        if add_colorbar, h_cb = colorbar; ylabel(h_cb,'temp. diff. (prev.frame) [°C]','fontsize',6); end
        hold on
        
        %freeze colormap & colorbar if several image requested (SLOWS down code execution by factor of 2)
        if distinctCmapNeeded, freezeColors; cbfreeze(colorbar); end
        
        set(gca,'ydir','reverse'); axis equal; xlim([1,imgSize(2)]); ylim([1,imgSize(1)]);
    end
end

%% LEGENDS

%add legends (& set color maps in future ?)
if add_legend
    h_ax = findobj(gcf,'type','axes','-not','tag','Colorbar');
    for i=1:numel(h_ax)
        
        set(gcf,'currentAxes',h_ax(i))
        
        if isempty(H{i}), continue, end %if no elt handle => continue to avoid default legend insertion
        
        %.set legend
        hleg=legend(H{i});
        set(hleg,'box','off','location','SouthOutside'); 

%         %.set color map
%         cMap_i = cMap_matrix{i};
%         colormap(cMap_i);
%         if distinctCmapNeeded
%             freezeColors;
%             cbfreeze(colorbar);
%         end
    end
end

%set axes fontSize
h_ax = findobj('type','axes'); set(h_ax,'fontsize',7)