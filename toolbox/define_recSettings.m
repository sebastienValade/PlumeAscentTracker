function varargout = define_recSettings(varargin)
% DEFINE_RECSETTINGS MATLAB code for define_recSettings.fig
%      DEFINE_RECSETTINGS, by itself, creates a new DEFINE_RECSETTINGS or raises the existing
%      singleton*.
%
%      H = DEFINE_RECSETTINGS returns the handle to a new DEFINE_RECSETTINGS or the handle to
%      the existing singleton*.
%
%      DEFINE_RECSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE_RECSETTINGS.M with the given input arguments.
%
%      DEFINE_RECSETTINGS('Property','Value',...) creates a new DEFINE_RECSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_recSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_recSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define_recSettings

% Last Modified by GUIDE v2.5 22-May-2013 17:59:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @define_recSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @define_recSettings_OutputFcn, ...
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


% --- Executes just before define_recSettings is made visible.
function define_recSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define_recSettings (see VARARGIN)

% Choose default command line output for define_recSettings
handles.output = hObject;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%EDITED:

%center gui on screen
movegui(gcf,'center')

%-- upload handles structure from gui_plumeTracker
H = varargin{1};
handles.H = H;

%-- set rec input values defined previously (if any)
if isfield(H,'inputRec')
    if isfield(H.inputRec,'frameRate')
        set(handles.frameRate,'string',num2str(H.inputRec.frameRate))
    end
    if isfield(H.inputRec,'inclinationAngle_deg')
        set(handles.inclinationAngle_deg,'string',num2str(H.inputRec.inclinationAngle_deg))
    end
    if isfield(H.inputRec,'distHoriz')
        set(handles.distHoriz,'string',num2str(H.inputRec.distHoriz))
    end
    if isfield(H.inputRec,'ventAlt_m')
        set(handles.ventAlt_m,'string',num2str(H.inputRec.ventAlt_m))
    end
    if isfield(H.inputRec,'IFOV')
        set(handles.IFOV,'string',num2str(H.inputRec.IFOV))
    end
    if isfield(H.inputRec,'FOVh_deg')
        set(handles.FOV_h,'string',num2str(H.inputRec.FOVh_deg))
    end
    if isfield(H.inputRec,'FOVv_deg')
        set(handles.FOV_v,'string',num2str(H.inputRec.FOVv_deg))
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes define_recSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = define_recSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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

% --- Executes on button press in plot_pxHeightCorrection.
function plot_pxHeightCorrection_Callback(hObject, eventdata, handles)
% hObject    handle to plot_pxHeightCorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load_workspaceVar

%NB: will pxHeightMAtrix with parameters of last tracking run (if transformation since, re-run tracking before plotting)
if exist('pxHeightMat_imgAx','var')
    plot_pxHeightCorrection
else
    plot_pxHeightCorrection(handles); %case if function called before code has ever been runned
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

H = handles.H;

%upload previously created inputStruct (if any)
if isfield(handles,'inputRec')
    inputRec = H.inputRec;
end

%get recording settings
inputRec.frameRate = str2double(get(handles.frameRate,'String'));
inputRec.inclinationAngle_deg = str2double(get(handles.inclinationAngle_deg,'String'));
inputRec.distHoriz = str2double(get(handles.distHoriz,'String'));
inputRec.ventAlt_m = str2double(get(handles.ventAlt_m,'String'));
inputRec.IFOV = str2double(get(handles.IFOV,'String'));
inputRec.FOVh_deg = str2double(get(handles.FOV_h,'String'));
inputRec.FOVv_deg = str2double(get(handles.FOV_v,'String'));

% update handles structure INSIDE gui_plumeTracker
H.inputRec = inputRec;
guidata(gui_plumeTracker,H)

% close GUI 'define_measureTools'
h_guiRecSettings = findobj('name','define_recSettings');
close(h_guiRecSettings)