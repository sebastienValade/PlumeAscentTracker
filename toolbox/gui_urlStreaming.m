function varargout = gui_urlStreaming(varargin)
% GUI_URLSTREAMING MATLAB code for gui_urlStreaming.fig
%      GUI_URLSTREAMING, by itself, creates a new GUI_URLSTREAMING or raises the existing
%      singleton*.
%
%      H = GUI_URLSTREAMING returns the handle to a new GUI_URLSTREAMING or the handle to
%      the existing singleton*.
%
%      GUI_URLSTREAMING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_URLSTREAMING.M with the given input arguments.
%
%      GUI_URLSTREAMING('Property','Value',...) creates a new GUI_URLSTREAMING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_urlStreaming_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_urlStreaming_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_urlStreaming

% Last Modified by GUIDE v2.5 17-May-2013 10:38:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_urlStreaming_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_urlStreaming_OutputFcn, ...
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


% --- Executes just before gui_urlStreaming is made visible.
function gui_urlStreaming_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_urlStreaming (see VARARGIN)

% Choose default command line output for gui_urlStreaming
handles.output = hObject;

%EDITED:

%.center gui on screen
movegui(gcf,'center') 

%-- upload handles structure from gui_plumeTracker
H = varargin{1};
handles.H = H;

%set imgAxis without labels
set(handles.ax_urlObj,'box','on','xTickLabel',{},'yTickLabel',{})

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_urlStreaming wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = gui_urlStreaming_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function urlAddress_Callback(hObject, eventdata, handles)
% hObject    handle to urlAddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of urlAddress as text
%        str2double(get(hObject,'String')) returns contents of urlAddress as a double

url = get(hObject,'String');

if strfind(url,'http')
    
    %matlabVersion_str = version('-release');
    k = strfind(url,'/');
    url_fileNameFull = url(k(end)+1:end);
    [url_fileName, remain] = strtok(url_fileNameFull,'.');
    url_fileExt = remain(2:end);
    
    formats = imformats(url_fileExt);%searches the known formats in the MATLAB file format registry for theformat associated with the filename extension 'url_fileExt'
    if isempty(formats)
        disp('URL link not valid.')
        h = get(handles.imgStreaming_panel,'children');
        set(h,'enable','off');
        return
    end
    
    if ~strcmp(url_fileExt,'jpg')
        disp('INFO: URL links to an image file which is not in a JPG format. Problems may be encountered.');
    end
    
    % if url links to JPG image
    % (ex webcam: 'http://wwwobs.univ-bpclermont.fr/opgc/webcamcez.jpg')
    handles.url = url;
    handles.url_fileNameFull = url_fileNameFull;
    handles.url_fileName = url_fileName;
    handles.url_fileExt = url_fileExt;
    guidata(hObject, handles);
    
    h = get(handles.imgStreaming_panel,'children');
    set(h,'enable','on');
    
else
    disp('URL link not valid.')
    
    h = get(handles.imgStreaming_panel,'children');
    set(h,'enable','off');
end

% --- Executes during object creation, after setting all properties.
function urlAddress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to urlAddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in streamStart.
function streamStart_Callback(hObject, eventdata, handles)
% hObject    handle to streamStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%.define folder to store url obj downloaded
slash = handles.H.slash;
path2folder_url = [cd slash 'urlObj' slash];
if ~isdir(path2folder_url), mkdir('urlObj'); end
handles.path2folder_url = path2folder_url;
guidata(hObject, handles);

% update handles structure INSIDE gui_plumeTracker
% (pathName needed to set define_trackingFilters)
%!!: guidata(gui_plumeTracker,H) causes gui_plumeTracker interface to come to the front of the screen...
H = handles.H;
H.pathName = path2folder_url;
guidata(gui_plumeTracker,H)
set(handles.H.select_fileORdir,'string','urlObj');

%set gui_urlStreaming as current figure and bring to foreground
set(0,'currentFigure',findobj('name','gui_urlStreaming'));
figure(gcf)

%define period at which urlObj should be collected
period_min = str2num(get(handles.period,'string'));
period_sec = period_min * 60;

%!!set handle visibility to 'on' instead of 'callback' (otherwise downloaded img will be plotted in a new figure)
%  however it will make the interface pop up each time the image is updated
set(handles.figure1,'handleVisibility','on')

%create timer object
timerObj = timer('Period', period_sec, ...
    'ExecutionMode', 'fixedRate');

%define timer function
timerObj.TimerFcn = {@get_urlObj, handles};
% t.StartFcn = {@get_urlObj, ['Collecting URL object every ' collectPeriod_sec 'sec...']};
% t.StopFcn = {@get_urlObj, ['Collecting URL object every ' collectPeriod_sec 'sec...']};

disp('URL object download STARTED...')
start(timerObj)

set(handles.streamStart,'string','STREAMING','backgroundColor','g')
handles.timerObj = timerObj;
guidata(hObject, handles);

function period_Callback(hObject, eventdata, handles)
% hObject    handle to period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of period as text
%        str2double(get(hObject,'String')) returns contents of period as a double

%get frameRate in fps to edit gui_plumeTracker interface
period_min = str2double(get(hObject,'String'));
period_sec = period_min * 60;
frameRate = 1 / period_sec;
set(handles.H.frameRate, 'string', num2str(frameRate))

% --- Executes during object creation, after setting all properties.
function period_CreateFcn(hObject, eventdata, handles)
% hObject    handle to period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in streamStop.
function streamStop_Callback(hObject, eventdata, handles)
% hObject    handle to streamStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.timerObj)
disp('...URL object download STOPPED.')

%if tracked data => take out of structure "trackedData" so plumeInfo* available on base workspace
try trackedData = evalin('base','trackedData');
    
    %export tracked data to base workspace
    fieldNames = fieldnames(trackedData);
    for i=1:numel(fieldNames)
        assignin ('base', fieldNames{i}, trackedData.(fieldNames{i}));
    end
    disp('Tracked data exported to base workspace.');
    
    %export inputstruct to base workspace 
    %(some var are needed for functions in output panel)
    inputStruct = evalin('base','inputStruct');
    fieldNames = fieldnames(inputStruct);
    for i=1:numel(fieldNames)
        assignin ('base', fieldNames{i}, inputStruct.(fieldNames{i}));
    end

catch
end

defCol = get(handles.streamStop,'backgroundColor');
set(handles.streamStart,'backgroundColor',defCol,'string','START streaming');

%if images downloaded => enable checkbox to track data (needed to define_trackinFilters)
set(handles.track_plumePx,'enable','on')

% --- Executes on button press in track_plumePx.
function track_plumePx_Callback(hObject, eventdata, handles)
% hObject    handle to track_plumePx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of track_plumePx

track_plumePx = get(hObject,'Value');

h = get(handles.set_inputsPanel,'children');
if track_plumePx
    set(h, 'enable', 'on');
else
    set(h, 'enable', 'off');
    defCol = get(handles.streamStop,'backgroundColor');
    set(handles.set_trackingInputs,'string','upload tracking inputs','backgroundColor',defCol);
end


% --- Executes on button press in set_trackingInputs.
function set_trackingInputs_Callback(hObject, eventdata, handles)
% hObject    handle to set_trackingInputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get frameRate in fps from "refresh period" textbox
period_min = str2double(get(handles.period,'String'));
period_sec = period_min * 60;
frameRate = 1 / period_sec;

inputStruct.frameRate = frameRate;

%% get recording settings
% => re-upload gui data of plume tracker (define_recInputs should have been opened and structure "inputRec" saved in "gui_plumeTracker" handles
HH = guidata(gui_plumeTracker); %will cause plumeTracker to become currentFigure

%set gui_urlStreaming as current figure and bring to foreground
set(0,'currentFigure',findobj('name','gui_urlStreaming'));
figure(gcf)

if isfield(HH,'inputRec')
    inputStruct.inclinationAngle_deg = HH.inputRec.inclinationAngle_deg;
    inputStruct.distHoriz = HH.inputRec.distHoriz;
    inputStruct.ventAlt_m = HH.inputRec.ventAlt_m;
    inputStruct.IFOV = HH.inputRec.IFOV;
    inputStruct.FOVh_deg = HH.inputRec.FOVh_deg;
    inputStruct.FOVv_deg = HH.inputRec.FOVv_deg;
else
    h = msgbox('Recording settings not defined: please select these using the dedicated pushbutton in plumeTracker main interface','warning','none'); uiwait(h);
    return
end


%% get image transformation settings
if isfield(HH,'inputs_imgTransf')
    inputStruct.imgTransformation = 1;
    inputStruct.inputs_imgTransf = HH.inputs_imgTransf;
else
    inputStruct.imgTransformation = 0;
end

%% get other input param
inputStruct.path2folder_outputs = handles.H.path2folder_outputs;
inputStruct.ventY = str2double(get(handles.H.ventY,'String'));


%% get tracking filters
%.filter img region
inputStruct.filter_imgRegion = get(handles.H.filter_imgRegion,'Value');
% if inputStruct.filter_imgRegion
    limH_px = get(handles.H.limH_px,'String'); %sym function from Symbolic Math Toolbox could be used
    inputStruct.limH_px_str = limH_px;
    if strfind(limH_px,'<')
        inputStruct.side_ofLimH = 'left'; inputStruct.limH_px=str2num(limH_px(2:end));
    elseif strfind(limH_px,'>')
        inputStruct.side_ofLimH = 'right'; inputStruct.limH_px=str2num(limH_px(2:end));
    else h = msgbox('Horizontal limit not properly defined: add < or > before numeric value','warning','none'); uiwait(h); return
    end
% end
%.filter temp thresh
inputStruct.filter_tempThresh = get(handles.H.filter_tempThresh,'Value');
if inputStruct.filter_tempThresh
    [operationType,threshold,~] = get_threshold(handles.H.plumeTemp_thresh);
    inputStruct.operation_onTempThresh = operationType;
    inputStruct.plumeTemp_thresh = threshold; 
end
%.filter temp variation
inputStruct.filter_tempVar = get(handles.H.filter_tempVar,'Value');
if inputStruct.filter_tempVar
    %filter type (fixed substraction or sliding substraction)
    list = cellstr(get(handles.H.imgSubstraction_list,'String'));
    inputStruct.filter_tempVar_type = list{get(handles.H.imgSubstraction_list,'Value')};

    %filter value
    inputStruct.plumeTempVar_thresh = str2double(get(handles.H.plumeTempVar_thresh,'String'));
    inputStruct.plumeTempVar_thresh_str = get(handles.H.plumeTempVar_thresh,'String');
end
%set frameRef (for imgDiff_frameRef => used by filter_tempVar, or by figMonitor for imgDiff_frameRef)
frame2substract = get(handles.H.imgSubstraction_frame,'string');
if strcmp(frame2substract,'previous')
    inputStruct.frameRef=1;
else
    inputStruct.frameRef=str2num(frame2substract);
end
%.filter interaction
h_sel=get(handles.H.filterInteraction_panel,'SelectedObject');
inputStruct.filterInteraction = get(h_sel,'tag');


%export to base
assignin('base','inputStruct',inputStruct);
disp('Tracking inputs uploaded from plumeTracker interface.')
set(handles.set_trackingInputs,'string','uploaded','backgroundColor','g');

