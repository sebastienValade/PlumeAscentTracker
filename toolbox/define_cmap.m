function varargout = define_cmap(varargin)
% DEFINE_CMAP MATLAB code for define_cmap.fig
%      DEFINE_CMAP, by itself, creates a new DEFINE_CMAP or raises the existing
%      singleton*.
%
%      H = DEFINE_CMAP returns the handle to a new DEFINE_CMAP or the handle to
%      the existing singleton*.
%
%      DEFINE_CMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE_CMAP.M with the given input arguments.
%
%      DEFINE_CMAP('Property','Value',...) creates a new DEFINE_CMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_cmap_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_cmap_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define_cmap

% Last Modified by GUIDE v2.5 18-Apr-2013 09:53:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @define_cmap_OpeningFcn, ...
    'gui_OutputFcn',  @define_cmap_OutputFcn, ...
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


% --- Executes just before define_cmap is made visible.
function define_cmap_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define_cmap (see VARARGIN)

% Choose default command line output for define_cmap
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes define_cmap wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%EDITED:

%-- upload handles structure from gui_plumeTracker
H = varargin{1};
handles.H = H;
guidata(hObject, handles);

%center gui on screen
movegui(gcf,'center') 

%get info from monitorFig preview
plotPos = get(H.h_monitorPlots,'position');
plotCont = get(H.h_monitorPlots,'string');
plotTag = get(H.h_monitorPlots,'tag');

if ~iscell(plotPos) %in case only 1plot => plotCont not cell array
    plotPos={plotPos};
    plotCont={plotCont};
    plotTag={plotTag};
end

%collect cmap & clim matrix if previously defined
if isfield(H,'cmap_matrix')
    cmap_matrix = H.cmap_matrix;
    clim_matrix = H.clim_matrix;
else cmap_matrix={};
end


%define default inputs for plots
bkgCol = [1,1,1];
h=[]; hh=[];

if isempty(cmap_matrix) %if cmap never defined
    cmapCustom_defined = 0;
else
    cmapCustom_defined = 1;
end

for i=1:numel(plotPos)
    idx = numel(h);
    
    %get plot contents in monitor fig
    plotContent = plotCont{i}; [nbL,nbC] = size(plotContent);
    if nbL>1, plotContent = mat2cell(plotContent,ones(nbL,1),nbC);
    else plotContent = plotCont(i);
    end
    
    if cmapCustom_defined==0 %isempty(cmap_matrix) %if cmap never defined
        
        [txt,limTxt,style,bkgColor,fColor] = get_defaultCmap(plotContent);
        
    else %if cmap has already been defined => restore
        txt = cmap_matrix{i};
        
        %clim
        limTxt = clim_matrix{i};
        if ~isempty(cell2mat(strfind(plotContent,'imgRaw')))
            style = 'edit'; bkgColor = [1,1,1]; fColor=[0,0,0];
        else style = 'frame'; bkgColor = [0.9412, 0.9412, 0.9412]; fColor=[0.65,0.65,0.65];
        end
        
    end
    
    
    %--- write in texbox
    pos = plotPos{i};
    
    %CMAP text boxes
    h(idx+1) = uicontrol('Style','text',...
        'Position',pos,...
        'string',txt,...
        'BackgroundColor',bkgCol,... %NB: 'ForegroundColor' controls text color not edge color!
        'ButtonDownFcn',@enablePlot_cmap,...
        'enable','off',...
        'tag',plotTag{i},...
        'parent',handles.panel_cmap);
    
    %CLIM text boxes
    %=> editable text box if imgRaw (or imgDiff*) requested
    hh(idx+1) = uicontrol('Style',style,...
        'Position',pos,...
        'string',limTxt,...
        'BackgroundColor',bkgColor,'ForegroundColor',fColor,...
        'callback', @enablePlot_clim,...
        'tag',plotTag{i},...
        'parent',handles.panel_clim,...
        'ButtonDownFcn',@enablePlot_clim,...
        'enable','off');
    %NB: with style 'edit' => 'ForegroundColor' defines the edited text color !!
    %---
    
    [tok,rem]=strtok(plotTag{i},',');
    r=str2double(tok); c=str2double(rem(2:end));
    
    %get default CMAP matrix constructed
    cmap_matrix{r,c} = txt;
    
    %get default CLIM matrix constructed
    clim_matrix{r,c} = limTxt;
end


% --- Outputs from this function are returned to the command line.
function varargout = define_cmap_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function enablePlot_cmap(hObject,eventdata)
%function called when user clicks on one of the preview plots

%get children of both panels
h=findobj(gcf,'type','uipanel');
h_txt = cell2mat(get(h,'children'));

%disable all plots except plot clicked
set(h_txt,'enable','off');
set(hObject,'enable','on')
if strcmp(get(hObject,'string'), '[empty]')
    set(hObject,'string','')
end

function enablePlot_clim(hObject,eventdata)

%get children of CLIM panel
hChild = get(get(hObject,'parent'),'children');

%enable edit clim boxe which has been clicked
set(hChild,'enable','off')
set(hObject,'enable','on')


% --- Executes on selection change in listbox_cmaps.
function listbox_cmaps_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_cmaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_cmaps contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_cmaps

contents = cellstr(get(hObject,'String'));
selection_idx = get(hObject,'Value');
selection_txt = contents{selection_idx};

%get handle of enabled plots
hPanel_cmap=findobj(gcf,'type','uipanel','tag','panel_cmap');
h_plotsON = findobj(gcf,'style','text','enable','on','parent',handles.panel_cmap);
set(h_plotsON,'string',selection_txt)

% --- Executes during object creation, after setting all properties.
function listbox_cmaps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_cmaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

H = handles.H;

h_cmapChild = get(handles.panel_cmap, 'children');
h_climChild = get(handles.panel_clim, 'children');

for i=1:numel(h_cmapChild)
    
    posIJ = get(h_cmapChild(i),'tag');
    [tok,rem]=strtok(posIJ,',');
    r=str2double(tok); c=str2double(rem(2:end));
    
    %build cmap & clim matrix
    cmap_matrix{r,c} = get(h_cmapChild(i),'string');
    clim_matrix{r,c} = get(h_climChild(i),'string');
end

%store default cmap matrix
H.cmap_matrix = cmap_matrix;
H.clim_matrix = clim_matrix;
set(handles.H.cmap_define,'string','custom'); %change string on push button


% update handles structure INSIDE gui_plumeTracker
guidata(gui_plumeTracker,H)

% close GUI 'define_cmap'
h_guiCmap = findobj('name','define_cmap');
close(h_guiCmap)

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% close GUI 'define_cmap' (default matrix saved to base workspace when figure created)
h_guiCmap = findobj('name','define_cmap');
close(h_guiCmap)
