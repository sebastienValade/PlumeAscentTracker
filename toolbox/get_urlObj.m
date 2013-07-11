function get_urlObj(obj, event, handles)
%get_urlObj(obj, event, arg1)

url = handles.url;
path2folder_url = handles.path2folder_url;
url_fileName = handles.url_fileName;
trackPixels = get(handles.track_plumePx,'Value');

%create file name
DateVector = datevec(now);
DateString_short = datestr(DateVector,30);
DateString_long = datestr(DateVector,31);
fileName_new = [path2folder_url url_fileName '_' DateString_short '.jpg'];

%get object from URL and save it in folder "path2folder_storage"
urlwrite(url,fileName_new);

%save urlObj
disp(['. image downloaded at ' DateString_long])

%plot urlObj
%NB: in order to plot in the desired figure, its handle visibility property must be 'on' (not 'callback')
img = importdata(fileName_new);
set(0,'currentFigure',handles.figure1) %findobj('name','gui_urlStreaming')
axes(handles.ax_urlObj) %set current axes

if ~trackPixels %plot raw object
    imagesc(img)
    axis image
    title(DateString_long)
    set(handles.ax_urlObj,'box','on','xTickLabel',{},'yTickLabel',{})
end



%% track

if trackPixels

    %--- set INPUTS
    %load input struct
    inputStruct = evalin('base','inputStruct');
    get_struct2var(inputStruct)
    
    %--- set image variables
    imgRaw_rgb = img;
    imgRaw_idx = rgb2ind(imgRaw_rgb, gray, 'nodither');
    imgRaw = double(imgRaw_idx);

    %-- image transformation (crop, rotate)
    if imgTransformation
        img_transformation;
    end
    imgSize = size(imgRaw);
    
    %-- plot (transformed) image
    axes(handles.ax_urlObj) %set current axes
    imagesc(imgRaw_rgb)
    axis image
    title(DateString_long)
    set(handles.ax_urlObj,'box','on','xTickLabel',{},'yTickLabel',{})

    %set other inputs
    idxLine = obj.TasksExecuted;
    frameStrt = 1;
    frameStep = 1; %need for time vector
    %frameEnd = 'last';
    
    FOVv_rad = FOVv_deg * pi/180;
    inclinAngleBase_deg = inclinationAngle_deg - FOVv_deg/2;
    inclinAngleBase_rad = inclinAngleBase_deg * pi/180;
    distSlant = distHoriz / cosd(inclinationAngle_deg);
    pxHeight_cst = distSlant*tan(IFOV);
    pxHeightMat_imgAx = get_pxHeightMatrix(imgSize);
        
    %load needed data
    currentFrame = idxLine;
    if idxLine==1
        imgRef = imgRaw;
        imgPrev = imgRaw;
        
        imgStored.imgPrev = imgRaw;
        imgStored.imgRef = imgRaw;
        obj.UserData = imgStored;
        
    else
        %load stored img data
        imgStored = obj.UserData;
        imgRef = imgStored.imgRef;
        imgPrev = imgStored.imgPrev;
        imgSum = imgStored.imgSum;
        
        %load tracked data (i.e., plumeInfo*)
        trackedData = evalin('base','trackedData');
        get_struct2var(trackedData)

        
        %update stored img data
        imgStored.imgPrev = imgRaw;
        obj.UserData = imgStored;
    end
    
    %--- image processing
    img_processing
    imgStored.imgSum = imgSum;
    obj.UserData = imgStored;
    
    %--- track pixels
    img2track = imgRaw;
    track_plumePx
    
    
    %--- plot plumePixels
    if ~isempty(plumeInfo_pxX)
        hold on
        h=plot(plumeInfo_pxX{idxLine},plumeInfo_pxY{idxLine},'y.','displayName',['plumePixels (' strrep(filterInteraction,'_','\_') ')']); 
        hold off
    end
    
    %export variables of interest to BASE workspace
    var_plumeInfo = who('plumeInfo*');
    var_filtInfo = who('filtInfo*');
    var_measurePts = who('measurePts*');
    var_various = {'atmInfo_refPx_xy';'atmInfo_refPx_tempC';'plumeCoord_px3D'};
    var2export = [var_plumeInfo; var_filtInfo; var_measurePts; var_various];
    for i=1:numel(var2export)
        trackedData.(var2export{i}) = eval(var2export{i});
    end
    assignin('base','trackedData',trackedData);
end