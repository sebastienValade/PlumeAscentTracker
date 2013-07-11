function varargout = define_measureTools(varargin)
% DEFINE_MEASURETOOLS MATLAB code for define_measureTools.fig
%      DEFINE_MEASURETOOLS, by itself, creates a new DEFINE_MEASURETOOLS or raises the existing
%      singleton*.
%
%      H = DEFINE_MEASURETOOLS returns the handle to a new DEFINE_MEASURETOOLS or the handle to
%      the existing singleton*.
%
%      DEFINE_MEASURETOOLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE_MEASURETOOLS.M with the given input arguments.
%
%      DEFINE_MEASURETOOLS('Property','Value',...) creates a new DEFINE_MEASURETOOLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_measureTools_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_measureTools_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define_measureTools

% Last Modified by GUIDE v2.5 03-Jan-2013 17:06:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @define_measureTools_OpeningFcn, ...
    'gui_OutputFcn',  @define_measureTools_OutputFcn, ...
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


% --- Executes just before define_measureTools is made visible.
function define_measureTools_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define_measureTools (see VARARGIN)

% Choose default command line output for define_measureTools
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%EDITED:

%-- upload handles structure from gui_plumeTracker
H = varargin{1};
handles.H = H;

%.center gui on screen
movegui(gcf,'center') 

%.load image storage
pathName = handles.H.pathName;
fileType = handles.H.fileType;
frameEnd = handles.H.frameEnd;
if isfield(handles.H,'videoName'), videoName = handles.H.videoName; end
load_imgStorage;
handles.imgStorage=imgStorage;
handles.nbFrames=nbFrames;
guidata(hObject,handles);

%.get frame to upload
frame2use=nbFrames/2; frame2use=floor(frame2use);
set(handles.frame_txt,'string',num2str(frame2use));

%load frame to use
load_img(frame2use)
%transform img (crop, rotate, ...)
if isfield(H,'inputs_imgTransf')
    inputs_imgTransf = H.inputs_imgTransf;
    img_transformation;
end
handles.imgRaw=imgRaw;
guidata(hObject,handles);

%plot frame
updateImages(handles,imgRaw)


%load measureTools previously stored, if any
if isfield(H, 'measurePoints_coordXY') && ~isempty(H.measurePoints_coordXY)
    measurePoints_coordXY = H.measurePoints_coordXY;
    
    for i=1 : size(measurePoints_coordXY,1)
        
        %create uitable from matrix 'measurePoints_coordXY'
        table{i,1} = measurePoints_coordXY{i,1}(1);
        table{i,2} = measurePoints_coordXY{i,2}(1);
        
        if numel(measurePoints_coordXY{i,1})==1
            %if point stored
            table{i,3} = NaN;
            table{i,4} = NaN;
            
            hList_ptA(i,1) = plot(measurePoints_coordXY{i,1}(1), measurePoints_coordXY{i,2}(1),'r+');
            htxtList_ptA(i,1) = text(measurePoints_coordXY{i,1}(1)+3, measurePoints_coordXY{i,2}(1)-3, num2str(i), 'color','r' ,'verticalAlignment','baseLine','fontsize',7);
            hList_ptB(i,1) = NaN;
            htxtList_ptB(i,1) = NaN;
            
        elseif numel(measurePoints_coordXY{i,1})>1
            %if line stored
            table{i,3} = measurePoints_coordXY{i,1}(end);
            table{i,4} = measurePoints_coordXY{i,2}(end);
            
            h_linePx = plot(measurePoints_coordXY{i,1},measurePoints_coordXY{i,2},'r.');
            h_line = []; 
            handles.h_line = h_line;
            handles.h_linePx = h_linePx;
            
            hList_ptA(i,1) = plot(measurePoints_coordXY{i,1}(1), measurePoints_coordXY{i,2}(1),'w+');
            htxtList_ptA(i,1) = text(measurePoints_coordXY{i,1}(1)+3, measurePoints_coordXY{i,2}(1)-3, [num2str(i) 'A'], 'color','r' ,'verticalAlignment','baseLine','fontsize',7);
            hList_ptB(i,1) = plot(measurePoints_coordXY{i,1}(end), measurePoints_coordXY{i,2}(end),'w+');
            htxtList_ptB(i,1) = text(measurePoints_coordXY{i,1}(end)+3, measurePoints_coordXY{i,2}(end)-3, [num2str(i) 'B'], 'color','r' ,'verticalAlignment','baseLine','fontsize',7);
            
        end
    end
    
    %update table
    set(handles.table_measurePtCoord,'data',cell2mat(table))
    
    handles.table = table;
    handles.measurePoints_coordXY = measurePoints_coordXY;
    handles.hList_ptA = hList_ptA; handles.hList_ptB = hList_ptB;
    handles.htxtList_ptA = htxtList_ptA; handles.htxtList_ptB = htxtList_ptB;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes define_measureTools wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = define_measureTools_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function frame_txt_Callback(hObject, eventdata, handles)
% hObject    handle to frame_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame_txt as text
%        str2double(get(hObject,'String')) returns contents of frame_txt as a double

frame2use = str2double(get(hObject,'String'));
handles.frame2use = frame2use;

% [imgRef,imgRaw,imgDiff_frameRef]=load_img(H,frame2use,imgStorage)
[imgRef,imgRaw,imgDiff_frameRef] = load_img(handles,frame2use);
handles.imgRef=imgRef;
handles.imgRaw=imgRaw;
handles.imgDiff_frameRef=imgDiff_frameRef;
guidata(hObject,handles);

%update img
updateImages(handles,imgRef,imgRaw,imgDiff_frameRef)

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

% --- Executes during object creation, after setting all properties.
function table_measurePtCoord_CreateFcn(hObject, eventdata, handles)
% hObject    handle to table_measurePtCoord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% FUNCTION CREATED to update manually table characteristics
%   in GUI: right clic on table-> View Callbacks -> CreateFunction

% Update table characteristics:
tableDim = cell(1,4);
% tableCell_editability = true(size(tableDim));
% colWidth = 40;

set(hObject,'data',tableDim)
% set(hObject,'columnEditable',tableCell_editability)
% set(hObject,'columnName',{'x','y','X','Y'})
% set(hObject,'columnwidth',num2cell(repmat(colWidth, 1,size(tableDim,2))))


% --- Executes during object creation, after setting all properties.
function axes_img_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_img

% FUNCTION CREATED to insert toobar to figure (in GUI: right clic on axis-> View Callbacks -> CreateFunction)
% Then in GUI, clic "Toolbar Editor" icon, and drag the wanted icons for the toolbar. Clic OK, run GUI, and voila.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADD MEASURE TOOLS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add POINT

% --- Executes on button press in add_point.
function add_point_Callback(hObject, eventdata, handles)
% hObject    handle to add_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y] = ginput(1);

%floor values to correspond to pixel
x=floor(x);
y=floor(y);

%plot selected point
hold on
h = plot(x,y,'r+');

%store handle of measure point added
if isfield(handles,'hList_ptA'), 
hList_ptA=handles.hList_ptA; hList_ptB=handles.hList_ptB; 
    htxtList_ptA=handles.htxtList_ptA; htxtList_ptB=handles.htxtList_ptB;
    idx=numel(handles.hList_ptA)+1;
else idx=1;
end
hList_ptA(idx,1) = h; handles.hList_ptA = hList_ptA;
hList_ptB(idx,1) = NaN; handles.hList_ptB = hList_ptB;  %handle list for point 2 (for LINE measurement tool)

%add text to specify point nber
htxt_ptA = text(x+3,y-3,num2str(idx),'color','r','verticalAlignment','baseLine','fontsize',7);
htxtList_ptA(idx,1) = htxt_ptA; handles.htxtList_ptA = htxtList_ptA;
htxtList_ptB(idx,1) = NaN; handles.htxtList_ptB = htxtList_ptB;

%save point coordinates in table & matrix
if isfield(handles,'table')
    idx=size(handles.table,1)+1;
    table = handles.table; %upload former entries (end-point coord)
    measurePoints_coordXY = handles.measurePoints_coordXY; %upload former entries (all fit-pixel coord)
else idx=1;
end
table{idx,1} = x;
table{idx,2} = y;
handles.table = table;

%find empty cells (in case line tool added) and insert NaN (else error with cell2mat)
[r,c] = find(cellfun('isempty',table));
if ~isempty(r)
    for i=1:numel(r)
        for j =1:numel(r)
            table{r(i),c(j)} = NaN;
        end
    end
end

%update table
handles.table = table;
set(handles.table_measurePtCoord,'data',cell2mat(table))

%SAVE coordinates of ALL points (not only end-points) in measurePoints_coordXY
measurePoints_coordXY{idx,1} = x;
measurePoints_coordXY{idx,2} = y;
handles.measurePoints_coordXY = measurePoints_coordXY;

%update handle structure
guidata(hObject,handles);


% add LINE

% --- Executes on button press in add_line.
function add_line_Callback(hObject, eventdata, handles)
% hObject    handle to add_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%-- SELECT end POINTS of line segment
h = msgbox('Select successively the 2 end points of the line segment.','Line segment definition','help');
uiwait(h);

[x1,y1] = ginput(1);
x1 = floor(x1); y1 = floor(y1);
h1 = plot(x1,y1,'w+');

[x2,y2] = ginput(1);
x2 = floor(x2); y2 = floor(y2);
h2 = plot(x2,y2,'w+');

%-- FIND pixels along a line (=> degree1) fitting the 2 points defined
degree = 1; %degree=1 => linear fit (coef polynomial order=1 : coef1*x + coef2)
Xpoints = [x1;x2];
Ypoints = [y1;y2];
[xFit,yFit]=get_fitPixels(Xpoints, Ypoints, degree);

%floor to correspond to true pixel value
% xFit_px = single(xFit); %(must be converted to single precision first, else problems if left double)
% yFit_px = single(yFit);
xFit_px = round(xFit);
yFit_px = round(yFit);

%plot pixels (white=true fit, red=pixels to match fit)
h_line = plot(xFit,yFit,'marker','.','color','w');
h_linePx = plot(xFit_px,yFit_px,'marker','.','color','r'); %[0.75,0.75,0.75]);
handles.h_line = h_line;
handles.h_linePx = h_linePx;
uistack([h1,h2],'top')

%store handle of measure point added
if isfield(handles,'hList_ptA'), 
    hList_ptA=handles.hList_ptA; hList_ptB=handles.hList_ptB; 
    htxtList_ptA=handles.htxtList_ptA; htxtList_ptB=handles.htxtList_ptB;
    idx=numel(handles.hList_ptA)+1;
else idx=1;
end
hList_ptA(idx,1) = h1; handles.hList_ptA = hList_ptA;
hList_ptB(idx,1) = h2; handles.hList_ptB = hList_ptB;

%add text to specify no of point
htxt_ptA = text(x1+3,y1-3,[num2str(idx) 'A'],'color','w','verticalAlignment','baseLine','fontsize',7);
htxtList_ptA(idx,1) = htxt_ptA; handles.htxtList_ptA = htxtList_ptA;
htxt_ptB = text(x2+3,y2-3,[num2str(idx) 'B'],'color','w','verticalAlignment','baseLine','fontsize',7);
htxtList_ptB(idx,1) = htxt_ptB; handles.htxtList_ptB = htxtList_ptB;
uistack([htxt_ptA,htxt_ptB],'top')

%SAVE point coordinates of the 2 end-points (table)
if isfield(handles,'table')
    idx=size(handles.table,1)+1;
    table = handles.table; %upload former entries (end-point coord)
    measurePoints_coordXY = handles.measurePoints_coordXY; %upload former entries (all fit-pixel coord)
else idx=1;
end
table{idx,1} = x1;
table{idx,2} = y1;
table{idx,3} = x2;
table{idx,4} = y2;

%find empty cells and insert NaN (else error with cell2mat)
[r,c] = find(cellfun('isempty',table));
if ~isempty(r)
    for i=1:numel(r)
        for j =1:numel(r)
            table{r(i),c(j)} = NaN; %[NaN,NaN];
        end
    end
end

%UPDATE table
handles.table = table;
set(handles.table_measurePtCoord,'data',cell2mat(table))

%SAVE coordinates of ALL points (not only end-points) in measurePoints_coordXY
measurePoints_coordXY{idx,1} = xFit_px;
measurePoints_coordXY{idx,2} = yFit_px;
handles.measurePoints_coordXY = measurePoints_coordXY;

%update handle structure
guidata(hObject,handles);


% --- Executes when entered data in editable cell(s) in table_measurePtCoord.
function table_measurePtCoord_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to table_measurePtCoord (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% Change position of point based on entered value in edited cell
if isfield(handles,'hList_ptA') %change position only if a measure point has been created, with its handle stored in hList_ptA
    
    idxCell = eventdata.Indices;
    
    %define point number to change based on edited cell (line number = measure point number)
    pointNber = idxCell(1);
    
    %define list type (listA=ptA; listB=ptB)
    if idxCell(2)>2, listType='hList_ptB'; listType_txt='htxtList_ptB';
    else listType='hList_ptA'; listType_txt='htxtList_ptA';
    end
    
    %change end-points A (and B if line tool)
    if idxCell(2)==1 || idxCell(2)==3 %cell position = column 1 or 3 => X coordinate changed
        
        %change point position & txt on image
        set(handles.(listType)(pointNber),'xdata',eventdata.NewData);
        txtPos_ini = get(handles.(listType_txt)(pointNber),'position');
        set(handles.(listType_txt)(pointNber),'position',[eventdata.NewData+3, txtPos_ini(2), txtPos_ini(3)]);
        
        %update stored coordinate
        handles.table{idxCell(1),idxCell(2)} = eventdata.NewData;
        
    elseif idxCell(2)==2 || idxCell(2)==4 %cell position = column 2 or 4 => Y coordinate changed
        
        %change point position & txt on image
        set(handles.(listType)(pointNber),'ydata',eventdata.NewData);
        txtPos_ini = get(handles.(listType_txt)(pointNber),'position');
        set(handles.(listType_txt)(pointNber),'position',[txtPos_ini(1), eventdata.NewData-3, txtPos_ini(3)]);
        
        %update stored coordinate
        handles.table{idxCell(1),idxCell(2)} = eventdata.NewData;
    end
    
    %change fit-pixels if line tool
    if strcmp(listType,'hList_ptB') || ~isnan(handles.table{idxCell(1),3})
        %delete former fit-pixels
        delete([handles.h_line, handles.h_linePx])
        
        %get new fit-pixels based, plot & store
        data = get(hObject,'data');
        ptA_xy = data(idxCell(1),1:2);
        ptB_xy = data(idxCell(1),3:4);
        
        degree = 1; %degree=1 => linear fit (coef polynomial order=1 : coef1*x + coef2)
        Xpoints = [ptA_xy(1); ptB_xy(1)];
        Ypoints = [ptA_xy(2); ptB_xy(2)];
        [xFit,yFit]=get_fitPixels(Xpoints, Ypoints, degree);
        
        %floor to correspond to true pixel value
        xFit_px = round(xFit);
        yFit_px = round(yFit);
        
        %plot pixels (white=true fit, red=pixels to match fit)
        h_line = plot(xFit,yFit,'marker','.','color','w');
        h_linePx = plot(xFit_px,yFit_px,'marker','.','color','r'); %[0.75,0.75,0.75]);
        handles.h_line = h_line;
        handles.h_linePx = h_linePx;
        
        %save coordinates of ALL points (not only end-points) in measurePoints_coordXY
        measurePoints_coordXY = handles.measurePoints_coordXY;
        measurePoints_coordXY{idxCell(1),1} = xFit_px;
        measurePoints_coordXY{idxCell(1),2} = yFit_px;
        handles.measurePoints_coordXY = measurePoints_coordXY;
    end
end

%update handle structure
guidata(hObject,handles);


function [xFit,yFit]=get_fitPixels(Xpoints, Ypoints, degree)
%find pixels fitting the given points

%degree=1 => linear fit (coef polynomial order=1 : coef1*x + coef2)

%find polynomial fit and coefficients
[fitCoefs,delta] = polyfit(Xpoints, Ypoints, degree);

% %define whether to fit on x-points or y-points
% x_amplitude = abs(Xpoints(1)-Xpoints(end));
% y_amplitude = abs(Ypoints(1)-Ypoints(end));
% if x_amplitude > y_amplitude, end

%define x-positions of points wanted in fit
xFit = min(Xpoints) : 1 : max(Xpoints);

%find y-position for x-positions defined above
yFit = polyval(fitCoefs, xFit);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMAGE FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function updateImages(handles,imgRaw)
% display image

H = handles.H;

%delete all images & colorbars
h_cb = findobj(gcf,'type','axes','tag','Colorbar');
h_im = findobj(gcf,'type','image');
delete([h_cb; h_im])

%define color map
radiometricData = H.radiometricData;
if radiometricData, cMap = jet;
else cMap = gray;
end

axes(handles.axes_img);
h=imagesc(imgRaw); hold on; uistack(h,'bottom')
axis image; colormap(cMap); colorbar; %('location','southoutside');
grid on


%set axes fontSize
h_ax = findobj('type','axes'); set(h_ax,'fontsize',7)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in resetCoordinates.
function resetCoordinates_Callback(hObject, eventdata, handles)
% hObject    handle to resetCoordinates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%. reset uitable characteristics:
tableDim = cell(1,4);
set(handles.table_measurePtCoord,'data',tableDim)

%-------------------------

%. delete existing fields holding table info in 'handles' structure of (GUI 'define_measureTools.m')
if isfield(handles,'table'), handles = rmfield(handles,'table'); end
if isfield(handles, 'measurePoints_coordXY'), handles = rmfield(handles,'measurePoints_coordXY'); end

%. delete existing field in handles structure of MAIN GUI ('gui_plumeTracker.m')
H = handles.H;
if isfield(H, 'measurePoints_coordXY')
    H = rmfield(H,'measurePoints_coordXY');
    handles.H = H;
end

%-------------------------

%. delete tools drawn in image
delete([handles.hList_ptA,handles.htxtList_ptA])
idx2del=find(~isnan(handles.hList_ptB)); delete(handles.hList_ptB(idx2del));
idx2del=find(~isnan(handles.htxtList_ptB)); delete(handles.htxtList_ptB(idx2del));
if isfield(handles,'h_line'), delete([handles.h_line,handles.h_linePx]); end
    
%. delete handles of tools in image
handles = rmfield(handles,{'hList_ptA';'hList_ptB';'htxtList_ptA';'htxtList_ptB';});
if isfield(handles,'h_line'), handles = rmfield(handles,{'h_line';'h_linePx'}); end

%-------------------------

%update handle structure
guidata(hObject,handles);

% --- Executes on button press in saveCoordinates.
function saveCoordinates_Callback(hObject, eventdata, handles)
% hObject    handle to saveCoordinates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

H = handles.H;

if isfield(handles, 'measurePoints_coordXY') %save if existent
    % implement 'measurePoints_coordXY' in handles structure (H) from gui_plumeTracker
    H.measurePoints_coordXY = handles.measurePoints_coordXY;
    
    %add possibility to plot measure points from list in figMonitor_optnList
    plotList = get(H.figMonitor_optnList,'string');
    if isempty(find(strcmp('measureTools',plotList), 1)) %add only if does not yet exist
        plotList(end+1) = {'measureTools'};
        set(H.figMonitor_optnList,'string',plotList);
        set(H.figMonitor_optnList,'value',numel(plotList));
    end
    
    %add possibility to plot measure point T° from list in plot_XY
    tempList = get(H.listbox_unitsTemp,'string');
    for i=1:size(handles.measurePoints_coordXY,1)
        if isempty(find(strcmp(['temp_measureTool' num2str(i)],tempList), 1)) %add only if does not yet exist
            tempList(end+1) = {['temp_measureTool' num2str(i)]};
        end
    end
    set(H.listbox_unitsTemp,'string',tempList);
    set(H.listbox_unitsTemp,'value',numel(tempList));
    
    %change string of pushbutton
    set(H.set_measureTools,'string',['nb of tools: ' num2str(size(handles.measurePoints_coordXY,1))])
    
    %enable possiblitiy to plot measure tool in output panel
    if get(H.plot_figOutputs,'value')
        set(H.plot_measureTools,'enable','on')
    end
    
else
    %delete possibility to plot measure points from list in figMonitor_optnList
    plotList = get(H.figMonitor_optnList,'string');
    idx=find(strcmp(plotList,'measureTools'));
    if ~isempty(idx)
        plotList(idx) = [];
        set(H.figMonitor_optnList,'string',plotList);
        set(H.figMonitor_optnList,'value',numel(plotList));
    end
    
    %add possibility to plot measure point T° from list in plot_XY
    tempList = get(H.listbox_unitsTemp,'string');
    str2search = 'temp_measureTool';
    [~,~,tokenindices,~,~,~,~] = regexpi(tempList, regexptranslate('wildcard', str2search),'match');
    idx=find(~cellfun('isempty',tokenindices));
    %NB: use of regexpi instead of strfind allows user to use '*' (wildcards) to search in string
    
    if ~isempty(idx)
        tempList(idx) = [];
        set(H.listbox_unitsTemp,'string',tempList);
        set(H.listbox_unitsTemp,'value',numel(tempList));
    end

    %change string of pushbutton
    set(H.set_measureTools,'string','set measure tools')
    
    %disable possiblitiy to plot measure tool in output panel
    if get(H.plot_figOutputs,'value')
        set(H.plot_measureTools,'enable','off')
    end
end

% update handles structure INSIDE gui_plumeTracker
guidata(gui_plumeTracker,H)

% close GUI 'define_measureTools'
h_guiMeasureTools = findobj('name','define_measureTools');
close(h_guiMeasureTools)
