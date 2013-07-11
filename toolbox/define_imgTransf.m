function varargout = define_imgTransf(varargin)
% DEFINE_IMGTRANSF MATLAB code for define_imgTransf.fig
%      DEFINE_IMGTRANSF, by itself, creates a new DEFINE_IMGTRANSF or raises the existing
%      singleton*.
%
%      H = DEFINE_IMGTRANSF returns the handle to a new DEFINE_IMGTRANSF or the handle to
%      the existing singleton*.
%
%      DEFINE_IMGTRANSF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE_IMGTRANSF.M with the given input arguments.
%
%      DEFINE_IMGTRANSF('Property','Value',...) creates a new DEFINE_IMGTRANSF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_imgTransf_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_imgTransf_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define_imgTransf

% Last Modified by GUIDE v2.5 27-May-2013 17:47:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @define_imgTransf_OpeningFcn, ...
                   'gui_OutputFcn',  @define_imgTransf_OutputFcn, ...
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


% --- Executes just before define_imgTransf is made visible.
function define_imgTransf_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define_imgTransf (see VARARGIN)

% Choose default command line output for define_imgTransf
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%EDITED:

%center gui on screen
movegui(gcf,'center')

%-- upload handles structure from gui_plumeTracker
H = varargin{1};
handles.H = H;

%set imgAxis without labels
set([handles.ax_imgOrig,handles.ax_imgTransf],'box','on','xTickLabel',{},'yTickLabel',{})

%% ORIGINAL image
pathName = H.pathName;

%.load image storage
fileType = H.fileType;
frameEnd = get(H.frameEnd,'string');
if isfield(H,'videoName'), videoName = H.videoName; end
load_imgStorage;
handles.imgStorage = imgStorage;

%write last frame available
set(handles.lastFrame_txt,'string', ['(last frame = ' num2str(nbFrames) ')'])
   
%.load image number 1
img2load = str2num(get(handles.frame2display,'string'));
load_img(img2load)
if exist('imgRaw_rgb','var'), img = imgRaw_rgb;
else img = imgRaw;
end

%write image size
set(handles.size_imgOrig,'string', [num2str(size(img,1)) ' x ' num2str(size(img,2))])

%.plot image
axes(handles.ax_imgOrig);
imagesc(img);
axis image

handles.img = img;

%% TRANSFORMED image (if any)
if isfield(H,'inputs_imgTransf')
    if isfield(H.inputs_imgTransf,'imgRotation')
        set(handles.transf_rotation, 'value', 1);
        transf_rotation_Callback(handles.transf_rotation, eventdata, handles)
        set(handles.rotation_nb, 'string', num2str(H.inputs_imgTransf.imgRotation_nb));
        rotation_nb_Callback(handles.rotation_nb, eventdata, handles)
    end
    
    if isfield(H.inputs_imgTransf,'imgCrop')
        set(handles.transf_crop, 'value', 1);
        
        %get image size
        h=findobj(handles.ax_imgTransf,'type','image');
        if ~isempty(h); imgT = get(h,'cdata'); imgSize = size(imgT);
        else imgSize = size(img);
        end
        
        xRange_L = H.inputs_imgTransf.imgCrop_xRange_L;  
        if xRange_L==1, set(handles.xRange_left,'string','none')
        else set(handles.xRange_left,'string',num2str(xRange_L))
        end
        xRange_R = H.inputs_imgTransf.imgCrop_xRange_R;
        if xRange_R==imgSize(2), set(handles.xRange_right,'string','none')
        else set(handles.xRange_right,'string',num2str(xRange_R))
        end
        yRange_B = H.inputs_imgTransf.imgCrop_yRange_B;
        if yRange_B==imgSize(1), set(handles.yRange_bottom,'string','none')
        else set(handles.yRange_bottom,'string',num2str(yRange_B))
        end
        yRange_T = H.inputs_imgTransf.imgCrop_yRange_T;
        if yRange_T==1, set(handles.yRange_top,'string','none')
        else set(handles.yRange_top,'string',num2str(yRange_T))
        end
        
        transf_crop_Callback(handles.transf_crop, eventdata, handles)
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes define_imgTransf wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = define_imgTransf_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function frame2display_Callback(hObject, eventdata, handles)
% hObject    handle to frame2display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame2display as text
%        str2double(get(hObject,'String')) returns contents of frame2display as a double


%update original image

img2load = str2num(get(handles.frame2display,'string'));
imgStorage = handles.imgStorage;
fileType = handles.H.fileType;
load_img(img2load)
if exist('imgRaw_rgb','var'), img = imgRaw_rgb;
else img = imgRaw;
end

axes(handles.ax_imgOrig);
imagesc(img);
axis image

handles.img = img;
guidata(hObject, handles);

%update transformed image
transf_rotation = get(handles.transf_rotation,'Value');
if transf_rotation
    rotation_nb_Callback(handles.rotation_nb, eventdata, handles)
end

transf_crop = get(handles.transf_crop,'Value');
if transf_crop
    %update crop region rectangle (string 'none' will render different value since img size may change with rotation)
    handles = draw_cropRegion(handles);
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function frame2display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame2display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in transf_rotation.
function transf_rotation_Callback(hObject, eventdata, handles)
% hObject    handle to transf_rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of transf_rotation

transf_rotation = get(hObject,'Value');

h = findobj(handles.transf_rotationPanel,'-not','tag','rotation_ang','-not','type','uipanel');

if transf_rotation
    set(h,'enable','on');
    rotation_nb_Callback(handles.rotation_nb, eventdata, handles)
else
    set(h,'enable','off');

    %check if ax_imgTransf empty
    h=findobj(handles.ax_imgTransf,'type','image');
    if ~isempty(h) %case if axe NOT empty => replace image by ax_imgOrig
        delete(h);
        
        h_img = findobj(handles.ax_imgOrig,'type','image');
        axes(handles.ax_imgTransf)
        imagesc(get(h_img,'cdata'))
        axis image
        
        %bring crop region rectangle (if any) to the front
        h = findobj('displayName','cropRegion');
        if ~isempty(h), uistack(h,'top'), end
    end
end

function rotation_nb_Callback(hObject, eventdata, handles)
% hObject    handle to rotation_nb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotation_nb as text
%        str2double(get(hObject,'String')) returns contents of rotation_nb as a double


nbRot = str2double(get(hObject,'String'));

img = handles.img;
if numel(size(img))>2
    imgRot(:,:,1) = rot90(img(:,:,1),nbRot);
    imgRot(:,:,2) = rot90(img(:,:,2),nbRot);
    imgRot(:,:,3) = rot90(img(:,:,3),nbRot);
else
    imgRot = rot90(img,nbRot);
end
handles.imgRot = imgRot;
guidata(hObject, handles);

%delete previous rot image
imgTransf = findobj(handles.ax_imgTransf,'type','image');
if ~isempty(imgTransf), delete(imgTransf); end

%plot rotated image
axes(handles.ax_imgTransf)
imagesc(imgRot)
axis image

%crop region rectangle
transf_crop = get(handles.transf_crop,'Value');
if transf_crop
    %update crop region rectangle (string 'none' will render different value since img size may change with rotation)
    handles = draw_cropRegion(handles);
    guidata(hObject, handles);
end

%write image size
imgSize_transf = write_sizeImgT(handles);
handles.imgSize_transf = imgSize_transf;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rotation_nb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotation_nb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function rotation_ang_Callback(hObject, eventdata, handles)
% hObject    handle to rotation_ang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotation_ang as text
%        str2double(get(hObject,'String')) returns contents of rotation_ang as a double


% --- Executes during object creation, after setting all properties.
function rotation_ang_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotation_ang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in transf_crop.
function transf_crop_Callback(hObject, eventdata, handles)
% hObject    handle to transf_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of transf_crop

transf_crop = get(hObject,'Value');

h = get(handles.transf_cropPanel,'children');

if transf_crop
    set(h,'enable','on');
    handles = draw_cropRegion(handles);
    guidata(hObject, handles);
else
    set(h,'enable','off');
    %delete crop region
    h = findobj('displayName','cropRegion');
    if ~isempty(h), delete(h), end
end


function handles = draw_cropRegion(handles)

axes(handles.ax_imgTransf)

%-- check if ax_imgTransf empty: if so => copy ax_imgOrig
h=findobj(handles.ax_imgTransf,'type','image');
if isempty(h) %case if axes empty => copy ax_imgOrig
    h_img = findobj(handles.ax_imgOrig,'type','image');
    imagesc(get(h_img,'cdata'))
    axis image
    %NB: copyobj(h_img,gca) will not set the tickLabels properly
end

imgTransf = findobj(handles.ax_imgTransf,'type','image');
imgX = get(imgTransf,'xdata');
imgY = get(imgTransf,'ydata');

%-- get crop region range (modify if exceeds img size)
%.xRange_L
xRange_L = get(handles.xRange_left,'string'); 
if strcmp(xRange_L,'none'), xRange_L = 1;
else xRange_L=str2num(xRange_L);
end

%.xRange_R
xRange_R = get(handles.xRange_right,'string'); 
if strcmp(xRange_R,'none')
    xRange_R = imgX(2);
else
    xRange_R=str2num(xRange_R); 
    if xRange_R>imgX(2) %case if limit exceeds img size => set limit = img size
        xRange_R = imgX(2);
        set(handles.xRange_right,'string',num2str(xRange_R))
    end
end

%.yRange_B
yRange_B = get(handles.yRange_bottom,'string');
if strcmp(yRange_B,'none'), yRange_B = imgY(2);
else
    yRange_B=str2num(yRange_B);
    if yRange_B>imgY(2) %case if limit exceeds img size => set limit = img size
        yRange_B = imgY(2);
        set(handles.yRange_bottom,'string',num2str(yRange_B))
    end
end

%.yRange_T
yRange_T = get(handles.yRange_top,'string'); 
if strcmp(yRange_T,'none'), yRange_T = 1; 
else yRange_T=str2num(yRange_T); 
end

%-- set rectangle size
width = xRange_R-xRange_L;
height = yRange_B-yRange_T;

%-- warning dialogs if erroneous input
if height<0
   h = msgbox({'Y-range not defined properly: lower limit value should be > upper limit value. (The origin of the coordinate system is at the top left of the image.)'},'warning','help'); uiwait(h); return
end
if width<0
   h = msgbox('X-range not defined properly: left limit value should be < right limit value.','warning','help'); uiwait(h); return
end
hold on

%delete previous crop region
h = findobj('displayName','cropRegion');
if ~isempty(h), delete(h), end

%draw region
rectangle('Position',[xRange_L,yRange_T,width,height],'EdgeColor','r','displayName','cropRegion')

%store crop range
handles.xRange_L = xRange_L;
handles.xRange_R = xRange_R;
handles.yRange_B = yRange_B;
handles.yRange_T = yRange_T;

%write image size
imgSize_transf = write_sizeImgT(handles);
handles.imgSize_transf = imgSize_transf;


function xRange_left_Callback(hObject, eventdata, handles)
% hObject    handle to xRange_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xRange_left as text
%        str2double(get(hObject,'String')) returns contents of xRange_left as a double

handles = draw_cropRegion(handles);
guidata(hObject, handles);

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



function xRange_right_Callback(hObject, eventdata, handles)
% hObject    handle to xRange_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xRange_right as text
%        str2double(get(hObject,'String')) returns contents of xRange_right as a double

handles = draw_cropRegion(handles);
guidata(hObject, handles);

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



function yRange_bottom_Callback(hObject, eventdata, handles)
% hObject    handle to yRange_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yRange_bottom as text
%        str2double(get(hObject,'String')) returns contents of yRange_bottom as a double

handles = draw_cropRegion(handles);
guidata(hObject, handles);

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



function yRange_top_Callback(hObject, eventdata, handles)
% hObject    handle to yRange_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yRange_top as text
%        str2double(get(hObject,'String')) returns contents of yRange_top as a double

handles = draw_cropRegion(handles);
guidata(hObject, handles);

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


function imgSize_transf = write_sizeImgT(handles)

transf_crop = get(handles.transf_crop,'Value');
if transf_crop
    xRange_L = handles.xRange_L;
    xRange_R = handles.xRange_R;
    yRange_B = handles.yRange_B;
    yRange_T = handles.yRange_T;
    imgSize_transf(1) = numel(yRange_T:yRange_B);
    imgSize_transf(2) = numel(xRange_L:xRange_R);
else
    imgSize_transf = size(handles.imgRot);
end

set(handles.size_imgTransf,'string', [num2str(imgSize_transf(1)) ' x ' num2str(imgSize_transf(2))])



% --- Executes on button press in saveTransf.
function saveTransf_Callback(hObject, eventdata, handles)
% hObject    handle to saveTransf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

H = handles.H;
txtGui = [];

%img rotation param
transf_rotation = get(handles.transf_rotation,'Value');
if transf_rotation
    inputs_imgTransf.imgRotation = 1;
    inputs_imgTransf.imgRotation_nb = str2double(get(handles.rotation_nb,'String'));
    txtGui = [txtGui, ' rot,'];
end

%img cropping param
transf_crop = get(handles.transf_crop,'Value');
if transf_crop
    if ~isfield(handles, 'xRange_L'), handles = draw_cropRegion(handles); end
    inputs_imgTransf.imgCrop = 1;
    inputs_imgTransf.imgCrop_xRange_L = handles.xRange_L;
    inputs_imgTransf.imgCrop_xRange_R = handles.xRange_R;
    inputs_imgTransf.imgCrop_yRange_B = handles.yRange_B;
    inputs_imgTransf.imgCrop_yRange_T = handles.yRange_T;
    txtGui = [txtGui, ' crop,'];
end

%img size
if transf_rotation || transf_crop
    inputs_imgTransf.imgSize_orig = size(handles.img);
    inputs_imgTransf.imgSize_transf = handles.imgSize_transf;
    
end

% update handles structure INSIDE gui_plumeTracker
if exist('inputs_imgTransf','var')
    H.inputs_imgTransf = inputs_imgTransf;
    guidata(gui_plumeTracker,H)
    
    %change string of pushbutton
    set(H.set_imgTransf,'string',['transformations:' txtGui(1:end-1)])

else
    %case if no transformation requested => delete info in handles structure INSIDE gui_plumeTracker
    if isfield(H,'inputs_imgTransf')
        H = rmfield(H,'inputs_imgTransf');
        guidata(gui_plumeTracker,H)
        
        %change string of pushbutton
        set(H.set_imgTransf,'string','set image transformations')
    end
end

% close GUI 'define_measureTools'
h_guiImgTransf = findobj('name','define_imgTransf');
close(h_guiImgTransf)
