function varargout = gui_imgAnalysis(varargin)
% GUI_IMGANALYSIS MATLAB code for gui_imgAnalysis.fig
%      GUI_IMGANALYSIS, by itself, creates a new GUI_IMGANALYSIS or raises the existing
%      singleton*.
%
%      H = GUI_IMGANALYSIS returns the handle to a new GUI_IMGANALYSIS or the handle to
%      the existing singleton*.
%
%      GUI_IMGANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_IMGANALYSIS.M with the given input arguments.
%
%      GUI_IMGANALYSIS('Property','Value',...) creates a new GUI_IMGANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_imgAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_imgAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_imgAnalysis

% Last Modified by GUIDE v2.5 12-May-2013 19:47:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_imgAnalysis_OpeningFcn, ...
    'gui_OutputFcn',  @gui_imgAnalysis_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_imgAnalysis is made visible.
function gui_imgAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_imgAnalysis (see VARARGIN)

% Choose default command line output for gui_imgAnalysis
handles.output = hObject;

%.center gui on screen
movegui(gcf,'center') 

%clear command window
clc

%.get operating system
OS = computer;
if strfind(OS,'PCWIN'), OS = 'WIN'; slash = '\';
elseif strfind(OS,'GLNX'), OS = 'LNX'; slash = '/';
elseif strfind(OS,'MACI'), OS = 'MAC'; slash = '/';
end
handles.slash = slash;

%.add local toolbox folder to path
path2folder_toolbox = [cd slash 'toolbox'];
addpath(genpath(path2folder_toolbox)) %(if path already defined => will be ignore)
%NB: genpath called inside of addpath => all subfolders added to path

%.add folder for outputs if non-existent
path2folder_outputs = [cd slash 'outputs' slash];
if ~isdir(path2folder_outputs), mkdir('outputs'); end
handles.path2folder_outputs = path2folder_outputs;

%set imgAxis without labels
set(handles.imgAxes,'box','on','xTickLabel',{},'yTickLabel',{})

%disable/enable children of trackingFilters_panel depending on initial status
h_specChild = findobj(handles.trackingFilters_panel, '-not','type','uipanel', '-not','type','text');
filter_plumePx = get(handles.filter_plumePx,'Value');
if filter_plumePx, set(h_specChild,'enable','on')
else set(h_specChild,'enable','off')
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_imgAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_imgAnalysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadImg.
function loadImg_Callback(hObject, eventdata, handles)
% hObject    handle to loadImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slash = handles.slash;

start_path=[cd slash '*.*'];

%. select image
currentPath = cd;
dialog_title = 'select image';
[fileName,pathName,~] = uigetfile(start_path,dialog_title);
if ~ischar(fileName), return, end %if cancel pressed
path = currentPath;
newString = fileName;

%. change push button string
set(hObject,'string',newString,'fontsize',6)

%. plot img
img = importdata([pathName slash fileName]);
imagesc(img)
axis image
set(gca,'fontsize',7)

%. get usefull information
inclinationAngle_deg = str2double(get(handles.inclinationAngle_deg,'string'));
IFOV = str2double(get(handles.IFOV,'string'));
distHoriz = str2double(get(handles.distHoriz,'string'));
distSlant = distHoriz / cosd(inclinationAngle_deg);      %distance from beam to image center
pxHeight_cst = 2*distSlant*tan(IFOV/2); 
handles.pxHeight_cst = pxHeight_cst;


%. enable possibility to track img, or export a region
set(handles.filter_plumePx, 'enable','on');
set(handles.export_imgRegion, 'enable','on');
set(handles.imgTransform, 'enable','on');
set(handles.imgSave_chbox, 'enable','on');

handles.img = img;
handles.imgDim = size(img);
handles.figName = fileName;
handles.pathName = pathName;
guidata(hObject, handles);


% --- Executes on button press in filter_tempThresh.
function filter_tempThresh_Callback(hObject, eventdata, handles)
% hObject    handle to filter_tempThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filter_tempThresh

filter_tempThresh = get(hObject,'Value');

%elts to disable / enable
h = [handles.plumeTemp_thresh,handles.plumeTemp_thresh_txt];

if filter_tempThresh
    set(h,'enable','on')
else
    set(h,'enable','off')   
end

function plumeTemp_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to plumeTemp_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plumeTemp_thresh as text
%        str2double(get(hObject,'String')) returns contents of plumeTemp_thresh as a double


% --- Executes during object creation, after setting all properties.
function plumeTemp_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plumeTemp_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in filter_tempVar.
function filter_tempVar_Callback(hObject, eventdata, handles)
% hObject    handle to filter_tempVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filter_tempVar



function plumeTempVar_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to plumeTempVar_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plumeTempVar_thresh as text
%        str2double(get(hObject,'String')) returns contents of plumeTempVar_thresh as a double


% --- Executes during object creation, after setting all properties.
function plumeTempVar_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plumeTempVar_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in filter_imgRegion.
function filter_imgRegion_Callback(hObject, eventdata, handles)
% hObject    handle to filter_imgRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filter_imgRegion

filter_imgRegion = get(hObject,'Value');

%elts to disable / enable
h = [handles.limH_px,handles.limH_px_txt];

%add or delete possibility to plot image region tracked from list in figMonitor_optnList
if filter_imgRegion, set(h,'enable','on')
else set(h,'enable','off')
end

function limH_px_Callback(hObject, eventdata, handles)
% hObject    handle to limH_px (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of limH_px as text
%        str2double(get(hObject,'String')) returns contents of limH_px as a double


% --- Executes during object creation, after setting all properties.
function limH_px_CreateFcn(hObject, eventdata, handles)
% hObject    handle to limH_px (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function ventY_Callback(hObject, eventdata, handles)
% hObject    handle to ventY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ventY as text
%        str2double(get(hObject,'String')) returns contents of ventY as a double

%set same value in textbox vent_pxY_txt (image transformation panel)
set(handles.vent_pxY_txt,'string',get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function ventY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ventY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_filters.
function set_filters_Callback(hObject, eventdata, handles)
% hObject    handle to set_filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%define default values
handles.fileType = 'image matrix';


%. detect whether image=radiometric (=> if .mat files)
%  NB: info for color map that will be used
matFormat = strfind(handles.figName,'.mat');
if ~isempty(matFormat), handles.radiometricData = 1;
else handles.radiometricData = 0;
end

define_filterValues(handles)


% --- Executes on button press in filter_plumePx.
function filter_plumePx_Callback(hObject, eventdata, handles)
% hObject    handle to filter_plumePx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filter_plumePx

filter_plumePx = get(hObject,'Value');

%- handles of children in panel "filter plume pixels"
%  => get child which are NOT panels, NOT axes, NOT text
%  NB: handle visibility for "track temperature variation" set to off, hence not seen by findobj. This is because imgRef not defined in this GUI.
h_specChild = findobj(handles.trackingFilters_panel, '-not','type','uipanel', '-not','type','text');

%- handles of filter children to enable/disable depending on value
h_disable = [];
filt_tempThresh = get(handles.filter_tempThresh,'value');
if ~filt_tempThresh
    h_disable = [h_disable; handles.plumeTemp_thresh; handles.plumeTemp_thresh_txt];
end
filt_imgRegion = get(handles.filter_imgRegion,'value');
if ~filt_imgRegion
    h_disable = [h_disable; handles.limH_px; handles.limH_px_txt];
end

%- handles for "plot tracked features" objects
h_objFeat = [handles.trackedFeatures_optnList, handles.trackedFeatures_txt, handles.trackedFeatures_plot, handles.trackedFeatures_clear];


if filter_plumePx
    set(h_specChild,'enable','on')
    set(h_disable,'enable','off')
    
else
    set(h_specChild,'enable','off')
    
    %.fitPlumeFeat_chbox
    set(handles.fitPlumeFeat_chbox, 'value',0);
    fitPlumeFeat_chbox_Callback(hObject, eventdata, handles)
    set(handles.fitPlumeFeat_chbox, 'enable','off');
    
    %.tempProfile_chbox
    set(handles.tempProfile_chbox, 'value',0);
    tempProfile_chbox_Callback(hObject, eventdata, handles)
    set(handles.tempProfile_chbox, 'enable','off');
    
    %.trackedFeatures_optnList
    set(handles.trackedFeatures_optnList,'string','empty')
    set(handles.trackedFeatures_optnList,'value',1);
    set(h_objFeat,'enable','off');

    %set(h_specChild,'enable','off')
    
    % delete all plotted features
    trackedFeatures_clear_Callback(hObject, eventdata, handles)
    handles = guidata(hObject); %updates the copy of the handles that has been updated
end

handles.h_specChild=h_specChild;
handles.h_objFeat=h_objFeat;
guidata(hObject, handles);

% --- Executes on button press in filter.
function filter_Callback(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%DELETE ALL ELTS PREVIOUSLY PLOTTED ON IMG
%. delete tracked features
if isfield(handles, 'h_feat')
    %h = handles.h_feat;
    %idxHandle = find(ishandle(h));
    %delete(h(idxHandle))
    delete(handles.h_feat); 
    handles=rmfield(handles,'h_feat'); 
    guidata(hObject, handles);
end

%. delete fit elts on img
if isfield(handles,'h_limUpper'), delete(handles.h_limUpper), handles=rmfield(handles,'h_limUpper'); end
if isfield(handles,'h_limLower'), delete(handles.h_limLower), handles=rmfield(handles,'h_limLower'); end
if isfield(handles,'h_featSel2fit'), delete(handles.h_featSel2fit), handles=rmfield(handles,'h_featSel2fit'); end
if isfield(handles,'h_feat2fit'), delete(handles.h_feat2fit), handles=rmfield(handles,'h_feat2fit'); end
if isfield(handles,'h_fit'), delete(handles.h_fit), handles=rmfield(handles,'h_fit'); end
guidata(hObject, handles);

%!!! the filtering to collect the plume pixels has to be done in a rather "un-elegant" form,
% i.e. by analysing each img line, from the vent position to the img top.
%This method (function "track_plumePx", used in the tracking algorithm in plumeTracker.m) has the advatage of storing the pixel
% coordinates in an intelligible way, which is not the case when finding the intersection of several sets of pixels (i.e. method in define_filterValues.m).

%% LOAD VARIABLES NEEDED IN FUNCTION "track_plumePx"

%-get input recording settings
frameRate = NaN;
inclinationAngle_deg = str2num(get(handles.inclinationAngle_deg,'string'));
FOVv_deg = str2num(get(handles.FOV_v,'string'));
IFOV = str2num(get(handles.IFOV,'string'));
distHoriz = str2num(get(handles.distHoriz,'string'));

%inclinationAngle_rad = inclinationAngle_deg * pi/180;   %inclination angle in radian
inclinAngleBase_deg = inclinationAngle_deg - FOVv_deg/2;
inclinAngleBase_rad = inclinAngleBase_deg * pi/180;
distSlant = distHoriz / cosd(inclinationAngle_deg);      %distance from beam to image center

%-pxHeightMatrix for pixel height correction
pxHeight_cst = 2*distSlant*tan(IFOV/2);                 %for plume volume computation; equ. from Harris (book)
imgTransformation = 0;
pxHeightMat_imgAx = get_pxHeightMatrix(handles.imgDim);

%-various
imgRaw = handles.img;
imgSize = handles.imgDim;
currentFrame = NaN;
idxLine = 1;

%- tracking filters
%.filter img region
filter_imgRegion = get(handles.filter_imgRegion,'Value');
ventY = str2double(get(handles.ventY,'String'));
limH_px = get(handles.limH_px,'String'); %sym function from Symbolic Math Toolbox could be used
if strfind(limH_px,'<')
    side_ofLimH = 'left'; limH_px=str2num(limH_px(2:end));
elseif strfind(limH_px,'>')
    side_ofLimH = 'right'; limH_px=str2num(limH_px(2:end));
else h = msgbox('Horizontal limit not properly defined: add < or > before numeric value','warning','none'); uiwait(h); return
end
%.filter temp thresh
filter_tempThresh = get(handles.filter_tempThresh,'Value');
if filter_tempThresh
    [operation_onTempThresh,plumeTemp_thresh,~] = get_threshold(handles.plumeTemp_thresh);
    if strcmp(operation_onTempThresh,'error'), return, end
    handles.plumeTemp_threshVal = plumeTemp_thresh;
    guidata(hObject, handles);
end
%.filter temp variation
filter_tempVar = get(handles.filter_tempVar,'Value');
if filter_tempVar
    plumeTempVar_thresh = str2double(get(handles.plumeTempVar_thresh,'String'));
    plumeTempVar_thresh_str = get(handles.plumeTempVar_thresh,'String');
end
%.filter interaction
h_sel=get(handles.filterInteraction_panel,'SelectedObject');
filterInteraction = get(h_sel,'tag');



%% TRACK PLUME PIXELS

%set img to track
img2track = imgRaw; %imgRaw; imgDiff_framePrev; imgDiff_frameStrt

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


%% ADD TRACKED FEATURES which can be plotted in listbox

%.get tracked features
% define_varCharact0
% optnList = feat_nameGUI;

%.get specific tracked features
define_varCharact; %get var charac: feat_nameGUI, feat_nameVarX, feat_nameVarY, feat_symbol, feat_legTxt
idx_imgFiltFeat = find(~cellfun('isempty',strfind(feat_parentOp, 'imgFiltering')));
optnList = feat_nameGUI(idx_imgFiltFeat);

set(handles.h_objFeat,'enable','on');
set(handles.trackedFeatures_optnList,'string',optnList)
set(handles.trackedFeatures_optnList,'value',size(optnList,1));

%% STORE var tracked on img in structure file
var_plumeInfo = who('plumeInfo*');
var2export = var_plumeInfo; %[var_plumeInfo; var_atmInfo; var_filtInfo; var_imgInfo; var_measurePts; var_inputParam; var_various];
for i=1:numel(var2export)
    plumeInfo_struct.(var2export{i}) = eval(var2export{i});
end
handles.plumeInfo_struct = plumeInfo_struct;
guidata(hObject, handles);


%enable fit checkbox
set(handles.fitPlumeFeat_chbox, 'enable','on');


% --- Executes on selection change in trackedFeatures_optnList.
function trackedFeatures_optnList_Callback(hObject, eventdata, handles)
% hObject    handle to trackedFeatures_optnList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns trackedFeatures_optnList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trackedFeatures_optnList

%Enable mutliple selection:
% NB: "To enable multiple selection in a list box, you must set the Min and Max properties so that Max - Min > 1. You must change the default Min and Max values of 0 and 1 to meet these conditions. Use the Property Inspector to set these properties on the list box."
set(hObject,'max',2);



% --- Executes during object creation, after setting all properties.
function trackedFeatures_optnList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trackedFeatures_optnList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in trackedFeatures_plot.
function trackedFeatures_plot_Callback(hObject, eventdata, handles)
% hObject    handle to trackedFeatures_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--- LOAD variables from structure file:
get_struct2var(handles.plumeInfo_struct)

%--- LOAD tracked features characteristics
define_varCharact; %get var charac: feat_nameGUI, feat_nameVarX, feat_nameVarY, feat_symbol, feat_legTxt

%- get selected plot optn
selection_idx = get(handles.trackedFeatures_optnList,'Value');
% contents = cellstr(get(handles.trackedFeatures_optnList,'String'));
% selection_txt = contents{selection_idx};

%- load/create handles of plotted features
if isfield(handles,'h_feat'), h_feat=handles.h_feat;
else h_feat=[];
end

%loop through requested plot optns => through requested trackedFeatures to plot
for i=1 : numel(selection_idx)
    
    idx = selection_idx(i); %index in the selected optns to plot
    idxLine = 1;            %idxLine=1 because only 1 frame tracked (idxLine = line index in data vector = each line holds values for 1 frame)
    
    %loop within a given trackedFeature (in case several distinct features should be plotted)
    if ischar(feat_nameVarX{idx}), nbFeat = 1; %(case if 1 elt => character array)
    elseif iscell(feat_nameVarX{idx}), nbFeat = numel(feat_nameVarX{idx});
    end
    for j=1 : nbFeat
        nameVarX = feat_nameVarX{idx}; if iscell(nameVarX), nameVarX=cell2mat(feat_nameVarX{idx}(j)); end
        nameVarY = feat_nameVarY{idx}; if iscell(nameVarY), nameVarY=cell2mat(feat_nameVarY{idx}(j)); end
          
        %get variable content
        try %case if variable existent in current workspace
            X = eval(nameVarX); 
            Y = eval(nameVarY); 
        catch %case if variable existent in handles function 
            X = handles.(nameVarX); 
            Y = handles.(nameVarY); 
        end
        
        %get variable graphic characteristics
        color = feat_color{idx}; if iscell(color), color=cell2mat(feat_color{idx}(j)); end
        marker = feat_marker{idx}; if iscell(marker), marker=cell2mat(feat_marker{idx}(j)); end
        line = feat_lineStyle{idx}; if iscell(line), line=cell2mat(feat_lineStyle{idx}(j)); end
        legend = feat_legTxt{idx}; if iscell(legend), legend=cell2mat(feat_legTxt{idx}(j)); end
        
        %plot
        if iscell(X), nbElts=size(X,1);
        else nbElts=1; X={X}; Y={Y};
        end
        for k=1:nbElts %loop within feature elements (if several)
            hold on
            h_feat(numel(h_feat)+1) = plot(X{k}, Y{k}, 'color',color, 'marker',marker, 'lineStyle',line, 'displayName', legend);
        end
    end
end

handles.h_feat = h_feat;
guidata(hObject, handles);


% --- Executes on button press in trackedFeatures_clear.
function trackedFeatures_clear_Callback(hObject, eventdata, handles)
% hObject    handle to trackedFeatures_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%delete handles.h_feat objects
% if isfield(handles, 'h_feat'); delete(handles.h_feat), handles=rmfield(handles, 'h_feat'); end
% guidata(hObject, handles);

%get handle of ALL objects
h_obj = findobj(handles.imgAxes,'-not','type','image','-not','type','axes');
if ~isempty(h_obj)
    
    delete(h_obj); %delete ALL objects (h_feat + h_feat2fit)
    
    if isfield(handles, 'h_feat'); handles=rmfield(handles, 'h_feat'); end
    if isfield(handles,'h_feat2fit'); handles=rmfield(handles, 'h_feat2fit'); end
    if isfield(handles,'h_limUpper'), handles=rmfield(handles,'h_limUpper'); end
    if isfield(handles,'h_featSel2fit'), handles=rmfield(handles,'h_featSel2fit'); end

    guidata(hObject, handles);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FIT PLUME FEATURES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in fitPlumeFeat_chbox.
function fitPlumeFeat_chbox_Callback(hObject, eventdata, handles)
% hObject    handle to fitPlumeFeat_chbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of fitPlumeFeat_chbox

fitPlumeFeat_chbox = get(hObject,'Value');

if fitPlumeFeat_chbox
    h = [handles.selectFeat2fit_statTxt; handles.selectFeat2fit_listbox];
    set(h,'enable','on');
    
else
    h_child = get(handles.fitPlumeFeat_panel,'children');
    set(h_child,'enable','off');
    
    %delete polynomial fit equation & inclination angle if any
    set(handles.polynomialEquation,'string','')
    set(handles.bentAngle,'string','')
    
    %delete fit elts on img
    if isfield(handles,'h_limUpper'), delete(handles.h_limUpper), handles=rmfield(handles,'h_limUpper'); end
    if isfield(handles,'h_limLower'), delete(handles.h_limLower), handles=rmfield(handles,'h_limLower'); end
    if isfield(handles,'h_featSel2fit'), delete(handles.h_featSel2fit), handles=rmfield(handles,'h_featSel2fit'); end
    if isfield(handles,'h_feat2fit'), delete(handles.h_feat2fit), handles=rmfield(handles,'h_feat2fit'); end
    if isfield(handles,'h_fit'), delete(handles.h_fit), handles=rmfield(handles,'h_fit'); end
    guidata(hObject,handles);
    
    %delete any plotted elts with displayName='fit'
    h_obj = findobj(handles.imgAxes,'-not','type','image','-not','type','axes','displayName','fit');
    delete(h_obj);
    
    %suppress options in listbox (if any)
    parentOp2find = 'fitFeature';
    plottingList_editOptn(parentOp2find,handles,'removeOptn')
    
end

function yLim_upper_Callback(hObject, eventdata, handles)
% hObject    handle to yLim_upper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yLim_upper as text
%        str2double(get(hObject,'String')) returns contents of yLim_upper as a double

%%%%code if push button to draw y-range exists
% if strcmp(yLim_txt,'none') && strcmp(get(handles.yLim_lower,'String'),'none')
%    set(handles.fit_drawYlim,'enable','off')
%    if isfield(handles,'h_limUpper'), delete(handles.h_limUpper), end
% else
%    set(handles.fit_drawYlim,'enable','on')
% end
%%%

yLim_upper_txt = get(hObject,'String');

if isfield(handles,'h_limUpper'), delete(handles.h_limUpper), handles=rmfield(handles,'h_limUpper'); end
if isfield(handles,'h_featSel2fit'), delete(handles.h_featSel2fit), handles=rmfield(handles,'h_featSel2fit'); end

feat2fit_pxX = handles.feat2fit_pxX;
feat2fit_pxY = handles.feat2fit_pxY;

%idx lower lim
yLim_lower_txt = get(handles.yLim_lower,'string');
if ~strcmp(yLim_lower_txt,'none')
    yLim_lower = str2num(yLim_lower_txt);
    idx_lowerLim = find(feat2fit_pxY<yLim_lower);
else idx_lowerLim = 1:numel(feat2fit_pxY);
end

%idx lower lim
if strcmp(yLim_upper_txt,'none')
    idx_upperLim = 1:numel(feat2fit_pxY);
    
else
    %plot line
    yLim_upper = str2num(yLim_upper_txt);
    imgDim = handles.imgDim;
    
    hold on
    h_limUpper = plot([1,imgDim(2)], [yLim_upper,yLim_upper], 'w:');
    handles.h_limUpper = h_limUpper;
    
    %upper lim idx
    yLim_upper = str2num(yLim_upper_txt);
    idx_upperLim = find(feat2fit_pxY>yLim_upper);
end

%intersection idx upper&lower lim
if ~isequal(idx_upperLim, idx_lowerLim)
    idx_inRange = intersect(idx_upperLim, idx_lowerLim);
    
    %.get data selected in requested range
    dat2fit_pxX = feat2fit_pxX(idx_inRange);
    dat2fit_pxY = feat2fit_pxY(idx_inRange);
    
    %.plot selection in feature to track
    hold on
    h_featSel2fit = plot(dat2fit_pxX,dat2fit_pxY,'color',[0.85,0.85,0.85],'marker','.','lineStyle','none');
    
    handles.dat2fit_pxX = dat2fit_pxX;
    handles.dat2fit_pxY = dat2fit_pxY;
    handles.h_featSel2fit = h_featSel2fit;
    
else %case if both 'none'
    handles = rmfield(handles,'dat2fit_pxX');
    handles = rmfield(handles,'dat2fit_pxY');
end

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function yLim_upper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yLim_upper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function yLim_lower_Callback(hObject, eventdata, handles)
% hObject    handle to yLim_lower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yLim_lower as text
%        str2double(get(hObject,'String')) returns contents of yLim_lower as a double

%%%%code if push button to draw y-range exists
% if strcmp(yLim_txt,'none') && strcmp(get(handles.yLim_upper,'String'),'none')
%    set(handles.fit_drawYlim,'enable','off')
%    if isfield(handles,'h_limLower'), delete(handles.h_limLower), end
% else
%    set(handles.fit_drawYlim,'enable','on')
% end
%%%

yLim_lower_txt = get(hObject,'String');

if isfield(handles,'h_limLower'), delete(handles.h_limLower), handles=rmfield(handles,'h_limLower'); end
if isfield(handles,'h_featSel2fit'), delete(handles.h_featSel2fit), handles=rmfield(handles,'h_featSel2fit'); end

feat2fit_pxX = handles.feat2fit_pxX;
feat2fit_pxY = handles.feat2fit_pxY;

%idx upper upper lim
yLim_upper_txt = get(handles.yLim_upper,'string');
if ~strcmp(yLim_upper_txt,'none')
    yLim_upper = str2num(yLim_upper_txt);
    idx_upperLim = find(feat2fit_pxY>yLim_upper);
else idx_upperLim = 1:numel(feat2fit_pxY);
end

%idx lower lim
if strcmp(yLim_lower_txt,'none')
    idx_lowerLim = 1:numel(feat2fit_pxY);
    
else
    %plot line
    yLim_lower = str2num(yLim_lower_txt);
    imgDim = handles.imgDim;
    hold on
    h_limLower = plot([1,imgDim(2)], [yLim_lower,yLim_lower], 'w:');
    handles.h_limLower = h_limLower;
    
    %lower lim idx
    yLim_lower = str2num(yLim_lower_txt);
    idx_lowerLim = find(feat2fit_pxY<yLim_lower);
    
end

%intersection idx upper&lower lim
if ~isequal(idx_upperLim, idx_lowerLim)
    idx_inRange = intersect(idx_upperLim, idx_lowerLim);
    
    %.get data selected in requested range
    dat2fit_pxX = feat2fit_pxX(idx_inRange);
    dat2fit_pxY = feat2fit_pxY(idx_inRange);
    
    %.plot selection in feature to track
    hold on
    h_featSel2fit = plot(dat2fit_pxX,dat2fit_pxY,'color',[0.85,0.85,0.85],'marker','.','lineStyle','none');
    
    handles.dat2fit_pxX = dat2fit_pxX;
    handles.dat2fit_pxY = dat2fit_pxY;
    handles.h_featSel2fit = h_featSel2fit;
    
else %case if both 'none'
    handles = rmfield(handles,'dat2fit_pxX');
    handles = rmfield(handles,'dat2fit_pxY');
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function yLim_lower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yLim_lower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function polyfitDegree_Callback(hObject, eventdata, handles)
% hObject    handle to polyfitDegree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of polyfitDegree as text
%        str2double(get(hObject,'String')) returns contents of polyfitDegree as a double

%enable bent angle only if fit degree = 1 (line)
degree = str2num(get(handles.polyfitDegree,'string'));
if degree>1
    set(handles.bentAngle, 'enable','off');
else
    set(handles.bentAngle, 'enable','on');
end

% --- Executes during object creation, after setting all properties.
function polyfitDegree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polyfitDegree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function selectFeat2fit_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectFeat2fit_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in selectFeat2fit_listbox.
function selectFeat2fit_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to selectFeat2fit_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectFeat2fit_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectFeat2fit_listbox


%--- LOAD variables from structure file:
get_struct2var(handles.plumeInfo_struct)

contents = cellstr(get(hObject,'String'));
feat2fit_txt = contents{get(hObject,'Value')};

idxLine = 1;
if strcmp(feat2fit_txt,'plumeEdge_left')
    feat2fit_pxX = plumeInfo_plumeEdges_pxX{idxLine}(:,1);
    feat2fit_pxY = plumeInfo_plumeEdges_pxY{idxLine}(:,1);
    
elseif strcmp(feat2fit_txt,'plumeEdge_right')
    feat2fit_pxX = plumeInfo_plumeEdges_pxX{idxLine}(:,2);
    feat2fit_pxY = plumeInfo_plumeEdges_pxY{idxLine}(:,2);
    
elseif strcmp(feat2fit_txt,'plumeEdge_middle')
    feat2fit_pxX = plumeInfo_plumeMiddles_pxXY{idxLine}(:,1);
    feat2fit_pxY = plumeInfo_plumeMiddles_pxXY{idxLine}(:,2);
    
end

%plot feat2fir (and delete previous if any)
if isfield(handles,'h_feat2fit'), delete(handles.h_feat2fit), end
hold on
h_feat2fit = plot(feat2fit_pxX,feat2fit_pxY,'color',[0.5,0.5,0.5],'marker','.','lineStyle','none');


%enable rest of panel children
h_child = get(handles.fitPlumeFeat_panel,'children');
set(h_child, 'enable','on');

%enable bent angle only if fit degree = 1 (line)
degree = str2num(get(handles.polyfitDegree,'string'));
if degree>1
    set(handles.bentAngle, 'enable','off');
end

handles.feat2fit_txt = feat2fit_txt;
handles.feat2fit_pxX = feat2fit_pxX;
handles.feat2fit_pxY = feat2fit_pxY;
handles.h_feat2fit = h_feat2fit;
guidata(hObject, handles);

% --- Executes on button press in fit_plumeFeature.
function fit_plumeFeature_Callback(hObject, eventdata, handles)
% hObject    handle to fit_plumeFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'feat2fit_txt')
    h = msgbox('Select a feature to fit in listbox.','warning','none'); uiwait(h); return
    
else
    
    %get data to fit
    if isfield(handles,'dat2fit_pxX') %data selection within Yrange
        dat2fit_pxX = handles.dat2fit_pxX;
        dat2fit_pxY = handles.dat2fit_pxY;
    else
        dat2fit_pxX = handles.feat2fit_pxX;
        dat2fit_pxY = handles.feat2fit_pxY;
    end
    
    %.get polynomial degree of fit
    polyfitDegree = str2num(get(handles.polyfitDegree,'string'));
    
    %.fit data
    [xFit,yFit,fitCoefs,delta] = fit_data(dat2fit_pxX,dat2fit_pxY,polyfitDegree);
    
    %.print polynom equation
    polyEquation = print_polynomEqu(fitCoefs);
    set(handles.polynomialEquation,'enable','on');
    set(handles.polynomialEquation,'string',polyEquation)
    
    %.print plume bent angle if degree=1
    degree = str2num(get(handles.polyfitDegree,'string'));
    if degree==1
        beta = atand(1/fitCoefs(1)); %(! inclinationAngle_deg = camera inclination)
        set(handles.bentAngle,'enable','on');
        set(handles.bentAngle,'string',num2str(beta,'%.2f'))
    end
    
%     %.plot fit
%     if isfield(handles,'h_fit'), delete(handles.h_fit), end
%     hold on, h_fit = plot(xFit,yFit,'m.');
%     handles.h_fit = h_fit;
   
    %.add possibility to plot fit in listbox
    parentOp2find = 'fitFeature';
    plottingList_editOptn(parentOp2find,handles,'addOptn')

    handles.xFit = xFit;
    handles.yFit = yFit;
    handles.fitCoefs = fitCoefs;
end

set(handles.tempProfile_chbox,'enable','on');
guidata(hObject,handles);


function plottingList_editOptn(parentOp2find,handles,addORremove_optn)
%plottingList_editOptn(parentOp2find,handles,addORremove_optn)
%   INPUTS: .parentOp2find = string searced for in feat_parentOp (=trackedFeatures(:,8));
%           .addORremove_optn = 'addOptn' || 'removeOptn'

%.add possibility to plot fit in listbox
define_varCharact;
idx_featFit = find(~cellfun('isempty',strfind(feat_parentOp, parentOp2find)));

if isempty(idx_featFit)
    disp(['WARNING: string "' parentOp2find '" not found in cellstr "feat_parentOp" => check define_varCharact.m']);

else
    optn2edit = feat_nameGUI(idx_featFit);
    
    for i=1 : numel(optn2edit)
        %check if option to add already exists
        optnList_cell = cellstr(get(handles.trackedFeatures_optnList,'string'));
        optnList = get(handles.trackedFeatures_optnList,'string');
        %idx = find(~cellfun('isempty',strfind(optnList_cell, optn2edit{i})));
        idx = find(strcmp(optn2edit{i},optnList_cell));
        
        %add option in listbox if non existent
        switch addORremove_optn
            case 'addOptn'
                if isempty(idx)
                    optnList_new = char([optnList;optn2edit]);
                    set(handles.trackedFeatures_optnList,'string',optnList_new)
                    set(handles.trackedFeatures_optnList,'value',size(optnList_new,1));
                end
            case 'removeOptn'
                if ~isempty(idx)
                    optnList_new = optnList;
                    optnList_new(idx,:)=[];
                    set(handles.trackedFeatures_optnList,'string',optnList_new)
                    set(handles.trackedFeatures_optnList,'value',size(optnList_new,1));
                end
        end
        
    end
end

    
%PUSH BUTTON TO DRAW Y-RANGE LIMIT:

% % --- Executes on button press in fit_drawYlim.
% function fit_drawYlim_Callback(hObject, eventdata, handles)
% % hObject    handle to fit_drawYlim (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% %DRAW RECTAGLE
%
% % h_img = findobj(gcf,'type','axes');
% % insertmenufcn(h_img, 'Rectangle')     %launch rectangle
% % gco
% % waitfor(gco,'position')               %pb: 'position'  property of rectangle does not change
% % %waitfor(gcf,'children')              %pb: rectagle not stored as children, nor in gcf nor in image axis
% % uiwait(gco);
% % activateuimode(gcf,'')                %reactivate GUI mode
% % pos = get(gco,'position');            %POSITION not intelligible with respect to img coordinates, whichever 'units' property chosen
%
%
% %DRAW Y-range
% imgDim = handles.imgDim;
%
% yLim_upper_txt = get(handles.yLim_upper,'String');
% yLim_lower_txt = get(handles.yLim_lower,'String');
%
% if ~strcmp(yLim_upper_txt,'none')
%     yLim_upper = str2num(yLim_upper_txt);
%     hold on
%     h_limUpper = plot([1,imgDim(2)], [yLim_upper,yLim_upper], 'w:');
%     handles.h_limUpper = h_limUpper;
% end
%
% if ~strcmp(yLim_lower_txt,'none')
%     yLim_lower = str2num(yLim_lower_txt);
%     hold on
%     h_limLower = plot([1,imgDim(2)], [yLim_lower,yLim_lower], 'w:');
%     handles.h_limLower = h_limLower;
% end
%
% guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function tempProfile_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempProfile_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in condLimProfile_temp.
function condLimProfile_temp_Callback(hObject, eventdata, handles)
% hObject    handle to condLimProfile_temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of condLimProfile_temp


% --- Executes on button press in condLimProfile_fixed.
function condLimProfile_fixed_Callback(hObject, eventdata, handles)
% hObject    handle to condLimProfile_fixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of condLimProfile_fixed



function thresh4limit_T_Callback(hObject, eventdata, handles)
% hObject    handle to thresh4limit_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh4limit_T as text
%        str2double(get(hObject,'String')) returns contents of thresh4limit_T as a double


% --- Executes during object creation, after setting all properties.
function thresh4limit_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh4limit_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thresh4limit_pxNb_Callback(hObject, eventdata, handles)
% hObject    handle to thresh4limit_pxNb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh4limit_pxNb as text
%        str2double(get(hObject,'String')) returns contents of thresh4limit_pxNb as a double


% --- Executes during object creation, after setting all properties.
function thresh4limit_pxNb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh4limit_pxNb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tempProfile_chbox.
function tempProfile_chbox_Callback(hObject, eventdata, handles)
% hObject    handle to tempProfile_chbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tempProfile_chbox

tempProfile_chbox = get(hObject,'Value');

if tempProfile_chbox
    h_child = findobj(handles.tempProfile_panel,'-not','type','uipanel','-not','tag','plotProfiles');
    set(h_child,'enable','on')
    
    h_selObj = get(handles.threshold4lim_bttongrp,'selectedObject');
    threshold4lim_bttongrp_SelectionChangeFcn(h_selObj, [], handles)
else
    h_child = findobj(handles.tempProfile_panel,'-not','type','uipanel');
    set(h_child,'enable','off')
    
    %delete any plotted elts with displayName='profile'
    h_obj = findobj(handles.imgAxes,'-not','type','image','-not','type','axes','displayName','profile');
    delete(h_obj);
    
    %suppress options in listbox (if any)
    parentOp2find = 'getProfile';
    plottingList_editOptn(parentOp2find,handles,'removeOptn')
end


% --- Executes when selected object is changed in threshold4lim_bttongrp.
function threshold4lim_bttongrp_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in threshold4lim_bttongrp 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

%created by right clic in GUIDE

selTag = get(hObject,'tag');

h_set1 = [handles.thresh4limit_T; handles.thresh4limit_T_txt];
h_set2 = [handles.thresh4limit_pxNb; handles.thresh4limit_pxNb_txt];

%enable/disable associated text boxes
if strcmp(selTag,'condLimProfile_temp')
    set(h_set1,'enable','on')
    set(h_set2,'enable','off')
    
    limThresh_type = 'temperature';
    limThresh_val = str2num(get(handles.thresh4limit_T,'string'));
    
elseif strcmp(selTag,'condLimProfile_fixed')
    set(h_set1,'enable','off')
    set(h_set2,'enable','on')
    
    limThresh_type = 'pixel';
    limThresh_val = str2num(get(handles.thresh4limit_pxNb,'string'));
end

handles.limThresh_type = limThresh_type;
handles.limThresh_val = limThresh_val;
guidata(hObject, handles);


% --- Executes on selection change in tempProfile_listbox.
function tempProfile_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to tempProfile_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tempProfile_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tempProfile_listbox


% --- Executes on button press in getProfiles.
function getProfiles_Callback(hObject, eventdata, handles)
% hObject    handle to getProfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%get chosen axis for profile from listbox
contents = cellstr(get(handles.tempProfile_listbox,'String'));
selectionTxt = contents{get(handles.tempProfile_listbox,'Value')};

%get chosen outer limit for profile
h_selObj = get(handles.threshold4lim_bttongrp,'selectedObject');
threshold4lim_bttongrp_SelectionChangeFcn(h_selObj, [], handles)
limThresh_type = handles.limThresh_type;
switch limThresh_type
    case 'temperature'
        limThresh_val = str2double(get(handles.thresh4limit_T,'string'));
    case 'pixel'
        limThresh_val = str2double(get(handles.thresh4limit_pxNb,'string'));
end


%delete any plotted profiles
h_obj = findobj(handles.imgAxes,'-not','type','image','-not','type','axes','displayName','profile');
delete(h_obj);

switch selectionTxt
    case 'normal lines from fit'
        
        %.get normals to fit
        handles = fitNormals(handles);
        %collected data:
        % - prof_axisPxX
        % - prof_axisPxY
        % - prof_axisPxT
        % - prof_center_idx
        % - prof_center_pxX
        % - prof_center_pxY
        % - prof_center_pxT
        
        %.get profile limits
        handles = get_profileLim(handles,limThresh_type,limThresh_val);
        %collected data:
        % - prof_idxL
        % - prof_idxR
        % - prof_idxC_selPx
        % - prof_pxX
        % - prof_pxY
        % - prof_pxT
        
        %.get distances in meters
        handles = get_distInMeters(handles);
        %collected data:
        % - prof_distAxialCenter_m
        % - prof_distRadial_fromCenter_m
        % - vent_pxX
        % - vent_pxY
        % - vent_idx
        
        %.get plume edge pixels on radial profiles
        handles = get_plumeEdgesNradius_onProfile(handles);
        %collected data:
        % - prof_idxLplume_Tthresh
        % - prof_idxRplume_Tthresh
        % - radiusL_Tthresh
        % - radiusR_Tthresh
        % - radiusMean_Tthresh
        % - plumeTemp_threshGaussian
        % - prof_idxLplume_Tgauss
        % - prof_idxRplume_Tgauss
        % - radiusL_Tgauss
        % - radiusR_Tgauss
        % - radiusMean_Tgauss

        %NB: indexes:
        %. prof_idxL,prof_idxR,prof_center_idx = index within full length profile vector
        %. profile_idxC_selPx = index within vector of selected profile pixels
        %. prof_idxL_plume,prof_idxR_plume = index of plume edges within vector of selected profile pixels

        
        %.add possibility to plot axis in listbox
        parentOp2find = 'getProfile';
        plottingList_editOptn(parentOp2find,handles,'addOptn')
        
        %.enable possibility to plot profiles with pushbutton (via a seperate GUI)
        set(handles.plotProfiles,'enable','on')
end

guidata(hObject,handles);


function handles = get_plumeEdgesNradius_onProfile(handles)

plumeTemp_threshVal = handles.plumeTemp_threshVal;
prof_distRadial_fromCenter_m = handles.prof_distRadial_fromCenter_m;
prof_pxT = handles.prof_pxT;
prof_idxC_selPx = handles.prof_idxC_selPx;

prof_axisPxT = handles.prof_axisPxT;
prof_center_idx = handles.prof_center_idx;
prof_center_pxT = handles.prof_center_pxT;

% figure
for i=numel(prof_pxT):-1:1 %bottom to top
    
    %---- from fixed temperature threshold
    %.get plume edges on profile 
    [idxL,idxR] = get_idxLR(prof_pxT{i},prof_idxC_selPx(i),plumeTemp_threshVal);
    if idxL ~= prof_idxC_selPx(i), idxL = idxL +1; end
    if idxR ~= prof_idxC_selPx(i), idxR = idxR -1; end
    prof_idxLplume_Tthresh(i,1) = idxL +1;
    prof_idxRplume_Tthresh(i,1) = idxR -1;
    %NB: idxL+1 & idxR-1 because we want temperatures stricly above plumeTemp_threshVal
    
    %.get plume mean radius on each side of center idx
    radiusL_Tthresh(i,1) = -1*prof_distRadial_fromCenter_m{i}(prof_idxLplume_Tthresh(i,1));
    radiusR_Tthresh(i,1) = prof_distRadial_fromCenter_m{i}(prof_idxRplume_Tthresh(i,1));
    radiusMean_Tthresh(i,1) = mean([radiusL_Tthresh(i,1),radiusR_Tthresh(i,1)]);
    
    %---- at temperature = 1 sigma of center temperature
    Tmin_mean = mean([prof_pxT{i}(1), prof_pxT{i}(end)]);
    %.temperature at 1 sigma of normal distribution = 60% of temperature amplitude
    %     plumeTemp_threshGaussian(i,1) = 0.6065 * (prof_center_pxT(i)-Tmin_mean) +Tmin_mean;
    %.temperature at sqrt(2)*1sigma of normal distribution (= 30% of temperature amplitude)
    plumeTemp_threshGaussian(i,1) = exp(-1) * (prof_center_pxT(i)-Tmin_mean) +Tmin_mean;
    
    %.get plume edges on profile 
    [idxL,idxR] = get_idxLR(prof_pxT{i},prof_idxC_selPx(i),plumeTemp_threshGaussian(i,1));
    %[idxL,idxR] = get_idxLR(prof_axisPxT{i},prof_center_idx(i),plumeTemp_threshGaussian(i,1));
    if idxL ~= prof_idxC_selPx(i), idxL = idxL +1; end
    if idxR ~= prof_idxC_selPx(i), idxR = idxR -1; end
    %NB: idxL+1 & idxR-1 because we want temperatures stricly above threshold
    prof_idxLplume_Tgauss(i,1) = idxL;
    prof_idxRplume_Tgauss(i,1) = idxR;
        
     %.get plume mean radius on each side of center idx
    radiusL_Tgauss(i,1) = -1*prof_distRadial_fromCenter_m{i}(prof_idxLplume_Tgauss(i,1));
    radiusR_Tgauss(i,1) = prof_distRadial_fromCenter_m{i}(prof_idxRplume_Tgauss(i,1));
    radiusMean_Tgauss(i,1) = mean([radiusL_Tgauss(i,1),radiusR_Tgauss(i,1)]);
    
    
%     hold off
%     plot(1:numel(prof_pxT{i}),prof_pxT{i},'-b.'),hold on
%     %plot(idxL:idxR,prof_pxT{i}(idxL:idxR),'-r.')
%     plot([1,numel(prof_pxT{i})],[plumeTemp_threshVal,plumeTemp_threshVal],'k:')
%     plot([1,numel(prof_pxT{i})],[plumeTemp_threshGaussian(i,1),plumeTemp_threshGaussian(i,1)],'m:')
%     xlim([1,numel(prof_pxT{i})])
end

handles.prof_idxLplume_Tthresh = prof_idxLplume_Tthresh;
handles.prof_idxRplume_Tthresh = prof_idxRplume_Tthresh;
handles.radiusL_Tthresh = radiusL_Tthresh;
handles.radiusR_Tthresh = radiusR_Tthresh;
handles.radiusMean_Tthresh = radiusMean_Tthresh;

handles.plumeTemp_threshGaussian = plumeTemp_threshGaussian;
handles.prof_idxLplume_Tgauss = prof_idxLplume_Tgauss;
handles.prof_idxRplume_Tgauss = prof_idxRplume_Tgauss;
handles.radiusL_Tgauss = radiusL_Tgauss;
handles.radiusR_Tgauss = radiusR_Tgauss;
handles.radiusMean_Tgauss = radiusMean_Tgauss;


function handles = get_distInMeters(handles)

prof_pxX = handles.prof_pxX;
prof_pxY = handles.prof_pxY;
prof_axisPxX = handles.prof_axisPxX;
prof_axisPxY = handles.prof_axisPxY;
prof_center_idx = handles.prof_center_idx;
prof_center_pxX = handles.prof_center_pxX;
prof_center_pxY = handles.prof_center_pxY;
        
imgDim = size(handles.img);
inclinationAngle_deg = str2double(get(handles.inclinationAngle_deg,'string'));
FOVv_deg = str2double(get(handles.FOV_v,'string'));
IFOV = str2double(get(handles.IFOV,'string'));
distHoriz = str2double(get(handles.distHoriz,'string'));
[pxHeightMat_imgAx_cumSum,pxHeight_cst]=pxHeightMatrix_cumul(imgDim,inclinationAngle_deg,distHoriz,IFOV,FOVv_deg);

%get vent_pxX & vent_pxY (for calculation of distance from vent)
%   => vent_pxX defined as the profile center pixel where the center intersects the defined ventY level
vent_pxY = str2double(get(handles.ventY,'string'));
[closest_value,closest_idx]=get_closestValue(prof_center_pxY,vent_pxY);
vent_pxX = prof_center_pxX(closest_idx);
vent_idx = closest_idx;

%set vent_pxX in editable textbox vent_pxX_txt (image transformation panel)
set(handles.vent_pxX_txt,'string',num2str(vent_pxX));

vent_pxY_prime = pxHeightMat_imgAx_cumSum(vent_pxY);
vent_pxX_prime = pxHeight_cst * vent_pxX;


for i=numel(prof_axisPxX):-1:1 %bottom to top
    
    %--- axial distance from vent
    prof_center_pxX = prof_axisPxX{i}(prof_center_idx(i));
    prof_center_pxY = prof_axisPxY{i}(prof_center_idx(i));
    center_pxX_prime = pxHeight_cst * prof_center_pxX;
    center_pxY_prime = pxHeightMat_imgAx_cumSum(prof_center_pxY);
    prof_distAxialCenter_m(i,1) = sqrt((center_pxX_prime-vent_pxX_prime)^2 + (center_pxY_prime-vent_pxY_prime)^2);
    %replace by NaN if radial distance is in fact <0
    if prof_center_pxY>vent_pxY, prof_distAxialCenter_m(i,1)=NaN; end
    
    %--- radial distance from profile center
    for j=1:numel(prof_pxX{i,1})
        pxX = prof_pxX{i,1}(j);
        pxX_prime = pxX * pxHeight_cst;
        
        pxY = prof_pxY{i,1}(j);
        pxY_prime = pxHeightMat_imgAx_cumSum(pxY);
        
        prof_distRadial_fromCenter_m{i,1}(j) = sqrt((center_pxX_prime-pxX_prime)^2 + (center_pxY_prime-pxY_prime)^2);
        if pxX<prof_center_pxX, prof_distRadial_fromCenter_m{i,1}(j) = -1 * prof_distRadial_fromCenter_m{i,1}(j); end
    end
    
end

idx_z0 = find(prof_distAxialCenter_m==0);
if ~isequal(vent_idx,idx_z0), disp('vent definition problem'); end

handles.prof_distAxialCenter_m = prof_distAxialCenter_m;
handles.prof_distRadial_fromCenter_m = prof_distRadial_fromCenter_m;
handles.vent_pxX=vent_pxX;
handles.vent_pxY=vent_pxY;
handles.vent_idx=vent_idx;


function [pxHeightMat_imgAx_cumSum,pxHeight_cst]=pxHeightMatrix_cumul(imgDim,inclinationAngle_deg,distHoriz,IFOV,FOVv_deg)

% imgDim = [240,320]
% IFOV = 1.3e-3
% distHoriz = 4500
% FOVv_deg=18

inclinationAngle_rad = inclinationAngle_deg * (pi/180);
FOVv_rad = FOVv_deg * pi/180; 
distSlant = distHoriz / cos(inclinationAngle_rad + FOVv_rad/2);
pxHeight_cst = distSlant*tan(IFOV);

for i=1:imgDim(1)
    pxTop = tan(inclinationAngle_rad + i*IFOV) * distHoriz;
    pxBottom = tan(inclinationAngle_rad + (i-1)*IFOV) * distHoriz;
    pxHeightMat(i,1) = pxTop - pxBottom;
end
pxHeightMat_imgAx = flipud(pxHeightMat);


pxHeightMat_imgAx_cumSum = cumsum(pxHeightMat_imgAx);


function handles = fitNormals(handles)

xFit=handles.xFit;
yFit=handles.yFit;
fitCoefs=handles.fitCoefs;
imgDim = handles.imgDim;
img = handles.img;

%get normals of fit curve
norm_pxX={}; norm_pxY={}; norm_pxT={};
idx=0;

for i=numel(xFit):-1:1 %bottom to top
    idx = idx+1;
    
    %get coef for normal equation
    normCoefs = [-1/fitCoefs(1) , 1/fitCoefs(1)*xFit(i)+yFit(i)];
    
    %get x,y coordinates of normal for x spanning the entire img
    xNorm = 1:1:imgDim(2);
    yNorm = polyval(normCoefs, xNorm);
    
    %get temperature at given pixels
    %normal_pxX{i,1} = floor(xNorm);
    %normal_pxY{i,1} = floor(yNorm);
    normal_pxX{i,1} = round(xNorm);
    normal_pxY{i,1} = round(yNorm);
    
    %replace pixels rounded outside image (px<=0 or px>imgDim(1)) by pixels at img border
    %  .case 1: value<=0, replace by 1
    idx_out1X = find(normal_pxX{i,1}<=0);
    idx_out1Y = find(normal_pxY{i,1}<=0); 
    if ~isempty(idx_out1X), normal_pxX{i}(idx_out1X)=ones(1,numel(idx_out1X)); end
    if ~isempty(idx_out1Y), normal_pxY{i}(idx_out1Y)=ones(1,numel(idx_out1Y)); end
    %  .case 2: value>imgDim(1), replace by imgDim(1) if on Y, imgDim(2) if on X
    idx_out2X = find(normal_pxX{i,1}<=0);
    idx_out2Y = find(normal_pxY{i,1}<=0); 
    if ~isempty(idx_out2X), normal_pxX{i}(idx_out2X)=ones(1,numel(idx_out2X))*imgDim(2); end
    if ~isempty(idx_out2Y), normal_pxY{i}(idx_out2Y)=ones(1,numel(idx_out2Y))*imgDim(1); end
    
%     %plot normal curve
%     plotNormals=0;
%     if plotNormals, plot(normal_pxX,normal_pxY,'c.'), end
    
    for j=1:numel(normal_pxX{i,1})
       normal_pxT{i,1}(j) = img(normal_pxY{i,1}(j),normal_pxX{i,1}(j));
    end
    
    %find plume center idx
    %idxCenter = find(xNorm==xFit(i));
    [closest_value,closest_idx]=get_closestValue(xNorm,xFit(i));
    center_idx(i,1)=closest_idx;
    center_pxX(i,1) = normal_pxX{i,1}(center_idx(i,1));
    center_pxY(i,1) = normal_pxY{i,1}(center_idx(i,1));
    center_pxT(i,1) = normal_pxT{i,1}(center_idx(i,1));
    %plot(normal_pxX(idxCenter),normal_pxY(idxCenter),'y*')

end

handles.prof_axisPxX = normal_pxX;
handles.prof_axisPxY = normal_pxY;
handles.prof_axisPxT = normal_pxT;
handles.prof_center_idx = center_idx;
handles.prof_center_pxX = center_pxX;
handles.prof_center_pxY = center_pxY;
handles.prof_center_pxT = center_pxT;
        

function handles = get_profileLim(handles,limThresh_type,limThresh_val)

prof_axisPxX = handles.prof_axisPxX;
prof_axisPxY = handles.prof_axisPxY;
prof_axisPxT = handles.prof_axisPxT;
prof_center_idx = handles.prof_center_idx;


for i=numel(prof_axisPxX):-1:1 %bottom to top
    
    %find plume outer limit
    switch limThresh_type
        case 'temperature'
            [idxL,idxR] = get_idxLR(prof_axisPxT{i},prof_center_idx(i),limThresh_val);
            profile_idxL(i) = idxL;
            profile_idxR(i) = idxR;
            
            %center idx in vector of selected profile px
            profile_idxC_selPx(i) = prof_center_idx(i) - profile_idxL(i);
            
        case 'pixel'
            profile_idxL(i) = prof_center_idx(i)-limThresh_val;
            profile_idxR(i) = prof_center_idx(i)+limThresh_val;
            
            %center idx in vector of selected profile px
            profile_idxC_selPx(i) = prof_center_idx(i) - profile_idxL(i); %=limThresh_val
    end
    
    
%     %plot profile edges
%     hold on
%     plot(prof_axisPxX{i}(idx_outPlumeL),prof_axisPxY{i}(idx_outPlumeL),'r*')
%     plot(prof_axisPxX{i}(idx_outPlumeR),prof_axisPxY{i}(idx_outPlumeR),'g*')
    
    
    %get cross section info
    profile_pxX{i,1} = prof_axisPxX{i}(profile_idxL(i):profile_idxR(i))';
    profile_pxY{i,1} = prof_axisPxY{i}(profile_idxL(i):profile_idxR(i))';
    profile_pxT{i,1} = prof_axisPxT{i}(profile_idxL(i):profile_idxR(i))';
    profile_pxCenterXY(i,1:2) = [prof_axisPxX{i}(prof_center_idx(i)), prof_axisPxY{i}(prof_center_idx(i))];
    %     norm_prof_center_idx(idx,1) = prof_center_idx;
    
    %get radii of points in cross section
    norm_pxr=[];
    for k=1:numel(profile_pxX{i})
        deltaX = prof_axisPxX{i}(prof_center_idx(i)) - profile_pxX{i}(k);
        deltaY = prof_axisPxY{i}(prof_center_idx(i)) - profile_pxY{i}(k);
        norm_pxr(k,1) = sqrt((deltaX)^2 + (deltaY)^2);
        if deltaX>0, norm_pxr(k,1) = -1 * norm_pxr(k,1); end
    end
    profile_distR_px{i,1} = norm_pxr;
    
%     plot(profile_pxX{i},profile_pxY{i},'y.')
%     for j=1:numel(profile_pxX{i,1}), plot(profile_pxX{i,1}(j),profile_pxY{i,1}(j),'k.'); end
end

handles.prof_idxL = profile_idxL;
handles.prof_idxR = profile_idxR;
handles.prof_idxC_selPx = profile_idxC_selPx;
handles.prof_pxX = profile_pxX;
handles.prof_pxY = profile_pxY;
handles.prof_pxT = profile_pxT;

function [idxL,idxR] = get_idxLR(vector,centerIdx,threshVal)

%left limit
for j= centerIdx : -1 : 1 %floor(xFit(i)) : -1 : min(pxX)
    if vector(j)<threshVal
        idxL=j;
        break
    else
        idxL=1;
    end
end

%right limit
for j= centerIdx : numel(vector) %floor(xFit(i)) : 1 : max(pxX)
    if vector(j)<threshVal
        idxR=j;
        break
    else
        idxR=numel(vector);
    end
end

            
function polynomialEquation_Callback(hObject, eventdata, handles)
% hObject    handle to polynomialEquation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of polynomialEquation as text
%        str2double(get(hObject,'String')) returns contents of polynomialEquation as a double


% --- Executes during object creation, after setting all properties.
function polynomialEquation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polynomialEquation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function bentAngle_Callback(hObject, eventdata, handles)
% hObject    handle to bentAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bentAngle as text
%        str2double(get(hObject,'String')) returns contents of bentAngle as a double


% --- Executes during object creation, after setting all properties.
function bentAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bentAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in export_imgRegion.
function export_imgRegion_Callback(hObject, eventdata, handles)
% hObject    handle to export_imgRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of export_imgRegion

export_imgRegion = get(hObject,'Value');

%- handles of children in panel "filter plume pixels"
%  => get child which are NOT panels, NOT axes, NOT text
%  NB: handle visibility for "track temperature variation" set to off, hence not seen by findobj. This is because imgRef not defined in this GUI.
h_specChild = findobj(handles.export_imgRegion_panel, '-not','type','uipanel', '-not','type','text');

if export_imgRegion
    set(h_specChild,'enable','on')
    imgDim = handles.imgDim;
    img = handles.img;

    %if isfield(handles,'h_expReg'), delete(handles.h_expReg); end
    h_reg2exp = findobj(handles.imgAxes,'displayName','region2export');
    delete(h_reg2exp);
    
    xRange_left = get(handles.xRange_left,'string'); if ~strcmp(xRange_left,'none'), xRange_left=str2num(xRange_left); else xRange_left = 1; end
    xRange_right = get(handles.xRange_right,'string'); if ~strcmp(xRange_right,'none'), xRange_right=str2num(xRange_right); else xRange_right = imgDim(2); end
    yRange_bottom = get(handles.yRange_bottom,'string'); if ~strcmp(yRange_bottom,'none'), yRange_bottom=str2num(yRange_bottom); else yRange_bottom = imgDim(1); end
    yRange_top = get(handles.yRange_top,'string'); if ~strcmp(yRange_top,'none'), yRange_top=str2num(yRange_top); else yRange_top = 1; end
    
    imgRegion = img(yRange_top:yRange_bottom,xRange_left:xRange_right);
    handles.imgRegion = imgRegion;
    
    width = xRange_right-xRange_left;
    height = yRange_bottom-yRange_top;
    
    
    rectangle('Position',[xRange_left,yRange_top,width,height],'EdgeColor','r','displayName','region2export')
    %h_expReg = rectangle('Position',[xRange_left,yRange_top,width,height],'EdgeColor','r','displayName','region2export');
    %handles.h_expReg = h_expReg;
    
else
    set(h_specChild,'enable','off')
    
    h_reg2exp = findobj(handles.imgAxes,'displayName','region2export');
    delete(h_reg2exp);
    %     if isfield(handles,'h_expReg'),
    %         delete(handles.h_expReg);
    %         handles=rmfield(handles,'h_expReg');
    %         handles = guidata(hObject);
    %     end

end

guidata(hObject,handles);


function xRange_right_Callback(hObject, eventdata, handles)
% hObject    handle to xRange_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xRange_right as text
%        str2double(get(hObject,'String')) returns contents of xRange_right as a double

export_imgRegion_Callback(handles.export_imgRegion, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function xRange_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xRange_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function xRange_left_Callback(hObject, eventdata, handles)
% hObject    handle to xRange_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xRange_left as text
%        str2double(get(hObject,'String')) returns contents of xRange_left as a double
export_imgRegion_Callback(handles.export_imgRegion, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function xRange_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xRange_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yRange_top_Callback(hObject, eventdata, handles)
% hObject    handle to yRange_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yRange_top as text
%        str2double(get(hObject,'String')) returns contents of yRange_top as a double
export_imgRegion_Callback(handles.export_imgRegion, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function yRange_top_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yRange_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function yRange_bottom_Callback(hObject, eventdata, handles)
% hObject    handle to yRange_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yRange_bottom as text
%        str2double(get(hObject,'String')) returns contents of yRange_bottom as a double
export_imgRegion_Callback(handles.export_imgRegion, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function yRange_bottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yRange_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in export_imgFile.
function export_imgFile_Callback(hObject, eventdata, handles)
% hObject    handle to export_imgFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imgRegion = handles.imgRegion;
path2folder_outputs = handles.path2folder_outputs;

fileName = get(handles.export_imgFileName,'string');

%plot image region
figure; imagesc(imgRegion); axis image;
save_sv([path2folder_outputs fileName],'jpg')

%save image region in matrix format
save([path2folder_outputs fileName],'imgRegion')
disp('Image region successfully exported.')


% --- Executes on button press in save_img.
function save_img_Callback(hObject, eventdata, handles)
% hObject    handle to save_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%plot image
figure

cLim=[]; %cLim=[0,125];
if ~isempty(cLim), imagesc(handles.img,cLim);
else imagesc(handles.img);
end 
axis image

% colormap(cmap_jet_baseK)
h_cb=colorbar; set(get(h_cb,'ylabel'),'string','temperature [°C]')
set(gca,'visible','on') %off => make axis tick labels invisible
h_ax = findobj('type','axes'); set(h_ax,'fontsize',7)

%copy any children object on GUI figure onto new figure
h_obj = findobj(handles.imgAxes,'-not','type','image','-not','type','axes');
if ~isempty(h_obj)
    copyobj(h_obj,gca);
end

% %copy the plotted features onto new image
% if isfield(handles,'h_feat')
%     %trackedFeatures_plot_Callback(hObject, eventdata, handles) %=> do not call function otherwise will increase h_feat matrix (when figure closure => pb with elt deleting)
%     hFeat_stackedOK = fliplr(handles.h_feat);
%     copyobj(hFeat_stackedOK,gca);
% end

%save image
figName = get(handles.imgSave_name,'string');
pathNfile = [handles.path2folder_outputs figName];
figFormat0 = get(handles.imgSave_format,'string');
[figFormat]=figFormat_str2cell(figFormat0); %redefine figFormat as cell array
save_sv(pathNfile,figFormat);

%reset GUI as current img
set(0,'currentFigure',handles.figure1)


% --- Executes on button press in imgSave_chbox.
function imgSave_chbox_Callback(hObject, eventdata, handles)
% hObject    handle to imgSave_chbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imgSave_chbox

imgSave_chbox = get(hObject,'Value');
h_child = get(handles.imgSave_panel,'children');
if imgSave_chbox
    set(h_child,'enable','on')
else
    set(h_child,'enable','off')
end

function imgSave_name_Callback(hObject, eventdata, handles)
% hObject    handle to imgSave_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imgSave_name as text
%        str2double(get(hObject,'String')) returns contents of imgSave_name as a double


% --- Executes during object creation, after setting all properties.
function imgSave_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgSave_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function imgSave_format_Callback(hObject, eventdata, handles)
% hObject    handle to imgSave_format (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imgSave_format as text
%        str2double(get(hObject,'String')) returns contents of imgSave_format as a double


% --- Executes during object creation, after setting all properties.
function imgSave_format_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgSave_format (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inclinationAngle_deg_Callback(hObject, eventdata, handles)
% hObject    handle to inclinationAngle_deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inclinationAngle_deg as text
%        str2double(get(hObject,'String')) returns contents of inclinationAngle_deg as a double


% --- Executes during object creation, after setting all properties.
function inclinationAngle_deg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inclinationAngle_deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function distHoriz_Callback(hObject, eventdata, handles)
% hObject    handle to distHoriz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of distHoriz as text
%        str2double(get(hObject,'String')) returns contents of distHoriz as a double


% --- Executes during object creation, after setting all properties.
function distHoriz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distHoriz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IFOV_Callback(hObject, eventdata, handles)
% hObject    handle to IFOV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IFOV as text
%        str2double(get(hObject,'String')) returns contents of IFOV as a double


% --- Executes during object creation, after setting all properties.
function IFOV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IFOV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FOV_h_Callback(hObject, eventdata, handles)
% hObject    handle to FOV_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FOV_h as text
%        str2double(get(hObject,'String')) returns contents of FOV_h as a double


% --- Executes during object creation, after setting all properties.
function FOV_h_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FOV_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FOV_v_Callback(hObject, eventdata, handles)
% hObject    handle to FOV_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FOV_v as text
%        str2double(get(hObject,'String')) returns contents of FOV_v as a double


% --- Executes during object creation, after setting all properties.
function FOV_v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FOV_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotProfiles.
function plotProfiles_Callback(hObject, eventdata, handles)
% hObject    handle to plotProfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plot_plumeProfiles(handles)



function export_imgFileName_Callback(hObject, eventdata, handles)
% hObject    handle to export_imgFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of export_imgFileName as text
%        str2double(get(hObject,'String')) returns contents of export_imgFileName as a double


% --- Executes during object creation, after setting all properties.
function export_imgFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to export_imgFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rotAngle_editTxt_Callback(hObject, eventdata, handles)
% hObject    handle to rotAngle_editTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotAngle_editTxt as text
%        str2double(get(hObject,'String')) returns contents of rotAngle_editTxt as a double

% --- Executes during object creation, after setting all properties.
function rotAngle_editTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotAngle_editTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function img_widthL_Callback(hObject, eventdata, handles)
% hObject    handle to img_widthL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of img_widthL as text
%        str2double(get(hObject,'String')) returns contents of img_widthL as a double


% --- Executes during object creation, after setting all properties.
function img_widthL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img_widthL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function img_widthR_Callback(hObject, eventdata, handles)
% hObject    handle to img_widthR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of img_widthR as text
%        str2double(get(hObject,'String')) returns contents of img_widthR as a double

% --- Executes during object creation, after setting all properties.
function img_widthR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img_widthR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function img_heightBelow_Callback(hObject, eventdata, handles)
% hObject    handle to img_heightBelow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of img_heightBelow as text
%        str2double(get(hObject,'String')) returns contents of img_heightBelow as a double

% --- Executes during object creation, after setting all properties.
function img_heightBelow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img_heightBelow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function img_heightAbove_Callback(hObject, eventdata, handles)
% hObject    handle to img_heightAbove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of img_heightAbove as text
%        str2double(get(hObject,'String')) returns contents of img_heightAbove as a double

% --- Executes during object creation, after setting all properties.
function img_heightAbove_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img_heightAbove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function vent_pxX_txt_Callback(hObject, eventdata, handles)
% hObject    handle to vent_pxX_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vent_pxX_txt as text
%        str2double(get(hObject,'String')) returns contents of vent_pxX_txt as a double

% --- Executes during object creation, after setting all properties.
function vent_pxX_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vent_pxX_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function vent_pxY_txt_Callback(hObject, eventdata, handles)
% hObject    handle to vent_pxY_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vent_pxY_txt as text
%        str2double(get(hObject,'String')) returns contents of vent_pxY_txt as a double

% --- Executes during object creation, after setting all properties.
function vent_pxY_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vent_pxY_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in imgTransform.
function imgTransform_Callback(hObject, eventdata, handles)
% hObject    handle to imgTransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imgTransform

imgTransform = get(hObject,'Value');

h = findobj(handles.imgTransform_panel, '-not','type','uipanel');
h_specON = [handles.imgTransf_mUnits; handles.imgTransf_rotation];

if imgTransform
    set(h_specON,'enable','on')
    
    %enable panel content if necessary
    %.dilatation panel
    if get(handles.imgTransf_mUnits,'value'), set(get(handles.imgTransf_dilatationPanel,'children'),'enable','on'); end;
    %.rotation panel
    imgTransf_rotation_Callback(handles.imgTransf_rotation, eventdata, handles)
    
else
    set(h,'enable','off')
end


% --- Executes on button press in imgTransf_rotation.
function imgTransf_rotation_Callback(hObject, eventdata, handles)
% hObject    handle to imgTransf_rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imgTransf_rotation

imgTransf_rotation = get(hObject,'Value');
h_panel = get(handles.imgTransf_rotationPanel,'children');

if imgTransf_rotation
    set(h_panel, 'enable', 'on');
else
    set(h_panel, 'enable', 'off');
end



% --- Executes on button press in imgTransf_resample.
function imgTransf_resample_Callback(hObject, eventdata, handles)
% hObject    handle to imgTransf_resample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imgTransf_resample

imgTransf_resample = get(hObject,'Value');
hChild = get(handles.imgTransf_resamplePanel,'children');

if imgTransf_resample
    set(hChild,'enable','on');
    set(handles.plot_newImg,'enable','off'); %optn should be unable only after resampling done
else
    set(hChild,'enable','off');
end


% --- Executes on button press in imgTransf_mUnits.
function imgTransf_mUnits_Callback(hObject, eventdata, handles)
% hObject    handle to imgTransf_mUnits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of imgTransf_mUnits

imgTransf_mUnits = get(hObject,'Value');
h_panel = get(handles.imgTransf_dilatationPanel,'children');

if imgTransf_mUnits
    
    %.enable panel
    set(h_panel,'enable','on');
    
    %.open or create figure 'fig_imgTransform' (where img transormations are plotted)
    h_imgT = findobj(0,'name','fig_imgTransform');
    if isempty(h_imgT), figure('name','fig_imgTransform'); plotbrowser %open plot brower automatically
    else set(0,'currentFigure',h_imgT), plotbrowser; hold on
    end
    
    %.get pixel size matrix
    img = handles.img;
    imgDim=handles.imgDim;
    inclinationAngle_deg = str2double(get(handles.inclinationAngle_deg,'string'));
    FOVv_deg = str2double(get(handles.FOV_v,'string'));
    IFOV = str2double(get(handles.IFOV,'string'));
    distHoriz = str2double(get(handles.distHoriz,'string'));
    [pxHeightMat_imgAx_cumSum,pxHeight_cst]=pxHeightMatrix_cumul(imgDim,inclinationAngle_deg,distHoriz,IFOV,FOVv_deg);
    
    %.get img mesh
    %---coordinates with CST px size
    X_pxCst = (1:1:imgDim(2))*pxHeight_cst;
    Y_pxCst = (1:1:imgDim(1))'*pxHeight_cst;
    %plot RAW temperatures on a meshgrid with CST px sizes
    [X2_cstPx,Y2_cstPx] = meshgrid(X_pxCst,Y_pxCst);
    if isempty(findobj(gca,'displayName','img_pxCst_meshPlot'))
        mesh(X2_cstPx,Y2_cstPx,img,'displayName','img_pxCst_meshPlot'); hold on
    end
%     %imagesc(X_pxCst,Y_pxCst,img,'displayName','img_pxCst_imgPlot'); hold on

    
    %---coordinates with VAR pixel size
    Y_pxVar = pxHeightMat_imgAx_cumSum;
    X_pxVar = (1:1:imgDim(2))*pxHeight_cst;
    %plot RAW temperatures on a meshgrid with VAR px size
    [X2_pxVar,Y2_pxVar] = meshgrid(X_pxVar, Y_pxVar);
    if isempty(findobj(gca,'displayName','img_pxVar_meshPlot'))
        mesh(X2_pxVar,Y2_pxVar,img,'displayName','img_pxVar_meshPlot');
    end
%     imagesc(X_pxVar,Y_pxVar,img,'displayName','img'); hold on
    
%NB: several problems are encountered when plotting onto the same figure both mesh plots and images:
%- when plotting more then 3 elts (2 mesh + 1 img) in figure the plotbrowser becomes empty
%- when plotting mesh + img => axis labels + legend will eventually be flipped (like looking into mirror

    axis image; view([0 0 1]); 
    set(gca,'ydir','reverse')
    
    handles.X_pxVar=X_pxVar;
    handles.Y_pxVar=Y_pxVar;
    handles.X2_pxVar=X2_pxVar;
    handles.Y2_pxVar=Y2_pxVar;
    guidata(hObject, handles);

else
    set(h_panel,'enable','off');
end


% --- Executes on button press in imgRotate.
function imgRotate_Callback(hObject, eventdata, handles)
% hObject    handle to imgRotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%.open or create figure 'fig_imgTransform' (where img transormations are plotted)
h_imgT = findobj(0,'name','fig_imgTransform');
if isempty(h_imgT), figure('name','fig_imgTransform'); plotbrowser %open plot brower automatically
else set(0,'currentFigure',h_imgT), plotbrowser; hold on
end

%.load data
if isfield(handles,'X2_pxVar')
    X2_pxVar=handles.X2_pxVar;
    Y2_pxVar=handles.Y2_pxVar;
else
    %call imgTransf_mUnits
    imgTransf_mUnits_Callback(hObject, eventdata, handles)
    handles = guidata(hObject); %updates the copy of the handles that has been updated
    
    %delete image with cst pixel size
    h_pxCst=findobj(gca,'displayName','img_pxCst_meshPlot');
    delete(h_pxCst);
    
    X2_pxVar=handles.X2_pxVar;
    Y2_pxVar=handles.Y2_pxVar;
end
img=handles.img;
imgDim=handles.imgDim;

%.get rotation angle
%--rotate
rotAngle_deg = str2double(get(handles.rotAngle_editTxt,'string'));

rotationMat = [cosd(rotAngle_deg) -sind(rotAngle_deg); sind(rotAngle_deg) cosd(rotAngle_deg)];
coord2rot = [X2_pxVar(:)'; Y2_pxVar(:)'];

coordRot = rotationMat * coord2rot;
Xrot_vec = coordRot(1,:)';
Yrot_vec = coordRot(2,:)';

%---reshape vector into grid
Xrot_mat = reshape(Xrot_vec,imgDim);
Yrot_mat = reshape(Yrot_vec,imgDim);

mesh(Xrot_mat,Yrot_mat,img,'displayName','img_rot_meshPlot');
axis image tight; view([0 0 1]);
set(gca,'ydir','reverse')

%export needed data
handles.rotAngle_deg = rotAngle_deg;
handles.rotationMat = rotationMat;
guidata(hObject, handles);

%enable possibility to resample image
set(handles.imgTransf_resample,'enable','on')
imgTransf_resample_Callback(handles.imgTransf_resample, eventdata, handles) %to enable/disable resampling panel

% --- Executes on button press in imgResample.
function imgResample_Callback(hObject, eventdata, handles)
% hObject    handle to imgResample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%.open or create figure 'fig_imgTransform' (where img transormations are plotted)
h_imgT = findobj(0,'name','fig_imgTransform');
if isempty(h_imgT), figure('name','fig_imgTransform'); plotbrowser %open plot brower automatically
else set(0,'currentFigure',h_imgT), plotbrowser; hold on
end

%.load data
rotAngle_deg = handles.rotAngle_deg;
X_pxVar = handles.X_pxVar;
Y_pxVar = handles.Y_pxVar;
rotationMat = handles.rotationMat;
pxHeight_cst = handles.pxHeight_cst;
img = handles.img;

%- vent in rotated coord

%.vent position in img raw
% NB: values of vent_pxX & vent_pxY are taken from vent_pxX_txt & vent_pxY_txt textboxes.
% Default values set in 'vent_pxX_txt' & 'vent_pxY_txt':
% vent_pxY_txt => when textbox 'ventY' updated, 'vent_pxY_txt' is set the same
% vent_pxX_txt => when 'getProfiles' called, 'vent_pxX' defined as the profile center pixel where the center intersects the defined ventY level
% If user changes values of 'vent_pxX_txt' & 'vent_pxY_txt' manually, it will only be taken into account in this function

vent_pxX = str2double(get(handles.vent_pxX_txt,'string'));
vent_pxY = str2double(get(handles.vent_pxY_txt,'string'));

%.vent position in pxVar space
ventX_pxVarSpace = X_pxVar(vent_pxX);
ventY_pxVarSpace = Y_pxVar(vent_pxY); %hold on, h_vent = plot(ventX_pxVarSpace,ventY_pxVarSpace,'m*'); %NB: plotted on a 3D mesh => to seen this point, the image should be rotated
if isempty(findobj(gca,'displayName','ventPosition'))
    plot3([ventX_pxVarSpace,ventX_pxVarSpace],[ventY_pxVarSpace,ventY_pxVarSpace],[0,max(img(:))],'-mo','displayName','ventPosition'), hold on
end

%.vent position in rotated pxVar space
coord2rot = [ventX_pxVarSpace; ventY_pxVarSpace];
coordRot = rotationMat * coord2rot;
vent_pxXrot = coordRot(1,:);
vent_pxYrot = coordRot(2,:);
if isempty(findobj(gca,'displayName','ventPosition_inRotImg'))
    plot3([vent_pxXrot,vent_pxXrot],[vent_pxYrot,vent_pxYrot],[0,max(img(:))],'-m*','displayName','ventPosition_inRotImg'), hold on
end

%- space to query
img_widthL = str2double(get(handles.img_widthL,'string'));
img_widthR = str2double(get(handles.img_widthR,'string'));
img_heightAbove = str2double(get(handles.img_heightAbove,'string'));
img_heightBelow = str2double(get(handles.img_heightBelow,'string'));

X_query = vent_pxXrot-img_widthL : pxHeight_cst : vent_pxXrot+img_widthR;
Y_query = (vent_pxYrot-img_heightAbove : pxHeight_cst : vent_pxYrot+img_heightBelow)';

[X2_query,Y2_query] = meshgrid(X_query, Y_query);
mesh(X2_query,Y2_query,zeros(size(X2_query)),'displayName','imgNew_mesh','edgeColor','g'); hold on


%--- interpolate

%- interpolate on rotated img
%=> NOT WORKING BECAUSE Xrot_mat not in meshgrid format
%     T_query = interp2(Xrot_mat,Yrot_mat,img,X_query,Y_query,'linear');
%     %plot INTERP temperatures on a meshgrid with CST px size
%     [X2_query,Y2_query] = meshgrid(X_query, Y_query);
%     hold on, h_figInterp=mesh(X2_query,Y2_query,img,'displayName','fig_interp');
%     axis image; view([0 0 1]); set(gca,'ydir','reverse')

%- interpolate on un-rotated img
%.un-rotate space to query
rotAngleBack_deg = rotAngle_deg *-1;
R = [cosd(rotAngleBack_deg) -sind(rotAngleBack_deg); sind(rotAngleBack_deg) cosd(rotAngleBack_deg)];
coord2rot = [X2_query(:)'; Y2_query(:)'];
coordRot = R * coord2rot;
XrotB_vec = coordRot(1,:)';
YrotB_vec = coordRot(2,:)';
XrotB_mat = reshape(XrotB_vec,size(X2_query));
YrotB_mat = reshape(YrotB_vec,size(X2_query));

%.plot un-rotated space to query
mesh(XrotB_mat,YrotB_mat,zeros(size(X2_query)),'displayName','imgNew_mesh_unRotated','edgeColor','g');
%.interpolate space to query on un-rotated img
T_query = interp2(X_pxVar,Y_pxVar,img,XrotB_mat,YrotB_mat,'linear');
mesh(XrotB_mat,YrotB_mat,T_query,'displayName','imgNew_resampled');

axis image tight; view([0 0 1]);
set(gca,'ydir','reverse')

%.plot interpolated point on rotated space to query
%     mesh(X2_query,Y2_query,T_query,'displayName','imgNew_resampled_rotImg');

handles.X_query = X_query;
handles.Y_query = Y_query;
handles.T_query = T_query;
guidata(hObject, handles);

%enable possibility to plot new image in vent-centered coordinates
set(handles.plot_newImg,'enable','on');

% --- Executes on button press in plot_newImg.
function plot_newImg_Callback(hObject, eventdata, handles)
% hObject    handle to plot_newImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_newImg

plot_newImg = get(hObject,'Value');

%---plot new image (dilated+rotated+resampled)
if plot_newImg
    
    %.load data
    img_widthL = str2double(get(handles.img_widthL,'string'));
    img_widthR = str2double(get(handles.img_widthR,'string'));
    pxHeight_cst = handles.pxHeight_cst;
    Y_query = handles.Y_query;
    T_query = handles.T_query;
    
    %.define axis with origin = vent
    X3_vec = -1*img_widthL : pxHeight_cst : img_widthR;
    Y3_vec = -1*(Y_query - Y_query(end))';
    [X3,Y3] = meshgrid(X3_vec, Y3_vec);
    

    %.plot as 3D mesh
    figure
    mesh(X3,Y3,T_query);
    axis image; %view([-45,45]); 
    xlabel('radial distance (from vent) [m]');
    ylabel('axial distance (from vent) [m]');
    zlabel('temperature [°C]')
    %figName = ['meshgrid_newIMG_from_pxVarImg-rotated' num2str(angle_deg) '-resampled'];
    %figName = [handles.path2folder_outputs figName];
    %save_sv(figName, {'fig','jpg'})
    
    %.plot as 2D image
    figure
    cLim = []; %[0,100];
    if isempty(cLim), imagesc(X3_vec,Y3_vec,T_query);
    else imagesc(X3_vec,Y3_vec,T_query,cLim);
    end
    
    axis image; set(gca,'ydir','normal')
    xlabel('radial distance (from vent) [m]'); ylabel('axial distance (from vent) [m]');
    h_cb=colorbar;
    set(get(h_cb,'ylabel'),'string','temperature [°C]');
    %figName = ['newIMG_from_pxVarImg-rotated' num2str(angle_deg) '-resampled'];
    %figName = [handles.path2folder_outputs figName];
    %save_sv(figName, {'fig','jpg'})
    %---
end 


% --- Executes on selection change in imgSubstraction_list.
function imgSubstraction_list_Callback(hObject, eventdata, handles)
% hObject    handle to imgSubstraction_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imgSubstraction_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imgSubstraction_list


% --- Executes during object creation, after setting all properties.
function imgSubstraction_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgSubstraction_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imgSubstraction_frame_Callback(hObject, eventdata, handles)
% hObject    handle to imgSubstraction_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imgSubstraction_frame as text
%        str2double(get(hObject,'String')) returns contents of imgSubstraction_frame as a double


% --- Executes during object creation, after setting all properties.
function imgSubstraction_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgSubstraction_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
