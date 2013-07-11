function varargout = define_filterValues(varargin)
% DEFINE_FILTERVALUES MATLAB code for define_filterValues.fig
%      DEFINE_FILTERVALUES, by itself, creates a new DEFINE_FILTERVALUES or raises the existing
%      singleton*.
%
%      H = DEFINE_FILTERVALUES returns the handle to a new DEFINE_FILTERVALUES or the handle to
%      the existing singleton*.
%
%      DEFINE_FILTERVALUES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE_FILTERVALUES.M with the given input arguments.
%
%      DEFINE_FILTERVALUES('Property','Value',...) creates a new DEFINE_FILTERVALUES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_filterValues_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_filterValues_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define_filterValues

% Last Modified by GUIDE v2.5 12-Feb-2013 14:39:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @define_filterValues_OpeningFcn, ...
                   'gui_OutputFcn',  @define_filterValues_OutputFcn, ...
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


% --- Executes just before define_filterValues is made visible.
function define_filterValues_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define_filterValues (see VARARGIN)

% Choose default command line output for define_filterValues
handles.output = hObject;


%EDITED:

%-- upload handles structure from gui_plumeTracker
H = varargin{1};
handles.H = H;

%. center gui on screen
movegui(gcf,'center') 

%. get name of calling gui
calling_guiName = get(H.figure1,'name');

if strcmp(calling_guiName,'gui_plumeTracker')
    
    %.load image storage
    %[imgStorage,nbFrames]=load_imgStorage(H);
    pathName = handles.H.pathName;
    fileType = handles.H.fileType;
    frameEnd = handles.H.frameEnd;
    if isfield(handles.H,'videoName'), videoName = handles.H.videoName; end
    load_imgStorage;
    
    if exist('frameRate_video','var'); handles.frameRate_video = frameRate_video; end
    handles.imgStorage=imgStorage;
    handles.nbFrames=nbFrames;
    guidata(hObject,handles);
    
    %.get frame to upload
    if nbFrames>1
        frame2use=nbFrames/2; frame2use=floor(frame2use);
    else frame2use=1;
    end
    set(handles.frame_txt,'string',num2str(frame2use));
    
    %write last frame available
    set(handles.lastFrame_txt,'string', ['(last frame = ' num2str(nbFrames) ')'])

    handles.frame2use = frame2use;
    [imgRef,imgRaw,imgPrev,imgDiff_frameRef,imgDiff_framePrev] = imageLoading(handles);

elseif strcmp(calling_guiName,'gui_imgAnalysis')
    
    frame2use=H.figName;
    handles.frame2use = frame2use;
    set(handles.frame_txt,'string',frame2use,'FontWeight','normal','fontsize',7);
    
    %set GUI elements invisible
    set(handles.lastFrame_txt,'visible', 'off')
    
    %disable GUI elements
    set(handles.filtThreshVar_chbox,'enable', 'off')
    
    %-- open imgage
    %.img RAW
    imgRaw = importdata([H.pathName frame2use]);
    
    %.img ref
    %NONE specified => imgRef = imgRaw
    imgRef = imgRaw;
    imgPrev = imgRaw;
    
    %.img operations
    imgDiff_frameRef = imgRaw - imgRef;     %img difference with frameStart
    imgDiff_framePrev = imgRaw - imgPrev;    %img difference with previousFrame
    
end

handles.imgRef=imgRef;
handles.imgPrev=imgPrev;
handles.imgRaw=imgRaw;
handles.imgDiff_frameRef=imgDiff_frameRef;
handles.imgDiff_framePrev=imgDiff_framePrev;
guidata(hObject,handles);


%set filter optns according to selection in gui_plumeTracker
set(handles.filtThresh_chbox,'value',get(H.filter_tempThresh,'value')); 
set(handles.filtThreshVar_chbox,'value',get(H.filter_tempVar,'value')); 
set(handles.filtThresh_txt,'string',get(H.plumeTemp_thresh,'string')); 
set(handles.imgSubstraction_list,'value', get(H.imgSubstraction_list,'value'));
set(handles.imgSubstraction_frame,'string', get(H.imgSubstraction_frame,'string'));
set(handles.filtThreshVar_txt,'string',get(H.plumeTempVar_thresh,'string')); 
set(handles.filtImgReg_chbox,'value',get(H.filter_imgRegion,'value')); 
set(handles.filtImgReg_txt,'string',get(H.limH_px,'string')); 
set(handles.ventY,'string',get(H.ventY,'string'));

%define slider range/value (value must be within min/max)
[~,plumeTemp_thresh,~] = get_threshold(H.plumeTemp_thresh);
%.slider 1: filtThresh slider
set_sliderProp(handles.filtThresh_sl, imgRaw, plumeTemp_thresh)

%.slider 2: filtThreshVar slider
if strcmp(calling_guiName,'gui_plumeTracker')
    [~,filtThreshVar_val,~] = get_threshold(H.plumeTempVar_thresh);
    thresh4slider = filtThreshVar_val;
    set_sliderProp(handles.filtThreshVar_sl, imgDiff_frameRef, thresh4slider)
elseif strcmp(calling_guiName,'gui_imgAnalysis')
end

%plot images
[h_imgDiff,h_imgDiff_cb]=updateImages(handles,imgRef,imgRaw,imgDiff_frameRef,imgDiff_framePrev);
handles.h_imgDiff_cb=h_imgDiff_cb;
handles.h_imgDiff=h_imgDiff;

selInteraction = get(get(H.filterInteraction_panel,'SelectedObject'),'tag');
switch selInteraction
    case 'filtInteract_all'
        set(handles.filtInteract_all,'value',1);
    case 'filtInteract_one'
        % set(handles.filterInteraction_panel,'selectedObject',findobj(gcf,'tag','filtInteract_one'));
        set(handles.filtInteract_one,'value',1);
end


%plot filtered px
handles.update_filtInteract_ax = 0; %flag=0 => update of filtInteract_ax done before this opening_function is done (otherwise error because all variables not defined)
filtThresh_chbox_Callback(handles.filtThresh_chbox, eventdata, handles)
handles = guidata(hObject); %updates the copy of the handles that has been updated
filtThreshVar_chbox_Callback(handles.filtThreshVar_chbox, eventdata, handles)
handles = guidata(hObject); %updates the copy of the handles that has been updated
filtImgReg_chbox_Callback(handles.filtImgReg_chbox, eventdata, handles)
handles = guidata(hObject); %updates the copy of the handles that has been updated


%plot interaction between filters
filterInteraction_panel_SelectionChangeFcn(hObject, eventdata, handles)

handles.update_filtInteract_ax = 1;
handles.calling_guiName = calling_guiName;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes define_filterValues wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = define_filterValues_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function set_sliderProp(h_slider, img4slider, thresh4slider)
%set_sliderProp(h_slider,img4slider,thresh4slider)

slider_min = min(img4slider(:)); slider_max = max(img4slider(:));

%case if thresh4slider given outside min/max img values
if thresh4slider<slider_min && thresh4slider<slider_max
    slider_min = thresh4slider;
elseif thresh4slider>slider_min && thresh4slider>slider_max
    slider_max = thresh4slider;
end

set(h_slider,'min',slider_min,'max',slider_max,'value',thresh4slider);

%FRAME selection

function frame_txt_Callback(hObject, eventdata, handles)
% hObject    handle to frame_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame_txt as text
%        str2double(get(hObject,'String')) returns contents of frame_txt as a double

frame2use = str2double(get(hObject,'String'));
handles.frame2use = frame2use;

[imgRef,imgRaw,imgPrev,imgDiff_frameRef,imgDiff_framePrev] = imageLoading(handles);
handles.imgRef=imgRef;
handles.imgPrev=imgPrev;
handles.imgRaw=imgRaw;
handles.imgDiff_frameRef=imgDiff_frameRef;
handles.imgDiff_framePrev=imgDiff_framePrev;
guidata(hObject,handles);


%-- check if operation correct
[operation_onTempThresh,plumeTemp_thresh,~] = get_threshold(handles.filtThresh_txt);
[operation_onTempThreshVar,filtThreshVar_val,~] = get_threshold(handles.filtThreshVar_txt);
if strcmp(operation_onTempThresh,'error') || strcmp(operation_onTempThreshVar,'error'),
    return
end

%-- define slider range/value (value must be within min/max)
%.slider 1: filtThresh slider
set_sliderProp(handles.filtThresh_sl, imgRaw, plumeTemp_thresh)
%.slider 2: filtThreshVar slider
imgDiff_list = cellstr(get(handles.imgSubstraction_list,'String'));
imgDiff_sel = imgDiff_list{get(handles.imgSubstraction_list,'Value')};
if strcmp(imgDiff_sel,'fixed substraction'), img4slider = handles.imgDiff_frameRef;
elseif strcmp(imgDiff_sel,'sliding substraction'), img4slider = handles.imgDiff_framePrev;
end
set_sliderProp(handles.filtThreshVar_sl, img4slider, filtThreshVar_val)

%-- update img
[h_imgDiff,h_imgDiff_cb]=updateImages(handles,imgRef,imgRaw,imgDiff_frameRef,imgDiff_framePrev);
handles.h_imgDiff_cb=h_imgDiff_cb;
handles.h_imgDiff=h_imgDiff;

%-- update filtered px
handles.update_filtInteract_ax = 0; %flag=0 => do not update filtInteract_ax during calls to checkbox functions

filtThresh_chbox_Callback(handles.filtThresh_chbox, eventdata, handles); 
handles = guidata(hObject); %updates the copy of the handles that has been updated
filtThreshVar_chbox_Callback(handles.filtThreshVar_chbox, eventdata, handles)
handles = guidata(hObject); %updates the copy of the handles that has been updated
filtImgReg_chbox_Callback(handles.filtImgReg_chbox, eventdata, handles)
handles = guidata(hObject); %updates the copy of the handles that has been updated

handles.update_filtInteract_ax = 1;
guidata(hObject,handles);

%update filter interaction
filterInteraction_panel_SelectionChangeFcn(hObject, eventdata, handles)
% filterInteraction_panel_SelectionChangeFcn(handles.output, [], handles)

% --- Executes during object creation, after setting all properties.
function frame_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%FILTER THRESH

% --- Executes on button press in filtThresh_chbox.
function filtThresh_chbox_Callback(hObject, eventdata, handles)
% hObject    handle to filtThresh_chbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filtThresh_chbox

filtThresh = get(hObject,'Value');
if filtThresh
    set([handles.filtThresh_sl,handles.filtThresh_txt],'enable','on')
    
    %get thresh values
    [operation_onTempThresh,plumeTemp_thresh,~] = get_threshold(handles.filtThresh_txt);
    handles.operation_onTempThresh=operation_onTempThresh;
    handles.plumeTemp_thresh=plumeTemp_thresh;
    if strcmp(operation_onTempThresh,'error'), guidata(hObject,handles), return, end
    
    %add px filtered & update filter interaction panel
    filterThresh_px(handles)
else
    set([handles.filtThresh_sl,handles.filtThresh_txt],'enable','off')
    %delete px filtered
    hpx = findobj(handles.filtThresh_ax,'-not','type','image','-not','type','axes');
    if ~isempty(hpx), delete(hpx), end
    
    handles.filtThresh_pxIdx=[];
    guidata(handles.output,handles)  

    %update filter interaction panel
    if handles.update_filtInteract_ax
        filterInteraction_panel_SelectionChangeFcn(handles.output, [], handles)
    end
end


% --- Executes on slider movement.
function filtThresh_sl_Callback(hObject, eventdata, handles)
% hObject    handle to filtThresh_sl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%round slider value
sliderVal = get(hObject,'Value');
filtThresh_val = round(sliderVal);

%.get thresh values
[operation_onTempThresh,~,~] = get_threshold(handles.filtThresh_txt);

%.change value in text box
if strcmp(operation_onTempThresh,'above'), newStr = ['>' num2str(filtThresh_val)];
elseif strcmp(operation_onTempThresh,'below'), newStr = ['<' num2str(filtThresh_val)];
elseif strcmp(operation_onTempThresh,'abs_above'), newStr = ['>|' num2str(filtThresh_val) '|'];
elseif strcmp(operation_onTempThresh,'abs_below'), newStr = ['<|' num2str(filtThresh_val) '|'];
elseif strcmp(operation_onTempThresh,'error'), return;
end
set(handles.filtThresh_txt,'string',newStr)

%.update slider value
set(hObject,'Value',filtThresh_val)

%.update value in handles
handles.operation_onTempThresh=operation_onTempThresh;
handles.plumeTemp_thresh=filtThresh_val;

%.filter px
filterThresh_px(handles)

% --- Executes during object creation, after setting all properties.
function filtThresh_sl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtThresh_sl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function filtThresh_txt_Callback(hObject, eventdata, handles)
% hObject    handle to filtThresh_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filtThresh_txt as text
%        str2double(get(hObject,'String')) returns contents of filtThresh_txt as a double

[operation_onTempThresh,plumeTemp_thresh,plumeTemp_thresh_str] = get_threshold(hObject);
handles.operation_onTempThresh=operation_onTempThresh;
handles.plumeTemp_thresh=plumeTemp_thresh;

if strcmp(operation_onTempThresh,'error'), guidata(hObject,handles); return, end

%.set slider to value entered
set(handles.filtThresh_sl,'value',plumeTemp_thresh);

%.plot filtered pixels
filterThresh_px(handles)

% --- Executes during object creation, after setting all properties.
function filtThresh_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtThresh_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function filterThresh_px(handles)

imgRaw=handles.imgRaw;
operation_onTempThresh=handles.operation_onTempThresh;
thresh=handles.plumeTemp_thresh;

%define image to search
if strfind(operation_onTempThresh,'abs');
    img2search = abs(imgRaw);
else img2search = imgRaw;
end

if strfind(operation_onTempThresh,'above')
    
    %find pixels with corresponding threshold
    [row,col,~] = find(img2search>thresh);
    
    %delete previous pixels if any and add new
    hpx = findobj(handles.filtThresh_ax,'-not','type','image','-not','type','axes');
    if ~isempty(hpx), delete(hpx), end
    plot(handles.filtThresh_ax,col,row,'r.');
    %axis image; 
    
elseif strfind(operation_onTempThresh,'below')
    
    %find pixels with corresponding threshold
    [row,col,~] = find(img2search<thresh);
    
    %delete previous pixels if any and add new
    hpx = findobj(handles.filtThresh_ax,'-not','type','image','-not','type','axes');
    if ~isempty(hpx), delete(hpx), end
    hold on; plot(handles.filtThresh_ax,col,row,'r.');
    
end

filtThresh_pxIdx = sub2ind(size(imgRaw),row,col);
handles.filtThresh_pxIdx=filtThresh_pxIdx;
guidata(handles.output,handles)

%update filter interaction panel
if handles.update_filtInteract_ax
    filterInteraction_panel_SelectionChangeFcn(handles.output, [], handles)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%FILTER THRESH VAR

% --- Executes on button press in filtThreshVar_chbox.
function filtThreshVar_chbox_Callback(hObject, eventdata, handles)
% hObject    handle to filtThreshVar_chbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filtThreshVar_chbox

filtThreshVar = get(hObject,'Value');

%elts to enable/disable
h = [handles.filtThreshVar_sl;...
    handles.filtThreshVar_txt;...
    get(handles.filtThreshVar_panel,'children')];

if filtThreshVar
    set(h,'enable','on')
    
    %imgSubstraction type chosen
    list = cellstr(get(handles.imgSubstraction_list,'String'));
    selection_txt = list{get(handles.imgSubstraction_list,'Value')};
    if strcmp(selection_txt,'fixed substraction')
        frame2substract = get(handles.imgSubstraction_frame,'string');
        if strcmp(frame2substract, 'previous'), set(handles.imgSubstraction_frame,'string','1'); end
    elseif strcmp(selection_txt,'sliding substraction')
        set(handles.imgSubstraction_frame,'string','previous');
        set(handles.imgSubstraction_frame,'enable','off');
    end
    
    %get thresh value
    [filtThreshVar_op,filtThreshVar_val,~] = get_threshold(handles.filtThreshVar_txt);
    handles.filtThreshVar_op = filtThreshVar_op;
    handles.filtThreshVar_val = filtThreshVar_val;
    if strcmp(filtThreshVar_op,'error'), guidata(hObject,handles), return, end
    
    %add px filtered
    filterThreshVar_px(handles)
    
else
    set(h,'enable','off')
    
    %delete px filtered
    hpx = findobj(handles.filtThreshVar_ax,'-not','type','image','-not','type','axes');
    if ~isempty(hpx), delete(hpx), end  
    
    handles.filtThreshVar_pxIdx=[];
    guidata(handles.output,handles)

    %update filter interaction panel
    if handles.update_filtInteract_ax
        filterInteraction_panel_SelectionChangeFcn(handles.output, [], handles)
    end    
end


% --- Executes on slider movement.
function filtThreshVar_sl_Callback(hObject, eventdata, handles)
% hObject    handle to filtThreshVar_sl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%round slider value
sliderVal = get(hObject,'Value');
filtThreshVar_val = round(sliderVal);

[filtThreshVar_op,~,~] = get_threshold(handles.filtThreshVar_txt);

%.change value in text box
if strcmp(filtThreshVar_op,'above'), newStr = ['>' num2str(filtThreshVar_val)];
elseif strcmp(filtThreshVar_op,'below'), newStr = ['<' num2str(filtThreshVar_val)];
elseif strcmp(filtThreshVar_op,'abs_above'), newStr = ['>|' num2str(filtThreshVar_val) '|'];
elseif strcmp(filtThreshVar_op,'abs_below'), newStr = ['<|' num2str(filtThreshVar_val) '|'];
elseif strcmp(filtThreshVar_op,'error'), return;
end
set(handles.filtThreshVar_txt,'string',newStr)

%.update slider value
set(hObject,'Value',filtThreshVar_val)

handles.filtThreshVar_val=filtThreshVar_val;

%add px filtered
filterThreshVar_px(handles)

% --- Executes during object creation, after setting all properties.
function filtThreshVar_sl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtThreshVar_sl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function filtThreshVar_txt_Callback(hObject, eventdata, handles)
% hObject    handle to filtThreshVar_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filtThreshVar_txt as text
%        str2double(get(hObject,'String')) returns contents of filtThreshVar_txt as a double

[filtThreshVar_op,filtThreshVar_val,~] = get_threshold(handles.filtThreshVar_txt);
handles.filtThreshVar_val=filtThreshVar_val;
handles.filtThreshVar_op=filtThreshVar_op;

if strcmp(filtThreshVar_op,'error'), guidata(hObject,handles); return, end

set(handles.filtThreshVar_sl,'value',filtThreshVar_val);



%add px filtered
filterThreshVar_px(handles)
    
% --- Executes during object creation, after setting all properties.
function filtThreshVar_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtThreshVar_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function filterThreshVar_px(handles)

%get appropriate imgDiff
imgDiff_list = cellstr(get(handles.imgSubstraction_list,'String'));
imgDiff_sel = imgDiff_list{get(handles.imgSubstraction_list,'Value')};
if strcmp(imgDiff_sel,'fixed substraction'), img = handles.imgDiff_frameRef;
elseif strcmp(imgDiff_sel,'sliding substraction'), img = handles.imgDiff_framePrev;
end

%get abs(img) if requested
filtThreshVar_op = handles.filtThreshVar_op;
if strfind(filtThreshVar_op,'abs');
    img = abs(img);
end

%search image
thresh = handles.filtThreshVar_val;
if strfind(filtThreshVar_op,'above')
    [row,col,~] = find(img>thresh);
elseif strfind(filtThreshVar_op,'below'), [row,col,~] = find(img<thresh);
elseif strfind(filtThreshVar_op,'error'), return
end


%delete previous pixels if any and add new
hpx = findobj(handles.filtThreshVar_ax,'-not','type','image','-not','type','axes');
if ~isempty(hpx), delete(hpx), end
hold on; plot(handles.filtThreshVar_ax,col,row,'g.');

filtThreshVar_pxIdx = sub2ind(size(img),row,col);
handles.filtThreshVar_pxIdx=filtThreshVar_pxIdx;
guidata(handles.output,handles)

%update filter interaction panel
if handles.update_filtInteract_ax
    filterInteraction_panel_SelectionChangeFcn(handles.output, [], handles)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%FILTER IMG REG

% --- Executes on button press in filtImgReg_chbox.
function filtImgReg_chbox_Callback(hObject, eventdata, handles)
% hObject    handle to filtImgReg_chbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filtImgReg_chbox

filtImgReg = get(hObject,'Value');

if filtImgReg
    set([handles.filtImgReg_txt, handles.filtImgReg_stattxt],'enable','on')

    filterImgReg_px(handles)
    
else
    set([handles.filtImgReg_txt, handles.filtImgReg_stattxt],'enable','off')
    
%     selectedObj = get(get(handles.filterInteraction_panel,'SelectedObject'),'tag');
%     switch selectedObj
%         case 'filtInteract_all'
%             filtImgReg_pxIdx=[];
%         case 'filtInteract_one'
%             %select px above vent
%             ventY_str = get(handles.H.ventY,'string');
%             ventY = str2double(ventY_str);
%             im = zeros(size(handles.imgRaw));
%             im(1:ventY, 1:size(handles.imgRaw,2)) = 1;
%             filtImgReg_pxIdx = find(im==1);  
%     end

    ventY_str = get(handles.ventY,'string'); ventY = str2double(ventY_str);
    im = zeros(size(handles.imgRaw));
    im(1:ventY, 1:size(handles.imgRaw,2)) = 1;
    filtImgReg_pxIdx = find(im==1);

    handles.filtImgReg_pxIdx=filtImgReg_pxIdx;
    guidata(handles.output,handles)
    
    %delete horiz limit
    h_child=get(handles.filtImgReg_ax,'children');
    h_limH = findobj(h_child,'type','line', 'LineStyle', '-');
    delete(h_limH)
    
    %update filter interaction panel
    if handles.update_filtInteract_ax
        filterInteraction_panel_SelectionChangeFcn(handles.output, [], handles)
    end
end


function filtImgReg_txt_Callback(hObject, eventdata, handles)
% hObject    handle to filtImgReg_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filtImgReg_txt as text
%        str2double(get(hObject,'String')) returns contents of filtImgReg_txt as a double

filterImgReg_px(handles)


% --- Executes during object creation, after setting all properties.
function filtImgReg_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtImgReg_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function filterImgReg_px(handles)

ventY_str = get(handles.ventY,'string');
ventY = str2double(ventY_str);

filtImgReg = get(handles.filtImgReg_chbox,'value');
if filtImgReg
    
    [operation_onThresh,limH,limH_str] = get_threshold(handles.filtImgReg_txt);
    if strcmp(operation_onThresh,'error'), return, end
    
    %delete previous limit if any if add new
    % hpx = findobj(handles.filtImgReg_ax,'-not','type','image','-not','type','axes');
    hpx = findobj(handles.filtImgReg_ax,'tag','limH');
    if ~isempty(hpx), delete(hpx), end
    hold on; plot(handles.filtImgReg_ax,[limH,limH],[ventY,0],'color',[1,1,1],'tag','limH');
    
    %define px filtered
    im = zeros(size(handles.imgRaw));
    if strcmp(operation_onThresh,'above'), im(1:ventY, limH:size(handles.imgRaw,2)) = 1;
    elseif strcmp(operation_onThresh,'below'), im(1:ventY, 1:limH) = 1;
    end
    filtImgReg_pxIdx = find(im==1);
    
else
    %define px filtered
    im = zeros(size(handles.imgRaw));
    im(1:ventY, 1:size(handles.imgRaw,2)) = 1;
    filtImgReg_pxIdx = find(im==1);
    
end
handles.filtImgReg_pxIdx=filtImgReg_pxIdx;
guidata(handles.output,handles)

%update filter interaction panel
if handles.update_filtInteract_ax
    filterInteraction_panel_SelectionChangeFcn(handles.output, [], handles)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FILTER INTERACTION

% --- Executes when selected object is changed in filterInteraction_panel.
function filterInteraction_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in filterInteraction_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

%NB: function created by:
% 1. selecting the button group in the GUIDE Editor
% 2. View > View Callbacks submenu > select "SelectionChangeFcn"

%check
if isfield(handles,'operation_onTempThresh') && strcmp(handles.operation_onTempThresh,'error')
    h = msgbox('Reminder: filt1 threshold not properly defined. Filter interaction not updated.','warning','none'); uiwait(h);
    return
end
if isfield(handles,'filtThreshVar_op') && strcmp(handles.filtThreshVar_op,'error')
    h = msgbox('Reminder: filt2 threshold not properly defined. Filter interaction not updated.','warning','none'); uiwait(h);
    return
end


%get selected object tag
if isempty(eventdata) %function called without pressing button
    h = get(handles.filterInteraction_panel,'SelectedObject');
    selectedObj = get(h,'Tag');
else %function called when pressing button
    selectedObj = get(eventdata.NewValue,'Tag');  % Get Tag of selected object.
end

%delete previous pixels if any
hpx = findobj(handles.filtInteract_ax,'-not','type','image','-not','type','axes');
if ~isempty(hpx), delete(hpx), end

filtThresh_pxIdx = handles.filtThresh_pxIdx;
filtThreshVar_pxIdx = handles.filtThreshVar_pxIdx;
filtImgReg_pxIdx = handles.filtImgReg_pxIdx;

switch selectedObj

        
    %.px must fullfill all filter conditions
    case 'filtInteract_all'
        
        %---if pxFilt vectors empty (=> do something else intersect vector will be empty)
        
        %. set px = all pixels in image (=> if no filt selected, all pixels will be highlighted)
        %         if isempty(filtThresh_pxIdx), filtThresh_pxIdx=find(ones(size(handles.imgRaw))); end
        %         if isempty(filtThreshVar_pxIdx), filtThreshVar_pxIdx=find(ones(size(handles.imgRaw))); end
        
        %. set px = values of non empty pxFilt 
        pxFilt = {filtThresh_pxIdx, filtThreshVar_pxIdx, filtImgReg_pxIdx};
        pxFilt_isempty = cellfun(@isempty,pxFilt);
        idx_empty = find(pxFilt_isempty==1);
        idx_notEmpty = find(pxFilt_isempty==0);
        if isempty(idx_notEmpty) %if all pxFilt vectors empty 
        else %if some pxFilt found empty => replace by non empty ones 
            if find(idx_empty==1), filtThresh_pxIdx = pxFilt{idx_notEmpty(1)}; end
            if find(idx_empty==2), filtThreshVar_pxIdx = pxFilt{idx_notEmpty(1)}; end
            if find(idx_empty==3), filtImgReg_pxIdx = pxFilt{idx_notEmpty(1)}; end
        end
       
        %--- get intersection pixels
        plumePx_idx = intersect(intersect(filtThresh_pxIdx,filtImgReg_pxIdx),filtThreshVar_pxIdx);
        [plumePx_y,plumePx_x] = ind2sub(size(handles.imgRaw),plumePx_idx);
        
        plot(handles.filtInteract_ax,plumePx_x,plumePx_y,'y.');
    
    %.px must fullfill at least one filter conditions
    case 'filtInteract_one'

        plumePx_idx = union(union(filtThresh_pxIdx,filtImgReg_pxIdx),filtThreshVar_pxIdx);
        %plumePx_idx = union(filtThresh_pxIdx,filtThreshVar_pxIdx);
        [plumePx_y,plumePx_x] = ind2sub(size(handles.imgRaw),plumePx_idx);
        plot(handles.filtInteract_ax,plumePx_x,plumePx_y,'y.');
end 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMAGE FUNCTIONS

function [imgRef,imgRaw,imgPrev,imgDiff_frameRef,imgDiff_framePrev] = imageLoading(handles)

frame2use = handles.frame2use;
pathName = handles.H.pathName;
fileType = handles.H.fileType;
imgStorage = handles.imgStorage;

%transform img (crop, rotate, ...)
if isfield(handles.H,'inputs_imgTransf')
    imgTransformation = 1;
    inputs_imgTransf = handles.H.inputs_imgTransf;
else imgTransformation = 0;
end

%load REF image (frame used for fixed img substraction)
imgDiff_list = cellstr(get(handles.imgSubstraction_list,'String'));
imgDiff_sel = imgDiff_list{get(handles.imgSubstraction_list,'Value')};
if strcmp(imgDiff_sel,'fixed substraction'),
    frameRef=str2double(get(handles.imgSubstraction_frame,'string'));
elseif strcmp(imgDiff_sel,'sliding substraction')
    frameRef=frame2use-1;
    if frameRef<=0, frameRef=1; end
end
load_img(frameRef)
if imgTransformation, img_transformation; end
imgRef = imgRaw;

%load PREV img
%NB: needs to be called BEFORE frame2use else imgRaw is overwritten
framePrev = frame2use-1;
if framePrev > 0
    load_img(framePrev)
    if imgTransformation, img_transformation; end
    imgPrev = imgRaw;
    
else imgPrev = imgRaw;
end

%load FRAME to USE 
load_img(frame2use)
if imgTransformation, img_transformation; end

%img PROCESSING
currentFrame = frame2use;
frameStrt = frame2use;
img_processing


function [h_imgDiff,h_imgDiff_cb]=updateImages(handles,imgRef,imgRaw,imgDiff_frameRef,imgDiff_framePrev)
% display image

H = handles.H;

%get name of calling function
[ST,I] = dbstack;
callingFcn_name = ST(2).name;

%delete all images & colorbars
h_cb = findobj(gcf,'type','axes','tag','Colorbar');
h_im = findobj(gcf,'type','image');
delete([h_cb; h_im])

%define color map
radiometricData = H.radiometricData;
if radiometricData, cMap = jet;
else cMap = gray;
end

%filter TRESH
axes(handles.filtThresh_ax);
imagesc(imgRaw); axis image; hold on; 
pos = get(gca,'position');
colormap(cMap); colorbar('location','southoutside');
if ~strcmp(callingFcn_name,'frame_txt_Callback'), axis image; end %avoids image from being re-zoomed when frame changed
set(gca,'position',pos) %reset the size of img to that defined in guide, i.e. before adding colorbar
freezeColors; 
CBH = cbfreeze; set(CBH,'XTickLabelMode','auto') %(default return = manual, powers label not rendered if auto not called)

%filter THRESH VAR
axes(handles.filtThreshVar_ax);
imgDiff_list = cellstr(get(handles.imgSubstraction_list,'String'));
imgDiff_sel = imgDiff_list{get(handles.imgSubstraction_list,'Value')};
if strcmp(imgDiff_sel,'fixed substraction'), imgDiff = imgDiff_frameRef;
elseif strcmp(imgDiff_sel,'sliding substraction'), imgDiff = imgDiff_framePrev;
end
h_imgDiff = imagesc(imgDiff); hold on; 
pos = get(gca,'position');
colormap(eval('cmap_bwr')); 
if ~strcmp(callingFcn_name,'frame_txt_Callback'), axis image; end %avoids image from being re-zoomed when frame changed
h_imgDiff_cb=colorbar('location','southoutside');
center_cAxis_at0 = 1;
if center_cAxis_at0
    max_absVal = max(abs(imgDiff(:))); max_absVal=double(max_absVal);
    caxis([-1 1]*max_absVal);
end
set(gca,'position',pos) %reset the size of img to that defined in guide, i.e. before adding colorbar
freezeColors; CBH=cbfreeze;
set(CBH,'XTickLabelMode','auto') %(default return = manual, powers label not rendered if auto not called)
h_imgDiff_cb=CBH(1); %!! because cbfreeze acts strangely (deleting handle properties once called?), handle redefined using output from cbfreeze
%set(handles.filtThreshVar_sl,'min',min(imgDiff(:)),'max',max(imgDiff(:)))

%filter img region
axes(handles.filtImgReg_ax); 
imagesc(imgRaw); hold on;
pos = get(gca,'position');
colormap(cMap); colorbar('location','southoutside');
if ~strcmp(callingFcn_name,'frame_txt_Callback'), axis image; end %avoids image from being re-zoomed when frame changed
set(gca,'position',pos) %reset the size of img to that defined in guide, i.e. before adding colorbar
freezeColors; CBH=cbfreeze;
set(CBH,'XTickLabelMode','auto') %(default return = manual, powers label not rendered if auto not called)

ventY_str = get(handles.ventY,'string'); ventY = str2double(ventY_str);
w=get(gca,'xlim'); hold on;
plot([w(1),w(2)],[ventY,ventY],'w:','tag','ventY');
text(w(1),ventY,[' ventY = ' ventY_str],'color','w','VerticalAlignment','bottom','tag','ventYtxt');

%filter interaction
axes(handles.filtInteract_ax);
imagesc(imgRaw); hold on;  
pos = get(gca,'position');
colormap(cMap); colorbar('location','southoutside');
if ~strcmp(callingFcn_name,'frame_txt_Callback'), axis image; end %avoids image from being re-zoomed when frame changed
set(gca,'position',pos) %reset the size of img to that defined in guide, i.e. before adding colorbar
freezeColors; CBH=cbfreeze;
set(CBH,'XTickLabelMode','auto') %(default return = manual, powers label not rendered if auto not called)

h_sel=get(handles.filterInteraction_panel,'SelectedObject');
inputStruct.filterInteraction = get(h_sel,'tag');

%set axes fontSize
h_ax = findobj('type','axes'); set(h_ax,'fontsize',7)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in linkaxes_4zoom.
function linkaxes_4zoom_Callback(hObject, eventdata, handles)
% hObject    handle to linkaxes_4zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linkaxes_4zoom

linkaxes_4zoom = get(hObject,'Value');
h_ax = findobj(gcf,'type','axes','-not','tag','Colorbar');
    
if linkaxes_4zoom, linkaxes(h_ax);
else linkaxes(h_ax,'off');
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in imgSubstraction_list.
function imgSubstraction_list_Callback(hObject, eventdata, handles)
% hObject    handle to imgSubstraction_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imgSubstraction_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imgSubstraction_list

imgDiff_list = cellstr(get(hObject,'String'));
imgDiff_sel = imgDiff_list{get(hObject,'Value')};

if strcmp(imgDiff_sel,'fixed substraction')
    frame2substract = get(handles.imgSubstraction_frame,'string');
    if strcmp(frame2substract, 'previous'), set(handles.imgSubstraction_frame,'string','1'); end
    set(handles.imgSubstraction_frame,'enable','on');
    
elseif strcmp(imgDiff_sel,'sliding substraction')
    set(handles.imgSubstraction_frame,'string','previous');
    set(handles.imgSubstraction_frame,'enable','off');
    
end

%re-LOAD images to redefine imgRef & imgDiff_frameRef
[imgRef,~,~,imgDiff_frameRef,~] = imageLoading(handles);
handles.imgRef=imgRef;
handles.imgDiff_frameRef=imgDiff_frameRef;
guidata(hObject,handles);

%UPDATE imgDiff only

%delete image & colorbar associated  
delete([handles.h_imgDiff; handles.h_imgDiff_cb])

axes(handles.filtThreshVar_ax);
imgDiff_list = cellstr(get(handles.imgSubstraction_list,'String'));
imgDiff_sel = imgDiff_list{get(handles.imgSubstraction_list,'Value')};
if strcmp(imgDiff_sel,'fixed substraction'), imgDiff = handles.imgDiff_frameRef;
elseif strcmp(imgDiff_sel,'sliding substraction'), imgDiff = handles.imgDiff_framePrev;
end
h_imgDiff = imagesc(imgDiff); hold on; 
%axis image; 
colormap(eval('cmap_bwr')); h_imgDiff_cb = colorbar('location','southoutside');
center_cAxis_at0 = 1;
if center_cAxis_at0
    max_absVal = max(abs(imgDiff(:))); max_absVal=double(max_absVal);
    caxis([-1 1]*max_absVal);
end
freezeColors; CBH=cbfreeze;
set(CBH,'XTickLabelMode','auto','fontsize',7) %(default return = manual, powers label not rendered if auto not called)
h_imgDiff_cb=CBH(1); %!! because cbfreeze acts strangely (deleting handle properties once called?), handle redefined using output from cbfreeze

handles.h_imgDiff_cb=h_imgDiff_cb;
handles.h_imgDiff=h_imgDiff;
guidata(hObject,handles);

%adjust slider range/value (value must be within min/max)
img4slider = imgDiff;
thresh4slider = handles.filtThreshVar_val;
set_sliderProp(handles.filtThreshVar_sl, img4slider, thresh4slider)


%ADD px filtered if chbox on
filtThreshVar = get(handles.filtThreshVar_chbox,'Value');
if filtThreshVar
    filterThreshVar_px(handles)
end


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


%check if chosen frame in available range
if isfield(handles,'nbFrames')
    frameRef = str2double(get(hObject,'string'));
    if frameRef > handles.nbFrames
        msg = ['Warning: entered frame nb exceeds the last available frame (' num2str(handles.nbFrames) '.'];
        h = msgbox(msg,'warning','help');
        uiwait(h)
        return
    end
end

currentFrame = str2double(get(handles.frame_txt,'String'));

%re-LOAD images
[imgRef,imgRaw,imgPrev,imgDiff_frameRef,imgDiff_framePrev] = imageLoading(handles);
handles.imgRef=imgRef;
handles.imgDiff_frameRef=imgDiff_frameRef;
guidata(hObject,handles);

%UPDATE imgDiff only
delete([handles.h_imgDiff; handles.h_imgDiff_cb])
axes(handles.filtThreshVar_ax);
imgDiff_list = cellstr(get(handles.imgSubstraction_list,'String'));
imgDiff_sel = imgDiff_list{get(handles.imgSubstraction_list,'Value')};
if strcmp(imgDiff_sel,'fixed substraction'), imgDiff = handles.imgDiff_frameRef;
elseif strcmp(imgDiff_sel,'sliding substraction'), imgDiff = handles.imgDiff_framePrev;
end
h_imgDiff = imagesc(imgDiff); hold on; 
axis image; colormap(eval('cmap_bwr')); h_imgDiff_cb = colorbar('location','southoutside');
center_cAxis_at0 = 1;
if center_cAxis_at0
    max_absVal = max(abs(imgDiff(:))); max_absVal=double(max_absVal);
    caxis([-1 1]*max_absVal);
end
freezeColors; CBH=cbfreeze;
set(CBH,'XTickLabelMode','auto') %(default return = manual, powers label not rendered if auto not called)
h_imgDiff_cb=CBH(1); %!! because cbfreeze acts strangely (deleting handle properties once called?), handle redefined using output from cbfreeze
handles.h_imgDiff_cb=h_imgDiff_cb;
handles.h_imgDiff=h_imgDiff;

guidata(hObject,handles);

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



function ventY_Callback(hObject, eventdata, handles)
% hObject    handle to ventY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ventY as text
%        str2double(get(hObject,'String')) returns contents of ventY as a double


ventY_str = get(hObject,'string'); 
ventY = str2double(ventY_str);

axes(handles.filtImgReg_ax);

%delete previous vent line/text
h_vent = findobj(handles.filtImgReg_ax,'tag','ventY');
h_ventTxt = findobj(handles.filtImgReg_ax,'tag','ventYtxt');
if ~isempty(h_vent), delete(h_vent), end
if ~isempty(h_ventTxt), delete(h_ventTxt), end

%plot new
w=get(gca,'xlim'); hold on;
plot([w(1),w(2)],[ventY,ventY],'w:','tag','ventY');
text(w(1),ventY,[' ventY = ' ventY_str],'color','w','VerticalAlignment','bottom','tag','ventYtxt');

%update filtered px
filterImgReg_px(handles)

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

H = handles.H;

%set filter optns in calling GUI (gui_plumeTracker or gui_imgAnalysis) according to selection 

%.filter thresh
set(H.filter_tempThresh,'value',get(handles.filtThresh_chbox,'value'));
set(H.plumeTemp_thresh,'string',get(handles.filtThresh_txt,'string')); 
if get(handles.filtThresh_chbox,'value'), set(H.plumeTemp_thresh,'enable','on'); 
else set(H.plumeTemp_thresh,'enable','off');
end
    
%.filter thresh var
set(H.filter_tempVar,'value',get(handles.filtThreshVar_chbox,'value')); 
set(H.plumeTempVar_thresh,'string',get(handles.filtThreshVar_txt,'string')); 
set(H.imgSubstraction_list,'value',get(handles.imgSubstraction_list,'value'));
set(H.imgSubstraction_frame,'string',get(handles.imgSubstraction_frame,'string'));
h = [H.plumeTempVar_thresh, H.plumeTempVar_thresh_txt, ...
    H.imgSubstraction_list, H.imgSubstraction_frame, H.imgSubstraction_txt];

calling_guiName = handles.calling_guiName;
if get(handles.filtThreshVar_chbox,'value'), 
    set(h,'enable','on'); 

    %filterTempVar_px option in figMonitor_optnList
    if strcmp(calling_guiName,'gui_plumeTracker')
        plotList = get(H.figMonitor_optnList,'string');
        idx_filtVar = find(strcmp(plotList,'filterTempVar_px'));
        if isempty(idx_filtVar)
            plotList(end+1) = {'filterTempVar_px'}; %add possibility to plot image region tracked from list in figMonitor_optnList
        end
    end
    
    %imgSubstraction type chosen
    list = cellstr(get(handles.imgSubstraction_list,'String'));
    selection_txt = list{get(handles.imgSubstraction_list,'Value')};
    if strcmp(selection_txt,'fixed substraction')
    elseif strcmp(selection_txt,'sliding substraction')
        set(H.imgSubstraction_frame,'enable','off');
    end
    
else
    set(h,'enable','off');
    
    %filterTempVar_px option in figMonitor_optnList
    if strcmp(calling_guiName,'gui_plumeTracker')
        plotList = get(H.figMonitor_optnList,'string');
        idx = find(cellfun(@(x) strcmp(x,'filterTempVar_px'),plotList)); %delete possibility to plot image region tracked from list in figMonitor_optnList
        if ~isempty(idx), plotList(idx)=[]; end
    end
end

%update filterTempVar_px option in figMonitor_optnList
if strcmp(calling_guiName,'gui_plumeTracker')
    set(H.figMonitor_optnList,'string',plotList);
    set(H.figMonitor_optnList,'value',numel(plotList));
end

%.filter img reg
set(H.filter_imgRegion,'value',get(handles.filtImgReg_chbox,'value')); 
set(H.limH_px,'string',get(handles.filtImgReg_txt,'string')); 
if get(handles.filtImgReg_chbox,'value'), set(H.limH_px,'enable','on'); 
else set(H.limH_px,'enable','off');
end
set(H.ventY,'string',get(handles.ventY,'string')); 

%.filter interaction
selInteraction = get(get(handles.filterInteraction_panel,'SelectedObject'),'tag');
switch selInteraction
    case 'filtInteract_all', set(H.filtInteract_all,'value',1);
    case 'filtInteract_one', set(H.filtInteract_one,'value',1);
end

if isfield(handles,'frameRate_video') %if video uploaded & frame rate known
    if isfield(H,'inputRec'), inputRec = H.inputRec; end
    inputRec.frameRate = handles.frameRate_video;
    %set(H.frameRate,'string',num2str(handles.frameRate_video));
    
    % update handles structure INSIDE gui_plumeTracker
    H.inputRec = inputRec;
    guidata(gui_plumeTracker,H)
end

% close GUI 'define_filterValues'
h_guiFilt = findobj('name','define_filterValues');
close(h_guiFilt)

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf)