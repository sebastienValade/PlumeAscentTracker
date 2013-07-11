function varargout = plot_plumeProfiles(varargin)
% PLOT_PLUMEPROFILES MATLAB code for plot_plumeProfiles.fig
%      PLOT_PLUMEPROFILES, by itself, creates a new PLOT_PLUMEPROFILES or raises the existing
%      singleton*.
%
%      H = PLOT_PLUMEPROFILES returns the handle to a new PLOT_PLUMEPROFILES or the handle to
%      the existing singleton*.
%
%      PLOT_PLUMEPROFILES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOT_PLUMEPROFILES.M with the given input arguments.
%
%      PLOT_PLUMEPROFILES('Property','Value',...) creates a new PLOT_PLUMEPROFILES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plot_plumeProfiles_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plot_plumeProfiles_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plot_plumeProfiles

% Last Modified by GUIDE v2.5 29-Apr-2013 11:36:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @plot_plumeProfiles_OpeningFcn, ...
    'gui_OutputFcn',  @plot_plumeProfiles_OutputFcn, ...
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


% --- Executes just before plot_plumeProfiles is made visible.
function plot_plumeProfiles_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plot_plumeProfiles (see VARARGIN)

% Choose default command line output for plot_plumeProfiles
handles.output = hObject;


% EDITED

%center gui on screen
movegui(gcf,'center') 

%clear command window
clc

%-- upload handles structure from gui_imgAnalysis
H = varargin{1};
handles.H = H;

%load needed data
prof_axisPxX = H.prof_axisPxX;
prof_axisPxY = H.prof_axisPxY;
prof_axisPxT = H.prof_axisPxT;
prof_pxX = H.prof_pxX;
prof_pxY = H.prof_pxY;
prof_pxT = H.prof_pxT;
prof_distRadial_fromCenter_m = H.prof_distRadial_fromCenter_m;
prof_distAxialCenter_m = H.prof_distAxialCenter_m;
prof_center_pxX = H.prof_center_pxX;
prof_center_pxY = H.prof_center_pxY;
prof_center_pxT = H.prof_center_pxT;
vent_pxX = H.vent_pxX;
vent_pxY = H.vent_pxY;
vent_idx = H.vent_idx;

prof_idxLplume_Tthresh = H.prof_idxLplume_Tthresh;
prof_idxRplume_Tthresh = H.prof_idxRplume_Tthresh;
plume_radMean_Tthresh = H.radiusMean_Tthresh;

prof_idxLplume_Tgauss = H.prof_idxLplume_Tgauss;
prof_idxRplume_Tgauss = H.prof_idxRplume_Tgauss;
plume_radMean_Tgauss = H.radiusMean_Tgauss;

nbProfiles = numel(prof_axisPxX);
%create matrices to reference profiles: profileRef_idxMatrix (line1=topmost profile), profileRef_nb (nb1=bottom most profile)
profileRef_idxMatrix = (1:1:nbProfiles)';
profileRef_nb = flipud(profileRef_idxMatrix);
handles.profileRef_nb = profileRef_nb;


%% 3D plot
set(gcf,'currentAxes',handles.axes_3D)
% set(handles.axes_3D,'color',[0.75,0.75,0.75])
for i=nbProfiles:-1:1 %from top to bottom
    hold on
    plot3(prof_axisPxX{i},prof_axisPxY{i},prof_axisPxT{i},'displayName','radial line','color',[0,0.8,1]);%['axial line nb ' num2str(profileRef_nb(i))]);
    plot3(prof_pxX{i},prof_pxY{i},prof_pxT{i},'g.','displayName','radial profile');%['axial profile nb ' num2str(profileRef_nb(i))]);
    
    %plume from fixed temperature threshold
    plot3(prof_pxX{i}(prof_idxLplume_Tthresh(i):prof_idxRplume_Tthresh(i)),prof_pxY{i}(prof_idxLplume_Tthresh(i):prof_idxRplume_Tthresh(i)),prof_pxT{i}(prof_idxLplume_Tthresh(i):prof_idxRplume_Tthresh(i)),'y.','displayName','plume (from T_{thresh})');
    
    %plume edges from fixed temperature threshold
    plot3(prof_pxX{i}(prof_idxLplume_Tthresh(i)),prof_pxY{i}(prof_idxLplume_Tthresh(i)),prof_pxT{i}(prof_idxLplume_Tthresh(i)),'kx','displayName','plume edge (from T_{thresh})')
    plot3(prof_pxX{i}(prof_idxRplume_Tthresh(i)),prof_pxY{i}(prof_idxRplume_Tthresh(i)),prof_pxT{i}(prof_idxRplume_Tthresh(i)),'kx','displayName','plume edge (from T_{thresh})')
    
    %plume edges from temperature threshold gaussian
    plot3(prof_pxX{i}(prof_idxLplume_Tgauss(i)),prof_pxY{i}(prof_idxLplume_Tgauss(i)),prof_pxT{i}(prof_idxLplume_Tgauss(i)),'bx','displayName','plume edge (from T_{gaussian})')
    plot3(prof_pxX{i}(prof_idxRplume_Tgauss(i)),prof_pxY{i}(prof_idxRplume_Tgauss(i)),prof_pxT{i}(prof_idxRplume_Tgauss(i)),'bx','displayName','plume edge (from T_{gaussian})')
    
end
set(gca,'ydir','reverse')
view(-45,45); axis tight

%current radial profile on 3D plot
profNb = str2double(get(handles.profileNb_txt,'String'));
profNb_idxRef = profileRef_nb(profNb);
set(handles.profileNb_slider,'value',profNb);
plot3(prof_pxX{profNb_idxRef},prof_pxY{profNb_idxRef},prof_pxT{profNb_idxRef},'-r.','displayName','radial profile selected');

%axial profile on 3D plot
plot3(prof_center_pxX,prof_center_pxY,prof_center_pxT,'m.','displayName','axial profile');

%vent position
plot3([vent_pxX;vent_pxX],[vent_pxY;vent_pxY],[0;prof_center_pxT(vent_idx)],'-co','displayName','vent position');

%TOP view of 3D plot
set(gcf,'currentAxes',handles.axes_3D_topView)
h_obj = findobj(handles.axes_3D,'-not','type','axes');
copyobj(h_obj,gca)
set(gca,'ydir','reverse','xticklabel',[],'yticklabel',[]); axis tight; box('on'); 
w = get(gca,'position');

%add legend
h_radLine = findobj(handles.axes_3D_topView,'displayName','radial line');
h_radProf = findobj(handles.axes_3D_topView,'displayName','radial profile');
h_radProfSel = findobj(handles.axes_3D_topView,'displayName','radial profile selected');
h_axProf = findobj(handles.axes_3D_topView,'displayName','axial profile');
h_vent = findobj(handles.axes_3D_topView,'displayName','vent position');
h_plumePx = findobj(handles.axes_3D_topView,'displayName','plume (from T_{thresh})');
h_edgeT1 = findobj(handles.axes_3D_topView,'displayName','plume edge (from T_{thresh})');
h_edgeT2 = findobj(handles.axes_3D_topView,'displayName','plume edge (from T_{gaussian})');
leg_h = [h_radLine(1); h_radProfSel; h_radProf(1); h_axProf; h_plumePx(1); h_edgeT1(1); h_edgeT2(1); h_vent];
leg_txt = get(leg_h,'displayName');
legend(leg_h,leg_txt,'location','EastOutside'); legend('boxoff');

set(gca,'position',w)


%% RADIAL profile
set(gcf,'currentAxes',handles.axes_radialProfile)

plot(prof_distRadial_fromCenter_m{profNb_idxRef},prof_pxT{profNb_idxRef},'-r.','displayName','radial profile selected')
hold on

xMin = floor(min(cellfun(@min,prof_distRadial_fromCenter_m))); %floor(min(prof_distRadial_fromCenter_m{profNb_idxRef}));
xMax = ceil(max(cellfun(@max,prof_distRadial_fromCenter_m))); %ceil(max(prof_distRadial_fromCenter_m{profNb_idxRef}));
yMin = min(cell2mat(prof_pxT));
yMax = max(cell2mat(prof_pxT));
set(handles.axes_radialProfile,'xlim',[xMin,xMax],'ylim',[yMin,yMax]);
xlabel('radial distance from center axis [m]'), ylabel('temperature [°C]')

%.plume center line
plot([0,0],[yMin,yMax],'k:');

%.plume fixed temperature threshold line
plumeTemp_threshVal = H.plumeTemp_threshVal;
plot([xMin,xMax],[plumeTemp_threshVal,plumeTemp_threshVal],'k:');
text(xMax,plumeTemp_threshVal,['T_{thresh}=' num2str(plumeTemp_threshVal) '  '],'horizontalAlignment','right','verticalAlignment','baseLine','fontSize',8)
%.plume pixels fixed temperature threshold on radial profile
plume_radR = prof_distRadial_fromCenter_m{profNb_idxRef}(prof_idxLplume_Tthresh(profNb_idxRef):prof_idxRplume_Tthresh(profNb_idxRef));
plume_radT = prof_pxT{profNb_idxRef}(prof_idxLplume_Tthresh(profNb_idxRef):prof_idxRplume_Tthresh(profNb_idxRef));
plot(plume_radR,plume_radT,'-y.','MarkerEdgeColor','r','displayName','plume (from T_{thresh})');
%.plume radius from fixed temperature threshold
plot([min(plume_radR),max(plume_radR)],[plumeTemp_threshVal,plumeTemp_threshVal],'-k','displayName','mean radius (from T_{thresh})');

%.plume temperature threshold at 1 sigma
plumeTemp_threshGaussian = H.plumeTemp_threshGaussian;
plot([xMin,xMax],[plumeTemp_threshGaussian(profNb_idxRef),plumeTemp_threshGaussian(profNb_idxRef)],'b:','displayName','threshTemp_gauss');
text(xMax,plumeTemp_threshGaussian(profNb_idxRef),['  T_{gaussian}=' num2str(plumeTemp_threshGaussian(profNb_idxRef),'%.1f')],'horizontalAlignment','left','verticalAlignment','baseLine','fontSize',8,'color','b','displayName','threshTemp_gauss_txt')
%.plume pixels fixed temperature threshold on radial profile
plume_radR_gauss = prof_distRadial_fromCenter_m{profNb_idxRef}(prof_idxLplume_Tgauss(profNb_idxRef):prof_idxRplume_Tgauss(profNb_idxRef));
%.plume radius from fixed temperature threshold
plot([min(plume_radR_gauss),max(plume_radR_gauss)],[plumeTemp_threshGaussian(profNb_idxRef),plumeTemp_threshGaussian(profNb_idxRef)],'-b','displayName','mean radius (from T_{gaussian})');

%add legend
h_radProfSel = findobj(handles.axes_radialProfile,'displayName','radial profile selected');
h_plumePx = findobj(handles.axes_radialProfile,'displayName','plume (from T_{thresh})');
h_radius = findobj(handles.axes_radialProfile,'-regexp','displayName','mean radius*');
leg_h = h_radius; %leg_h = [h_radProfSel; h_plumePx; h_radius];
leg_txt = get(leg_h,'displayName');
legend(leg_h,leg_txt,'location','northwest'); legend('boxoff');


%% AXIAL profile - temperature
set(gcf,'currentAxes',handles.axes_axialProfileT)
plot(prof_distAxialCenter_m,prof_center_pxT,'-m.','displayName','temperature on axial profile'), hold on
xlabel('axial distance from vent [m]'); ylabel('temperature [°C]')
axis tight

%.vent position
plot([0,0],get(gca,'ylim'),'-c','lineWidth',3,'displayName','vent position');
%.profile cursor
xCursor = prof_distAxialCenter_m(profNb_idxRef);
yCursor = get(gca,'yLim');
plot([xCursor,xCursor],[0,yCursor(2)],'k:','displayName','profileCursor');

%add legend
h_axProf = findobj(handles.axes_axialProfileT,'displayName','temperature on axial profile');
leg_txt = get(h_axProf,'displayName');
legend(h_axProf,leg_txt,'location','northeast'); legend('boxoff');


%% AXIAL profile - radius
set(gcf,'currentAxes',handles.axes_axialProfileR)

%mean radius from fixed temperature thresh
plot(prof_distAxialCenter_m,plume_radMean_Tthresh,'-k.','displayName','mean radius (from T_{thresh})'); hold on

%mean radius from gaussian temperature threshold
plot(prof_distAxialCenter_m,plume_radMean_Tgauss,'-b.','displayName','mean radius (from T_{gaussian})'); hold on
xlabel('axial distance from vent [m]'); ylabel('mean plume radius')
axis tight

%.profile cursor
yCursor = get(gca,'yLim');
plot([xCursor,xCursor],[0,yCursor(2)],'k:','displayName','profileCursor');

h = findobj(handles.axes_axialProfileR,'-regexp','displayName','mean radius*');
leg_txt = get(h,'displayName');
legend(h,leg_txt,'location','southeast'); legend('boxoff');



%% stacked RADIAL profiles
set(gcf,'currentAxes',handles.axes_radialProfile_stacked)
for i=1:nbProfiles
    zFactor(i,1) = prof_distAxialCenter_m(i);
    plot(prof_distRadial_fromCenter_m{i},prof_pxT{i}+zFactor(i),'-g')
    
    %plume edges from fixed temperature threshold
    plot(prof_distRadial_fromCenter_m{i}(prof_idxLplume_Tthresh(i)),prof_pxT{i}(prof_idxLplume_Tthresh(i))+zFactor(i),'kx','displayName','edge_Tthresh_L')
    plot(prof_distRadial_fromCenter_m{i}(prof_idxRplume_Tthresh(i)),prof_pxT{i}(prof_idxRplume_Tthresh(i))+zFactor(i),'kx','displayName','edge_Tthresh_R')
    
    %plume edges from temperature threshold gaussian
    plot(prof_distRadial_fromCenter_m{i}(prof_idxLplume_Tgauss(i)),prof_pxT{i}(prof_idxLplume_Tgauss(i))+zFactor(i),'bx','displayName','edge_Tgauss_L')
    plot(prof_distRadial_fromCenter_m{i}(prof_idxRplume_Tgauss(i)),prof_pxT{i}(prof_idxRplume_Tgauss(i))+zFactor(i),'bx','displayName','edge_Tgauss_R')
    
    hold on
end

%%CODE to plot profiles with both temperature shift and no temperature shift
%use check box to visualize one or the other (handles.zFactor_tempShift)    
% nbProf_px = numel(prof_distRadial_fromCenter_m{1});
% for i=1:nbProfiles
%     
%     %---profiles WITH zFactor
%     zFactor(i,1) = prof_distAxialCenter_m(i);
%     plot(prof_distRadial_fromCenter_m{i},prof_pxT{i}+zFactor(i),'-g','displayName','profT_zFactor')
%     
%     %plume edges from fixed temperature threshold
%     plot(prof_distRadial_fromCenter_m{i}(prof_idxLplume_Tthresh(i)),prof_pxT{i}(prof_idxLplume_Tthresh(i))+zFactor(i),'kx','displayName','edgeL_Tthresh_zFactor')
%     plot(prof_distRadial_fromCenter_m{i}(prof_idxRplume_Tthresh(i)),prof_pxT{i}(prof_idxRplume_Tthresh(i))+zFactor(i),'kx','displayName','edgeR_Tthresh_zFactor')
%     
%     %plume edges from temperature threshold gaussian
%     plot(prof_distRadial_fromCenter_m{i}(prof_idxLplume_Tgauss(i)),prof_pxT{i}(prof_idxLplume_Tgauss(i))+zFactor(i),'bx','displayName','edgeL_Tgauss_zFactor')
%     plot(prof_distRadial_fromCenter_m{i}(prof_idxRplume_Tgauss(i)),prof_pxT{i}(prof_idxRplume_Tgauss(i))+zFactor(i),'bx','displayName','edgeR_Tgauss_zFactor')
%     
%     %---profiles WITHOUT zFactor
%     plot(prof_distRadial_fromCenter_m{i},repmat(prof_distAxialCenter_m(i),1,nbProf_px),'-g','displayName','profT','visible','off')
%     
%     %plume edges from fixed temperature threshold
%     plot(prof_distRadial_fromCenter_m{i}(prof_idxLplume_Tthresh(i)),prof_distAxialCenter_m(i),'kx','displayName','edgeL_Tthresh','visible','off')
%     plot(prof_distRadial_fromCenter_m{i}(prof_idxRplume_Tthresh(i)),prof_distAxialCenter_m(i),'kx','displayName','edgeR_Tthresh','visible','off')
%     
%     %plume edges from temperature threshold gaussian
%     plot(prof_distRadial_fromCenter_m{i}(prof_idxLplume_Tgauss(i)),prof_distAxialCenter_m(i),'bx','displayName','edgeL_Tgauss','visible','off')
%     plot(prof_distRadial_fromCenter_m{i}(prof_idxRplume_Tgauss(i)),prof_distAxialCenter_m(i),'bx','displayName','edgeR_Tgauss','visible','off')
%     
%     hold on
% end
plot(prof_distRadial_fromCenter_m{profNb_idxRef},prof_pxT{profNb_idxRef}+zFactor(profNb_idxRef,1),'-r.','displayName','radial profile selected')
set(handles.axes_radialProfile_stacked,'xlim',[xMin,xMax],'ylim',[yMin,max(prof_pxT{1})+zFactor(1)]);
%axis tight
xlabel('radial distance from center axis [m]'); ylabel('axial distance from vent [m]')
%.temperature scale
w=get(gca,'xlim'); xPos = w(2)-0.1*w(2);
line([xPos,xPos],[0,100],'color','k');
text(xPos,50,'T = 100 °C','Rotation',90,'horizontalAlignment','center','verticalAlignment','bottom','fontSize',8)
%.plume center line
w = get(gca,'ylim');
plot([0,0],[w(1),w(2)],'k:');

%%
%set fontsize
h_ax = findobj('type','axes'); set(h_ax,'fontsize',7)

handles.zFactor = zFactor;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plot_plumeProfiles wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plot_plumeProfiles_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function profileNb_txt_Callback(hObject, eventdata, handles)
% hObject    handle to profileNb_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of profileNb_txt as text
%        str2double(get(hObject,'String')) returns contents of profileNb_txt as a double

%load needed data
profNb = str2double(get(handles.profileNb_txt,'String'));
profNb_idxRef = handles.profileRef_nb(profNb);
plumeTemp_threshVal = handles.H.plumeTemp_threshVal;
prof_pxX = handles.H.prof_pxX;
prof_pxY = handles.H.prof_pxY;
prof_pxT = handles.H.prof_pxT;
prof_distRadial_fromCenter_m = handles.H.prof_distRadial_fromCenter_m;
prof_distAxialCenter_m = handles.H.prof_distAxialCenter_m;
prof_center_pxT = handles.H.prof_center_pxT;
prof_idxLplume_Tthresh = handles.H.prof_idxLplume_Tthresh;
prof_idxRplume_Tthresh = handles.H.prof_idxRplume_Tthresh;
prof_idxLplume_Tgauss = handles.H.prof_idxLplume_Tgauss;
prof_idxRplume_Tgauss = handles.H.prof_idxRplume_Tgauss;
plumeTemp_threshGaussian = handles.H.plumeTemp_threshGaussian;

%--- 3D plot
h = findobj(handles.axes_3D,'displayName','radial profile selected');
set(h,'xdata',prof_pxX{profNb_idxRef},'ydata',prof_pxY{profNb_idxRef},'zdata',prof_pxT{profNb_idxRef});

%--- 3D plot top view
h = findobj(handles.axes_3D_topView,'displayName','radial profile selected');
set(h,'xdata',prof_pxX{profNb_idxRef},'ydata',prof_pxY{profNb_idxRef},'zdata',prof_pxT{profNb_idxRef});

%--- RADIAL plot
h = findobj(handles.axes_radialProfile,'displayName','radial profile selected');
set(h,'xdata',prof_distRadial_fromCenter_m{profNb_idxRef},'ydata',prof_pxT{profNb_idxRef});

h = findobj(handles.axes_radialProfile,'displayName','threshTemp_gauss');
set(h,'ydata',[plumeTemp_threshGaussian(profNb_idxRef),plumeTemp_threshGaussian(profNb_idxRef)]);
h = findobj(handles.axes_radialProfile,'displayName','threshTemp_gauss_txt'); 
set(h,'string',['  T_{gaussian}=' num2str(plumeTemp_threshGaussian(profNb_idxRef),'%.1f')]);
%NB: changing the text position causes the program to lag. "Drawnow" command at the end of the code slightly improves it.
w = get(h,'position');
% diff_pct = 100*diff([w(2),plumeTemp_threshGaussian(profNb_idxRef)])/w(2);
% if abs(diff_pct)>20, set(h,'position',[w(1),plumeTemp_threshGaussian(profNb_idxRef),0]); end
set(h,'position',[w(1),plumeTemp_threshGaussian(profNb_idxRef),0]);

%.plume pixels on radial profile 
h = findobj(handles.axes_radialProfile,'displayName','plume (from T_{thresh})');
plume_radR = prof_distRadial_fromCenter_m{profNb_idxRef}(prof_idxLplume_Tthresh(profNb_idxRef):prof_idxRplume_Tthresh(profNb_idxRef));
plume_radT = prof_pxT{profNb_idxRef}(prof_idxLplume_Tthresh(profNb_idxRef):prof_idxRplume_Tthresh(profNb_idxRef));
set(h,'xdata',plume_radR,'ydata',plume_radT);

%.plume radius
h = findobj(handles.axes_radialProfile,'displayName','mean radius (from T_{thresh})');
set(h,'xdata',[min(plume_radR),max(plume_radR)],'ydata',[plumeTemp_threshVal,plumeTemp_threshVal]);

h = findobj(handles.axes_radialProfile,'displayName','mean radius (from T_{gaussian})');
plume_radR_gauss = prof_distRadial_fromCenter_m{profNb_idxRef}(prof_idxLplume_Tgauss(profNb_idxRef):prof_idxRplume_Tgauss(profNb_idxRef));
set(h,'xdata',[min(plume_radR_gauss),max(plume_radR_gauss)],'ydata',[plumeTemp_threshGaussian(profNb_idxRef),plumeTemp_threshGaussian(profNb_idxRef)]);

%--- AXIAL plot - temperature
h = findobj(handles.axes_axialProfileT,'displayName','profileCursor');
xCursor = prof_distAxialCenter_m(profNb_idxRef);
set(h,'xdata',[xCursor,xCursor]);


%--- AXIAL plot - radius
h = findobj(handles.axes_axialProfileR,'displayName','profileCursor');
xCursor = prof_distAxialCenter_m(profNb_idxRef);
set(h,'xdata',[xCursor,xCursor]);

%--- stacked RADIAL profile
h = findobj(handles.axes_radialProfile_stacked,'displayName','radial profile selected');
zFactor = prof_distAxialCenter_m(profNb_idxRef);
set(h,'xdata',prof_distRadial_fromCenter_m{profNb_idxRef},'ydata',prof_pxT{profNb_idxRef}+zFactor);

drawnow

% --- Executes during object creation, after setting all properties.
function profileNb_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to profileNb_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function profileNb_slider_Callback(hObject, eventdata, handles)
% hObject    handle to profileNb_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% %redefine slider properties
% sliderAmplitude = get(handles.profileNb_slider,'max') - get(handles.profileNb_slider,'min') +1; %to to 100 since amplitude 1-100=99
% set(handles.profileNb_slider,'sliderStep',[0.0001*sliderAmplitude, 0.001*sliderAmplitude])

sliderVal = get(hObject,'Value');
sliderVal_new = round(sliderVal);

set(hObject,'Value',sliderVal_new)

%.change value in text box
set(handles.profileNb_txt,'string',sliderVal_new)

%.update plots
profileNb_txt_Callback(handles.profileNb_txt, [], handles)

% --- Executes during object creation, after setting all properties.
function profileNb_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to profileNb_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in profileExport.
function profileExport_Callback(hObject, eventdata, handles)
% hObject    handle to profileExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get export format
formatTxt = get(handles.exportFormat_txt,'Value');
formatMat = get(handles.exportFormat_mat,'Value');

%get profile(s) to export
listContent = cellstr(get(handles.exportProf_list,'String'));
selection_idx = get(handles.exportProf_list,'Value');

%load needed data
profNb = str2double(get(handles.profileNb_txt,'String'));
profNb_idxRef = handles.profileRef_nb(profNb);
prof_pxT = handles.H.prof_pxT;
prof_distRadial_fromCenter_m = handles.H.prof_distRadial_fromCenter_m;
prof_distAxialCenter_m = handles.H.prof_distAxialCenter_m;
prof_center_pxT = handles.H.prof_center_pxT;
plume_radMean_Tthresh = handles.H.radiusMean_Tthresh;
plume_radMean_Tgauss = handles.H.radiusMean_Tgauss;
path2folder_outputs = handles.H.path2folder_outputs; 

for i=1 : numel(selection_idx)
    
    idx = selection_idx(i); %index in the selected optns to plot
    
    %define variable to export
    switch listContent{idx}
        case {'profiles 2D', 'profiles 3D', 'radial profiles (stacked)'}
            listChoice = strrep(listContent{idx},' ','');
            fileName = [listChoice '_radialT'];
            nbProfiles = numel(prof_pxT);
            
            %check if profiles length constant
            profLength = unique(cellfun(@numel,prof_pxT));
            
            if numel(profLength)==1
                %=> constant profile length (length = fixed distance threshold):
                %     column 1 = prof_distRadial_fromCenter_m
                %     column 2:end = prof_pxT
                
                %define header names
                headerNames_0 = repmat({'profileT'},[1,nbProfiles+1]);
                headerNames = genvarname(headerNames_0);
                headerNames{1} = 'radius [m]';
                
                %define matrix
                %!!prof_distRadial_fromCenter_m may not be constant !!
                col1=prof_distRadial_fromCenter_m{profNb_idxRef};
                prof_pxT_horiz = cellfun(@rot90,prof_pxT,'uniformOutput',0);
                M = [col1; prof_pxT_horiz];
                M_txt = cell2mat(M);
                
            else
                %=> constant profile length (length = linked to temperature threshold)
                %     column 1 = profile 1 distance
                %     column 2 = profile 1 temperature
                %     etc...
                
                %define header names
                headerNames_D = repmat({'profileD_'},[1,nbProfiles+1]);
                headerNames_D = genvarname(headerNames_D);
                headerNames_T = repmat({'profileT_'},[1,nbProfiles+1]);
                headerNames_T = genvarname(headerNames_T);
                headerNames = [headerNames_D(2:end),headerNames_T(2:end)];
                
                %define matrix
                %!!prof_distRadial_fromCenter_m may not be constant !!
                colD = prof_distRadial_fromCenter_m;
                colT = cellfun(@rot90,prof_pxT,'uniformOutput',0);
                M = [colD; colT];
                %fill with NaN to have rectagular matrix (needed for cell2mat operation)
                maxLength = max(profLength);
                M_nan = NaN(nbProfiles*2,maxLength);
                M_nanC = mat2cell(M_nan,ones(nbProfiles*2,1),maxLength);
                M_rect = M_nanC;
                for j=1:nbProfiles*2
                    idxLast = numel(M{j,1});
                    M_rect{j,1}(1:idxLast) = M{j,1};
                end
                M_txt = cell2mat(M_rect);
                
            end
            
            %.write to matlab file
            if formatMat
                save([path2folder_outputs fileName], 'prof_distRadial_fromCenter_m', 'prof_pxT')
            end
            
            
        case 'radial profile (temperature)'
            fileName = ['radialProfile_nb' num2str(profNb)];
            
            headerNames={'radius [m]','temperature [°C]'};
            colA=prof_distRadial_fromCenter_m{profNb_idxRef};
            colB=prof_pxT{profNb_idxRef};
            M_txt = [colA; colB']; %!! to have vertical vectors in txt file, vectors in the matrix M have to be horizontal !!
            
            %.write to matlab file
            if formatMat
                prof_distRadial_m = prof_distRadial_fromCenter_m{profNb_idxRef}';
                prof_pxT_C = prof_pxT{profNb_idxRef};
                save([path2folder_outputs fileName], 'prof_distRadial_m', 'prof_pxT_C')
            end
            
        case 'axial profile (temperature)'
            fileName = 'axialProfileT';
            
            headerNames={'axial distance [m]','temperature [°C]'};
            colA=prof_distAxialCenter_m;
            colB=prof_center_pxT;
            M_txt = [colA'; colB']; %!! to have vertical vectors in txt file, vectors in the matrix M have to be horizontal !!
            
            %.write to matlab file
            if formatMat
                save([path2folder_outputs fileName], 'profTemp_distAxialCenter_m', 'prof_center_pxT')
            end
            
        case 'axial profile (radius)'
            fileName = 'axialProfileR';
            
            headerNames={'axial distance [m]','mean radius (Tthresh) [m]','mean radius (Tgaussian) [m]'};
            colA=prof_distAxialCenter_m;
            colB=plume_radMean_Tthresh;
            colC=plume_radMean_Tgauss;

            M_txt = [colA'; colB'; colC']; %!! to have vertical vectors in txt file, vectors in the matrix M have to be horizontal !!
            
            %.write to matlab file
            if formatMat
                save([path2folder_outputs fileName], 'prof_distAxialCenter_m', 'plume_radMean_Tthresh', 'plume_radMean_Tgauss')
            end
          
        otherwise
            warning('Unexpected plot type.');
    end
    
    %. write txt file
    if formatTxt && exist('M_txt','var')
        write_txtFile(M_txt,headerNames,[path2folder_outputs fileName '.txt'])
        %save(fileName,'radius_m', '-ascii', '-tabs')
    end
    
end


% --- Executes on selection change in exportProf_list.
function exportProf_list_Callback(hObject, eventdata, handles)
% hObject    handle to exportProf_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns exportProf_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from exportProf_list

%Enable mutliple selection:
% NB: "To enable multiple selection in a list box, you must set the Min and Max properties so that Max - Min > 1. You must change the default Min and Max values of 0 and 1 to meet these conditions. Use the Property Inspector to set these properties on the list box."
set(hObject,'max',2);


% --- Executes during object creation, after setting all properties.
function exportProf_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exportProf_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exportFormat_mat.
function exportFormat_mat_Callback(hObject, eventdata, handles)
% hObject    handle to exportFormat_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of exportFormat_mat


% --- Executes on button press in exportFormat_txt.
function exportFormat_txt_Callback(hObject, eventdata, handles)
% hObject    handle to exportFormat_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of exportFormat_txt


% --- Executes on button press in figFormat_fig.
function figFormat_fig_Callback(hObject, eventdata, handles)
% hObject    handle to figFormat_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of figFormat_fig


% --- Executes on button press in figFormat_jpg.
function figFormat_jpg_Callback(hObject, eventdata, handles)
% hObject    handle to figFormat_jpg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of figFormat_jpg


% --- Executes on button press in profileSave.
function profileSave_Callback(hObject, eventdata, handles)
% hObject    handle to profileSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get profile(s) to export
listContent = cellstr(get(handles.exportProf_list,'String'));
selection_idx = get(handles.exportProf_list,'Value');

%load needed data
profNb = str2double(get(handles.profileNb_txt,'String'));
formatFig = get(handles.figFormat_fig,'Value');
formatJpg = get(handles.figFormat_jpg,'Value');
figFormat = {};
if formatFig, figFormat{numel(figFormat)+1}='fig'; end
if formatJpg, figFormat{numel(figFormat)+1}='jpg'; end

figure
for i=1 : numel(selection_idx)
    
    idx = selection_idx(i); %index in the selected optns to plot

    subplot(1,numel(selection_idx),i)
    
    %define variable to export
    switch listContent{idx}
        case 'profiles 2D'
            fileName{i} = 'prof2D';
            h_axes = handles.axes_3D_topView;
            
        case 'profiles 3D'
            fileName{i} = 'prof3D';
            h_axes = handles.axes_3D;
        
        case 'radial profile (temperature)'
            fileName{i} = ['profRad' num2str(profNb)];
            h_axes = handles.axes_radialProfile;

        case 'axial profile (temperature)'
            fileName{i} = 'profAxT';
            h_axes = handles.axes_axialProfileT;
            
        case 'axial profile (radius)'
            fileName{i} = 'profAxR';
            h_axes = handles.axes_axialProfileR;
            
        case 'radial profiles (stacked)'
            fileName{i} = 'profRadStack';
            h_axes = handles.axes_radialProfile_stacked;
    end
    
    
    %copy axes onto new figure
    h_obj = findobj(h_axes,'-not','type','axes'); %image','-not','type'
    copyobj(h_obj,gca);
    
    xlim(get(h_axes,'xlim'))
    ylim(get(h_axes,'ylim'))
    xlabel(get(get(h_axes,'xlabel'),'string'))
    ylabel(get(get(h_axes,'ylabel'),'string'))
    title(get(get(h_axes,'title'),'string'))
    if h_axes==handles.axes_radialProfile, title([get(get(h_axes,'title'),'string') ' nb ' num2str(profNb)]), end
    view(get(h_axes,'view'))
    set(gca,'ydir',get(h_axes,'ydir'))
    axis square

end

%set axes fontSize
h_ax = findobj('type','axes'); set(h_ax,'fontsize',7)

%save figure
maximize_figure
if ~isempty(figFormat)
    figName = cell2mat(cellfun(@(x) [x '-'],fileName,'UniformOutput',false));
    pathNfile = [handles.H.path2folder_outputs figName(1:end-1)];
    save_sv(pathNfile, figFormat)
end


function fitEquation_Callback(hObject, eventdata, handles)
% hObject    handle to fitEquation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fitEquation as text
%        str2double(get(hObject,'String')) returns contents of fitEquation as a double


% --- Executes during object creation, after setting all properties.
function fitEquation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fitEquation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function apertureAngle_Callback(hObject, eventdata, handles)
% hObject    handle to apertureAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of apertureAngle as text
%        str2double(get(hObject,'String')) returns contents of apertureAngle as a double


% --- Executes during object creation, after setting all properties.
function apertureAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to apertureAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function entrainmentCoef_Callback(hObject, eventdata, handles)
% hObject    handle to entrainmentCoef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of entrainmentCoef as text
%        str2double(get(hObject,'String')) returns contents of entrainmentCoef as a double


% --- Executes during object creation, after setting all properties.
function entrainmentCoef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to entrainmentCoef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fitEdge_chbox.
function fitEdge_chbox_Callback(hObject, eventdata, handles)
% hObject    handle to fitEdge_chbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fitEdge_chbox

fitEdge_chbox = get(hObject,'Value');

if fitEdge_chbox
    h = findobj(handles.fitEdge_panel,'-not','type','uipanel');
    set(h,'enable','on')
    
    %reset color of any previously highlighted edge
    resetColor_edge2fit(handles)
    
    %delete any existant fit
    h = findobj(handles.axes_radialProfile_stacked,'displayName','edgeFit');
    delete(h);
    
    %highlight chosen edge to fit
    selEdge = get(get(handles.edge2fit_panel,'SelectedObject'),'string');
    selEdgeSide = get(get(handles.edgeSide2fit_panel,'SelectedObject'),'string');
    
    switch selEdge
        case 'T = fixed'
            if strcmp(selEdgeSide,'left edge')
                h = findobj(handles.axes_radialProfile_stacked,'displayName','edge_Tthresh_L');
            elseif strcmp(selEdgeSide,'right edge')
                h = findobj(handles.axes_radialProfile_stacked,'displayName','edge_Tthresh_R');
            end
        case 'T = gaussian'
            if strcmp(selEdgeSide,'left edge')
                h = findobj(handles.axes_radialProfile_stacked,'displayName','edge_Tgauss_L');
            elseif strcmp(selEdgeSide,'right edge')
                h = findobj(handles.axes_radialProfile_stacked,'displayName','edge_Tgauss_R');
            end
    end
    
    set(h,'color','m')
    set(h,'tag','selected_forFit')
    
else
    h = findobj(handles.entrainmentCoef_panel,'-not','type','uipanel','-not','tag','fitEdge_chbox');
    set(h,'enable','off')
         
    %reset color of any previously highlighted edge
    resetColor_edge2fit(handles)
    
    %delete any existant fit
    h = findobj(handles.axes_radialProfile_stacked,'displayName','edgeFit');
    delete(h);
end

function resetColor_edge2fit(handles)
%reset color of any previously highlighted edge
h = findobj(handles.axes_radialProfile_stacked,'tag','selected_forFit');
if ~isempty(h)
    edgeTagged_dispName = get(h(1),'displayName');
    edgeTagged_sister = findobj(handles.axes_radialProfile_stacked,'-regexp','displayName',[edgeTagged_dispName(1:end-1) '*'],'-not','displayName',edgeTagged_dispName);
    resetColor = get(edgeTagged_sister,'color');
    
    set(h,'color',resetColor{1});
    set(h,'tag','')
end

% --- Executes when selected object is changed in edge2fit_panel.
function edge2fit_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in edge2fit_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

fitEdge_chbox_Callback(handles.fitEdge_chbox, eventdata, handles)

% --- Executes when selected object is changed in edgeSide2fit_panel.
function edgeSide2fit_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in edgeSide2fit_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

fitEdge_chbox_Callback(handles.fitEdge_chbox, eventdata, handles)

% --- Executes on button press in fitEdge.
function fitEdge_Callback(hObject, eventdata, handles)
% hObject    handle to fitEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%delete any existant fit
h = findobj(handles.axes_radialProfile_stacked,'displayName','edgeFit');
delete(h);

%get needed data
prof_distRadial_fromCenter_m = handles.H.prof_distRadial_fromCenter_m;
prof_distAxialCenter_m = handles.H.prof_distAxialCenter_m;
nbProfiles = numel(prof_distRadial_fromCenter_m);
prof_idxLplume_Tthresh = handles.H.prof_idxLplume_Tthresh;
prof_idxRplume_Tthresh = handles.H.prof_idxRplume_Tthresh;
prof_idxLplume_Tgauss = handles.H.prof_idxLplume_Tgauss;
prof_idxRplume_Tgauss = handles.H.prof_idxRplume_Tgauss;


%% FIT with data from figure (y = axial dist + temperature) => graphic purposes only

%get data of edge to fit
h = findobj(handles.axes_radialProfile_stacked,'tag','selected_forFit');
x = cell2mat(get(h,'xdata'));
y = cell2mat(get(h,'ydata')); %ydata = distAxialCenter + temperature

%find y>0
idx_aboveVent = find(y>0);

%fit
polyfitDegree = 1;
dat2fit_pxX = x(idx_aboveVent);
dat2fit_pxY = y(idx_aboveVent);
[xFit,yFit,fitCoefs,delta] = fit_data(dat2fit_pxX,dat2fit_pxY,polyfitDegree);

%plot fit
plot(handles.axes_radialProfile_stacked,xFit,yFit,'m-','displayName','edgeFit');


%% TEST: plot stacked profiles without Temperature data
plot_stackedProf_noTempShif = 0;

if plot_stackedProf_noTempShif
    figure;
    nbProf_px = numel(prof_distRadial_fromCenter_m{1});
    for i=1:nbProfiles
        plot(prof_distRadial_fromCenter_m{i},repmat(prof_distAxialCenter_m(i),1,nbProf_px),'-g')
        
        %plume edges from fixed temperature threshold
        plot(prof_distRadial_fromCenter_m{i}(prof_idxLplume_Tthresh(i)),prof_distAxialCenter_m(i),'kx','displayName','edge_Tthresh_L')
        plot(prof_distRadial_fromCenter_m{i}(prof_idxRplume_Tthresh(i)),prof_distAxialCenter_m(i),'kx','displayName','edge_Tthresh_R')
        
        %plume edges from temperature threshold gaussian
        plot(prof_distRadial_fromCenter_m{i}(prof_idxLplume_Tgauss(i)),prof_distAxialCenter_m(i),'bx','displayName','edge_Tgauss_L')
        plot(prof_distRadial_fromCenter_m{i}(prof_idxRplume_Tgauss(i)),prof_distAxialCenter_m(i),'bx','displayName','edge_Tgauss_R')
        
        hold on
    end
    axis equal tight
end


%% FIT with real data (y = axial dist only)

%. get index of edge pixels in profile vector
selEdge = get(get(handles.edge2fit_panel,'SelectedObject'),'string');
selEdgeSide = get(get(handles.edgeSide2fit_panel,'SelectedObject'),'string');

switch selEdge
    case 'T = fixed'
        if strcmp(selEdgeSide,'left edge')
            idxVector = prof_idxLplume_Tthresh;
        elseif strcmp(selEdgeSide,'right edge')
            idxVector = prof_idxRplume_Tthresh;
        end
    case 'T = gaussian'
        if strcmp(selEdgeSide,'left edge')
            idxVector = prof_idxLplume_Tgauss;
        elseif strcmp(selEdgeSide,'right edge')
            idxVector = prof_idxRplume_Tgauss;
        end
end


%. get data to fit
x = zeros(nbProfiles,1);
for i=1:nbProfiles
   x(i,1) = prof_distRadial_fromCenter_m{i}(idxVector(i)); 
end
y = prof_distAxialCenter_m;

%find y>0
idx_aboveVent = find(y>0);
dat2fit_pxX = x(idx_aboveVent);
dat2fit_pxY = y(idx_aboveVent);

%. FIT
polyfitDegree = 1;
[xFit,yFit,fitCoefs,delta] = fit_data(dat2fit_pxX,dat2fit_pxY,polyfitDegree);
%print polynom equation
polyEquation = print_polynomEqu(fitCoefs);
set([handles.fitEquation,handles.fitEquation_txt],'enable','on');
set(handles.fitEquation,'string',polyEquation)

%(TMP TEST: plot fit)
if plot_stackedProf_noTempShif, plot(gca,xFit,yFit,'m-','displayName','edgeFit'); end


%. get APERTURE ANGLE
alpha = atand(1/fitCoefs(1));
%print aperture angle
set([handles.apertureAngle,handles.apertureAngle_txt],'enable','on');
set(handles.apertureAngle,'string',num2str(alpha,'%.2f'));

%. get SPREADING RATE
spreadRate = 1/fitCoefs(1); %spreading rate = d(radius)/d(height) = 1 / (dY/dX)
%print spreading rate
set([handles.spreadingRate,handles.spreadingRate_txt],'enable','on');
set(handles.spreadingRate,'string',num2str(spreadRate,'%.2f'));

%. get ENTRAINMENT COEF
entCoef = 5/6 * spreadRate;
%print entrainment coefficient
set([handles.entrainmentCoef,handles.entrainmentCoef_txt],'enable','on');
set(handles.entrainmentCoef,'string',num2str(entCoef,'%.2f'));
    


% --- Executes on button press in zFactor_tempShift.
function zFactor_tempShift_Callback(hObject, eventdata, handles)
% hObject    handle to zFactor_tempShift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zFactor_tempShift



function spreadingRate_Callback(hObject, eventdata, handles)
% hObject    handle to spreadingRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spreadingRate as text
%        str2double(get(hObject,'String')) returns contents of spreadingRate as a double


% --- Executes during object creation, after setting all properties.
function spreadingRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spreadingRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
