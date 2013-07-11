function varargout = define_massInputs(varargin)
% DEFINE_MASSINPUTS MATLAB code for define_massInputs.fig
%      DEFINE_MASSINPUTS, by itself, creates a new DEFINE_MASSINPUTS or raises the existing
%      singleton*.
%
%      H = DEFINE_MASSINPUTS returns the handle to a new DEFINE_MASSINPUTS or the handle to
%      the existing singleton*.
%
%      DEFINE_MASSINPUTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE_MASSINPUTS.M with the given input arguments.
%
%      DEFINE_MASSINPUTS('Property','Value',...) creates a new DEFINE_MASSINPUTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_massInputs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_massInputs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define_massInputs

% Last Modified by GUIDE v2.5 14-May-2013 13:21:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @define_massInputs_OpeningFcn, ...
                   'gui_OutputFcn',  @define_massInputs_OutputFcn, ...
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


% --- Executes just before define_massInputs is made visible.
function define_massInputs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define_massInputs (see VARARGIN)


% Choose default command line output for define_massInputs
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%EDITED:

%center gui on screen
movegui(gcf,'center')

%-- upload handles structure from gui_plumeTracker
H = varargin{1};
handles.H = H;

%-- upload saved inputs_massParam structure if existent, and fill GUI with saved input parameters
if isfield(H, 'inputs_massParam')
    
    %--- inputs common to BOTH methods
    
    %set temperature atm
    h_selObj = findobj('tag',H.inputs_massParam.temp_atm2use);
    set(handles.tempAtm_panel,'SelectedObject',h_selObj)
    if isfield(H.inputs_massParam, 'tempAtm_val')
        set(handles.tempAtm_val,'string',num2str(H.inputs_massParam.tempAtm_val))
        set([handles.tempAtm_val; handles.tempAtm_txt],'enable','on');
    end
    
    %set temperature air
    h_selObj = findobj('tag',H.inputs_massParam.temp_heatedAir2use);
    set(handles.tempHeatedAir_panel,'SelectedObject',h_selObj)
    if isfield(H.inputs_massParam, 'tempAir_val')
        set(handles.tempAir_val,'string',num2str(H.inputs_massParam.tempAir_val))
        set([handles.tempAir_val; handles.tempAir_txt],'enable','on');
    end
    
    
    %--- inputs specific to ASH FRACTION method
    
    %set drag coefficients
    set(handles.dragCoef_sph,'String',num2str(H.inputs_massParam.dragCoef_sph));
    set(handles.dragCoef_cyl,'String',num2str(H.inputs_massParam.dragCoef_cyl));
    
    %set radius
    radL_content = cellstr(get(handles.radius_listbox,'String'));
    idx = find(strcmp(radL_content,H.inputs_massParam.radius2use));
    set(handles.radius_listbox,'value',idx);
    
    %set height
    heightL_content = cellstr(get(handles.length_listbox,'String'));
    idx = find(strcmp(heightL_content,H.inputs_massParam.height2use));
    set(handles.length_listbox,'value',idx);
    
    %set velocity
    velocL_content = cellstr(get(handles.velocity_listbox,'String'));
    idx = find(strcmp(velocL_content,H.inputs_massParam.velocity2use));
    set(handles.velocity_listbox,'value',idx);
    
    %set acceleration
    accelL_content = cellstr(get(handles.acceleration_listbox,'String'));
    idx = find(strcmp(accelL_content,H.inputs_massParam.acceleration2use));
    set(handles.acceleration_listbox,'value',idx);
    
    %set density ash
    set(handles.densityAsh,'string',num2str(H.inputs_massParam.densityAsh))
    
    %set density atmo
    h_selObj = findobj('tag',H.inputs_massParam.dens_atm2use);
    set(handles.densAtm_panel,'SelectedObject',h_selObj)
    if isfield(H.inputs_massParam, 'densAtm_val')
       set(handles.densAtm_val,'string',num2str(H.inputs_massParam.densAtm_val))
       set([handles.densAtm_val; handles.densAtm_txt],'enable','on');
    end
    

    %--- inputs specific to THERMAL BALANCE method
    if H.radiometricData
        %set specific heat values
        set(handles.specHeat_ash,'string',num2str(H.inputs_massParam.specHeat_ash))
        set(handles.specHeat_air,'string',num2str(H.inputs_massParam.specHeat_air))
        
        %set ash temperature
        h_selObj = findobj('tag',H.inputs_massParam.temp_ash2use);
        set(handles.tempAsh_panel,'SelectedObject',h_selObj)
        if isfield(H.inputs_massParam, 'tempAsh_val')
            set(handles.tempAsh_val,'string',num2str(H.inputs_massParam.tempAsh_val))
            set([handles.tempAsh_val; handles.tempAsh_txt],'enable','on');
        end
    end
    
end

%disable certain options if data non-radiometric
if ~H.radiometricData
    %. disable optn temperature of heated air = mean temperature
    h_airTmean = findobj('tag','tempAir_meanT');
    set(h_airTmean,'enable','off')
    
    h_airTcst = findobj('tag','tempAir_cst');
    set([handles.tempAir_val; handles.tempAir_txt],'enable','on')
    set(handles.tempHeatedAir_panel,'SelectedObject',h_airTcst)
    
    %. disable panel for thermal balance input param
    hChild = findobj(handles.methTB_panel,'-not','type','uipanel');
    set(hChild,'enable','off');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes define_massInputs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = define_massInputs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function densityAsh_Callback(hObject, eventdata, handles)
% hObject    handle to densityAsh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of densityAsh as text
%        str2double(get(hObject,'String')) returns contents of densityAsh as a double


% --- Executes during object creation, after setting all properties.
function densityAsh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to densityAsh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function tempHeatedAir_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempHeatedAir_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function tempAir_val_Callback(hObject, eventdata, handles)
% hObject    handle to tempAir_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tempAir_val as text
%        str2double(get(hObject,'String')) returns contents of tempAir_val as a double


% --- Executes during object creation, after setting all properties.
function tempAir_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempAir_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tempAtm_val_Callback(hObject, eventdata, handles)
% hObject    handle to tempAtm_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tempAtm_val as text
%        str2double(get(hObject,'String')) returns contents of tempAtm_val as a double


% --- Executes during object creation, after setting all properties.
function tempAtm_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempAtm_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function densAtm_val_Callback(hObject, eventdata, handles)
% hObject    handle to densAtm_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of densAtm_val as text
%        str2double(get(hObject,'String')) returns contents of densAtm_val as a double


% --- Executes during object creation, after setting all properties.
function densAtm_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to densAtm_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function specHeat_ash_Callback(hObject, eventdata, handles)
% hObject    handle to specHeat_ash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of specHeat_ash as text
%        str2double(get(hObject,'String')) returns contents of specHeat_ash as a double


% --- Executes during object creation, after setting all properties.
function specHeat_ash_CreateFcn(hObject, eventdata, handles)
% hObject    handle to specHeat_ash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function specHeat_air_Callback(hObject, eventdata, handles)
% hObject    handle to specHeat_air (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of specHeat_air as text
%        str2double(get(hObject,'String')) returns contents of specHeat_air as a double


% --- Executes during object creation, after setting all properties.
function specHeat_air_CreateFcn(hObject, eventdata, handles)
% hObject    handle to specHeat_air (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tempAsh_val_Callback(hObject, eventdata, handles)
% hObject    handle to tempAsh_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tempAsh_val as text
%        str2double(get(hObject,'String')) returns contents of tempAsh_val as a double


% --- Executes during object creation, after setting all properties.
function tempAsh_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempAsh_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function dragCoef_sph_Callback(hObject, eventdata, handles)
% hObject    handle to dragCoef_sph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dragCoef_sph as text
%        str2double(get(hObject,'String')) returns contents of dragCoef_sph as a double


% --- Executes during object creation, after setting all properties.
function dragCoef_sph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dragCoef_sph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dragCoef_cyl_Callback(hObject, eventdata, handles)
% hObject    handle to dragCoef_cyl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dragCoef_cyl as text
%        str2double(get(hObject,'String')) returns contents of dragCoef_cyl as a double


% --- Executes during object creation, after setting all properties.
function dragCoef_cyl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dragCoef_cyl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in velocity_listbox.
function velocity_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to velocity_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns velocity_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from velocity_listbox


% --- Executes during object creation, after setting all properties.
function velocity_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to velocity_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in acceleration_listbox.
function acceleration_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to acceleration_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns acceleration_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from acceleration_listbox


% --- Executes during object creation, after setting all properties.
function acceleration_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acceleration_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in radius_listbox.
function radius_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to radius_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns radius_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from radius_listbox


% --- Executes during object creation, after setting all properties.
function radius_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in length_listbox.
function length_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to length_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns length_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from length_listbox


% --- Executes during object creation, after setting all properties.
function length_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to length_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in densAtm_panel.
function densAtm_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in densAtm_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

selectionTag = get(eventdata.NewValue,'tag');

h = [handles.densAtm_val; handles.densAtm_txt];

switch selectionTag
    case 'densAtm_stdAtm'
        set(h,'enable','off')
    case 'densAtm_cst'
        set(h,'enable','on')
end


% --- Executes when selected object is changed in tempAtm_panel.
function tempAtm_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in tempAtm_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

selectionTag = get(eventdata.NewValue,'tag');

h = [handles.tempAtm_val; handles.tempAtm_txt];

switch selectionTag
    case 'tempAtm_stdAtm'
        set(h,'enable','off')
    case 'tempAtm_cst'
        set(h,'enable','on')
end


% --- Executes when selected object is changed in tempHeatedAir_panel.
function tempHeatedAir_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in tempHeatedAir_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

selectionTag = get(eventdata.NewValue,'tag');

h = [handles.tempAir_val; handles.tempAir_txt];

switch selectionTag
    case 'tempAir_meanT'
        set(h,'enable','off')
    case 'tempAir_cst'
        set(h,'enable','on')
end


% --- Executes when selected object is changed in tempAsh_panel.
function tempAsh_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in tempAsh_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

selectionTag = get(eventdata.NewValue,'tag');

h = [handles.tempAsh_val; handles.tempAsh_txt];

switch selectionTag
    case 'tempAsh_maxT'
        set(h,'enable','off')
    case 'tempAsh_cst'
        set(h,'enable','on')
end

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

H = handles.H;

%--- inputs common to BOTH methods

%get temperature of atmosphere to use
h_sel=get(handles.tempAtm_panel,'SelectedObject');
inputs_massParam.temp_atm2use = get(h_sel,'tag');
if strcmp(inputs_massParam.temp_atm2use,'tempAtm_cst')
    inputs_massParam.tempAtm_val = str2double(get(handles.tempAtm_val,'String'));
end

%get temperature of heated air  to use
h_sel=get(handles.tempHeatedAir_panel,'SelectedObject');
inputs_massParam.temp_heatedAir2use = get(h_sel,'tag');
if strcmp(inputs_massParam.temp_heatedAir2use,'tempAir_cst')
    inputs_massParam.tempAir_val = str2double(get(handles.tempAir_val,'String'));
end


%--- inputs specific to ASH FRACTION method
% NB: listbox contents identical to those in plot XY fig

%get drag coefficients
inputs_massParam.dragCoef_sph = str2double(get(handles.dragCoef_sph,'String'));
inputs_massParam.dragCoef_cyl = str2double(get(handles.dragCoef_cyl,'String'));

%get radius
radL_content = cellstr(get(handles.radius_listbox,'String'));
inputs_massParam.radius2use = radL_content{get(handles.radius_listbox,'Value')};

%get height
heightL_content = cellstr(get(handles.length_listbox,'String'));
inputs_massParam.height2use = heightL_content{get(handles.length_listbox,'Value')};

%get velocity
velocL_content = cellstr(get(handles.velocity_listbox,'String'));
inputs_massParam.velocity2use = velocL_content{get(handles.velocity_listbox,'Value')};

%get acceleration
accelL_content = cellstr(get(handles.acceleration_listbox,'String'));
inputs_massParam.acceleration2use = accelL_content{get(handles.acceleration_listbox,'Value')};

%get ash density
inputs_massParam.densityAsh = str2double(get(handles.densityAsh,'String'));

%get density of atmosphere to use
h_sel=get(handles.densAtm_panel,'SelectedObject');
inputs_massParam.dens_atm2use = get(h_sel,'tag');
if strcmp(inputs_massParam.dens_atm2use,'densAtm_cst')
    inputs_massParam.densAtm_val = str2double(get(handles.densAtm_val,'String'));
end

%--- inputs specific to THERMAL BALANCE method
%=> collect only if data is radiometric
if H.radiometricData
    inputs_massParam.specHeat_ash = str2double(get(handles.specHeat_ash,'String'));
    inputs_massParam.specHeat_air = str2double(get(handles.specHeat_air,'String'));
    
    %get temperature of ash to use
    h_sel=get(handles.tempAsh_panel,'SelectedObject');
    inputs_massParam.temp_ash2use = get(h_sel,'tag');
    if strcmp(inputs_massParam.temp_ash2use,'tempAsh_cst')
        inputs_massParam.tempAsh_val = str2double(get(handles.tempAsh_val,'String'));
    end
end
    
% update handles structure INSIDE gui_plumeTracker
H.inputs_massParam = inputs_massParam;
guidata(gui_plumeTracker,H)

% close GUI 'define_measureTools'
h_guiMassInputs = findobj('name','define_massInputs');
close(h_guiMassInputs)
