function track_plumePx

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


plume_pxX = [];
plume_pxY = [];
plumeCoord_px3D = [];
plumeRadii_perFrame = [];
filtTemp_pxX=[]; filtTemp_pxY=[];
filtTempVar_pxX=[]; filtTempVar_pxY=[];
filtImgReg_pxX=[]; filtImgReg_pxY=[];

%loop from px above vent to top of image
for j = ventY-1:-1:1
    
    %define current pixel height from 'pxHeightMat_imgAx'
    pxHeight = pxHeightMat_imgAx(j);
    
    %% --filter px with temperature threshold (horizontal limit)
    if filter_tempThresh
        line=img2track(j,1:imgSize(2));
        if strfind(operation_onTempThresh,'abs'), line = abs(line); end
        if strfind(operation_onTempThresh,'above')
            idx_pxX_tempThresh = find(line(1:end)>plumeTemp_thresh);
        elseif strfind(operation_onTempThresh,'below')
            idx_pxX_tempThresh = find(line(1:end)<plumeTemp_thresh);
        end
    else
        idx_pxX_tempThresh_4all = 1:1:imgSize(2); %full line selected
        idx_pxX_tempThresh_4one = [];
    end
    
    %% --filter px from img region (horizontal limit)
    if filter_imgRegion
        if strcmp(side_ofLimH,'left'), idx_pxX_imReg = 1:1:limH_px;
        elseif strcmp(side_ofLimH,'right'), idx_pxX_imReg = limH_px:1:imgSize(2);
        end
        
    else
        idx_pxX_imReg_4all = 1:1:imgSize(2); %=>full line selected
        idx_pxX_imReg_4one = [];
    end
    
    %% --filter px with temperature variation
    if filter_tempVar

        switch filter_tempVar_type
            case 'fixed substraction', line=imgDiff_frameRef(j,1:imgSize(2));
            case 'sliding substraction', line=imgDiff_framePrev(j,1:imgSize(2));
        end

        if strfind(operation_onTempThreshVar,'abs'), line = abs(line); end
        if strfind(operation_onTempThreshVar,'above'), idx_pxX_tempVar = find(line>plumeTempVar_thresh);
        elseif strfind(operation_onTempThreshVar,'below'), idx_pxX_tempVar = find(line<plumeTempVar_thresh);
        end
    else
        idx_pxX_tempVar_4all = 1:1:imgSize(2); %full line selected
        idx_pxX_tempVar_4one = []; %empty
    end
    
    
    %% --collect pixels filtered
    
    %- filter COMBINATION (=plumePx):
    %.px must fullfill all filter conditions
    if strcmp(filterInteraction,'filtInteract_all')
        if ~exist('idx_pxX_tempThresh','var'), idx_pxX_tempThresh=idx_pxX_tempThresh_4all; end
        if ~exist('idx_pxX_imReg','var'), idx_pxX_imReg=idx_pxX_imReg_4all; end
        if ~exist('idx_pxX_tempVar','var'), idx_pxX_tempVar=idx_pxX_tempVar_4all; end
        
        idx_plumeLine = intersect(intersect(idx_pxX_tempThresh,idx_pxX_imReg),idx_pxX_tempVar);
        
        %.px must fullfill at least one of the filter conditions
    elseif strcmp(filterInteraction,'filtInteract_one')
        if ~exist('idx_pxX_tempThresh','var'), idx_pxX_tempThresh=idx_pxX_tempThresh_4one; end
        if ~exist('idx_pxX_imReg','var'), idx_pxX_imReg=idx_pxX_imReg_4one; end
        if ~exist('idx_pxX_tempVar','var'), idx_pxX_tempVar=idx_pxX_tempVar_4one; end
        
        idx_plumeLine = union(union(idx_pxX_tempThresh,idx_pxX_imReg),idx_pxX_tempVar);
    end
    
    plume_pxX = [plume_pxX; idx_plumeLine'];
    plume_pxY = [plume_pxY; ones(numel(idx_plumeLine),1)*j];
    
    %- filter temperature:
    filtTemp_pxX = [filtTemp_pxX; idx_pxX_tempThresh'];
    filtTemp_pxY = [filtTemp_pxY; ones(numel(idx_pxX_tempThresh),1)*j];
    
    %- filter temperature var:
    filtImgReg_pxX = [filtImgReg_pxX; idx_pxX_imReg'];
    filtImgReg_pxY = [filtImgReg_pxY; ones(numel(idx_pxX_imReg),1)*j];
    
    %- filter temperature var:
    filtTempVar_pxX = [filtTempVar_pxX; idx_pxX_tempVar'];
    filtTempVar_pxY = [filtTempVar_pxY; ones(numel(idx_pxX_tempVar),1)*j];
    
    
    %% --gather plume coordinates
    if ~isempty(idx_plumeLine) %if plume found on line j
        gaps = diff([idx_plumeLine(1)-1000, idx_plumeLine, idx_plumeLine(end)+1000]);
        %NB: the vector inside 'diff' function is 'idx_plumeLine', to which are added to both ends an extra value (+ or -1000) to mark the begin and end of the plume lobe
        idx_lobeEdges = find(gaps>1);
        
        for k=1:numel(idx_lobeEdges)-1 %loop through plume lobes
            idxLine_coord = size(plumeCoord_px3D,1);
            
            %exclude pixels found if outside wanted img region
            if filter_imgRegion
                if strcmp(side_ofLimH,'left')
                    if idx_plumeLine(idx_lobeEdges(k)) > limH_px, continue, end
                elseif strcmp(side_ofLimH,'right')
                    if idx_plumeLine(idx_lobeEdges(k)) < limH_px, continue, end
                end
            end
            
            %identify successives lobes (indexes = n° of elt in vector "idx_plumeLine" )
            idx_strtLobe = idx_lobeEdges(k);
            idx_endLobe = idx_lobeEdges(k+1)-1;
            
            plumeLobe = idx_plumeLine(idx_strtLobe:idx_endLobe);
            
            %get lobe characteristics
            plumeDiam_px = numel(plumeLobe); %+1 = half pixel to both sides of lobe
            plumeRad_px = plumeDiam_px / 2;
            plumeCenter_px = plumeLobe(1)-0.5 + plumeRad_px; %-0.5 accounts for half pixel to the left of lobe
            plumeRad_m = plumeRad_px*pxHeight_cst; %pixel width kept cst = pxHeight_cst
            
            %define x,y default values to draw a circle (which defines gate limits)
            step=0.1; %defines nb of points to draw cylinder, EX: 0.1=63pts
            x0=cos(0:step:2*pi); %x0=[-1 +1]
            y0=sin(0:step:2*pi);
            %define circle
            X0=(x0*plumeRad_px)+plumeCenter_px;
            Y0=(y0*plumeRad_px);
            Z0=j*ones(1,numel(X0));
            X=[X0, X0(1)]; Y=[Y0, Y0(1)]; Z=[Z0, Z0(1)]; %close circle
            
            %store plume 3D coordinates of current frame (plumeCoord emptyed at each step of i loop )
            % => stores successive circle coord, each lobe is a line
            plumeCoord_px3D(idxLine_coord+1,:,1)=X;
            plumeCoord_px3D(idxLine_coord+1,:,2)=Y;
            plumeCoord_px3D(idxLine_coord+1,:,3)=Z;
            
            
            cylindersVolume_perFrame(idxLine_coord+1,1) = pi * plumeRad_m^2 * pxHeight; %volume of each cylinder
            cylindersEnveloppe_perFrame(idxLine_coord+1,1) = 2 * pi * plumeRad_m * pxHeight; %enveloppe of each cylinder (does not account for surface of base/top)
            
            plumeRadii_surface(idxLine_coord+1,1) = 2 * plumeRad_m * pxHeight; %2D surface of each plumeLine
            
                        
            %store radii
            % .each lobe is a new line
            plumeRadii_perFrame(idxLine_coord+1,1)=plumeRad_px;
            % .each lobe is a new column, each line a pixel line
            idx2use=ventY-j;
            plumeRadii_perFrame_perLobe(idx2use,k)=plumeRad_px;
            plumeRadii_perFrame_perLobe_yPos(idx2use,1)=j;
            plumeRadii_perFrame_perLobe_xLim{idx2use,k}=[min(X),max(X)];

        end
      
        %plume radii (SUMMING ALL lobe radii)
        plumeRadii_perFrame_sumLobes(idx2use,1) = sum(plumeRadii_perFrame_perLobe(idx2use,:));
        
        %store plume edges & centers for each line (!! disgards wether lobes found on line: takes left px of leftmost lobe, right px of righmost lobe)
        plumeEdge_perLine_pxX(idx2use,:) = [plumeRadii_perFrame_perLobe_xLim{idx2use,1}(1), plumeRadii_perFrame_perLobe_xLim{idx2use,k}(2)];
        plumeEdges_perLine_pxY(idx2use,:) = [j, j];
        plumeMiddles_perLine_pxXY(idx2use,1:2) = [mean(plumeEdge_perLine_pxX(idx2use,:)), j];
        %plot(plumeEdge_perLine_pxX(idx2use,1),plumeEdges_perLine_pxY(idx2use,1),'r.'); plot(plumeEdge_perLine_pxX(idx2use,2),plumeEdges_perLine_pxY(idx2use,2),'g.')
        %plot(plumeMiddles_perLine_pxXY(idx2use,1),plumeMiddles_perLine_pxXY(idx2use,2),'k.');
    end
end


%% time vectors

%--- Time based on frames
%. t_frameNb
plumeInfo_frame(idxLine,1) = currentFrame;

%. t_frameSec => t_frameSec=0 at frameStrt (idxLine=1)
if idxLine==1, tStep_sec = 0;
else tStep_sec = (currentFrame - plumeInfo_frame(idxLine-1,1)) / frameRate;
end
plumeInfo_frameSec(idxLine,1) = (idxLine-1) * tStep_sec;

%--- Time based on eruption start
%. t_onset => defined as t_frameSec when plume pixels found for the 1st time
if ~isempty(plume_pxX) && ~exist('plumeInfo_tOnset_frameNb','var')
    plumeInfo_tOnset_frameNb = currentFrame;
    plumeInfo_tOnset_frameSec = plumeInfo_frameSec(idxLine,1);
end

%. t_sec => t_sec=0 at tOnset
if exist('plumeInfo_tOnset_frameNb','var')
    plumeInfo_tsec(idxLine,1) = plumeInfo_frameSec(idxLine,1) - plumeInfo_tOnset_frameSec;
else plumeInfo_tsec(idxLine,1) = NaN; 
end

%. t_min
plumeInfo_tmin(idxLine,1) = plumeInfo_tsec(idxLine,1)/60;



%% collect plume information
if ~isempty(plume_pxX)
    
        
    %-- Get filtered PIXELS
    filtInfo_temp_pxX{idxLine,1} = filtTemp_pxX;
    filtInfo_temp_pxY{idxLine,1} = filtTemp_pxY;
    filtInfo_tempVar_pxX{idxLine,1} = filtTempVar_pxX;
    filtInfo_tempVar_pxY{idxLine,1} = filtTempVar_pxY;
    filtInfo_imgReg_pxX{idxLine,1} = filtImgReg_pxX;
    filtInfo_imgReg_pxY{idxLine,1} = filtImgReg_pxY;
    
    %-- Get plume PIXELS (=> intersection|union of all filters)
    plumeInfo_pxX{idxLine,1} = plume_pxX;
    plumeInfo_pxY{idxLine,1} = plume_pxY;
    
    %-- Get plume CONTOUR pixels
    [contour_pxX,contour_pxY]=get_plumeContour(plume_pxX,plume_pxY);
    plumeInfo_contour_pxX{idxLine,1} = contour_pxX;
    plumeInfo_contour_pxY{idxLine,1} = contour_pxY;
    
    %-- Get plume CENTER & CENTROID (on largest contour found using the 'contour function' applied on contour_pxX&Y)
    [plumeCenter_xy,plumeCentroid_xy,plumeCenterHeight_m,plumeCentroidHeight_m,largestContour_xy,largestContour_pxX,largestContour_pxY]=get_plumeCentroid(contour_pxX,contour_pxY,plume_pxX,plume_pxY,imgSize,ventY,pxHeightMat_imgAx);
    plumeInfo_largestContourXY_used2getCentroid{idxLine,1} = largestContour_xy;
    plumeInfo_largestContourPxX_used2getCentroid{idxLine,1} = largestContour_pxX;
    plumeInfo_largestContourPxY_used2getCentroid{idxLine,1} = largestContour_pxY;
    
    %. plume centroid (mean XY of the plume px held in largest closed contour)
    plumeInfo_centroidXY{idxLine,1} = plumeCentroid_xy;
    plumeInfo_centroidM(idxLine,1) = plumeCentroidHeight_m;
    plumeInfo_velocCentroid(idxLine,1) = plumeCentroidHeight_m / plumeInfo_tsec(idxLine,1);
    plumeInfo_accelCentroid(idxLine,1) = plumeInfo_velocCentroid(idxLine,1) / plumeInfo_tsec(idxLine,1);
    
    %. plume center (mean XY of the largest closed contour)
    %plumeInfo_centerXY{idxLine,1} = plumeCenter_xy; %plume barycenter
    %plumeInfo_centerM(idxLine,1) = plumeCenterHeight_m;
    %plumeInfo_velocCenter(idxLine,1) = plumeCenterHeight_m / plumeInfo_tsec(idxLine,1);
    %plumeInfo_accelCenter(idxLine,1) = plumeInfo_velocCenter(idxLine,1) / plumeInfo_tsec(idxLine,1);

        
    %-- Get plume pixels TEMPERATURE
    [plume_pxT] = get_plumeTemp(plume_pxX,plume_pxY,img2track);
    plumeInfo_tempPx{idxLine,1} = plume_pxT;
    plumeInfo_tempMean_C(idxLine,1) = mean(plume_pxT);
    plumeInfo_tempMax_C(idxLine,1) = unique(max(plume_pxT));
    
    %-- Get plume VOLUME
    plumeInfo_volume(idxLine,1) = sum(cylindersVolume_perFrame);
    
    %-- Get plume SURFACE (sum of cylinder's enveloppe, does not account for surface of base/top)
    plumeInfo_surface3D(idxLine,1) = sum(cylindersEnveloppe_perFrame); 
    plumeInfo_surface2D(idxLine,1) = sum(plumeRadii_surface);
    
    %-- Get plume TOP HEIGHT
    %. plume top (absolute)
    idxPx_top = find(plume_pxY==min(plume_pxY));
    idxPx_top2use = floor(median(idxPx_top)); %if multiple idxPx_top, take median then floor to have round nber (=px)
    plumeInfo_top_pxY(idxLine,1) = min(plume_pxY);
    plumeInfo_top_pxX(idxLine,1) = plume_pxX(idxPx_top2use);
    plumeInfo_top_m(idxLine,1) = sum( pxHeightMat_imgAx(plumeInfo_top_pxY(idxLine,1) : ventY-1) ); %recall that pxHeightMat_imgAx(1)=px at imageTop & pxHeightMat_imgAx(end)=px at imageBottom
    %NB: why ventY-1? With this 'home-made' method we store pixels coordinates, which are in fact the value at the center of the pixel. The matrix pxHeightMat_imgAx stores pixel heights for each pixel. To make it simpler to compute the
    % height in meters, we suppose that the vent position, plumeTop position, etc. are at the top of each pixel; hence we do not consider the pixel ventY in the sum(pxHeightMat_imgAx(...)) => sum(... :ventY-1).
    %EX: if plumeTop=px174 at frame1, and ventY=175, then:
    % plumeTop in meters = pixelHeight in meters of pixel n°174 = sum(pxHeightMat_imgAx(174 : ventY-1)) = sum(pxHeightMat_imgAx(174))
    plumeInfo_velocTop(idxLine,1) = plumeInfo_top_m(idxLine,1) / plumeInfo_tsec(idxLine,1);
    plumeInfo_accelTop(idxLine,1) = plumeInfo_velocTop(idxLine,1) / plumeInfo_tsec(idxLine,1);
    
    %instantaneous velocities
    if idxLine>1
        dt = plumeInfo_tsec(idxLine,1)-plumeInfo_tsec(idxLine-1,1);
        %.top
        dH_top = plumeInfo_top_m(idxLine,1) - plumeInfo_top_m(idxLine-1,1);
        plumeInfo_velocTop_inst(idxLine,1) = dH_top/dt;
        %.centroid
        dH_cent = plumeInfo_centroidM(idxLine,1) - plumeInfo_centroidM(idxLine-1,1);
        plumeInfo_velocCent_inst(idxLine,1) = dH_cent/dt;

    else
        plumeInfo_velocTop_inst(idxLine,1) = NaN;
        plumeInfo_velocCent_inst(idxLine,1) = NaN;
    end

    %instantaneous accelerations
    if idxLine>1
        dt = plumeInfo_tsec(idxLine,1)-plumeInfo_tsec(idxLine-1,1);
        %.top
        dV_top = plumeInfo_velocTop_inst(idxLine,1) - plumeInfo_velocTop_inst(idxLine-1,1);
        plumeInfo_accelTop_inst(idxLine,1) = dV_top/dt;
        %.centroid
        dV_cent = plumeInfo_velocCent_inst(idxLine,1) - plumeInfo_velocCent_inst(idxLine-1,1);
        plumeInfo_accelCent_inst(idxLine,1) = dV_cent/dt;

    else
        plumeInfo_accelTop_inst(idxLine,1) = NaN;
        plumeInfo_accelCent_inst(idxLine,1) = NaN;
    end
    
    %. plumeTop (mean)
    %...get nbLinesBelowTop
    plumeH_pxNb = ventY - plumeInfo_top_pxY(idxLine,1);
    percentage_ofHeight = 25;
    topMean_nbLinesBelowTop = round(plumeH_pxNb * (percentage_ofHeight/100));
    %topMean_nbLinesBelowTop = 10;
    
    %...get pixels to use
    %plume_uniqueYval = unique(plume_pxY);
    lowerYlim = plumeInfo_top_pxY(idxLine,1)+topMean_nbLinesBelowTop;
    idx_plumePx4topMean = find(plume_pxY<=lowerYlim);
    plumeInfo_topMean_pxXused{idxLine,1} = plume_pxX(idx_plumePx4topMean);
    plumeInfo_topMean_pxYused{idxLine,1} = plume_pxY(idx_plumePx4topMean);
    %...get mean position
    plumeInfo_topMean_pxXY{idxLine,1}(1) = floor(mean(plumeInfo_topMean_pxXused{idxLine,1}));
    plumeInfo_topMean_pxXY{idxLine,1}(2) = floor(mean(plumeInfo_topMean_pxYused{idxLine,1}));
    plumeInfo_topMean_m(idxLine,1) = sum( pxHeightMat_imgAx(plumeInfo_topMean_pxXY{idxLine,1}(2) : ventY-1) ); %recall that pxHeightMat_imgAx(1)=px at imageTop & pxHeightMat_imgAx(end)=px at imageBottom
    plumeInfo_velocTopMean(idxLine,1) = plumeInfo_topMean_m(idxLine,1) / plumeInfo_tsec(idxLine,1);
    plumeInfo_accelTopMean(idxLine,1) = plumeInfo_velocTopMean(idxLine,1) / plumeInfo_tsec(idxLine,1);
    %... get mean temperature
    [plume_pxT] = get_plumeTemp(plume_pxX(idx_plumePx4topMean),plume_pxY(idx_plumePx4topMean),img2track);
    plumeInfo_tempMeanTop_C(idxLine,1) = mean(plume_pxT);
    
    %-- Get plume max RADIUS
    [idxMax,c] = find(plumeRadii_perFrame==max(plumeRadii_perFrame)); %largest circle (plume3D) radius
    plumeRad_maxCircle=unique(plumeRadii_perFrame(idxMax));
    plumeInfo_radMax_m(idxLine,1) = plumeRad_maxCircle * pxHeight_cst; %no horizontal image correction => use cst pxSize computed from IFOV
    plumeInfo_radMax_pxXEdge{idxLine,1} = [min(plumeCoord_px3D(idxMax(1),:,1)) , max(plumeCoord_px3D(idxMax(1),:,1))]; %if several idxMax (several circles as identical diam => plot idxMax(1))
    plumeInfo_radMax_pxYEdge{idxLine,1} = [unique(plumeCoord_px3D(idxMax(1),:,3)) , unique(plumeCoord_px3D(idxMax(1),:,3))];
    
    %-- Get plume mean RADIUS
    plumeInfo_radMean_px(idxLine,1) = mean(plumeRadii_perFrame_sumLobes);
    plumeInfo_radMean_m(idxLine,1) = plumeInfo_radMean_px(idxLine) * pxHeight_cst;

    %-- Get plume RADIUS at centroid height
    centroid_pxY = round(plumeInfo_centroidXY{idxLine,1}(2));
    idx = find(plumeEdges_perLine_pxY(:,1)==centroid_pxY);
    plumeInfo_radCent_pxYEdge{idxLine,1} = repmat(centroid_pxY,[1,2]);
    plumeInfo_radCent_pxXEdge{idxLine,1} = plumeEdge_perLine_pxX(idx,:);
    plumeInfo_radCent_px(idxLine,1) = plumeRadii_perFrame_sumLobes(idx);
    %plumeInfo_radCentroid_px(idxLine,:) = plumeEdge_perLine_pxX(idx,2)-plumeEdge_perLine_pxX(idx,1);
    plumeInfo_radCent_m(idxLine,1) = plumeInfo_radCent_px(idxLine,:) * pxHeight_cst; 
    
%     hold on
%     h=plot(plumeInfo_centroidXY{idxLine}(1),plumeInfo_centroidXY{idxLine}(2),'ws','displayName','plumeC'); hold on
%     h2=plot(plumeEdge_perLine_pxX(idx,:),plumeEdges_perLine_pxY(idx,:),'w-','displayName','plumeC_rad'); hold on
    
    
    %-- Get plume edges & centers for each line
    plumeInfo_plumeEdges_pxX{idxLine,1} = plumeEdge_perLine_pxX;
    plumeInfo_plumeEdges_pxY{idxLine,1} = plumeEdges_perLine_pxY;
    plumeInfo_plumeMiddles_pxXY{idxLine,1} = plumeMiddles_perLine_pxXY;
    
    %-- Get ATMOSPHERE temperature
    % => T° of pixel located n pixels away from the plume left edge, at the centroid altitude
    distFromPlume_px = 30;
    atmT_refPx_x = floor(plumeInfo_radCent_pxXEdge{idxLine}(1)) - distFromPlume_px;
    if atmT_refPx_x<=0, atmT_refPx_x=1; end %if x coord outside image, take 1st px
    atmInfo_refPx_xy{idxLine,1} = [atmT_refPx_x, plumeInfo_radCent_pxYEdge{idxLine}(1)];
    atmInfo_refPx_tempC(idxLine,1) = img2track(atmInfo_refPx_xy{idxLine}(2),atmInfo_refPx_xy{idxLine}(1)); %!! img2track = 240x320 => img2track(Y,X) not the opposite
    
   
else
    
    %-- set NaN or 0 values to variables:
    %. NaN value => when variable plotted, points with NaN values do not appear
    %. 0 value => when variable plotted, points plotted at coordinate 0
    
    filtInfo_temp_pxX{idxLine,1} = NaN;
    filtInfo_temp_pxY{idxLine,1} = NaN;
    filtInfo_tempVar_pxX{idxLine,1} = NaN;
    filtInfo_tempVar_pxY{idxLine,1} = NaN;
    filtInfo_imgReg_pxX{idxLine,1} = NaN;
    filtInfo_imgReg_pxY{idxLine,1} = NaN;
    
    plumeInfo_pxX{idxLine,1} = NaN;
    plumeInfo_pxY{idxLine,1} = NaN;
    
    plumeInfo_contour_pxX{idxLine,1} = NaN;
    plumeInfo_contour_pxY{idxLine,1} = NaN;
    
    plumeInfo_largestContourXY_used2getCentroid{idxLine,1} = [NaN;NaN];
    plumeInfo_largestContourPxX_used2getCentroid{idxLine,1} = NaN;
    plumeInfo_largestContourPxY_used2getCentroid{idxLine,1} = NaN;    
    
    %plumeInfo_centerXY{idxLine,1} = [NaN,NaN];
    %plumeInfo_centerM(idxLine,1) = NaN;
    %plumeInfo_velocCenter(idxLine,1) = NaN;
    %plumeInfo_accelCenter(idxLine,1) = NaN;
    
    plumeInfo_centroidXY{idxLine,1} = [NaN,NaN];
    plumeInfo_centroidM(idxLine,1) = NaN; %0;
    plumeInfo_velocCentroid(idxLine,1) = NaN; %0;
    plumeInfo_accelCentroid(idxLine,1) = NaN; %0;
    
    plumeInfo_tempPx{idxLine,1} = NaN;
    plumeInfo_tempMean_C(idxLine,1) = NaN;
    plumeInfo_tempMax_C(idxLine,1) = NaN;
    
    plumeInfo_volume(idxLine,1) = NaN;
    
    plumeInfo_surface3D(idxLine,1) = NaN;
    plumeInfo_surface2D(idxLine,1) = NaN;
    
    plumeInfo_top_pxY(idxLine,1) = NaN;
    plumeInfo_top_pxX(idxLine,1) = NaN;
    plumeInfo_top_m(idxLine,1) = NaN; %0
    plumeInfo_velocTop(idxLine,1) = NaN; %0;
    plumeInfo_accelTop(idxLine,1) = NaN; %0;
    
    plumeInfo_velocTop_inst(idxLine,1) = NaN; %0;
    plumeInfo_velocCent_inst(idxLine,1) = NaN; %0;
    plumeInfo_accelTop_inst(idxLine,1) = NaN; %0;
    plumeInfo_accelCent_inst(idxLine,1) = NaN; %0;
    
    plumeInfo_topMean_pxXused{idxLine,1} = NaN;
    plumeInfo_topMean_pxYused{idxLine,1} = NaN;    
    plumeInfo_topMean_pxXY{idxLine,1} = [NaN,NaN];
    plumeInfo_topMean_m(idxLine,1) = NaN; %0;
    plumeInfo_velocTopMean(idxLine,1) = NaN; %0;
    plumeInfo_accelTopMean(idxLine,1) = NaN; %0;
    plumeInfo_tempMeanTop_C(idxLine,1) = NaN;
        
    plumeInfo_radMax_m(idxLine,1) = NaN; %0;
    plumeInfo_radMax_pxXEdge{idxLine,1} = [NaN,NaN];
    plumeInfo_radMax_pxYEdge{idxLine,1} = [NaN,NaN];
    
    plumeInfo_radMean_px(idxLine,1) = NaN; %0;
    plumeInfo_radMean_m(idxLine,1) = NaN; %0;
    
    plumeInfo_radCent_pxYEdge{idxLine,1} = [NaN,NaN];
    plumeInfo_radCent_pxXEdge{idxLine,1} = [NaN,NaN];
    plumeInfo_radCent_px(idxLine,1) = NaN; %0;
    plumeInfo_radCent_m(idxLine,1) = NaN; %0;
        
    plumeInfo_plumeEdges_pxX{idxLine,1} = NaN;
    plumeInfo_plumeEdges_pxY{idxLine,1} = NaN;
    plumeInfo_plumeMiddles_pxXY{idxLine,1} = NaN;
    
    atmInfo_refPx_xy{idxLine,1} = NaN;
    atmInfo_refPx_tempC(idxLine,1) = NaN;
   
end


%collect temperature at measure points (if defined)
if exist('measurePts_coordXY','var')
    for k=1:size(measurePts_coordXY,1)
        XXX = measurePts_coordXY{k,1};
        YYY = measurePts_coordXY{k,2};
        [plume_pxT] = get_plumeTemp(XXX,YYY,img2track);
        measurePts_T{idxLine,k} = plume_pxT;
        measurePts_maxT(idxLine,k) = unique(max(plume_pxT));
        measurePts_meanT(idxLine,k) = mean(plume_pxT);
        measurePts_minT(idxLine,k) = unique(min(plume_pxT));
    end
end


   
%export variables of interest
var_plumeInfo = who('plumeInfo*');
var_filtInfo = who('filtInfo*');
var_measurePts = who('measurePts*');
var_various = {'atmInfo_refPx_xy';'atmInfo_refPx_tempC';'plumeCoord_px3D'};

var2export = [var_plumeInfo; var_filtInfo; var_measurePts; var_various];
for i=1:numel(var2export)
    assignin('caller',var2export{i},eval(var2export{i}));
end


function [contour_pxX,contour_pxY]=get_plumeContour(XXX,YYY)
%GET PLUME CONTOUR PIXELS

% %-- Get px coordinates of plume
% XXX=cellfun(@(x) get(x,'xdata'),h_pxPlume,'uniformOutput',false); XXX=cell2mat(XXX)';
% YYY=cellfun(@(x) get(x,'ydata'),h_pxPlume,'uniformOutput',false); YYY=cell2mat(YYY)';

%- Build new coordinates:
% => area = plume extent with 1px band on border
% => values = 0 (=no plume) or 1 (=plume)
coord_pxPlume = zeros(max(YYY)-min(YYY)+1+2, max(XXX)-min(XXX)+1+2); %+2 so it leaves a 1-pixel-band empty all around image
XXX_newCoord = XXX - min(XXX) +2; %range between 1-max(XXX)
YYY_newCoord = YYY - min(YYY) +2;
for k=1: numel(XXX)
    coord_pxPlume(YYY_newCoord(k),XXX_newCoord(k)) = 1;
end

%-- Get contour using discrete Laplacian function
% [FX,FY] = gradient(coord_pxPlume);
% [r,c]=find(FX~=0 | FY~=0);
U=del2(coord_pxPlume); %Laplacien ~= moyenne des valeurs FX & FY sur 4 pixels entourant 1 px, sauf qu'il s'agit de derivee secondes (cad ~= diff(diff(M))) )
[r,c]=find(U~=0);
r_contour=[]; c_contour=[];
for k=1:numel(r) %get only points that correspond to plume (=> values=1)
    if coord_pxPlume(r(k),c(k))==1
        idx = numel(r_contour);
        r_contour(idx+1,1) = r(k);
        c_contour(idx+1,1) = c(k);
    end
end

%-- Check plot
% figure, imagesc(coord_pxPlume); colormap(gray); axis image; hold on
%plot(c,r,'c.'); plot(c_contour,r_contour,'r.');

%Collect real px coordinates
contour_pxX = c_contour + min(XXX) -2; %-2 to supress bordering 1px band
contour_pxY = r_contour + min(YYY) -2;


function [plumeCenter_xy,plumeCentroid_xy,plumeCenterHeight_m,plumeCentroidHeight_m,largestContour_xy,largestContour_pxX,largestContour_pxY]=get_plumeCentroid(contour_pxX,contour_pxY,plume_pxX,plume_pxY,imgSize,ventY,pxHeightMat_imgAx)

%create image of ones
imgContour = ones(imgSize(1),imgSize(2)); %zeros(240,320);

%set contour pixels value = 0
for k=1: numel(contour_pxX), imgContour(contour_pxY(k),contour_pxX(k)) = 0; end

%check plot
% figure, imagesc(imgContour); colormap(gray), hold on; %set(gca,'ydir','reverse','ylim',[0,240],'xlim',[0,320])

%-- get CONTOUR plot to collect largest contour and find its center
h_figContour=figure;
C = contour(imgContour,[1 1]);
close(h_figContour) %close figure automatically generated by 'contour' function
% NB: C(1,:)=X coord; C(2,:)=Ycoord; each contour line (for a given T° thresh) are stacked next to one another in C, where 1st row=X; 2nd row=Y
% !!! Each contour line begins with a column that contains the value of the contour (i.e. plumeTemp_thresh) on 1st line, and the number of (x,y) vertices in the contour line on the second line

%-- find the columns containing contour value & vertice numbers
idx_nbVertices = 1;
nbVertices=[]; idxLastVertice=[];
idx_nbVertices=1;
while idx_nbVertices(end) < size(C,2)
    nbVertices(numel(nbVertices)+1) = C(2,idx_nbVertices(end));
    idxLastVertice(numel(nbVertices)+1) = idx_nbVertices(end) + nbVertices(end);
    
    idx_nbVertices(numel(nbVertices)+1) = idxLastVertice(end) +1;
end

%-- store each contour in cell array C_cell;
nbContours=numel(nbVertices);
C_cell=cell(1,nbContours);
% col=jet(nbContours);
for k=1:nbContours
    C_cell{k} = C(:,idx_nbVertices(k)+1:idxLastVertice(k+1));
    
    %check plot:
    %plot(C_cell{k}(1,:),C_cell{k}(2,:),'color',col(k,:));%'r.');
end

%-- collect data:

%.get largest closed contour (=plume)
sz = cellfun(@(x) size(x,2),C_cell);
[~,largestContour_idx] = find(sz==max(sz));
largestContour_xy = C_cell{largestContour_idx};

%.get plume CENTER (on largest contour found using the 'contour function' applied on contour_pxX&Y)
plumeCenter_xy = [mean(largestContour_xy(1,:)), mean(largestContour_xy(2,:))];
plumeCenter_ceil4pxY = ceil(mean(largestContour_xy(2,:)));
plumeCenterHeight_m = sum( pxHeightMat_imgAx(plumeCenter_ceil4pxY : ventY-1) ); %recall that pxHeightMat_imgAx(1)=px at imageTop & pxHeightMat_imgAx(end)=px at imageBottom
%NB2: why ventY-1 & ceil4pxY? because to make it simpler to compute the height in meters, we suppose that the vent position, plumeCenter position, etc. are at the top of each pixel; hence we do not consider the pixel ventY in the sum(pxHeightMat_imgAx(...)) => sum(... :ventY-1).

%-- Get plume CENTROID (2D-geometrical center of the entire plume area, e.g. Kitamura and Sumita, 2011
%- centroid from ALL plume px
plumeCentroidXY_fromAllPx = [mean(plume_pxX), mean(plume_pxY)];
%- centroid from pixels within largest contour
largestContour_limX = [min(largestContour_xy(1,:)), max(largestContour_xy(1,:))];
largestContour_limY = [min(largestContour_xy(2,:)), max(largestContour_xy(2,:))];
idxX = find(plume_pxX>largestContour_limX(1) & plume_pxX<largestContour_limX(2));
idxY = find(plume_pxY>largestContour_limY(1) & plume_pxY<largestContour_limY(2));
idx_pxINlargestCont = intersect(idxX,idxY);
largestContour_pxX = plume_pxX(idx_pxINlargestCont);
largestContour_pxY = plume_pxY(idx_pxINlargestCont);
plumeCentroid_xy = [mean(largestContour_pxX), mean(largestContour_pxY)];
% plumeInfo_centroidXY{idxLine,1} = plumeCentroidXY_fromLargestContourPx;
%- centroid height
plumeCentroid_ceil4pxY = ceil(plumeCentroid_xy(2));
plumeCentroidHeight_m = sum( pxHeightMat_imgAx(plumeCentroid_ceil4pxY : ventY-1) ); %recall that pxHeightMat_imgAx(1)=px at imageTop & pxHeightMat_imgAx(end)=px at imageBottom

function [plume_pxT] = get_plumeTemp(XXX,YYY,img2track)

for i=1:numel(XXX)
    plume_pxT(i,1) = img2track(YYY(i),XXX(i)); %!! img2track = 240x320 => img2track(YYY(i),XXX(i)) not the opposite
end
