function img_transformation


%% --- LOAD workspace variables:
ws_base = evalin('caller','who');
varNames = ws_base;
for i= 1 : length(varNames)
    varVal = evalin('caller',varNames{i});    %evaluate variable named 'variables{i}' from workspace ('base')
    S.(varNames{i}) = varVal;
end
get_struct2var(S)
%---

%% -- img transformation


if isfield(inputs_imgTransf,'imgRotation')
    nbRot = inputs_imgTransf.imgRotation_nb;
    
    imgRaw = rot90(imgRaw,nbRot);
    
    if exist('imgRaw_kelvin','var')
        imgRaw_kelvin = rot90(imgRaw_kelvin,nbRot);
    end
    if exist('imgRaw_idx','var')
        imgRaw_idx = rot90(imgRaw_idx,nbRot);
    end
    if exist('imgRaw_rgb','var')
        if numel(size(imgRaw_rgb))==3
            %.case if 3 component imagery data (RGB)
            imgR(:,:,1) = rot90(imgRaw_rgb(:,:,1),nbRot);
            imgR(:,:,2) = rot90(imgRaw_rgb(:,:,2),nbRot);
            imgR(:,:,3) = rot90(imgRaw_rgb(:,:,3),nbRot);
            imgRaw_rgb = imgR;
        else
            %.case if 2 component imagery data
            % NB: "imgRaw_rgb" still defined eventhough not RGB because data non-radiometric => GUI fig-monitor options = imgRaw_rgb & imgRaw_idx
            imgRaw_rgb = rot90(imgRaw_rgb,nbRot);
        end
    end
end

if isfield(inputs_imgTransf,'imgCrop')
    xRange_L = inputs_imgTransf.imgCrop_xRange_L;
    xRange_R = inputs_imgTransf.imgCrop_xRange_R;
    yRange_B = inputs_imgTransf.imgCrop_yRange_B;
    yRange_T = inputs_imgTransf.imgCrop_yRange_T;
    
    imgRaw = imgRaw(yRange_T:yRange_B , xRange_L:xRange_R);
    
    if exist('imgRaw_kelvin','var')
        imgRaw_kelvin = imgRaw_kelvin(yRange_T:yRange_B , xRange_L:xRange_R);
    end
    if exist('imgRaw_idx','var')
        imgRaw_idx = imgRaw_idx(yRange_T:yRange_B , xRange_L:xRange_R);
    end
    if exist('imgRaw_rgb','var')
        if numel(size(imgRaw_rgb))==3
            %.case if 3 component imagery data (RGB)
            imgRaw_rgb = imgRaw_rgb(yRange_T:yRange_B , xRange_L:xRange_R, 1:3);
        else
            %.case if 2 component imagery data
            % NB: "imgRaw_rgb" still defined eventhough not RGB because data non-radiometric => GUI fig-monitor options = imgRaw_rgb & imgRaw_idx
            imgRaw_rgb = imgRaw_rgb(yRange_T:yRange_B , xRange_L:xRange_R);
        end
    end
end


%% -- EXPORT variables to calling function
var_img = who('img*');
for i=1:numel(var_img)
    assignin('caller',var_img{i},eval(var_img{i}));
end