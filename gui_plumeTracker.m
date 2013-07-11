function varargout = gui_plumeTracker(varargin)
% GUI_PLUMETRACKER MATLAB code for gui_plumeTracker.fig
%      GUI_PLUMETRACKER, by itself, creates a new GUI_PLUMETRACKER or raises the existing
%      singleton*.
%
%      H = GUI_PLUMETRACKER returns the handle to a new GUI_PLUMETRACKER or the handle to
%      the existing singleton*.
%
%      GUI_PLUMETRACKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PLUMETRACKER.M with the given input arguments.
%
%      GUI_PLUMETRACKER('Property','Value',...) creates a new GUI_PLUMETRACKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_plumeTracker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_plumeTracker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_plumeTracker

% Last Modified by GUIDE v2.5 22-May-2013 18:40:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_plumeTracker_OpeningFcn, ...
    'gui_OutputFcn',  @gui_plumeTracker_OutputFcn, ...
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


% --- Executes just before gui_plumeTracker is made visible.
function gui_plumeTracker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_plumeTracker (see VARARGIN)

% Choose default command line output for gui_plumeTracker
handles.output = hObject;

%get file type selected by default
contents = cellstr(get(handles.fileType_menu,'String'));
fileType = contents{get(handles.fileType_menu,'Value')};
handles.fileType=fileType;

% UIWAIT makes gui_plumeTracker wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%--added by SV

%.center gui on screen
movegui(gcf,'center') 

%.clear command window
clc

%.clear workspace
% clear all
% disp('workspace cleared.')

%.get operating system
OS = computer;
if strfind(OS,'PCWIN'), OS = 'WIN'; slash = '\';
elseif strfind(OS,'GLNX'), OS = 'LNX'; slash = '/';
elseif strfind(OS,'MACI'), OS = 'MAC'; slash = '/';
end

%.add local toolbox folder to path
path2folder_toolbox = [cd slash 'toolbox'];
addpath(genpath(path2folder_toolbox)) %(if path already defined => will be ignore)
%NB: genpath called inside of addpath => all subfolders added to path

%.add folder for outputs if non-existent
path2folder_outputs = [cd slash 'outputs' slash];
if ~isdir(path2folder_outputs), mkdir('outputs'); end
%assignin('base','path2folder_outputs',path2folder_outputs); %save in base workspace

%.set Standard Background Color
% NB: matlab uses the standard system background color of the system on which GUI is running as the default component bkg color. 
% This color varies on different computer systems (e.g. the standard shade of gray on PC systems differs from that on UNIX system, and may not match the default GUI background color).
% => make the GUI background color match the default component background color:
defaultBackground = get(0,'defaultUicontrolBackgroundColor');
set(handles.figure1,'Color',defaultBackground)

%.get contents of listbox_unitsKG (plot X vs Y)
handles.massAsh_optnList_ini = get(handles.listbox_unitsKG,'string');

handles.path2folder_outputs = path2folder_outputs;
handles.slash = slash;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = gui_plumeTracker_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRACKING INPUTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function frameStrt_Callback(hObject, eventdata, handles)
% hObject    handle to frameStrt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameStrt as text
%        str2double(get(hObject,'String')) returns contents of frameStrt as a double


% --- Executes during object creation, after setting all properties.
function frameStrt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameStrt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function frameStep_Callback(hObject, eventdata, handles)
% hObject    handle to frameStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameStep as text
%        str2double(get(hObject,'String')) returns contents of frameStep as a double


% --- Executes during object creation, after setting all properties.
function frameStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function frameEnd_Callback(hObject, eventdata, handles)
% hObject    handle to frameEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameEnd as text
%        str2double(get(hObject,'String')) returns contents of frameEnd as a double


% --- Executes during object creation, after setting all properties.
function frameEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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


function frameRate_Callback(hObject, eventdata, handles)
% hObject    handle to frameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameRate as text
%        str2double(get(hObject,'String')) returns contents of frameRate as a double


% --- Executes during object creation, after setting all properties.
function frameRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameRate (see GCBO)
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

function ventY_Callback(hObject, eventdata, handles)
% hObject    handle to ventY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ventY as text
%        str2double(get(hObject,'String')) returns contents of ventY as a double


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PICK VENT functions

% --- Executes on button press in ventPosition_pick.
function ventPosition_pick_Callback(hObject, eventdata, handles)
% hObject    handle to ventPosition_pick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get pathName
if ~isfield(handles,'pathName')
    contents = cellstr(get(handles.fileType_menu,'String'));
    fileType = contents{get(handles.fileType_menu,'Value')};
    if strcmp(fileType,'url link')
        warnMsg = 'Please start/stop streaming first, in order to download at least one image from url link.';
    else
        warnMsg = 'Please select image directory.';
    end
    
    h = msgbox(warnMsg,'warning','none'); uiwait(h);
    return
end
pathName = handles.pathName;

%load image storage
fileType = handles.fileType;
frameEnd = get(handles.frameEnd,'string');
if isfield(handles,'videoName'), videoName = handles.videoName; end
load_imgStorage;

%load image number 1
img2load = 1;
load_img(img2load)
if isfield(handles,'inputs_imgTransf')
    inputs_imgTransf = handles.inputs_imgTransf;
    img_transformation;
end
if exist('imgRaw_rgb','var'), img = imgRaw_rgb; %=> use RGB image rather then binary image
else img = imgRaw;
end

%plot image
hFig = figure('position',[560 450 560 500]); %default = [560 528 560 420]
hax = axes('position',[.1  .25  .8  .7]);
imagesc(img);
axis image

%.center figure on screen
movegui(gcf,'center') 

%add uicontrols
%.push button 'pick'
hPick = uicontrol('style','pushbutton', ...
    'String', 'pick vent Y-position',...
    'Position', [140 30 125 30],...
    'CallBack',{@pick_ventY,handles});
% handles.hPick = hPick;

%push button 'save'
hSave = uicontrol('style','pushbutton', ...
    'String', 'save',...
    'Position', [300 30 75 30],...
    'CallBack',{@save_ventY,handles});

%.insert toolbar 
% nb: 'toolbar' property in figure is set to 'auto' by default, which displays the figure toolbar, but removes it if a uicontrol is added to the figure.
set(hFig,'ToolBar','figure');

function pick_ventY(hObject, eventdata, handles)

h_child = findobj(gca,'-not','type','image','-not','type','axes');

if ~isempty(h_child), delete(h_child), end

%user picks on image
[~,y]=ginput(1);
ventY_px = floor(y);

%plot line
w=get(gca,'xlim');
hold on;
plot([w(1),w(2)],[ventY_px,ventY_px],'w:');
text(w(1),ventY_px,[' ventY = ' num2str(ventY_px)],'color','w','VerticalAlignment','bottom');

%store in application data of the pushbutton
setappdata(hObject,'ventY_px',ventY_px)

function save_ventY(hObject, eventdata, handles)

%get handle of push button 'pick ...'
hPick = findobj(gcf,'style','pushbutton','string','pick vent Y-position');

%collect application data of pushbutton
ventY_px = getappdata(hPick,'ventY_px');

%update ventY edit box in GUI
set(handles.ventY,'string',num2str(ventY_px));
close(gcf)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


function ventAlt_m_Callback(hObject, eventdata, handles)
% hObject    handle to ventAlt_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ventAlt_m as text
%        str2double(get(hObject,'String')) returns contents of ventAlt_m as a double


% --- Executes during object creation, after setting all properties.
function ventAlt_m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ventAlt_m (see GCBO)
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

%add or delete possibility to plot image region tracked from list in figMonitor_optnList
plotList = get(handles.figMonitor_optnList,'string');
if filter_imgRegion
    plotList(end+1) = {'filterImgReg_px'};
    set([handles.limH_px,handles.limH_px_txt],'enable','on')
else
    idx = find(cellfun(@(x) strcmp(x,'filterImgReg_px'),plotList));
    if ~isempty(idx), plotList(idx)=[]; end
    set([handles.limH_px,handles.limH_px_txt],'enable','off')
end
set(handles.figMonitor_optnList,'string',plotList);
set(handles.figMonitor_optnList,'value',numel(plotList));

% --- Executes on button press in filter_tempThresh.
function filter_tempThresh_Callback(hObject, eventdata, handles)
% hObject    handle to filter_tempThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of filter_tempThresh

filter_tempThresh = get(hObject,'Value');

%add or delete possibility to plot image region tracked from list in figMonitor_optnList
plotList = get(handles.figMonitor_optnList,'string');
if filter_tempThresh
    plotList(end+1) = {'filterTemp_px'};
    set([handles.plumeTemp_thresh,handles.plumeTemp_thresh_txt],'enable','on')
else
    idx = find(cellfun(@(x) strcmp(x,'filterTemp_px'),plotList));
    if ~isempty(idx), plotList(idx)=[]; end
    set([handles.plumeTemp_thresh,handles.plumeTemp_thresh_txt],'enable','off')   
end
set(handles.figMonitor_optnList,'string',plotList);
set(handles.figMonitor_optnList,'value',numel(plotList));


% --- Executes on button press in filter_tempVar.
function filter_tempVar_Callback(hObject, eventdata, handles)
% hObject    handle to filter_tempVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of filter_tempVar

filter_tempVar = get(hObject,'Value');

%elts to enable/disable
h = [handles.plumeTempVar_thresh, handles.plumeTempVar_thresh_txt, ...
    handles.imgSubstraction_list, handles.imgSubstraction_frame, handles.imgSubstraction_txt];


%add or delete possibility to plot image region tracked from list in figMonitor_optnList
plotList = get(handles.figMonitor_optnList,'string');
if filter_tempVar
    plotList(end+1) = {'filterTempVar_px'};

    %enable elts
    set(h,'enable','on');
    
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

    
else
    idx = find(cellfun(@(x) strcmp(x,'filterTempVar_px'),plotList));
    if ~isempty(idx), plotList(idx)=[]; end
    
    %disable elts
    set(h,'enable','off');
    
end
set(handles.figMonitor_optnList,'string',plotList);
set(handles.figMonitor_optnList,'value',numel(plotList));

% --- Executes on selection change in imgSubstraction_list.
function imgSubstraction_list_Callback(hObject, eventdata, handles)
% hObject    handle to imgSubstraction_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imgSubstraction_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imgSubstraction_list

list = cellstr(get(hObject,'String'));
selection_txt = list{get(hObject,'Value')};

if strcmp(selection_txt,'fixed substraction')
    frame2substract = get(handles.imgSubstraction_frame,'string');
    if strcmp(frame2substract, 'previous'), set(handles.imgSubstraction_frame,'string','1'); end
    set(handles.imgSubstraction_frame,'enable','on');
    
elseif strcmp(selection_txt,'sliding substraction')
    set(handles.imgSubstraction_frame,'string','previous');
    set(handles.imgSubstraction_frame,'enable','off');
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MONITOR FIGURE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function figMonitor_linesVScol_Callback(hObject, eventdata, handles)
% hObject    handle to figMonitor_linesVScol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figMonitor_linesVScol as text
%        str2double(get(hObject,'String')) returns contents of figMonitor_linesVScol as a double

%define nb of lines and columns
[L, C] = strtok(get(handles.figMonitor_linesVScol,'String'),'x'); %[L, C] = strtok(get(hObject,'String'),'x');
nbLines = str2double(deblank(L));
nbCol = str2double(deblank(C(2:end)));

if isfield(handles,'h_monitorPlots'), delete(handles.h_monitorPlots); handles=rmfield(handles,'h_monitorPlots'); end
h_monitorPlots = [];

%get preview panel dimensions
set(handles.figMonitor_previewPanel,'units','pixels');  %default panel units = 'characters'
panelPosition = get(handles.figMonitor_previewPanel,'position'); %[left bottom width height]
panelH = panelPosition(end) - 20; %-20 to substract size of panel title
panelW = panelPosition(3) - 20;

%define margin dimensions
marginH = (panelW/nbCol) / 10;
marginV = (panelH/nbLines) / 10;

%define plot dimension
if nbCol==1
    posW=150;
    posL_0 = (panelW/2 - posW/2) - marginH - posW;
else
    posW = (panelW - nbCol*marginH) / nbCol;
    posL_0 = -1*posW;
end
if nbLines==1
    posH=150;
    posB = (panelH/2 - posH/2) - marginV - posH;
else
    posH = (panelH - nbLines*marginV) / nbLines;
    posB = -1*posH;
end

%define default inputs for plots
bkgCol = [1,1,1]; %[0.75,0.75,0.75]
txt = '[empty]';

for i=nbLines:-1:1
    
    posB = posB + marginV + posH;
    posL = posL_0;
    for j=1:nbCol
        posL = posL + marginH + posW;
        idx = numel(h_monitorPlots);
        
        %create the text box
        h_monitorPlots(idx+1) = uicontrol(handles.figMonitor_previewPanel,'Style','text','Position',[posL posB posW posH],'string',txt,'BackgroundColor',bkgCol,'ButtonDownFcn',{@fillPlot,handles.figMonitor_previewPanel},'enable','off');
        
        %set 'tag' = [i,j] position
        plot_posIJ = [num2str(i) ',' num2str(j)];
        set(h_monitorPlots(idx+1),'tag',plot_posIJ);
    end
end

%reset colormap & clim matrix
% assignin('base','cmap_matrix',{});
% assignin('base','clim_matrix',{});
handles.cmap_matrix={};
handles.clim_matrix={};
set(handles.cmap_define,'string','define color map');

%save handles of new panels
handles.h_monitorPlots = h_monitorPlots;
guidata(hObject, handles);


function fillPlot(hObject,eventdata,h_previewPanel)
%function called when user right-clics on one of the preview plots

%search if plots without txt, add txt [empty]
h_previewChild = get(h_previewPanel,'children');
txtPlots = get(h_previewChild,'string');
if ischar(txtPlots), txtPlots={txtPlots}; end %in case just 1 subplot=>txtPlots = char rather then cell
txtEmpty_idx = cellfun(@isempty, txtPlots);
if ~isempty(txtEmpty_idx)
    h_txtEmpty = h_previewChild(txtEmpty_idx);
    set(h_txtEmpty,'string','[empty]')
end

%disable all plots except plot clicked
set(h_previewChild,'enable','off');
set(hObject,'enable','on')
if strcmp(get(hObject,'string'), '[empty]')
    set(hObject,'string','')
end


% --- Executes on button press in figMonitor_clear.
function figMonitor_clear_Callback(hObject, eventdata, handles)
% hObject    handle to figMonitor_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get handle of enabled plots
h_previewChild = get(handles.figMonitor_previewPanel,'children');
child_enabledState = get(h_previewChild,'enable');
idx_plotsON = find(strcmp('on',child_enabledState));
h_plotsON = h_previewChild(idx_plotsON);

set(h_plotsON,'string','[empty]')
set(h_plotsON,'enable','off')


% --- Executes during object creation, after setting all properties.
function figMonitor_linesVScol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figMonitor_linesVScol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in figMonitor_optnList.
function figMonitor_optnList_Callback(hObject, eventdata, handles)
% hObject    handle to figMonitor_optnList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns figMonitor_optnList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from figMonitor_optnList

%Enable mutliple selection:
% NB: "To enable multiple selection in a list box, you must set the Min and Max properties so that Max - Min > 1. You must change the default Min and Max values of 0 and 1 to meet these conditions. Use the Property Inspector to set these properties on the list box."
set(hObject,'max',2);

contents = cellstr(get(hObject,'String'));
selection_idx = get(hObject,'Value');
selection_txt = contents{selection_idx};

%get handle of enabled plots
h_previewChild = get(handles.figMonitor_previewPanel,'children');
child_enabledState = get(h_previewChild,'enable');
idx_plotsON = find(strcmp('on',child_enabledState));
h_plotsON = h_previewChild(idx_plotsON);

if ~isempty(h_plotsON)
    %define txt to write in plots
    for i=1:numel(h_plotsON) %loop through active plots
        txt = get(h_plotsON,'string');
        txt_cell = cellstr(txt);
        idx_txtFound = find(strcmp(selection_txt,txt_cell));
        if ~isempty(idx_txtFound)
            txt_cell(idx_txtFound) = [];
            txt = char(txt_cell);
        else
            txt = strvcat(txt,selection_txt);
        end
    end
    
    %write in enabled plots
    set(h_plotsON,'string',txt)
    
    %align to left if >1 txt line
    %if size(txt,1)>1, set(h_plotsON,'horizontalAlignment','left'); end
end


% --- Executes during object creation, after setting all properties.
function figMonitor_optnList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figMonitor_optnList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_figMonitor.
function plot_figMonitor_Callback(hObject, eventdata, handles)
% hObject    handle to plot_figMonitor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_figMonitor

plot_figMonitor = get(hObject,'Value');

%get handles to childrens
h_child = get(handles.figMonitor_panel,'children');
childType = get(h_child,'type');
childWhichAreNotPanels = find(~strcmp(childType,'uipanel'));

h_child_notSavegif = findobj(handles.figMonitor_panel,'-not','type','uipanel','-not', 'parent',handles.saveGIF_panel,'-not', 'parent',handles.slowExecution_panel);

if plot_figMonitor
    set(handles.figMonitor_panel,'ForegroundColor',[0,0,0]) %set title color to black to simulate 'enable on'
    set(handles.figMonitor_previewPanel,'ForegroundColor',[0,0,0]) %set title color to black to simulate 'enable on'
    set(h_child_notSavegif,'enable','on');
    %set(h_child(childWhichAreNotPanels),'enable','on')
    set(handles.figMonitor_optnList,'backgroundcolor',[1,1,1]) %set listbox bck to white
    figMonitor_linesVScol_Callback(hObject, eventdata, handles) %call funciton to add plot in preview panel
else
    set(handles.figMonitor_panel,'ForegroundColor',[0.5,0.5,0.5]) %set title color to gray to simulate 'enable off'
    set(handles.figMonitor_previewPanel,'ForegroundColor',[0.5,0.5,0.5]) %set title color to gray to simulate 'enable off'
    %set(h_child(childWhichAreNotPanels),'enable','off')
    set(h_child_notSavegif,'enable','off');
    set(handles.figMonitor_optnList,'backgroundcolor',[0.933,0.933,0.933]) %set listbox bck to light gray
    %delete plots contained in figMonitor_previewPanel
    h_child = get(handles.figMonitor_previewPanel,'children');
    if ~isempty(h_child), delete(h_child); handles=rmfield(handles,'h_monitorPlots'); end
    guidata(hObject, handles);
    
    %if saveGIF=ON => turn OFF
    if get(handles.saveGIF,'value')==1
        set(handles.saveGIF,'value',0)
        saveGIF_Callback(handles.saveGIF, eventdata, handles)
    end
    
    %if slowExecution=ON => turn OFF
    if get(handles.slowExecution_chbox,'value')==1
        set(handles.slowExecution_chbox,'value',0)
        slowExecution_chbox_Callback(handles.slowExecution_chbox, eventdata, handles)
    end
end


% --- Executes on button press in cmap_define.
function cmap_define_Callback(hObject, eventdata, handles)
% hObject    handle to cmap_define (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

define_cmap(handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LISTBOXES for XY plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% [TIME] listbox %%%

% --- Executes on selection change in listbox_unitsTime.
function listbox_unitsTime_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_unitsTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_unitsTime contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_unitsTime

contents = cellstr(get(hObject,'String'));
sel = contents{get(hObject,'Value')};

%set list tag (different depending on selection because each refer to distinct units)
if strcmp(sel,'t_sec')
    listTag = 'units = [time sec]';
elseif strcmp(sel,'t_min')
    listTag = 'units = [time min]';
elseif strcmp(sel,'t_frame')
    listTag = 'units = [time frame]';
end

define_XYlabels(listTag,hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox_unitsTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_unitsTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%% [M] listbox %%%

% --- Executes on selection change in listbox_unitsM.
function listbox_unitsM_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_unitsM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_unitsM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_unitsM

% %Enable mutliple selection:
% % NB: "To enable multiple selection in a list box, you must set the Min and Max properties so that Max - Min > 1. You must change the default Min and Max values of 0 and 1 to meet these conditions. Use the Property Inspector to set these properties on the list box."
% set(hObject,'max',2);

%set list tag
listTag = 'units = [m]';

define_XYlabels(listTag,hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox_unitsM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_unitsM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%% [M/S] listbox %%%

% --- Executes on selection change in listbox_unitsMS.
function listbox_unitsMS_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_unitsMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_unitsMS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_unitsMS

%set list tag
listTag = 'units = [m/s]';

define_XYlabels(listTag,hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox_unitsMS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_unitsMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%% [M/S2] listbox %%%

% --- Executes on selection change in listbox_unitsMS2.
function listbox_unitsMS2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_unitsMS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_unitsMS2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_unitsMS2

%set list tag
listTag = 'units = [m/s2]';

define_XYlabels(listTag,hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox_unitsMS2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_unitsMS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%% [M2] listbox %%%

% --- Executes on selection change in listbox_unitsM2.
function listbox_unitsM2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_unitsM2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_unitsM2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_unitsM2

%set list tag
listTag = 'units = [m2]';

define_XYlabels(listTag,hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox_unitsM2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_unitsM2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%% [M3] listbox %%%

% --- Executes on selection change in listbox_unitsM3.
function listbox_unitsM3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_unitsM3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_unitsM3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_unitsM3

%set list tag
listTag = 'units = [m3]';

define_XYlabels(listTag,hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox_unitsM3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_unitsM3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%% [NONE] listbox %%%

% --- Executes on selection change in listbox_unitsNone.
function listbox_unitsNone_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_unitsNone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_unitsNone contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_unitsNone

%set list tag
listTag = 'units = [none]';

define_XYlabels(listTag,hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox_unitsNone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_unitsNone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%% [TEMP] listbox %%%

% --- Executes on selection change in listbox_unitsTemp.
function listbox_unitsTemp_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_unitsTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_unitsTemp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_unitsTemp

%set list tag
listTag = 'units = [T]';

define_XYlabels(listTag,hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox_unitsTemp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_unitsTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%% [KG] listbox %%%

% --- Executes on selection change in listbox_unitsKG.
function listbox_unitsKG_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_unitsKG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_unitsKG contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_unitsKG

%set list tag
listTag = 'units = [kg]';

define_XYlabels(listTag,hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox_unitsKG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_unitsKG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%% [KG/m3] listbox %%%

% --- Executes on selection change in listbox_unitsKGM3.
function listbox_unitsKGM3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_unitsKGM3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_unitsKGM3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_unitsKGM3

%set list tag
listTag = 'units = [kg/m3]';

define_XYlabels(listTag,hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox_unitsKGM3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_unitsKGM3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% WRITE XY LABELS %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function define_XYlabels(listTag, hObject, handles)
%function define_XYlabels(selection_txt,listTag,handles)
%=> function called when listbox clicked => write selection in "active" axes

%get chosen optn from list box
contents = cellstr(get(hObject,'String'));
selection_idx = get(hObject,'Value');
selection_txt0 = contents{selection_idx};
selection_txt = strrep(selection_txt0,'_','\_');

%get handle of axes with white background color (=> "active" axes)
h_axON = findobj(handles.figOutputs_previewPanel,'type','axes','color',[1,1,1]);

%NB: multiple selection in listboxes works but may cause confusion => disabled
%for i=1 : numel(selection_idx)
% selection_txt0 = contents{selection_idx(i)};
% selection_txt = strrep(selection_txt0,'_','\_');

%write txt in axes
if ~isempty(h_axON)
    
    %--- get handle of txt in axes (and its 'tag')
    h_txt = get(h_axON,'children');
    txtTag = get(h_txt,'tag');
    
    %--- define new text in axis
    
    %. if units ~[m] (or tag unset)=> overwrite existing text
    if ~strcmp(txtTag,listTag) || isempty(txtTag)
        set(h_txt,'string',selection_txt)
        set(h_txt,'tag',listTag)
        
    elseif strcmp(txtTag,listTag)
        txt = get(h_txt,'string');
        txt_cell = cellstr(txt);
        idx_txtFound = find(strcmp(selection_txt,txt_cell));
        
        if ~isempty(idx_txtFound)
            txt_cell(idx_txtFound) = [];
            txt = char(txt_cell);
        else
            txt = strvcat(txt,selection_txt);
        end
        
        set(h_txt,'string',txt)
        set(h_txt,'tag',listTag)
    end
end


% --- Executes on button press in plot_xyFig_clearAx.
function plot_xyFig_clearAx_Callback(hObject, eventdata, handles)
% hObject    handle to plot_xyFig_clearAx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get handle of axes with white background color (=> "active" axes)
h_axON = findobj(handles.figOutputs_previewPanel,'type','axes','color',[1,1,1]);

%write txt in axes
if ~isempty(h_axON)
    h_txt = get(h_axON,'children');
    set(h_txt,'string',[])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOUSE PRESS functions on axes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on mouse press over axes background.
function ax_Y1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ax_Y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axesHighlight(hObject, handles)

% --- Executes on mouse press over axes background.
function ax_Y2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ax_Y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axesHighlight(hObject, handles)

% --- Executes on mouse press over axes background.
function ax_X1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ax_X1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axesHighlight(hObject, handles)

% --- Executes on mouse press over axes background.
function ax_X2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ax_X2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axesHighlight(hObject, handles)

function axesHighlight(hObject, handles)
%get handle of axes in preview panel
h_child = get(handles.figOutputs_previewPanel,'children');
childType = get(h_child,'type');
childWhichAreAxes = strcmp(childType,'axes');
h_childAxes = h_child(childWhichAreAxes);

%make all axis gray except active on in white
set(h_childAxes,'color',[0.93,0.93,0.93])
if strcmp(get(hObject,'type'), 'axes')
    set(hObject,'color','w')
else %in case user pressed on the text in axes rather the axis itself
    h_parentAx = get(hObject,'parent');
    set(h_parentAx,'color','w')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in plot_figOutputs.
function plot_figOutputs_Callback(hObject, eventdata, handles)
% hObject    handle to plot_figOutputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_figOutputs

plot_figOutputs = get(hObject,'Value');

%get child which are NOT panels, NOT axes, NOT text and whose parent is NOT plotXY_panel, NOT plotXY_displayPanel NOT saveFig_panel
h_specChild = findobj(handles.figOutputs_panel, '-not','type','uipanel', '-not','type','axes', '-not','type','text', '-not','parent',handles.plotXY_panel, '-not','parent',handles.plotXY_displayPanel, '-not','parent',handles.saveFig_panel);

if plot_figOutputs
    set(h_specChild,'enable','on')
    
    %adapt state of plot measure tools depending on whether any tool is defined
    if isfield(handles,'measurePoints_coordXY'), measureTool_nb = size(handles.measurePoints_coordXY,1);
    else measureTool_nb = 0;
    end
    if measureTool_nb>0, set(handles.plot_measureTools,'enable','on')
    else set(handles.plot_measureTools,'enable','off')
    end

else
    set(h_specChild,'enable','off')
    %disable saveFig panel content
    if get(handles.saveFig,'Value')
        set(handles.saveFig,'Value',0)
        saveFig_Callback(hObject, eventdata, handles)
    end
    %disable saveFig panel content
    if get(handles.plot_XY,'Value')
        set(handles.plot_XY,'Value',0)
        plot_XY_Callback(hObject, eventdata, handles)
    end
    %disable 'various' plots
    set(handles.plot_contour,'Value',0);
    set(handles.plot_measureTools,'Value',0);
end





% --- Executes on button press in plot_XY.
function plot_XY_Callback(hObject, eventdata, handles)
% hObject    handle to plot_XY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_XY

plot_XY = get(hObject,'Value');

%get child which are NOT panels, NOT axes, NOT text
h_allowEnableProp = findobj(handles.plotXY_panel, '-not', 'type','uipanel', '-not', 'type','axes', '-not','type','text');
%get listbox handles
h_listbox = findobj(handles.plotXY_panel, 'style', 'listbox'); %, '-not', 'type','axes', '-not', 'parent',handles.plotXY_panel, '-not', 'parent',handles.saveFig_panel);
%get axes handles
h_axes = findobj(handles.plotXY_panel, 'type', 'axes');

if plot_XY
    
    %enable listboxes
    set(h_allowEnableProp,'enable','on')
    set(handles.panel_simulatingAx,'visible','on')
    set(h_listbox,'backgroundColor','w')
    set(handles.figOutputs_previewPanel,'foregroundColor','k')
    
    %make axis visible + add txt labels (NB: use of text within 'axes' rather than just 'staticText' because the latter cannot be set vertically
    for i=1:numel(h_axes)
        set(gcf,'currentAxes', h_axes(i))
        
        %set axes visible
        set(gca,'visible','on','units','normalized','Ytick',[],'Xtick',[],'box','on');
        set(gca,'color', [0.93,0.93,0.93])
        
        %define txt label rotation (depending if X or Y label)
        axTag = get(gca,'tag');
        [axType,~] = strtok(axTag,'ax_');
        if strcmp(axType(1),'X'), rotAngle = 0;
        elseif strcmp(axType(1),'Y'), rotAngle = 90;
        end
        
        %add txt label
        h_txt(i) = text(0.5,0.5,[axType ' [empty]'],'rotation',rotAngle,'fontsize',7,'VerticalAlignment','middle','HorizontalAlignment','center');
        
        %define to text the same ButtonDownFcn as the parent axes (otherwise when clicking on it nothing happens)
        h_ButtonPushFcn = get(gca,'ButtonDownFcn');
        set(h_txt(i),'ButtonDownFcn',h_ButtonPushFcn)
    end
    handles.h_txt=h_txt;
    guidata(hObject, handles);
    
else
    
    %disable listboxes
    set(h_allowEnableProp,'enable','off')
    set(handles.panel_simulatingAx,'visible','off')
    set(h_listbox,'backgroundColor',[0.93,0.93,0.93])
    set(handles.figOutputs_previewPanel,'foregroundColor',[0.5,0.5,0.5])
    
    %delete txt labels (=axes children)
    h_txtLabels = get(h_axes,'children');
    delete(cell2mat(h_txtLabels));
    
    %make axes invisible
    set(h_axes,'visible','off')
end


% --- Executes on button press in launch_plotXY.
function launch_plotXY_Callback(hObject, eventdata, handles)
% hObject    handle to launch_plotXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% %-- define 'caller' => where to collect the variables
% % .caller = 'plumeTracker_GUI' => variables stored in 'base' workspace
% % .caller = 'plumeTracker_FCN' => variables stored in 'caller' workspace
% caller = 'plumeTracker_GUI';

%-- collect options selected
error = plotXY_getOptnRequested(handles);
if error, return; end

%-- if plotXY launched from uploaded structure file data
if get(handles.uploadTrackedData_radBtton,'value')
    
    %check if structure file uploaded
    if ~isfield(handles,'struct_pathNfile')
        h = msgbox('Please select structure file.','warning','none'); uiwait(h);
        return
    end
    
    %     %export variables to 'base' workspace, where all variables are stored (e.g. variables from plumeTrack)
    %     var = who;
    %     for i=1:numel(var)
    %         assignin('base',var{i},eval(var{i}));
    %     end
    
    %PLOT XY fig
    plot_xyFig
end

%-- if plotXY launched from tracked data
if get(handles.trackPlume_radBtton,'value')
    try
        plumeInfo = evalin('base','plumeInfo_frame');
    catch
        disp('Track plume or upload structure file before asking for XY plot.');
        return
    end
    plot_xyFig
end


function error = plotXY_getOptnRequested(handles)

error = 0;

h_sel=get(handles.plotXY_displayPanel,'SelectedObject');
switch get(h_sel,'tag')
    case 'disp_uniqueFig', plot_uniqueFig = 1;
    case 'disp_seperateFig', plot_uniqueFig = 0;
end

figSave = get(handles.saveFig,'Value');
figName = get(handles.figName,'String');
figFormat0=get(handles.figFormat,'String');
[figFormat]=figFormat_str2cell(figFormat0); %redefine figFormat as cell array
%Ylim = [0,NaN];

%-- collect X & Y txt axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h_ax = findobj(handles.figOutputs_previewPanel,'type','axes');
for i=1:numel(h_ax)
    axTag = get(h_ax(i),'tag');
    axName = axTag(4:end);
    
    h_txt = get(h_ax(i),'children');
    txt0 = get(h_txt,'string');
    if strcmp(txt0,[axName ' [empty]']) || strcmp(txt0,''), txtAx = {};
    else
        txt = cellstr(txt0);
        txtAx = cellfun(@(x) strrep(x,'\',''),txt,'uniformOutput',false)';
    end
    
    axStruct.(axName) = txtAx;
end
Xaxis_array = [axStruct.X1, axStruct.X2];
Yaxis_array = [axStruct.Y1, axStruct.Y2];

%check if at least 1 X & 1 Y data selected
if isempty(Xaxis_array), h = msgbox('Please select X data.','warning','none'); uiwait(h); error=1; return; end
if isempty(Yaxis_array), h = msgbox('Please select Y data.','warning','none'); uiwait(h); error=1; return; end

%export needed variables to 'base' workspace, so they can be found when calling the workspace in plot_xyFig function
varName2export = {'axStruct','plot_uniqueFig','figSave','figName','figFormat'};
for i=1:numel(varName2export)
    assignin('base',varName2export{i},eval(varName2export{i}));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPERATION  PANEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in trackPlume_radBtton.
function trackPlume_radBtton_Callback(hObject, eventdata, handles)
% hObject    handle to trackPlume_radBtton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of trackPlume_radBtton


% --- Executes on button press in uploadTrackedData_radBtton.
function uploadTrackedData_radBtton_Callback(hObject, eventdata, handles)
% hObject    handle to uploadTrackedData_radBtton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of uploadTrackedData_radBtton


% --- Executes when selected object is changed in operationPanel_buttongrp.
function operationPanel_buttongrp_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in operationPanel_buttongrp
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

%NB: function created by:
% 1. selecting the button group in the GUIDE Editor
% 2. View > View Callbacks submenu > select "SelectionChangeFcn"

% h_eltsTrack = [handles.txt_loadImgFile, handles.browse_staticTxt, handles.txt_fileType, handles.select_fileORdir, handles.fileType_menu];
% h_eltsLoad = [handles.txt_loadStrtFile, handles.txt_file];

%-- get handles of 'track_panel' children
%NB: panels do not support 'enable' property
h_trackChild_notPanel_all = findobj(handles.track_panel, '-not', 'type','uipanel');
h_trackChild_notPanelnotMonitchil = findobj(handles.track_panel, '-not', 'type','uipanel', '-not', 'parent',handles.figMonitor_panel);
h_trackChild_notPanelnotMonitchil_2 = findobj(handles.track_panel, '-not', 'type','uipanel', '-not','parent',handles.figMonitor_panel, '-not','parent',handles.cmap_panel, '-not', 'parent',handles.saveGIF_panel);
h_trackChild_Panel = findobj(handles.track_panel, 'type','uipanel');
h_trackChild_PanelnotMonitchil = findobj(handles.track_panel, 'type','uipanel', '-not', 'parent',handles.figMonitor_panel);

%-- get handles of 'load_panel' children
h_loadChild = get(handles.load_panel,'children');

switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'trackPlume_radBtton'
        %enable 'start_tracking' push button
        set(handles.start_tracking,'enable','on')
        
        %enable 'track_panel' children
        set(h_trackChild_notPanelnotMonitchil_2,'enable','on')
        set(h_trackChild_PanelnotMonitchil,'foregroundcolor','k')
        set(handles.track_panel, 'borderWidth', 2, 'highlightColor', 'k')
        
        %disable 'load_panel' children
        set(h_loadChild,'enable','off')
        set(handles.load_panel, 'borderWidth', 2, 'highlightColor', 'w')
        
    case 'uploadTrackedData_radBtton'
        %disable 'start_tracking' push button
        set(handles.start_tracking,'enable','off')
        
        %disable 'track_panel' children
        set(h_trackChild_notPanelnotMonitchil_2,'enable','off')
        set(h_trackChild_PanelnotMonitchil,'foregroundcolor',[0.5,0.5,0.5])
        set(handles.track_panel, 'borderWidth', 2, 'highlightColor', 'w')
        
        %if tick box to plot figMonitor=ON => turn OFF
        if get(handles.plot_figMonitor,'value')==1
            set(handles.plot_figMonitor,'value',0)
            plot_figMonitor_Callback(handles.plot_figMonitor, eventdata, handles)
        end
        
        %enable 'load_panel' children
        set(h_loadChild,'enable','on')
        set(handles.load_panel, 'borderWidth', 2, 'highlightColor', 'k')
        
        %enable possibility to save variables to txt file
        set(handles.saveTxtFile,'enable','on')
        
end


% --- Executes on button press in select_fileORdir.
function select_fileORdir_Callback(hObject, eventdata, handles)
% hObject    handle to select_fileORdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%get fileType selected
fileType = handles.fileType;
slash = handles.slash;

start_path = get(handles.path2file_txtbox,'String');

if strcmp(start_path,'path'), start_path=[cd slash '*.*']; end

if strcmp(fileType,'image files')

    %. select image directory
    dialog_title = 'select image directory';
    folder_name = uigetdir(start_path,dialog_title);
    if ~ischar(folder_name), return, end %if cancel pressed
    
    pathName = [folder_name slash];
    
    k = strfind(folder_name, slash);
    newString = folder_name(k(end)+1:end); %last folder in chosen path
    
    if isfield(handles,'videoName'), rmfield(handles,'videoName'); end
    
    %. detect whether image=radiometric (=> if .mat files)
    list_fileNamesSpecif = get_filesInfolder(pathName,'*.mat');
    if ~isempty(list_fileNamesSpecif), radiometricData = 1;
    else radiometricData = 0;
    end
    
elseif strcmp(fileType,'video file')

    %. select movie file
    currentPath = cd;
    dialog_title = 'select movie file';
    [fileName,pathName,~] = uigetfile([start_path '*'],dialog_title);
    if ~ischar(fileName), return, end %if cancel pressed
    path = currentPath;
    newString = fileName;

    radiometricData = 0;
    
    handles.videoName = fileName;
    
elseif strcmp(fileType,'url link')
    %browse button inactive
    return
end

% write path
set(hObject,'string',newString,'fontsize',6) %change push button string
set(handles.path2file_txtbox,'string',pathName,'fontsize',6)
handles.pathName = pathName;

% update elts in GUI
radiometricData_guiUpdate(radiometricData,handles)

handles.radiometricData = radiometricData;
guidata(hObject, handles);


function radiometricData_guiUpdate(radiometricData,handles)
% update elts in GUI depending on whether data is radiometric or not
% updated elts: monitor fig options, X vs. Y plot options

%update monitor fig options:
list = get(handles.figMonitor_optnList,'string');
hPlots = get(handles.figMonitor_previewPanel,'children');
if radiometricData
    list{1}='imgRaw_celsius';
    list{2}='imgRaw_kelvin';
else
    list{1}='imgRaw_rgb';
    list{2}='imgRaw_idx';
end
set(handles.figMonitor_optnList,'string',list)
if ~isempty(hPlots), set(hPlots,'string','[empty]','enable','off'); end

%update X vs. Y fig options
if radiometricData
    set(handles.text_unitsT,'string','[T°]');
    %reset full option list
    set(handles.listbox_unitsKG,'string',handles.massAsh_optnList_ini)
else
    set(handles.text_unitsT,'string','[color-indexed value]');
    %supress last option (massAsh_methThermBalance)
    set(handles.listbox_unitsKG,'string',handles.massAsh_optnList_ini(1:end-1))
end
    

function path2file_txtbox_Callback(hObject, eventdata, handles)
% hObject    handle to path2file_txtbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path2file_txtbox as text
%        str2double(get(hObject,'String')) returns contents of path2file_txtbox as a double

path_withORwithout_file = get(hObject,'String');
slash = handles.slash;

% if path modified manually => collect last folder in chosen path & define the "browse pushbutton" with it
if ~strcmp(path_withORwithout_file,'path')
    
    k = strfind(path_withORwithout_file, slash);
    if ~isempty(k)
        if k(end)==numel(path_withORwithout_file) %if path entered ends with \
            newString = path_withORwithout_file(k(end-1)+1:numel(path_withORwithout_file)-1);
        else newString = path_withORwithout_file(k(end)+1:end);
        end
        set(handles.select_fileORdir,'String', newString);
        
        %.detect whether image=radiometric (=> if .mat files)
        list_fileNamesSpecif = get_filesInfolder(path_withORwithout_file,'*.mat');
        if ~isempty(list_fileNamesSpecif), radiometricData = 1;
        else radiometricData = 0;
        end
        %.update elts in GUI
        radiometricData_guiUpdate(radiometricData,handles)
        
        handles.radiometricData = radiometricData;
        handles.pathName = path_withORwithout_file;
        guidata(hObject, handles);
    else
        h = msgbox('Path entered not correct.','warning','none'); uiwait(h); return
    end
    
end


% --- Executes during object creation, after setting all properties.
function path2file_txtbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path2file_txtbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in fileType_menu.
function fileType_menu_Callback(hObject, eventdata, handles)
% hObject    handle to fileType_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fileType_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fileType_menu

fileType_beforeUpdate = handles.fileType;

contents = cellstr(get(hObject,'String'));
fileType = contents{get(hObject,'Value')};

%reset browse button & search path
if ~strcmp(fileType_beforeUpdate,fileType)
    set(handles.select_fileORdir,'string','browse');
    set(handles.path2file_txtbox,'string','path');
    if isfield(handles,'pathName')
        handles = rmfield(handles,'pathName');
    end
end

%elts to disable if fileType = url link
h_url = [handles.frameStrt,handles.frameStep,handles.frameEnd];

% update elts in GUI
if strcmp(fileType,'video file')
    %video file always non-radiometric
    radiometricData = 0;
    radiometricData_guiUpdate(radiometricData,handles)
    handles.radiometricData = radiometricData;
    set(h_url,'enable','on');
    
elseif strcmp(fileType,'image files')
    %image file may be radiometric (.mat file) or non-radiometric (jpg,...)
    %=> gui update done when selecting img directory (select_fileORdir_Callback)
    set(h_url,'enable','on');
    
elseif strcmp(fileType,'url link')
    %url file always non-radiometric
    radiometricData = 0;
    radiometricData_guiUpdate(radiometricData,handles)
    handles.radiometricData = radiometricData;
    
    set(h_url,'enable','off');
    
    %launch GUI "gui_urlStreaming"
    gui_urlStreaming(handles)
end


%reset imgTransformation
if isfield(handles,'inputs_imgTransf')
    handles = rmfield(handles,'inputs_imgTransf');
    set(handles.set_imgTransf,'string','set image transformations')
end

%reset measure tools
if isfield(handles,'measurePoints_coordXY')
    handles = rmfield(handles,'measurePoints_coordXY');
    set(handles.set_measureTools,'string','set measure tools')
end

handles.fileType = fileType;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function fileType_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileType_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select_strctFile.
function select_strctFile_Callback(hObject, eventdata, handles)
% hObject    handle to select_strctFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fileType = '*.mat';
DialogTitle = 'Select structure file (.mat).';
start_path = {}; %'c:\Users\sebastien\Documents\IR Santiaguito\Data\Seq.28\Seq28_raw\'; %{}

%define filter spec (=> fileType and/or start path)
if ~isempty(start_path)
    FilterSpec = [start_path fileType];
else FilterSpec = fileType;
end

[struct_fileName,struct_pathName,~] = uigetfile(FilterSpec,DialogTitle);
if ~ischar(struct_fileName), return, end %if cancel pressed
struct_pathNfile = [struct_pathName struct_fileName];

%set fileName in push button
set(hObject,'string',struct_fileName,'fontsize',6)

%%upload structure file => variables stored in 'base' workspace
if ~isempty(struct_fileName)
    get_structfile2var(struct_pathNfile)
end

%store pathNfile
handles.struct_pathNfile = struct_pathNfile;
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in saveGIF.
function saveGIF_Callback(hObject, eventdata, handles)
% hObject    handle to saveGIF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveGIF

saveGIF = get(hObject,'Value');
h_child = get(handles.saveGIF_panel,'children');

if saveGIF
    set(h_child, 'enable', 'on')
else
    set(h_child, 'enable', 'off')
end


function figName_GIF_Callback(hObject, eventdata, handles)
% hObject    handle to figName_GIF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figName_GIF as text
%        str2double(get(hObject,'String')) returns contents of figName_GIF as a double


% --- Executes during object creation, after setting all properties.
function figName_GIF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figName_GIF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveStructFile.
function saveStructFile_Callback(hObject, eventdata, handles)
% hObject    handle to saveStructFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveStructFile

saveStructFile = get(hObject,'Value');
h_child = get(handles.saveStruct_panel,'children');

if saveStructFile
    set(h_child, 'enable', 'on')
else
    set(h_child, 'enable', 'off')
end

function fileName_struct_Callback(hObject, eventdata, handles)
% hObject    handle to fileName_struct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileName_struct as text
%        str2double(get(hObject,'String')) returns contents of fileName_struct as a double


% --- Executes during object creation, after setting all properties.
function fileName_struct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileName_struct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveTxtFile.
function saveTxtFile_Callback(hObject, eventdata, handles)
% hObject    handle to saveTxtFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveTxtFile

saveTxtFile = get(hObject,'Value');
h_child = get(handles.saveTxtFile_panel,'children');

if saveTxtFile
    set(h_child, 'enable', 'on')
        
else
    txtfileStruct={}; %reset
    assignin('base','txtfileStruct',txtfileStruct)
    set(h_child, 'enable', 'off')
end


function fileName_txt_Callback(hObject, eventdata, handles)
% hObject    handle to fileName_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileName_txt as text
%        str2double(get(hObject,'String')) returns contents of fileName_txt as a double


% --- Executes during object creation, after setting all properties.
function fileName_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileName_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT VARIOUS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in plot_contour.
function plot_contour_Callback(hObject, eventdata, handles)
% hObject    handle to plot_contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of plot_contour

% --- Executes on button press in plot_pxHeightCorrection.
function plot_pxHeightCorrection_Callback(hObject, eventdata, handles)
% hObject    handle to plot_pxHeightCorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of plot_pxHeightCorrection

load_workspaceVar

if exist('pxHeightMat_imgAx','var')
    plot_pxHeightCorrection
else
    plot_pxHeightCorrection(handles); %case if function called before code has ever been runned
end

    
% --- Executes on button press in plot_imgMeanFig.
function plot_imgMeanFig_Callback(hObject, eventdata, handles)
% hObject    handle to plot_imgMeanFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of plot_imgMeanFig

% --- Executes on button press in launch_plotVarious.
function launch_plotVarious_Callback(hObject, eventdata, handles)
% hObject    handle to launch_plotVarious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%continue if tracking succceeded
try evalin('base','trackingSucceeded')
catch
    disp('INFO: perform tracking before plot request.')
    return
end

%collect variables related to figure saving & export to 'base' workspace so they can be found when calling the workspace in functions)
%(operation to be done before calling function in case values have changed since the tracking)
figSave = get(handles.saveFig,'Value');
figName = get(handles.figName,'String');
figFormat0=get(handles.figFormat,'String');
[figFormat]=figFormat_str2cell(figFormat0);

varName2export = {'figSave','figName','figFormat'};
for i=1:numel(varName2export)
    assignin('base',varName2export{i},eval(varName2export{i}));
end

%contour plot
plot_contour=get(handles.plot_contour,'Value');
if plot_contour
    plot_contourFig
end

% plot_pxImgMean_Callback
plot_imgMeanFig=get(handles.plot_imgMeanFig,'Value');
if plot_imgMeanFig
    plot_imgMean
end

%img measure tools
plot_measureTools=get(handles.plot_measureTools,'Value');
if plot_measureTools
    plot_measurePts
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE FIG OPTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in saveFig.
function saveFig_Callback(hObject, eventdata, handles)
% hObject    handle to saveFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveFig

saveFig = get(hObject,'Value');
h_child = get(handles.saveFig_panel,'children');

if saveFig
    set(h_child, 'enable', 'on')
else
    set(h_child, 'enable', 'off')
end

function figName_Callback(hObject, eventdata, handles)
% hObject    handle to figName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of figName as text
%        str2double(get(hObject,'String')) returns contents of figName as a double

% --- Executes during object creation, after setting all properties.
function figName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function figFormat_Callback(hObject, eventdata, handles)
% hObject    handle to textfigFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of textfigFormat as text
%        str2double(get(hObject,'String')) returns contents of textfigFormat as a double

% --- Executes during object creation, after setting all properties.
function textfigFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textfigFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function figFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in add_colorbar.
function add_colorbar_Callback(hObject, eventdata, handles)
% hObject    handle to add_colorbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of add_colorbar


% --- Executes on button press in add_legend.
function add_legend_Callback(hObject, eventdata, handles)
% hObject    handle to add_legend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of add_legend



% --- Executes on button press in set_filters.
function set_filters_Callback(hObject, eventdata, handles)
% hObject    handle to set_filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if ~isfield(handles,'pathName')
    contents = cellstr(get(handles.fileType_menu,'String'));
    fileType = contents{get(handles.fileType_menu,'Value')};
    
    if strcmp(fileType,'url link')
        warnMsg = 'Please start/stop streaming to download at least one image from url link.';
    else
        warnMsg = 'Please select image directory.';
    end
    h = msgbox(warnMsg,'warning','none'); uiwait(h);
    return
        
else
    
    %check if input correct
    [operation_onTempThresh,~,~] = get_threshold(handles.plumeTemp_thresh);
    [operation_onTempThreshVar,~,~] = get_threshold(handles.plumeTempVar_thresh);
    if strcmp(operation_onTempThresh,'error') || strcmp(operation_onTempThreshVar,'error')
        return
    end
    
    define_filterValues(handles)
end


% --- Executes on button press in set_measureTools.
function set_measureTools_Callback(hObject, eventdata, handles)
% hObject    handle to set_measureTools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'pathName')
    h = msgbox('Please select image directory.','warning','none'); uiwait(h);
    return
else
    define_measureTools(handles);
end

% --- Executes on button press in plot_measureTools.
function plot_measureTools_Callback(hObject, eventdata, handles)
% hObject    handle to plot_measureTools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_measureTools


% --- Executes on button press in set_massParam.
function set_massParam_Callback(hObject, eventdata, handles)
% hObject    handle to set_massParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'pathName')
    h = msgbox('Please select image directory.','warning','none'); uiwait(h);
    %NB: define_massInputs requires knowledge of whether data is radiometric
    return
else
    define_massInputs(handles)
end


% --- Executes on button press in set_recSettings.
function set_recSettings_Callback(hObject, eventdata, handles)
% hObject    handle to set_recSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

define_recSettings(handles)


% --- Executes on button press in set_imgTransf.
function set_imgTransf_Callback(hObject, eventdata, handles)
% hObject    handle to set_imgTransf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'pathName')
    contents = cellstr(get(handles.fileType_menu,'String'));
    fileType = contents{get(handles.fileType_menu,'Value')};
    
    if strcmp(fileType,'url link')
        warnMsg = 'Please start/stop streaming to download at least one image from url link.';
    else
        warnMsg = 'Please select image directory.';
    end
    h = msgbox(warnMsg,'warning','none'); uiwait(h);
    return
        
else
    define_imgTransf(handles)
end


% --- Executes on button press in selectVar2save.
function selectVar2save_Callback(hObject, eventdata, handles)
% hObject    handle to selectVar2save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

define_txtfileContent(handles);


% --- Executes on button press in imgAnalysis.
function imgAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to imgAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_imgAnalysis(handles)


% --- Executes on button press in slowExecution_chbox.
function slowExecution_chbox_Callback(hObject, eventdata, handles)
% hObject    handle to slowExecution_chbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of slowExecution_chbox

h_child = get(handles.slowExecution_panel,'children');

slowExecution = get(hObject,'Value');
if slowExecution
    set(h_child,'enable','on')
else
    set(h_child,'enable','off') 
end


function slowExecution_val_Callback(hObject, eventdata, handles)
% hObject    handle to slowExecution_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slowExecution_val as text
%        str2double(get(hObject,'String')) returns contents of slowExecution_val as a double

% --- Executes during object creation, after setting all properties.
function slowExecution_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slowExecution_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in saveFrame.
function saveFrame_Callback(hObject, eventdata, handles)
% hObject    handle to saveFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveFrame

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LOAD INPUTS and START TRACKING %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in start_tracking.
function start_tracking_Callback(hObject, eventdata, handles)
% hObject    handle to start_tracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc

%get pathName
if isfield(handles,'pathName'), inputStruct.pathName = handles.pathName;
else h = msgbox('Please select image directory.','warning','none'); uiwait(h); return
end

%get file type
fileType = handles.fileType;
inputStruct.fileType = fileType;
if strcmp(fileType,'video file'), inputStruct.videoName=handles.videoName; end    

%get tracking inputs
inputStruct.frameStrt = str2double(get(handles.frameStrt,'String'));
inputStruct.frameStep = str2double(get(handles.frameStep,'String'));
frameEnd = get(handles.frameEnd,'String');
if strcmp(frameEnd,'last'), inputStruct.frameEnd=frameEnd;
else inputStruct.frameEnd = str2double(frameEnd);
    if inputStruct.frameStrt > inputStruct.frameEnd, h = msgbox('Frame START cannot be > Frame END.','warning','none'); uiwait(h); return; end
end

%get radiometricData var
inputStruct.radiometricData = handles.radiometricData;

%get tracking filters
%.filter img region
inputStruct.filter_imgRegion = get(handles.filter_imgRegion,'Value');
% if inputStruct.filter_imgRegion
    inputStruct.ventY = str2double(get(handles.ventY,'String'));
    limH_px = get(handles.limH_px,'String'); %sym function from Symbolic Math Toolbox could be used
    inputStruct.limH_px_str = limH_px;
    if strfind(limH_px,'<')
        inputStruct.side_ofLimH = 'left'; inputStruct.limH_px=str2num(limH_px(2:end));
    elseif strfind(limH_px,'>')
        inputStruct.side_ofLimH = 'right'; inputStruct.limH_px=str2num(limH_px(2:end));
    else h = msgbox('Horizontal limit not properly defined: add < or > before numeric value','warning','none'); uiwait(h); return
    end
% end
%.filter temp thresh
inputStruct.filter_tempThresh = get(handles.filter_tempThresh,'Value');
if inputStruct.filter_tempThresh
    [operationType,threshold,~] = get_threshold(handles.plumeTemp_thresh);
    if strcmp(operationType,'error'), return, end
    inputStruct.operation_onTempThresh = operationType;
    inputStruct.plumeTemp_thresh = threshold; 
end
%.filter temp variation
inputStruct.filter_tempVar = get(handles.filter_tempVar,'Value');
if inputStruct.filter_tempVar
    %filter type (fixed substraction or sliding substraction)
    list = cellstr(get(handles.imgSubstraction_list,'String'));
    inputStruct.filter_tempVar_type = list{get(handles.imgSubstraction_list,'Value')};

    %filter value
    %get thresh value
    [operationType,threshold,threshold_txt] = get_threshold(handles.plumeTempVar_thresh);
    if strcmp(operationType,'error'), return, end
    inputStruct.operation_onTempThreshVar = operationType;
    inputStruct.plumeTempVar_thresh = threshold;
    inputStruct.plumeTempVar_thresh_str = threshold_txt;
end
%set frameRef (for imgDiff_frameRef => used by filter_tempVar, or by figMonitor for imgDiff_frameRef)
frame2substract = get(handles.imgSubstraction_frame,'string');
if strcmp(frame2substract,'previous')
    inputStruct.frameRef=1;
else
    inputStruct.frameRef=str2num(frame2substract);
end
%.filter interaction
h_sel=get(handles.filterInteraction_panel,'SelectedObject');
inputStruct.filterInteraction = get(h_sel,'tag');

%get recording settings
if ~isfield(handles,'inputRec') || numel(fieldnames(handles.inputRec))<7 
    %NB: nber of fields may be <7 if frameRate defined automatically when video uploaded
    
    %Contents of inputRec:
    %. frameRate
    %. inclinationAngle_deg
    %. distHoriz
    %. ventAlt_m
    %. IFOV
    %. FOVh_deg
    %. FOVv_deg
    
    h = msgbox({'Recording settings not defined:'; '=> default values will be attributed';'=> time vectors & pixel size might be erroneous'},'warning','none'); uiwait(h);
    
    %open GUI "define_massInputs" and call "save" function 
    %  => structure 'inputs_massParam' created, and GUI closed
    hGUI = define_recSettings(handles);
    h = findobj(hGUI,'tag','save'); %get handle of pushbutton 'save'
    fh = get(h,'Callback');         %get 'save function' callback
    feval(fh,h,handles)             %evaluate function handle
    handles = guidata(hObject);     %updates the copy of the handles that has been updated

end
inputStruct.inputRec = handles.inputRec;


%get figMonitor content
plot_figMonitor = get(handles.plot_figMonitor,'Value');
if ~plot_figMonitor
    plot_monitorImg = {};
else
    %get txt in fig preview plots and assign in cell array
    h_child = get(handles.figMonitor_previewPanel,'children');
    
%     %sometimes the preview panel itself is seen as child...suppress if it is the case
%     errChild = find(cellfun(@(x) strcmp(x,'fig preview'), get(h_child,'string')));
%     if ~isempty(errChild), h_child(errChild) =[]; end
    
    for i=1:numel(h_child)
        %get coordinates fo cell array
        plot_posIJ = get(h_child(i),'tag'); [tok,rem]=strtok(plot_posIJ,',');
        r=str2num(tok); c=str2num(rem(2:end));
        
        %get txt in cell format
        txt_char = get(h_child(i),'string');
        txt_cell = cellstr(txt_char);
        
        %write in cell array
        plot_monitorImg{r,c} = txt_cell;
        plot_monitorImg_posIJ(i,1:2) = [r,c];
    end
    inputStruct.plot_monitorImg_posIJ = plot_monitorImg_posIJ;
end
inputStruct.plot_monitorImg = plot_monitorImg;
inputStruct.plotTypes = cellstr(get(handles.figMonitor_optnList,'String'));

%get color map options
if plot_figMonitor

    %CMAP
    if ~isempty(handles.cmap_matrix)
        %.get cmap if customized
        cmap_matrix = handles.cmap_matrix;
    else
        %.get default cmap without calling GUI define_cmap
        
        %get info from monitorFig preview
        plotPos = get(handles.h_monitorPlots,'position');
        plotCont = get(handles.h_monitorPlots,'string');
        plotTag = get(handles.h_monitorPlots,'tag');
        
        if ~iscell(plotPos) %in case only 1plot => plotCont not cell array
            plotPos={plotPos}; plotCont={plotCont}; plotTag={plotTag};
        end

        for i=1:numel(plotPos)
            %get plot contents in monitor fig
            plotContent = plotCont{i}; [nbL,nbC] = size(plotContent);
            if nbL>1, plotContent = mat2cell(plotContent,ones(nbL,1),nbC);
            else plotContent = plotCont(i);
            end
            
            [txt,limTxt,~,~,~] = get_defaultCmap(plotContent);
            
            [tok,rem]=strtok(plotTag{i},',');
            r=str2double(tok); c=str2double(rem(2:end));
            
            cmap_matrix{r,c} = txt;
            clim_matrix{r,c} = limTxt;
        end
    end
        
    %. modify cmap_matrix to matrix with true color map names or values
    for i=1:size(cmap_matrix,1)
        for j=1:size(cmap_matrix,2)
            cMap = cmap_matrix{i,j};
            if strcmp(cMap,'jet_baseK'), cMap = eval(['cmap_' cMap]); %cMap must be name of matlab file which contains the color map
            elseif strcmp(cMap,'jet_centerW'), cMap = eval(['cmap_' cMap]);
            elseif strcmp(cMap,'blue_white_red'), cMap = eval('cmap_bwr');
            elseif strcmp(cMap,'none'), cMap = [];
            end
            cMap_matrix{i,j} = cMap;
        end
    end
    
    %. check if multiple color maps chosen
    if ~all(all(strcmp(cmap_matrix{1},cmap_matrix)))
        if numel(cmap_matrix)==2 && ~isempty(find(strcmp(cmap_matrix(:),'none'))) %incase 2 suplots with one having cmap = 'none'
            distinctCmapNeeded = 0;
        else
            distinctCmapNeeded = 1; %=> multiple colormap & colorbar enabled, BUT will SLOW down code execution by factor of 2
            disp('Tip: multiple colormaps enabled, to improve processing speed set identical colormaps to all plots.')
            %multiple colormaps enabled => freecolors function converts the objects color (e.g. images,...) from indexed CData to [r g b] truecolor)')
        end
    else distinctCmapNeeded = 0;
    end
 
    %.store in input structure
    inputStruct.distinctCmapNeeded = distinctCmapNeeded;
    inputStruct.cMap_matrix = cMap_matrix;
    
    %CLIM
    %.get cLim if different then custom
    if ~isempty(handles.clim_matrix), clim_matrix = handles.clim_matrix; end
    
    %. modify clim_matrix to numeric values
    for i=1:size(clim_matrix,1)
        for j=1:size(clim_matrix,2)
            cLim = clim_matrix{i,j};
            if strcmp(strrep(cLim,' ',''),'[]'), cLim = []; %cLim must be name of matlab file which contains the color map
            else
                [token,remain] = strtok(cLim(2:end-1),':');
                cLim = [str2double(token),str2double(remain(2:end))];
                %NB: str2double(string)=>NaN; str2num(string)=>[]
            end
            cLim_matrix{i,j} = cLim;
        end
    end    
    inputStruct.cLim_matrix = cLim_matrix;
    
end

%add colorbar & legend
add_colorbar=get(handles.add_colorbar,'value');
inputStruct.add_colorbar=add_colorbar;
add_legend=get(handles.add_legend,'value');
inputStruct.add_legend=add_legend;
if add_colorbar, disp('Tip: to improve processing speed, disable ''add colorbar'''); end
if add_legend, disp('Tip: to improve processing speed, disable ''add legend'''); end

%get tracking output options
%plot_figOutputs = get(handles.plot_figOutputs,'Value');
inputStruct.plot_XY = get(handles.plot_XY,'Value');
if inputStruct.plot_XY
    %collect requested options, and export needed variables to 'base' workspace, so they can be found when calling the workspace in plot_xyFig function
    error = plotXY_getOptnRequested(handles);
    if error, return; end
end
inputStruct.plot_contourPlot = get(handles.plot_contour,'Value');
inputStruct.plot_imgMeanFig = get(handles.plot_imgMeanFig,'Value');
inputStruct.plot_measureTools = get(handles.plot_measureTools,'Value');

%save animated GIF
inputStruct.saveGif = get(handles.saveGIF,'value');
inputStruct.figName_GIF = get(handles.figName_GIF,'string'); %[handles.path2folder_outputs get(handles.figName_GIF,'string') '.gif'];

%save each frame as JPG
inputStruct.saveFrame = get(handles.saveFrame,'value');

%slow program execution
inputStruct.slowExecution = get(handles.slowExecution_chbox,'value');
inputStruct.slowExecution_sec = str2num(get(handles.slowExecution_val,'string'));
if inputStruct.slowExecution, disp('INFO: slow program execution option is enabled.'); end

%save ws variables in structure file
inputStruct.save_wsvar2file = get(handles.saveStructFile,'value');
inputStruct.fileName_struct = get(handles.fileName_struct,'string');

%save specific variables in tab-delimited file
save_specvar2txtFile = get(handles.saveTxtFile,'value');
if save_specvar2txtFile
    %. import txtfileStruct
    try txtfileStruct = evalin('base','txtfileStruct');
    catch, txtfileStruct={}; %in case 'save_specvar2txtFile' on, but no structure for the tab-delimited file is saved
    end
    inputStruct.txtfileStruct = txtfileStruct;
    inputStruct.fileName_txt = get(handles.fileName_txt,'string');   
end
inputStruct.save_specvar2txtFile = save_specvar2txtFile;

%save output fig
inputStruct.figSave = get(handles.saveFig,'Value');
inputStruct.figName = get(handles.figName,'String');
figFormat0=get(handles.figFormat,'String');
inputStruct.figFormat=figFormat_str2cell(figFormat0);

%path to outputs folder
inputStruct.path2folder_outputs = handles.path2folder_outputs;

%measure point coordinates
if isfield(handles,'measurePoints_coordXY')
inputStruct.measurePts_coordXY = handles.measurePoints_coordXY;
inputStruct.measurePts_T = {};
else
end

%mass input parameters needed for computation
if ~isfield(handles,'inputs_massParam')
    
    %open GUI "define_massInputs" and call "save" function 
    %  => structure 'inputs_massParam' created, and GUI closed
    hGUI = define_massInputs(handles);
    h = findobj(hGUI,'tag','save'); %get handle of pushbutton 'save'
    fh = get(h,'Callback');         %get 'save function' callback
    feval(fh,h,handles)             %evaluate function handle
    handles = guidata(hObject);     %updates the copy of the handles that has been updated

    disp('INFO: input parameters required to compute ash mass have not been defined manually: default values assigned.')

end
inputStruct.inputs_massParam = handles.inputs_massParam;

%image transformations
if isfield(handles,'inputs_imgTransf')
    inputStruct.imgTransformation = 1;
    inputStruct.inputs_imgTransf = handles.inputs_imgTransf;
else inputStruct.imgTransformation = 0;
end

% START TRACKING
tic
plumeTracker(inputStruct)
toc
