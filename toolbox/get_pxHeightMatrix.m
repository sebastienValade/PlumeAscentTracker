function pxHeightMat_imgAx = get_pxHeightMatrix(imgSize)

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

%% using "inclinAngleBase_rad"

%get img range on which to compute pxHeightMatrix
if imgTransformation
    
    if isfield(inputs_imgTransf,'imgCrop')
        %... case if img crop, and possibly rotation
        yRange_T = inputs_imgTransf.imgCrop_yRange_T;
        yRange_B = inputs_imgTransf.imgCrop_yRange_B;
        
        %image size
        S = inputs_imgTransf.imgSize_orig(1:2);
        %adapt image size if img rotation
        if isfield(inputs_imgTransf,'imgRotation')
            nbRot = inputs_imgTransf.imgRotation_nb;
            evenNbRot = isequal(nbRot/2, floor(nbRot/2)); %check if nber of rotation is an even number
            if ~evenNbRot, S = fliplr(S); end %if un-even nber of rotation => adapt img size to use
        end
        
        A = S(1) - yRange_B;
        B = S(1) - yRange_T;
        
    elseif ~isfield(inputs_imgTransf,'imgCrop') && isfield(inputs_imgTransf,'imgRotation')
        %... case if img rotation only
        A = 1;
        B = inputs_imgTransf.imgSize_transf(1);
    
    end
    
else
    %... case no img transformation
    A = 1;
    B = imgSize(1);
end

%-- CONSTRUCT pxHeight matrix 
idx = 0;
if inclinationAngle_deg>0
    %inclinationAngle_deg>0 => px height increases towards top of image
    
    for i = A : B
        idx = idx+1;
        pxTop = tan(inclinAngleBase_rad + i*IFOV) * distHoriz;
        pxBottom = tan(inclinAngleBase_rad + (i-1)*IFOV) * distHoriz;
        pxHeightMat(idx,1) = pxTop - pxBottom;
    end
    pxHeightMat_imgAx = flipud(pxHeightMat); 
    %NB: pxHeightMat_imgAx => index = same as image axis: 1=top of image=max size pixel; 240=bottom of image=min size pixel

else
    
    for i = A : B
        idx = idx+1;
        pxTop = tan(inclinAngleBase_rad - (i-1)*IFOV) * distHoriz;
        pxBottom = tan(inclinAngleBase_rad - i*IFOV) * distHoriz;
        pxHeightMat(idx,1) = pxTop - pxBottom;
    end
    pxHeightMat_imgAx = pxHeightMat; %no need to flip
    
end



%% using "inclinationAngle_rad"

% %-- CONSTRUCT pxHeight matrix 
% if inclinationAngle_deg>0
%     %inclinationAngle_deg>0 => px height increases towards top of image
%     
%     for i=1:imgSize(1)
%         pxTop = tan(inclinationAngle_rad + i*IFOV) * distHoriz;
%         pxBottom = tan(inclinationAngle_rad + (i-1)*IFOV) * distHoriz;
%         pxHeightMat(i,1) = pxTop - pxBottom;
%     end
%     pxHeightMat_imgAx = flipud(pxHeightMat); 
%     %NB: pxHeightMat_imgAx => index = same as image axis: 1=top of image=max size pixel; 240=bottom of image=min size pixel
% 
% else
%     
%     for i=1:imgSize(1)
%         pxTop = tan(inclinationAngle_rad - (i-1)*IFOV) * distHoriz;
%         pxBottom = tan(inclinationAngle_rad - i*IFOV) * distHoriz;
%         pxHeightMat(i,1) = pxTop - pxBottom;
%     end
%     pxHeightMat_imgAx = pxHeightMat; %no need to flip
%     
% end
