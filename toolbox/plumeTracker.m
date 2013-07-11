function plumeTracker(inputStruct)


% load INPUTS
get_struct2var(inputStruct)
get_struct2var(inputRec)

%set other inputs
FOVv_rad = FOVv_deg * pi/180;
% inclinationAngle_rad = inclinationAngle_deg * pi/180;   %inclination angle in radian 
% distSlant = distHoriz / cos(inclinationAngle_rad + FOVv_rad/2);      %distance from beam to image center

inclinAngleBase_deg = inclinationAngle_deg - FOVv_deg/2;
inclinAngleBase_rad = inclinAngleBase_deg * pi/180;
distSlant = distHoriz / cosd(inclinationAngle_deg);      %distance from beam to image center

% %%%TMP
% distSlant = 275
% distHoriz = cos(abs(inclinationAngle_rad) + FOVv_rad/2) * distSlant;
% %%%

pxHeight_cst = distSlant*tan(IFOV);
%pxHeight_cst = 2*distSlant*tan(IFOV/2);                 %equ. from Harris (book)
%%%%%%%%%%%%%

% load IMAGE STORAGE (images=>folder, video=>videoObject)
load_imgStorage;

% load REF IMG
load_img(frameRef)

% img transformation (crop, rotate, ...)
if imgTransformation, img_transformation; end
imgRef = imgRaw;
imgPrev = imgRef;
imgSize = size(imgRef);

% checks before tracking
%. is frameStrt>frameEnd
if frameStrt > frameEnd, h = msgbox('Frame START cannot be > Frame END.','warning','none'); uiwait(h); return; end
%. is ventY>imgSize
if ventY > imgSize(1), h = msgbox('Vent Y-position cannot be > image size.','warning','none'); uiwait(h); return; end

%get pxHeightMatrix for pixel height correction
pxHeightMat_imgAx = get_pxHeightMatrix(imgSize);


%get location of requested plots
nbplots_row = size(plot_monitorImg,1);
nbplots_col = size(plot_monitorImg,2);
for i=1:numel(plotTypes)
    plotRequest0_cell = cellfun(@(x) strcmp(x, plotTypes{i}),plot_monitorImg,'uniformOutput',false);
    plotRequest0 = cellfun(@(x) find(x),plotRequest0_cell,'uniformOutput',false);
    [row.(plotTypes{i}),col.(plotTypes{i}),~] = find(~cellfun('isempty',plotRequest0));
end


%--- initialize variables
idxLine = 0;    %line index for plumeInfo vectors
if ~isempty(plot_monitorImg), h_monitorFig = figure; maximize_figure; end
%---

disp(char('','Tracking in progress...'))

%%  LOOP THROUGH FRAMES
for i=frameStrt:frameStep:frameEnd
    idxLine = idxLine+1;

    if frameStrt==1 && i~=frameStrt, i=i-1; end %so frames are on even number if frameStrt = 1
    currentFrame = i;

    %-- image upload
    load_img(currentFrame)
    
    %-- image transfomation (crop, rotate, ...)
    if imgTransformation
        img_transformation;
    end

    %-- image processing
    img_processing
    imgPrev = imgRaw;   %defined for next loop iteration
    
    %set img to track
    img2track = imgRaw; %imgRaw; imgDiff_framePrev; imgDiff_frameRef

    %-- contour interpolated (Matlab function)
    track_contourMatlab = 1;
    if track_contourMatlab
        [C_cell,W] = track_contourMtlb;
    end
    
    %-- contour pixels (home-made function)
    track_plumePixels = 1;
    if track_plumePixels
        track_plumePx
    end
    
    %-- plot images
    if ~isempty(plot_monitorImg)
        
        plot_monitorFig
        
        if saveGif
            save_animatedGif
        end
        
        if saveFrame
            figName = [path2folder_outputs 'frame_' num2str(i)];
            figFormat = {'jpg'}; %,'fig','emf', 'eps'};
            save_sv(figName,figFormat)
        end
    end
    
    %halt execution if spacebar pressed
    key = get(gcf,'CurrentCharacter'); %see also 'KeyPressFcn' & 'KeyReleaseFcn' in figure properties
    if key==32 %32 = spacebar; 13 = return/enter
       
        pausing_optn = 1; %1|2
        % pausing_optn = 1: 
        %    => zooming into figure impossible because mouse clic ends pause
        % pausing_optn = 2
        %    => zooming possible, but 'return' key is the only one that can end the pause (=> moving frame by frame by pressing space impossible)
        
        if pausing_optn==1
            disp('** Execution paused: press Enter to continue, Space to go to next frame. **')
            waitforbuttonpress
       
        elseif pausing_optn==2
            disp('** Execution paused: press Enter to continue. **')
            
            linkAxes = 1; %zooming affects all figures
            h_ax = findobj(gcf,'type','axes','-not','tag','Colorbar');
            if linkAxes, linkaxes(h_ax); 
            else linkaxes(h_ax,'off');  
            end
            waitfor(gcf,'CurrentCharacter',13)
        end

    end
    
    %slow program execution
    if slowExecution
        pause(slowExecution_sec) %(0.1)
    end
    
end
disp('... tracking ended.')
trackingSucceeded = 1;


%% --- compute ash mass

%. density ratio
compute_densityRatio = 1;
if compute_densityRatio
    [plumeInfo_densityRatio_sphere, plumeInfo_densityRatio_cylinder] = get_densityRatio;
end

%. ash mass
compute_ashMass = 1;
if compute_ashMass
    %define ashMass_method2use
    if radiometricData
        ashMass_method2use = {'meth_ashFraction','meth_thermalBalance'};
    else
        ashMass_method2use = {'meth_ashFraction'};
    end

    get_ashMass
end



%%  SAVE all variables in .mat file (= structure array)
if save_wsvar2file
    if isempty(fileName_struct)
        fileName_struct = [path2folder_outputs 'workspaceVar.mat'];
    else fileName_struct = [path2folder_outputs fileName_struct '.mat'];
    end
    save(fileName_struct)
    
    disp(' ')
    disp(['Structure file created: ' fileName_struct])
end

% SAVE specific variables to tab delimited file (.txt)
if save_specvar2txtFile
    ws_2upload = 'caller';
    save_var2txtfile(ws_2upload)
end

%export variables of interest (whose names start with 'plumeInfo' & 'atmInfo')
%=> variables stored in 'base' workspace, hence can be collected once tracking ended
var_plumeInfo = who('plumeInfo*');
var_atmInfo = who('atmInfo*');
var_filtInfo = who('filtInfo*'); %NB: filtInfo_imgReg_pxX & filtInfo_imgReg_pxY VERY heavy to export
var_imgInfo = 'imgSum'; %who('img*');
var_measurePts = who('measurePts*');
var_fig = who('fig*');
% inputParam_threshT = plumeTemp_thresh;
% inputParam_img2track = img2track;
var_inputParam = {'frameStrt';'frameStep';'frameEnd';'frameRate';'inclinationAngle_deg'};
if exist('plumeTemp_thresh','var'), var_inputParam{end+1}='plumeTemp_thresh'; end
if exist('plumeTempVar_thresh','var'), var_inputParam{end+1}='plumeTempVar_thresh'; end
if exist('limH_px','var'), var_inputParam{end+1}='limH_px'; end
var_various = {'pxHeight_cst';'ventY'; 'pxHeightMat_imgAx'; 'imgSize'; 'trackingSucceeded'; 'path2folder_outputs'};

var2export = [var_plumeInfo; var_atmInfo; var_filtInfo; var_imgInfo; var_measurePts; var_inputParam; var_fig; var_various];

for i=1:numel(var2export)
    assignin('base',var2export{i},eval(var2export{i}));
end

%save(filename,'plumeInfo*')    %saves in a matlab file all variables that start with 'plumeInfo'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PLOT output figures requested:

%plot x vs y
if plot_XY
    %     %-- define 'caller' => where to collect the variables
    %     % .caller = 'plumeTracker_GUI' => variables stored in 'base' workspace
    %     % .caller = 'plumeTracker_FCN' => variables stored in 'caller' workspace
    %     caller = 'plumeTracker_FCN';

    plot_xyFig
end

%contour plot
if plot_contourPlot
    plot_contourFig
end

%img mean
if plot_imgMeanFig
    plot_imgMean
end

%img mean
if plot_measureTools
    plot_measurePts
end

