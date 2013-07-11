function plot_pxHeightCorrection(varargin)

if isempty(varargin)
    %=> if pxHeightMat_imgAx defined in base workspace

    load_workspaceVar

else
    %=> if pxHeightMat_imgAx never defined (i.e., plot called before code has ever been runned)

    handles = varargin{1};
    
    %get image dimensions
    imgSize = [240, 320];
    disp(['INFO: default image dimensions (' num2str(imgSize) ') defined for pixel-size matrix plot (untill image opened for the first time).'])
    
    %get inclination angle
    inclinationAngle_deg = str2double(get(handles.inclinationAngle_deg,'String'));
    FOVv_deg = str2double(get(handles.FOV_v,'String'));
    inclinAngleBase_deg = inclinationAngle_deg - FOVv_deg/2;
    inclinAngleBase_rad = inclinAngleBase_deg * pi/180;
    
    %get IFOV
    IFOV = str2double(get(handles.IFOV,'String'));
    
    %get distHoriz
    distHoriz = str2double(get(handles.distHoriz,'String'));
    
    %get pixel height matrix
    pxHeightMat_imgAx = get_pxHeightMatrix(imgSize);
    
end

if inclinationAngle_deg>0
    pxHeightMat = flipud(pxHeightMat_imgAx);
    %NB: pxHeightMat_imgAx => index = same as image axis: 1=top of image=max size pixel; 240=bottom of image=min size pixel
else
    pxHeightMat = pxHeightMat_imgAx;
end

figure
for i=1:imgSize(1)
    plot([0,imgSize(2)],[pxHeightMat(i),pxHeightMat(i)]); hold on
end
    
if inclinationAngle_deg<0
    set(gca,'ydir','reverse')
end


ylabel('pixel vertical extent [m]'); xlabel('image width [pixel number]'); axis tight;
h=title(['matrix size = ' num2str(size(pxHeightMat,1)) ' x ' num2str(size(pxHeightMat,2))]);
set(h,'fontSize',8)

% if figSave
%     figureName = [figName 'pxHeight_variation'];
%     save_sv(figureName,figFormat)
% end
